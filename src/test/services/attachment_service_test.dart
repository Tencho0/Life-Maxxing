// AttachmentService — the single write path for photos: image pipeline,
// cardinality enforcement, and delete-cascades-files (technical-spec §5.1).
// Real compression runs on device; here the pipeline is faked so the
// orchestration (paths, metadata, cardinality, file cleanup) is unit-tested
// against an in-memory drift db + a temp documents dir.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/services/attachment_service.dart';
import 'package:lifemaxxing/services/image_processor.dart';
import 'package:path/path.dart' as p;

/// Deterministic stand-in for the real image pipeline. Scales a notional
/// [srcWidth]x[srcHeight] source to fit a [maxEdge] box (preserving aspect) and
/// returns bytes whose length == pixel area, so a thumbnail is provably smaller
/// than the full image. Records the (maxEdge, quality) of every call.
class _FakeProcessor implements ImageProcessor {
  static const int srcWidth = 4000;
  static const int srcHeight = 3000;
  final List<({int maxEdge, int quality})> calls = [];

  @override
  Future<ProcessedImage> process(String sourcePath,
      {required int maxEdge, required int quality}) async {
    calls.add((maxEdge: maxEdge, quality: quality));
    final longEdge = srcWidth > srcHeight ? srcWidth : srcHeight;
    final scale = longEdge <= maxEdge ? 1.0 : maxEdge / longEdge;
    final w = (srcWidth * scale).round();
    final h = (srcHeight * scale).round();
    return ProcessedImage(bytes: Uint8List(w * h), width: w, height: h);
  }
}

