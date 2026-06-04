// BackupService — full ZIP backup & all-or-nothing, filesystem-safe restore
// (technical-spec §5.2, spec §26; locked decisions §4).
//
// Create: serialize every table to `data.json` (exact snapshot — money in
// cents, enums as stable codes, timestamps ISO-8601; the derived `*Lower`
// columns are omitted and recomputed on restore), build `manifest.json`, copy
// every attachment file (full + thumbnail) into `attachments/…`, zip it.
//
// Restore (all-or-nothing): the filesystem swap is NOT covered by the DB
// transaction, so live data is never destroyed until the replacement is staged
// and validated:
//   1. validate fully (valid zip, manifest + data.json, supported schema, every
//      referenced attachment present, structural validity) — abort leaves all
//      data intact;
//   2. stage the restored attachment files into a NEW dir (`attachments_restore`);
//   3. swap files FIRST (live → `attachments_old`, staged → live);
//   4. THEN import data in a single drift transaction;
//   5. on commit failure roll the swap back (the DB auto-rolls-back); on success
//      drop the set-aside old dir.
// Inserts route through the DAOs so the `*Lower` shadow columns are rebuilt.

import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/database.dart';
import '../domain/enums.dart';
import '../domain/period.dart' show ymd;

class BackupException implements Exception {
  BackupException(this.message, [this.errors = const []]);
  final String message;
  final List<String> errors;
  @override
  String toString() => 'BackupException: $message ${errors.join('; ')}';
}

/// Result of pre-restore validation (spec §26.10) — drives the screen checklist.
class BackupValidation {
  BackupValidation({
    required this.ok,
    this.errors = const [],
    this.recordCount = 0,
    this.attachmentCount = 0,
    this.createdAt,
    this.appVersion,
  });
  final bool ok;
  final List<String> errors;
  final int recordCount;
  final int attachmentCount;
  final DateTime? createdAt;
  final String? appVersion;
}

class BackupService {
  BackupService(
    this._db, {
    Future<Directory> Function()? docsDir,
    DateTime Function()? clock,
    String appVersion = '1.0.0',
  })  : _docsDir = docsDir ?? getApplicationDocumentsDirectory,
        _clock = clock ?? DateTime.now,
        _appVersion = appVersion;

  final AppDatabase _db;
  final Future<Directory> Function() _docsDir;
  final DateTime Function() _clock;
  final String _appVersion;

  static const int schemaVersion = 1;
  static const String _attachmentsDir = 'attachments';

  /// The 14 data.json list keys, in FK-safe insert order (bucket items before
  /// their experiences).
  static const List<String> dataKeys = [
    'meals', 'activities', 'expenses', 'income', 'healthEvents', 'labTests',
    'bloodPressureLogs', 'medicationLogs', 'dailyLogs', 'steps',
    'bucketItems', 'bucketExperiences', 'trips', 'attachments',
  ];

  // ── Create ───────────────────────────────────────────────────────────

  Future<Uint8List> buildZipBytes() async {
    final base = await _docsDir();

    // Read the attachments table ONCE. Only include rows whose full + thumb
    // files both exist on disk, so the backup stays self-consistent: a dangling
    // row (file deleted out from under us) would otherwise be written to
    // data.json without a file, making the backup fail its own validation.
    final fileEntries = <ArchiveFile>[];
    final includedAttachments = <Attachment>[];
    for (final a in await _db.select(_db.attachments).get()) {
      final full = File(p.join(base.path, p.joinAll(p.posix.split(a.filePath))));
      final thumb = File(p.join(base.path, p.joinAll(p.posix.split(a.thumbPath))));
      if (await full.exists() && await thumb.exists()) {
        includedAttachments.add(a);
        fileEntries.add(ArchiveFile.bytes(a.filePath, await full.readAsBytes()));
        fileEntries.add(ArchiveFile.bytes(a.thumbPath, await thumb.readAsBytes()));
      }
    }

    final data = await _serializeAll(attachments: includedAttachments);
    final manifest = {
      'appName': 'LifeMaxxing',
      'backupType': 'full',
      'createdAt': _clock().toIso8601String(),
      'schemaVersion': schemaVersion,
      'appVersion': _appVersion,
      'dataFile': 'data.json',
      'attachmentsFolder': _attachmentsDir,
    };

    final archive = Archive()
      ..addFile(ArchiveFile.string('manifest.json', _json(manifest)))
      ..addFile(ArchiveFile.string('data.json', _json(data)));
    for (final f in fileEntries) {
      archive.addFile(f);
    }
    return ZipEncoder().encodeBytes(archive);
  }

