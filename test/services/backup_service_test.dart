// BackupService — full ZIP backup (manifest + data.json + attachment files) and
// all-or-nothing, filesystem-safe restore (stage → validate → swap files first,
// then commit DB; roll the swap back on commit failure). The DB transaction and
// the filesystem swap are exercised on an in-memory drift db + a temp documents
// dir; share_plus / file_picker (the platform bits) live in the screen.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/services/backup_service.dart';
import 'package:path/path.dart' as p;

void main() {
  late AppDatabase db;
  late Directory docs;
  late BackupService svc;

  DateTime clock() => DateTime.utc(2026, 6, 1, 20, 30);
  final ts = DateTime.utc(2026, 5, 1, 12);

  setUp(() async {
    db = AppDatabase.memory();
    docs = await Directory.systemTemp.createTemp('lm_backup_test');
    svc = BackupService(db, docsDir: () async => docs, clock: clock);
  });
  tearDown(() async {
    await db.close();
    if (await docs.exists()) await docs.delete(recursive: true);
  });

  // Write an attachment file (full + thumb) on disk and its metadata row.
  Future<void> addAttachmentWithFiles({
    required String id,
    required AttachmentEntity entity,
    required String entityId,
    List<int> bytes = const [9, 9, 9, 9],
  }) async {
    final relFull = p.posix.join('attachments', entity.folder, '$id.jpg');
    final relThumb = p.posix.join('attachments', entity.folder, '${id}_thumb.jpg');
    for (final rel in [relFull, relThumb]) {
      final f = File(p.join(docs.path, p.joinAll(p.posix.split(rel))));
      await f.parent.create(recursive: true);
      await f.writeAsBytes(bytes, flush: true);
    }
    await db.attachmentsDao.save(AttachmentsCompanion.insert(
      id: id, entityType: entity, entityId: entityId,
      role: AttachmentRole.photo, filePath: relFull, thumbPath: relThumb,
      fileType: 'image/jpeg', fileSize: bytes.length, createdAt: ts,
    ));
  }

  // A small but representative dataset with one photo-bearing record.
  Future<void> seedSmall() async {
    await db.mealsDao.save(MealsCompanion.insert(
        id: 'meal1', date: '2026-05-15', name: 'Салата с риба',
        type: MealType.lunch, calories: const Value(420),
        note: const Value('Вкусно'), createdAt: ts, updatedAt: ts));
    await db.financeDao.saveExpense(ExpensesCompanion.insert(
        id: 'exp1', date: '2026-05-10', amountCents: 3250,
        category: ExpenseCategory.food, description: 'Обяд навън',
        createdAt: ts, updatedAt: ts));
    await db.bucketDao.saveItem(BucketItemsCompanion.insert(
        id: 'bi1', title: 'Скок с парашут', priority: BucketPriority.high,
        status: BucketStatus.completed, createdAt: ts, updatedAt: ts));
    await db.bucketDao.saveExperience(BucketExperiencesCompanion.insert(
        id: 'be1', bucketItemId: 'bi1', completedDate: '2026-05-20',
        feelingRating: 9, worthIt: true, createdAt: ts, updatedAt: ts));
    await addAttachmentWithFiles(
        id: 'att1', entity: AttachmentEntity.meal, entityId: 'meal1');
  }

  Future<int> rowCount(dynamic table) async =>
      (await db.customSelect('SELECT COUNT(*) c FROM ${table.actualTableName}')
              .getSingle())
          .read<int>('c');

  group('create + round-trip', () {
    test('backup zip contains manifest, data.json and attachment files',
        () async {
      await seedSmall();
      final bytes = await svc.buildZipBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      final names = archive.files.map((f) => f.name).toSet();
      expect(names, contains('manifest.json'));
      expect(names, contains('data.json'));
      expect(names, contains('attachments/meals/att1.jpg'));
      expect(names, contains('attachments/meals/att1_thumb.jpg'));

      final manifest = jsonDecode(utf8.decode(
          archive.files.firstWhere((f) => f.name == 'manifest.json').content));
      expect(manifest['appName'], 'LifeMaxxing');
      expect(manifest['backupType'], 'full');
      expect(manifest['schemaVersion'], 1);
    });

    test('restore into a wiped app reproduces every record and file', () async {
      await seedSmall();
      final bytes = await svc.buildZipBytes();
      final origMeal = await db.mealsDao.getById('meal1');

      // Wipe DB + attachments.
      await clearAll(db);
      await Directory(p.join(docs.path, 'attachments')).delete(recursive: true);
      expect(await db.mealsDao.getById('meal1'), isNull);

      await svc.restore(bytes);

      final meal = await db.mealsDao.getById('meal1');
      expect(meal, isNotNull);
      expect(meal!.name, 'Салата с риба');
      expect(meal.calories, 420);
      expect(meal.nameLower, 'салата с риба'); // shadow column recomputed
      expect(meal.createdAt, origMeal!.createdAt); // exact timestamp round-trip
      expect((await db.financeDao.getExpense('exp1'))!.amountCents, 3250);
      expect((await db.bucketDao.experienceForItem('bi1'))!.feelingRating, 9);

      // Attachment files restored byte-for-byte.
      final full = File(p.join(docs.path, 'attachments', 'meals', 'att1.jpg'));
      expect(await full.exists(), isTrue);
      expect(await full.readAsBytes(), [9, 9, 9, 9]);
    });
  });

  group('validation (§26.10)', () {
    test('corrupt (non-zip) bytes are rejected', () async {
      final v = await svc.validate(Uint8List.fromList([1, 2, 3, 4]));
      expect(v.ok, isFalse);
      expect(v.errors, isNotEmpty);
    });

    test('missing manifest is rejected', () async {
      final a = Archive()
        ..addFile(ArchiveFile.string('data.json', '{"meals":[]}'));
      final v = await svc.validate(ZipEncoder().encodeBytes(a));
      expect(v.ok, isFalse);
      expect(v.errors.join(), contains('manifest'));
    });

    test('unsupported schemaVersion is rejected', () async {
      await seedSmall();
      final bytes = await svc.buildZipBytes();
      final bad = _patchManifest(bytes, (m) => m['schemaVersion'] = 999);
      final v = await svc.validate(bad);
      expect(v.ok, isFalse);
      expect(v.errors.join().toLowerCase(), contains('schema'));
    });

    test('a referenced attachment missing from the zip is rejected', () async {
      await seedSmall();
      final bytes = await svc.buildZipBytes();
      // Drop the attachment files but keep their metadata in data.json.
      final bad = _dropFiles(bytes, (n) => n.startsWith('attachments/'));
      final v = await svc.validate(bad);
      expect(v.ok, isFalse);
      expect(v.errors.join(), contains('att1.jpg'));
    });

    test('restore of an invalid backup leaves existing data untouched',
        () async {
      await seedSmall();
      expect(
          svc.restore(Uint8List.fromList([1, 2, 3])), throwsA(isA<BackupException>()));
      // Existing meal still present.
      await Future<void>.delayed(Duration.zero);
      expect(await db.mealsDao.getById('meal1'), isNotNull);
    });
  });

  test('mid-commit failure reverts the file swap and the DB (all-or-nothing)',
      () async {
    // Build a valid backup, then poison data.json with a CHECK-violating BP row
    // so the DB insert fails AFTER the file swap has happened.
    await seedSmall();
    final good = await svc.buildZipBytes();
    final poisoned = _patchData(good, (data) {
      (data['bloodPressureLogs'] as List).add({
        'id': 'bad', 'date': '2026-05-01', 'time': '08:00',
        'systolic': 80, 'diastolic': 120, 'pulse': 70, 'note': null,
        'createdAt': ts.toIso8601String(), 'updatedAt': ts.toIso8601String(),
      });
    });

    // Reset to a distinct "live" state: a different meal + a marker file.
    await clearAll(db);
    await Directory(p.join(docs.path, 'attachments')).delete(recursive: true);
    await db.mealsDao.save(MealsCompanion.insert(
        id: 'orig', date: '2026-01-01', name: 'Оригинал',
        type: MealType.dinner, createdAt: ts, updatedAt: ts));
    final marker = File(p.join(docs.path, 'attachments', 'marker.txt'));
    await marker.parent.create(recursive: true);
    await marker.writeAsBytes([1, 1, 1], flush: true);

    await expectLater(svc.restore(poisoned), throwsA(isA<BackupException>()));

    // DB reverted: original meal kept, backup's meal never landed.
    expect(await db.mealsDao.getById('orig'), isNotNull);
    expect(await db.mealsDao.getById('meal1'), isNull);
    // Files reverted: the original marker is back, the staged dir is gone.
    expect(await marker.exists(), isTrue);
    expect(await marker.readAsBytes(), [1, 1, 1]);
    expect(
        await Directory(p.join(docs.path, 'attachments_restore')).exists(), isFalse);
  });

  test('isEmpty reflects whether the app has data', () async {
    expect(await svc.isEmpty(), isTrue);
    await seedSmall();
    expect(await svc.isEmpty(), isFalse);
    expect(await rowCount(db.meals), 1); // sanity on the count helper
  });
}