void main() {
  late AppDatabase db;
  late Directory docs;
  late _FakeProcessor proc;
  late AttachmentService svc;
  late String src;
  var idN = 0;

  setUp(() async {
    db = AppDatabase.memory();
    docs = await Directory.systemTemp.createTemp('lm_attach_test');
    proc = _FakeProcessor();
    idN = 0;
    svc = AttachmentService(
      db.attachmentsDao,
      imageProcessor: proc,
      docsDir: () async => docs,
      idGen: () => 'a${idN++}',
      clock: () => DateTime.utc(2026, 6, 1, 12),
    );
    src = p.join(docs.path, 'source.jpg');
    await File(src).writeAsBytes(List<int>.filled(100, 7));
  });
  tearDown(() async {
    await db.close();
    if (await docs.exists()) await docs.delete(recursive: true);
  });

  // Absolute path from a stored relative (posix) path, native-separator safe.
  String abs(String rel) => p.join(docs.path, p.joinAll(p.posix.split(rel)));

  test('adds a photo: writes full + thumb files and inserts a metadata row',
      () async {
    final a = await svc.addFromFile(
      entity: AttachmentEntity.meal,
      entityId: 'meal-1',
      role: AttachmentRole.photo,
      sourcePath: src,
      originalFileName: 'lunch.jpg',
    );

    expect(a.entityType, AttachmentEntity.meal);
    expect(a.role, AttachmentRole.photo);
    expect(a.fileType, 'image/jpeg');
    expect(a.originalFileName, 'lunch.jpg');
    expect(a.sortOrder, 0);
    // 4000x3000 source clamped to a 1600 long edge → 1600x1200.
    expect(a.width, 1600);
    expect(a.height, 1200);
    expect(a.fileSize, 1600 * 1200); // bytes of the full (compressed) image
    expect(a.filePath, 'attachments/meals/a0.jpg');
    expect(a.thumbPath, 'attachments/meals/a0_thumb.jpg');
    expect(File(abs(a.filePath)).existsSync(), isTrue);
    expect(File(abs(a.thumbPath)).existsSync(), isTrue);

    final rows = await db.attachmentsDao.forEntity(AttachmentEntity.meal, 'meal-1');
    expect(rows, hasLength(1));
  });

  test('pipeline uses 1600/Q80 for full and 320/Q70 for thumb; thumb is smaller',
      () async {
    final a = await svc.addFromFile(
      entity: AttachmentEntity.meal,
      entityId: 'm',
      role: AttachmentRole.photo,
      sourcePath: src,
    );

    expect(proc.calls, [
      (maxEdge: 1600, quality: 80),
      (maxEdge: 320, quality: 70),
    ]);
    final fullSize = File(abs(a.filePath)).lengthSync();
    final thumbSize = File(abs(a.thumbPath)).lengthSync();
    expect(thumbSize, lessThan(fullSize));
    expect(thumbSize, 320 * 240); // 4000x3000 → 320x240 thumbnail
  });

  test('singleton role replaces: a second meal photo deletes the first files',
      () async {
    final a1 = await svc.addFromFile(
      entity: AttachmentEntity.meal,
      entityId: 'm',
      role: AttachmentRole.photo,
      sourcePath: src,
    );
    final a2 = await svc.addFromFile(
      entity: AttachmentEntity.meal,
      entityId: 'm',
      role: AttachmentRole.photo,
      sourcePath: src,
    );

    final rows = await db.attachmentsDao.forEntity(AttachmentEntity.meal, 'm');
    expect(rows, hasLength(1));
    expect(rows.single.id, a2.id);
    expect(File(abs(a1.filePath)).existsSync(), isFalse);
    expect(File(abs(a1.thumbPath)).existsSync(), isFalse);
    expect(File(abs(a2.filePath)).existsSync(), isTrue);
  });

  test('many role appends with incrementing sortOrder', () async {
    await svc.addFromFile(
      entity: AttachmentEntity.healthEvent,
      entityId: 'h',
      role: AttachmentRole.photo,
      sourcePath: src,
    );
    await svc.addFromFile(
      entity: AttachmentEntity.healthEvent,
      entityId: 'h',
      role: AttachmentRole.photo,
      sourcePath: src,
    );

    final rows = await db.attachmentsDao.forEntity(AttachmentEntity.healthEvent, 'h');
    expect(rows.map((a) => a.sortOrder), [0, 1]);
    expect(rows.every((a) => File(abs(a.filePath)).existsSync()), isTrue);
  });

  test('trip cover is singleton, gallery is many; they coexist', () async {
    final cover1 = await svc.addFromFile(
      entity: AttachmentEntity.trip,
      entityId: 't',
      role: AttachmentRole.cover,
      sourcePath: src,
    );
    await svc.addFromFile(
      entity: AttachmentEntity.trip,
      entityId: 't',
      role: AttachmentRole.gallery,
      sourcePath: src,
    );
    await svc.addFromFile(
      entity: AttachmentEntity.trip,
      entityId: 't',
      role: AttachmentRole.gallery,
      sourcePath: src,
    );
    final cover2 = await svc.addFromFile(
      entity: AttachmentEntity.trip,
      entityId: 't',
      role: AttachmentRole.cover,
      sourcePath: src,
    );

    final rows = await db.attachmentsDao.forEntity(AttachmentEntity.trip, 't');
    final covers = rows.where((a) => a.role == AttachmentRole.cover).toList();
    final gallery = rows.where((a) => a.role == AttachmentRole.gallery).toList();
    expect(covers, hasLength(1));
    expect(covers.single.id, cover2.id);
    expect(gallery, hasLength(2));
    expect(File(abs(cover1.filePath)).existsSync(), isFalse); // old cover gone
    expect(File(abs(cover2.filePath)).existsSync(), isTrue);
  });

  test('removeAttachment deletes both files and the row', () async {
    final a = await svc.addFromFile(
      entity: AttachmentEntity.labTest,
      entityId: 'l',
      role: AttachmentRole.photo,
      sourcePath: src,
    );
    await svc.removeAttachment(a);

    expect(await db.attachmentsDao.forEntity(AttachmentEntity.labTest, 'l'), isEmpty);
    expect(File(abs(a.filePath)).existsSync(), isFalse);
    expect(File(abs(a.thumbPath)).existsSync(), isFalse);
  });

  test('deleteAllForEntity removes every file and row for the entity', () async {
    final a = await svc.addFromFile(
      entity: AttachmentEntity.labTest,
      entityId: 'l',
      role: AttachmentRole.photo,
      sourcePath: src,
    );
    final b = await svc.addFromFile(
      entity: AttachmentEntity.labTest,
      entityId: 'l',
      role: AttachmentRole.photo,
      sourcePath: src,
    );
    await svc.deleteAllForEntity(AttachmentEntity.labTest, 'l');

    expect(await db.attachmentsDao.forEntity(AttachmentEntity.labTest, 'l'), isEmpty);
    expect(File(abs(a.filePath)).existsSync(), isFalse);
    expect(File(abs(b.filePath)).existsSync(), isFalse);
  });

  test('deleteForBucketItem cascades to the experience files (no orphans)',
      () async {
    final item = await svc.addFromFile(
      entity: AttachmentEntity.bucketItem,
      entityId: 'bi',
      role: AttachmentRole.photo,
      sourcePath: src,
    );
    final exp = await svc.addFromFile(
      entity: AttachmentEntity.bucketExperience,
      entityId: 'be',
      role: AttachmentRole.photo,
      sourcePath: src,
    );

    await svc.deleteForBucketItem('bi', experienceId: 'be');

    expect(await db.attachmentsDao.forEntity(AttachmentEntity.bucketItem, 'bi'), isEmpty);
    expect(
        await db.attachmentsDao.forEntity(AttachmentEntity.bucketExperience, 'be'),
        isEmpty);
    expect(File(abs(item.filePath)).existsSync(), isFalse);
    expect(File(abs(item.thumbPath)).existsSync(), isFalse);
    expect(File(abs(exp.filePath)).existsSync(), isFalse);
    expect(File(abs(exp.thumbPath)).existsSync(), isFalse);
  });
}