  /// Write the backup to [outDir] as `lifemaxxing-backup-YYYY-MM-DD.zip` (for
  /// share_plus). Returns the written file.
  Future<File> writeBackupFile(Directory outDir) async {
    final bytes = await buildZipBytes();
    final name = 'lifemaxxing-backup-${ymd(_clock())}.zip';
    final file = File(p.join(outDir.path, name));
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  // ── Validate (§26.10) ──────────────────────────────────────────────

  Future<BackupValidation> validate(List<int> zipBytes) async {
    Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zipBytes);
    } catch (_) {
      return BackupValidation(ok: false, errors: const ['Невалиден ZIP файл']);
    }
    return _validateArchive(archive);
  }

  /// Validates an already-decoded [archive] (so restore decodes the zip once).
  BackupValidation _validateArchive(Archive archive) {
    final manifestBytes = _fileBytes(archive, 'manifest.json');
    final dataBytes = _fileBytes(archive, 'data.json');
    final errors = <String>[];
    if (manifestBytes == null) errors.add('Липсва manifest.json');
    if (dataBytes == null) errors.add('Липсва data.json');
    if (errors.isNotEmpty) return BackupValidation(ok: false, errors: errors);

    Map<String, dynamic>? manifest, data;
    try {
      manifest = jsonDecode(utf8.decode(manifestBytes!)) as Map<String, dynamic>;
    } catch (_) {
      errors.add('Повреден manifest.json');
    }
    try {
      data = jsonDecode(utf8.decode(dataBytes!)) as Map<String, dynamic>;
    } catch (_) {
      errors.add('Повреден data.json');
    }
    if (errors.isNotEmpty) return BackupValidation(ok: false, errors: errors);

    // schemaVersion: accept int or numeric string; distinguish missing/garbage
    // from unsupported.
    final svRaw = manifest!['schemaVersion'];
    final sv = svRaw is int ? svRaw : int.tryParse('$svRaw');
    if (svRaw == null) {
      errors.add('Липсва schemaVersion в manifest.json');
    } else if (sv == null) {
      errors.add('Невалидна schemaVersion: $svRaw');
    } else if (sv != schemaVersion) {
      errors.add('Неподдържана schemaVersion: $sv (очаквана $schemaVersion)');
    }

    for (final key in dataKeys) {
      if (data![key] is! List) errors.add('Невалидно/липсващо поле: $key');
    }
    if (errors.isNotEmpty) return BackupValidation(ok: false, errors: errors);

    // Referenced attachment files present in the zip.
    final names = {for (final f in archive.files) f.name};
    final atts = (data!['attachments'] as List).cast<Map<String, dynamic>>();
    for (final a in atts) {
      for (final rel in [a['filePath'], a['thumbPath']]) {
        if (rel is String && !names.contains(rel)) {
          errors.add('Липсва файл в backup-а: $rel');
        }
      }
    }

    // Row-level structural validity (§26.10) — build every companion (without
    // inserting). This catches missing required fields, unparseable timestamps,
    // and unknown enum codes UP FRONT, before any irreversible swap.
    try {
      _buildAllCompanions(data);
    } catch (e) {
      errors.add('Невалидна структура на данните: $e');
    }

    var recordCount = 0;
    for (final key in dataKeys) {
      if (key == 'attachments') continue;
      recordCount += (data[key] as List).length;
    }
    return BackupValidation(
      ok: errors.isEmpty,
      errors: errors,
      recordCount: recordCount,
      attachmentCount: atts.length,
      createdAt: DateTime.tryParse('${manifest['createdAt']}'),
      appVersion: manifest['appVersion'] as String?,
    );
  }

  // ── Restore (all-or-nothing, swap files first then commit DB) ─────────

  Future<void> restore(List<int> zipBytes) async {
    // (1) Decode once; validate fully. Abort here leaves everything untouched.
    Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zipBytes);
    } catch (_) {
      throw BackupException('Невалиден backup файл', const ['Невалиден ZIP файл']);
    }
    final v = _validateArchive(archive);
    if (!v.ok) throw BackupException('Невалиден backup файл', v.errors);

    final data = jsonDecode(utf8.decode(_fileBytes(archive, 'data.json')!))
        as Map<String, dynamic>;

    final base = await _docsDir();
    final live = Directory(p.join(base.path, _attachmentsDir));
    final old = Directory(p.join(base.path, '${_attachmentsDir}_old'));
    final staged = Directory(p.join(base.path, '${_attachmentsDir}_restore'));

    // Clear leftovers from any previously aborted restore.
    if (await old.exists()) await old.delete(recursive: true);
    if (await staged.exists()) await staged.delete(recursive: true);

    // Everything that could fail destructively runs inside the try so the
    // catch can return the filesystem to its pre-restore state regardless of
    // how far we got (stage → swap step 1 → swap step 2 → DB commit).
    final hadLive = await live.exists();
    var movedLiveToOld = false; // live → attachments_old done
    var stagedToLive = false; // attachments_restore → live done
    try {
      // (2) Stage restored attachment files into a NEW dir.
      await staged.create(recursive: true);
      for (final f in archive.files) {
        if (!f.isFile) continue;
        const prefix = '$_attachmentsDir/';
        if (!f.name.startsWith(prefix)) continue;
        final rel = f.name.substring(prefix.length);
        final dest = File(p.join(staged.path, p.joinAll(p.posix.split(rel))));
        await dest.parent.create(recursive: true);
        await dest.writeAsBytes(f.content, flush: true);
      }

      // (3) Swap files FIRST.
      if (hadLive) {
        await live.rename(old.path);
        movedLiveToOld = true;
      }
      await staged.rename(live.path);
      stagedToLive = true;

      // (4) THEN commit the DB in a single transaction.
      await _db.transaction(() async {
        await _deleteAll();
        await _insertAll(data);
      });
    } catch (e) {
      // (5) Roll back to the exact pre-restore state (DB auto-rolled-back).
      if (stagedToLive) {
        // `live` now holds the staged content — remove it.
        if (await live.exists()) await live.delete(recursive: true);
      } else if (await staged.exists()) {
        await staged.delete(recursive: true);
      }
      if (movedLiveToOld && await old.exists()) await old.rename(live.path);
      throw BackupException(
          'Възстановяването пропадна — данните са непокътнати', [e.toString()]);
    }

    // Success — drop the set-aside old dir. Best-effort: a cleanup failure must
    // NOT report the (already-committed) restore as failed.
    try {
      if (await old.exists()) await old.delete(recursive: true);
    } catch (_) {}
  }

  /// True when every table is empty (drives the replace-all warning, §26.9).
  /// The `settings` table holds device preferences (not user data, never in a
  /// backup), so it's excluded — a saved locale must not suppress the warning.
  Future<bool> isEmpty() async {
    final settingsTable = _db.settings.actualTableName;
    for (final t in _db.allTables) {
      if (t.actualTableName == settingsTable) continue;
      final rows = await _db
          .customSelect('SELECT 1 FROM ${t.actualTableName} LIMIT 1')
          .get();
      if (rows.isNotEmpty) return false;
    }
    return true;
  }

  /// User-facing "clear all data" (Settings): permanently wipe every record and
  /// every attachment file, returning the app to an empty state. The `settings`
  /// table (display name + locale) is deliberately preserved — those are device
  /// preferences, not user data, so onboarding is not re-triggered.
  ///
  /// Order matters: delete the rows in a single transaction first (atomic), then
  /// remove the on-disk `attachments/` dir. If file removal fails after the
  /// commit, the DB is already clean and the leftover files orphan harmlessly
  /// (no row references them) — the reverse order could leave rows pointing at
  /// missing images. Required by the "deleting a record deletes its files"
  /// locked decision (§4).
  Future<void> clearAllData() async {
    await _db.transaction(_deleteAll);
    final base = await _docsDir();
    final live = Directory(p.join(base.path, _attachmentsDir));
    if (await live.exists()) await live.delete(recursive: true);
  }

  // ── DB writes ────────────────────────────────────────────────────────

  Future<void> _deleteAll() async {
    // Children before parents (FK-safe), mirroring dev clearAll.
    await _db.delete(_db.attachments).go();
    await _db.delete(_db.bucketExperiences).go();
    await _db.delete(_db.bucketItems).go();
    await _db.delete(_db.trips).go();
    await _db.delete(_db.meals).go();
    await _db.delete(_db.activities).go();
    await _db.delete(_db.expenses).go();
    await _db.delete(_db.income).go();
    await _db.delete(_db.bloodPressureLogs).go();
    await _db.delete(_db.medicationLogs).go();
    await _db.delete(_db.healthEvents).go();
    await _db.delete(_db.labTests).go();
    await _db.delete(_db.dailyLogs).go();
    await _db.delete(_db.steps).go();
  }

  Future<void> _insertAll(Map<String, dynamic> data) async {
    List<Map<String, dynamic>> rows(String key) =>
        (data[key] as List).cast<Map<String, dynamic>>();

    for (final m in rows('meals')) {
      await _db.mealsDao.save(_mealCompanion(m));
    }
    for (final a in rows('activities')) {
      await _db.activitiesDao.save(_activityCompanion(a));
    }
    for (final e in rows('expenses')) {
      await _db.financeDao.saveExpense(_expenseCompanion(e));
    }
    for (final i in rows('income')) {
      await _db.financeDao.saveIncome(_incomeCompanion(i));
    }
    for (final e in rows('healthEvents')) {
      await _db.healthDao.saveEvent(_eventCompanion(e));
    }
    for (final l in rows('labTests')) {
      await _db.healthDao.saveLab(_labCompanion(l));
    }
    for (final b in rows('bloodPressureLogs')) {
      await _db.healthDao.saveBp(_bpCompanion(b));
    }
    for (final m in rows('medicationLogs')) {
      await _db.healthDao.saveMed(_medCompanion(m));
    }
    for (final d in rows('dailyLogs')) {
      await _db.dailyLogsDao.save(_dailyCompanion(d));
    }
    for (final s in rows('steps')) {
      await _db.stepsDao.save(_stepCompanion(s));
    }
    for (final b in rows('bucketItems')) {
      await _db.bucketDao.saveItem(_bucketItemCompanion(b));
    }
    for (final e in rows('bucketExperiences')) {
      await _db.bucketDao.saveExperience(_bucketExperienceCompanion(e));
    }
    for (final t in rows('trips')) {
      await _db.tripsDao.save(_tripCompanion(t));
    }
    for (final a in rows('attachments')) {
      await _db.attachmentsDao.save(_attachmentCompanion(a));
    }
  }

  /// Builds every companion from [data] WITHOUT inserting, purely to surface
  /// structural problems (missing required fields, unparseable timestamps,
  /// unknown enum codes) during validation — before any irreversible swap.
  void _buildAllCompanions(Map<String, dynamic> data) {
    List<Map<String, dynamic>> rows(String key) =>
        (data[key] as List).cast<Map<String, dynamic>>();
    rows('meals').forEach(_mealCompanion);
    rows('activities').forEach(_activityCompanion);
    rows('expenses').forEach(_expenseCompanion);
    rows('income').forEach(_incomeCompanion);
    rows('healthEvents').forEach(_eventCompanion);
    rows('labTests').forEach(_labCompanion);
    rows('bloodPressureLogs').forEach(_bpCompanion);
    rows('medicationLogs').forEach(_medCompanion);
    rows('dailyLogs').forEach(_dailyCompanion);
    rows('steps').forEach(_stepCompanion);
    rows('bucketItems').forEach(_bucketItemCompanion);
    rows('bucketExperiences').forEach(_bucketExperienceCompanion);
    rows('trips').forEach(_tripCompanion);
    rows('attachments').forEach(_attachmentCompanion);
  }

  // ── Serialize (exact snapshot; no *Lower; enums → code; cents) ─────────

  Future<Map<String, dynamic>> _serializeAll({List<Attachment>? attachments}) async => {
        'meals': [for (final m in await _db.select(_db.meals).get()) _meal(m)],
        'activities': [
          for (final a in await _db.select(_db.activities).get()) _activity(a)
        ],
        'expenses': [
          for (final e in await _db.select(_db.expenses).get()) _expense(e)
        ],
        'income': [
          for (final i in await _db.select(_db.income).get()) _income(i)
        ],
        'healthEvents': [
          for (final e in await _db.select(_db.healthEvents).get()) _event(e)
        ],
        'labTests': [
          for (final l in await _db.select(_db.labTests).get()) _lab(l)
        ],
        'bloodPressureLogs': [
          for (final b in await _db.select(_db.bloodPressureLogs).get()) _bp(b)
        ],
        'medicationLogs': [
          for (final m in await _db.select(_db.medicationLogs).get()) _med(m)
        ],
        'dailyLogs': [
          for (final d in await _db.select(_db.dailyLogs).get()) _daily(d)
        ],
        'steps': [for (final s in await _db.select(_db.steps).get()) _step(s)],
        'bucketItems': [
          for (final b in await _db.select(_db.bucketItems).get()) _bucketItem(b)
        ],
        'bucketExperiences': [
          for (final e in await _db.select(_db.bucketExperiences).get())
            _bucketExperience(e)
        ],
        'trips': [for (final t in await _db.select(_db.trips).get()) _trip(t)],
        'attachments': [
          for (final a in attachments ?? await _db.select(_db.attachments).get())
            _attachment(a)
        ],
      };

  Map<String, dynamic> _meal(Meal m) => {
        'id': m.id, 'date': m.date, 'time': m.time, 'name': m.name,
        'type': m.type.code, 'quantity': m.quantity, 'calories': m.calories,
        'protein': m.protein, 'carbs': m.carbs, 'fat': m.fat, 'note': m.note,
        'createdAt': _iso(m.createdAt), 'updatedAt': _iso(m.updatedAt),
      };
  Map<String, dynamic> _activity(Activity a) => {
        'id': a.id, 'date': a.date, 'startTime': a.startTime,
        'endTime': a.endTime, 'durationMin': a.durationMin, 'type': a.type.code,
        'name': a.name, 'intensity': a.intensity?.code, 'quality': a.quality,
        'moodAfter': a.moodAfter, 'note': a.note,
        'createdAt': _iso(a.createdAt), 'updatedAt': _iso(a.updatedAt),
      };
  Map<String, dynamic> _expense(Expense e) => {
        'id': e.id, 'date': e.date, 'time': e.time,
        'amountCents': e.amountCents, 'category': e.category.code,
        'description': e.description, 'paymentMethod': e.paymentMethod?.code,
        'note': e.note, 'createdAt': _iso(e.createdAt),
        'updatedAt': _iso(e.updatedAt),
      };
  Map<String, dynamic> _income(IncomeEntry i) => {
        'id': i.id, 'date': i.date, 'amountCents': i.amountCents,
        'source': i.source, 'category': i.category.code, 'note': i.note,
        'createdAt': _iso(i.createdAt), 'updatedAt': _iso(i.updatedAt),
      };
  Map<String, dynamic> _event(HealthEvent e) => {
        'id': e.id, 'date': e.date, 'type': e.type.code,
        'subtype': e.subtype?.code, 'clinic': e.clinic, 'reason': e.reason,
        'whatWasDone': e.whatWasDone, 'priceCents': e.priceCents,
        'nextRecommendedDate': e.nextRecommendedDate, 'note': e.note,
        'createdAt': _iso(e.createdAt), 'updatedAt': _iso(e.updatedAt),
      };
  Map<String, dynamic> _lab(LabTest l) => {
        'id': l.id, 'date': l.date, 'lab': l.lab, 'reason': l.reason,
        'resultsText': l.resultsText, 'note': l.note,
        'createdAt': _iso(l.createdAt), 'updatedAt': _iso(l.updatedAt),
      };
  Map<String, dynamic> _bp(BloodPressureLog b) => {
        'id': b.id, 'date': b.date, 'time': b.time, 'systolic': b.systolic,
        'diastolic': b.diastolic, 'pulse': b.pulse, 'note': b.note,
        'createdAt': _iso(b.createdAt), 'updatedAt': _iso(b.updatedAt),
      };
  Map<String, dynamic> _med(MedicationLog m) => {
        'id': m.id, 'date': m.date, 'time': m.time, 'name': m.name,
        'type': m.type.code, 'dose': m.dose, 'status': m.status.code,
        'reason': m.reason, 'note': m.note,
        'createdAt': _iso(m.createdAt), 'updatedAt': _iso(m.updatedAt),
      };
  Map<String, dynamic> _daily(DailyLog l) => {
        'id': l.id, 'date': l.date, 'mood': l.mood, 'proud': l.proud,
        'didUncomfortable': l.didUncomfortable,
        'uncomfortableWhat': l.uncomfortableWhat, 'workout': l.workout,
        'drankAlcohol': l.drankAlcohol, 'alcoholWhat': l.alcoholWhat,
        'screenTimeMin': l.screenTimeMin, 'note': l.note,
        'createdAt': _iso(l.createdAt), 'updatedAt': _iso(l.updatedAt),
      };
  Map<String, dynamic> _step(StepEntry s) => {
        'id': s.id, 'date': s.date, 'count': s.count, 'note': s.note,
        'source': s.source.code, 'createdAt': _iso(s.createdAt),
        'updatedAt': _iso(s.updatedAt),
      };
  Map<String, dynamic> _bucketItem(BucketItem b) => {
        'id': b.id, 'title': b.title, 'description': b.description,
        'whyWantIt': b.whyWantIt, 'priority': b.priority.code,
        'status': b.status.code, 'createdAt': _iso(b.createdAt),
        'updatedAt': _iso(b.updatedAt),
      };
  Map<String, dynamic> _bucketExperience(BucketExperience e) => {
        'id': e.id, 'bucketItemId': e.bucketItemId,
        'completedDate': e.completedDate, 'feelingRating': e.feelingRating,
        'worthIt': e.worthIt, 'reflection': e.reflection,
        'createdAt': _iso(e.createdAt), 'updatedAt': _iso(e.updatedAt),
      };
  Map<String, dynamic> _trip(Trip t) => {
        'id': t.id, 'title': t.title, 'destination': t.destination,
        'fromDate': t.fromDate, 'toDate': t.toDate, 'overall': t.overall,
        'fun': t.fun, 'food': t.food, 'sights': t.sights, 'value': t.value,
        'wouldRepeat': t.wouldRepeat, 'comment': t.comment,
        'createdAt': _iso(t.createdAt), 'updatedAt': _iso(t.updatedAt),
      };
  Map<String, dynamic> _attachment(Attachment a) => {
        'id': a.id, 'entityType': a.entityType.code, 'entityId': a.entityId,
        'role': a.role.code, 'filePath': a.filePath, 'thumbPath': a.thumbPath,
        'fileType': a.fileType, 'originalFileName': a.originalFileName,
        'fileSize': a.fileSize, 'width': a.width, 'height': a.height,
        'sortOrder': a.sortOrder, 'createdAt': _iso(a.createdAt),
      };

  // ── Deserialize → companions (DAO.save rebuilds *Lower) ───────────────

  MealsCompanion _mealCompanion(Map<String, dynamic> m) => MealsCompanion.insert(
        id: m['id'], date: m['date'], name: m['name'],
        type: _reqEnum(MealType.values, m['type']),
        time: Value(m['time']), quantity: Value(m['quantity']),
        calories: Value(m['calories']), protein: Value(_d(m['protein'])),
        carbs: Value(_d(m['carbs'])), fat: Value(_d(m['fat'])),
        note: Value(m['note']),
        createdAt: _pdt(m['createdAt']), updatedAt: _pdt(m['updatedAt']),
      );
  ActivitiesCompanion _activityCompanion(Map<String, dynamic> a) =>
      ActivitiesCompanion.insert(
        id: a['id'], date: a['date'],
        type: _reqEnum(ActivityType.values, a['type']),
        startTime: Value(a['startTime']), endTime: Value(a['endTime']),
        durationMin: Value(a['durationMin']), name: Value(a['name']),
        intensity: Value(a['intensity'] == null
            ? null
            : _reqEnum(Intensity.values, a['intensity'])),
        quality: Value(a['quality']), moodAfter: Value(a['moodAfter']),
        note: Value(a['note']),
        createdAt: _pdt(a['createdAt']), updatedAt: _pdt(a['updatedAt']),
      );
  ExpensesCompanion _expenseCompanion(Map<String, dynamic> e) =>
      ExpensesCompanion.insert(
        id: e['id'], date: e['date'], amountCents: e['amountCents'],
        category: _reqEnum(ExpenseCategory.values, e['category']),
        description: e['description'], time: Value(e['time']),
        paymentMethod: Value(e['paymentMethod'] == null
            ? null
            : _reqEnum(PaymentMethod.values, e['paymentMethod'])),
        note: Value(e['note']),
        createdAt: _pdt(e['createdAt']), updatedAt: _pdt(e['updatedAt']),
      );
  IncomeCompanion _incomeCompanion(Map<String, dynamic> i) =>
      IncomeCompanion.insert(
        id: i['id'], date: i['date'], amountCents: i['amountCents'],
        source: i['source'],
        category: _reqEnum(IncomeCategory.values, i['category']),
        note: Value(i['note']),
        createdAt: _pdt(i['createdAt']), updatedAt: _pdt(i['updatedAt']),
      );
  HealthEventsCompanion _eventCompanion(Map<String, dynamic> e) =>
      HealthEventsCompanion.insert(
        id: e['id'], date: e['date'],
        type: _reqEnum(HealthEventType.values, e['type']),
        whatWasDone: e['whatWasDone'],
        subtype: Value(e['subtype'] == null
            ? null
            : _reqEnum(DentalSubtype.values, e['subtype'])),
        clinic: Value(e['clinic']), reason: Value(e['reason']),
        priceCents: Value(e['priceCents']),
        nextRecommendedDate: Value(e['nextRecommendedDate']),
        note: Value(e['note']),
        createdAt: _pdt(e['createdAt']), updatedAt: _pdt(e['updatedAt']),
      );
  LabTestsCompanion _labCompanion(Map<String, dynamic> l) =>
      LabTestsCompanion.insert(
        id: l['id'], date: l['date'], lab: l['lab'], reason: l['reason'],
        resultsText: Value(l['resultsText']), note: Value(l['note']),
        createdAt: _pdt(l['createdAt']), updatedAt: _pdt(l['updatedAt']),
      );
  BloodPressureLogsCompanion _bpCompanion(Map<String, dynamic> b) =>
      BloodPressureLogsCompanion.insert(
        id: b['id'], date: b['date'], time: b['time'], systolic: b['systolic'],
        diastolic: b['diastolic'], pulse: b['pulse'], note: Value(b['note']),
        createdAt: _pdt(b['createdAt']), updatedAt: _pdt(b['updatedAt']),
      );
  MedicationLogsCompanion _medCompanion(Map<String, dynamic> m) =>
      MedicationLogsCompanion.insert(
        id: m['id'], date: m['date'], time: m['time'], name: m['name'],
        type: _reqEnum(MedType.values, m['type']),
        status: _reqEnum(MedStatus.values, m['status']),
        dose: Value(m['dose']), reason: Value(m['reason']), note: Value(m['note']),
        createdAt: _pdt(m['createdAt']), updatedAt: _pdt(m['updatedAt']),
      );
  DailyLogsCompanion _dailyCompanion(Map<String, dynamic> l) =>
      DailyLogsCompanion.insert(
        id: l['id'], date: l['date'], mood: l['mood'], proud: l['proud'],
        didUncomfortable: l['didUncomfortable'], workout: l['workout'],
        drankAlcohol: l['drankAlcohol'],
        uncomfortableWhat: Value(l['uncomfortableWhat']),
        alcoholWhat: Value(l['alcoholWhat']),
        screenTimeMin: Value(l['screenTimeMin']), note: Value(l['note']),
        createdAt: _pdt(l['createdAt']), updatedAt: _pdt(l['updatedAt']),
      );
  StepsCompanion _stepCompanion(Map<String, dynamic> s) => StepsCompanion.insert(
        id: s['id'], date: s['date'], count: s['count'],
        source: _reqEnum(StepsSource.values, s['source']),
        note: Value(s['note']),
        createdAt: _pdt(s['createdAt']), updatedAt: _pdt(s['updatedAt']),
      );
  BucketItemsCompanion _bucketItemCompanion(Map<String, dynamic> b) =>
      BucketItemsCompanion.insert(
        id: b['id'], title: b['title'],
        priority: _reqEnum(BucketPriority.values, b['priority']),
        status: _reqEnum(BucketStatus.values, b['status']),
        description: Value(b['description']), whyWantIt: Value(b['whyWantIt']),
        createdAt: _pdt(b['createdAt']), updatedAt: _pdt(b['updatedAt']),
      );
  BucketExperiencesCompanion _bucketExperienceCompanion(
          Map<String, dynamic> e) =>
      BucketExperiencesCompanion.insert(
        id: e['id'], bucketItemId: e['bucketItemId'],
        completedDate: e['completedDate'], feelingRating: e['feelingRating'],
        worthIt: e['worthIt'], reflection: Value(e['reflection']),
        createdAt: _pdt(e['createdAt']), updatedAt: _pdt(e['updatedAt']),
      );
  TripsCompanion _tripCompanion(Map<String, dynamic> t) => TripsCompanion.insert(
        id: t['id'], title: t['title'], destination: t['destination'],
        fromDate: t['fromDate'], toDate: t['toDate'], overall: t['overall'],
        fun: Value(t['fun']), food: Value(t['food']), sights: Value(t['sights']),
        value: Value(t['value']), wouldRepeat: Value(t['wouldRepeat']),
        comment: Value(t['comment']),
        createdAt: _pdt(t['createdAt']), updatedAt: _pdt(t['updatedAt']),
      );
  AttachmentsCompanion _attachmentCompanion(Map<String, dynamic> a) =>
      AttachmentsCompanion.insert(
        id: a['id'],
        entityType: _reqEnum(AttachmentEntity.values, a['entityType']),
        entityId: a['entityId'],
        role: _reqEnum(AttachmentRole.values, a['role']),
        filePath: a['filePath'], thumbPath: a['thumbPath'],
        fileType: a['fileType'], originalFileName: Value(a['originalFileName']),
        fileSize: a['fileSize'], width: Value(a['width']),
        height: Value(a['height']), sortOrder: Value(a['sortOrder'] ?? 0),
        createdAt: _pdt(a['createdAt']),
      );

  // ── Primitives ─────────────────────────────────────────────────────

  Uint8List? _fileBytes(Archive a, String name) {
    for (final f in a.files) {
      if (f.name == name && f.isFile) return f.content;
    }
    return null;
  }

  /// Strict enum parse for restore: throws on an unknown code so a corrupt or
  /// forward-schema backup is rejected during validation rather than silently
  /// rewriting the value to a default.
  T _reqEnum<T extends Coded>(List<T> values, Object? code) {
    final v = parseCode(values, '$code');
    if (v == null) throw FormatException('Неизвестен код "$code"');
    return v;
  }

  double? _d(Object? n) => (n as num?)?.toDouble();
  String _json(Object o) => const JsonEncoder.withIndent('  ').convert(o);
  String _iso(DateTime d) => d.toIso8601String();
  DateTime _pdt(Object? s) => DateTime.parse(s as String);
}