// ── Zip-editing helpers (tests construct corrupt/poisoned backups) ──────

Uint8List _rebuild(Archive src, {List<ArchiveFile>? replace}) {
  final out = Archive();
  final replaced = {for (final f in replace ?? const <ArchiveFile>[]) f.name};
  for (final f in src.files) {
    if (replaced.contains(f.name)) continue;
    out.addFile(f);
  }
  for (final f in replace ?? const <ArchiveFile>[]) {
    out.addFile(f);
  }
  return Uint8List.fromList(ZipEncoder().encodeBytes(out));
}

Uint8List _patchManifest(List<int> bytes, void Function(Map<String, dynamic>) edit) {
  final a = ZipDecoder().decodeBytes(bytes);
  final m = jsonDecode(
      utf8.decode(a.files.firstWhere((f) => f.name == 'manifest.json').content)) as Map<String, dynamic>;
  edit(m);
  return _rebuild(a, replace: [ArchiveFile.string('manifest.json', jsonEncode(m))]);
}

Uint8List _patchData(List<int> bytes, void Function(Map<String, dynamic>) edit) {
  final a = ZipDecoder().decodeBytes(bytes);
  final d = jsonDecode(
      utf8.decode(a.files.firstWhere((f) => f.name == 'data.json').content)) as Map<String, dynamic>;
  edit(d);
  return _rebuild(a, replace: [ArchiveFile.string('data.json', jsonEncode(d))]);
}

Uint8List _dropFiles(List<int> bytes, bool Function(String name) drop) {
  final a = ZipDecoder().decodeBytes(bytes);
  final out = Archive();
  for (final f in a.files) {
    if (drop(f.name)) continue;
    out.addFile(f);
  }
  return Uint8List.fromList(ZipEncoder().encodeBytes(out));
}
