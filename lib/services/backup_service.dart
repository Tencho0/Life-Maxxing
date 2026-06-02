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
    final data = await _serializeAll();
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

    final base = await _docsDir();
    for (final a in await _db.select(_db.attachments).get()) {
      for (final rel in [a.filePath, a.thumbPath]) {
        final f = File(p.join(base.path, p.joinAll(p.posix.split(rel))));
        if (await f.exists()) {
          archive.addFile(ArchiveFile.bytes(rel, await f.readAsBytes()));
        }
      }
    }
    return ZipEncoder().encodeBytes(archive);
  }

  /// Write the backup to [outDir] as `lifemaxxing-backup-YYYY-MM-DD.zip` (for
  /// share_plus). Returns the written file.
  Future<File> writeBackupFile(Directory outDir) async {
    final bytes = await buildZipBytes();
    final name = 'lifemaxxing-backup-${_ymd(_clock())}.zip';
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

    final sv = manifest!['schemaVersion'];
    if (sv != schemaVersion) {
      errors.add('Неподдържана schemaVersion: $sv (очаквана $schemaVersion)');
    }

    for (final key in dataKeys) {
      if (data![key] is! List) errors.add('Невалидно/липсващо поле: $key');
    }
    if (errors.isNotEmpty) return BackupValidation(ok: false, errors: errors);

    final names = {for (final f in archive.files) f.name};
    var recordCount = 0;
    for (final key in dataKeys) {
      if (key == 'attachments') continue;
      recordCount += (data![key] as List).length;
    }
    final atts = (data!['attachments'] as List).cast<Map<String, dynamic>>();
    for (final a in atts) {
      for (final rel in [a['filePath'], a['thumbPath']]) {
        if (rel is String && !names.contains(rel)) {
          errors.add('Липсва файл в backup-а: $rel');
        }
      }
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
    final v = await validate(zipBytes);
    if (!v.ok) throw BackupException('Невалиден backup файл', v.errors);

    final archive = ZipDecoder().decodeBytes(zipBytes);
    final data = jsonDecode(utf8.decode(_fileBytes(archive, 'data.json')!))
        as Map<String, dynamic>;

    final base = await _docsDir();
    final live = Directory(p.join(base.path, _attachmentsDir));
    final old = Directory(p.join(base.path, '${_attachmentsDir}_old'));
    final staged = Directory(p.join(base.path, '${_attachmentsDir}_restore'));

    // Clear leftovers from any previously aborted restore.
    if (await old.exists()) await old.delete(recursive: true);
    if (await staged.exists()) await staged.delete(recursive: true);

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
    final hadLive = await live.exists();
    if (hadLive) await live.rename(old.path);
    await staged.rename(live.path);

    // (4) THEN commit the DB in a single transaction.
    try {
      await _db.transaction(() async {
        await _deleteAll();
        await _insertAll(data);
      });
    } catch (e) {
      // (5) Roll the swap back; the DB transaction has already rolled back.
      if (await live.exists()) await live.delete(recursive: true);
      if (hadLive) await old.rename(live.path);
      throw BackupException('Възстановяването пропадна — данните са непокътнати',
          [e.toString()]);
    }

    // Success — drop the set-aside old dir.
    if (await old.exists()) await old.delete(recursive: true);
  }

  /// True when every table is empty (drives the replace-all warning, §26.9).
  Future<bool> isEmpty() async {
    for (final t in _db.allTables) {
      final rows = await _db
          .customSelect('SELECT 1 FROM ${t.actualTableName} LIMIT 1')
          .get();
      if (rows.isNotEmpty) return false;
    }
    return true;
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

  // ── Serialize (exact snapshot; no *Lower; enums → code; cents) ─────────

  Future<Map<String, dynamic>> _serializeAll() async => {
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
          for (final a in await _db.select(_db.attachments).get()) _attachment(a)
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
        type: _enum(MealType.values, m['type'], MealType.other),
        time: Value(m['time']), quantity: Value(m['quantity']),
        calories: Value(m['calories']), protein: Value(_d(m['protein'])),
        carbs: Value(_d(m['carbs'])), fat: Value(_d(m['fat'])),
        note: Value(m['note']),
        createdAt: _pdt(m['createdAt']), updatedAt: _pdt(m['updatedAt']),
      );
  ActivitiesCompanion _activityCompanion(Map<String, dynamic> a) =>
      ActivitiesCompanion.insert(
        id: a['id'], date: a['date'],
        type: _enum(ActivityType.values, a['type'], ActivityType.other),
        startTime: Value(a['startTime']), endTime: Value(a['endTime']),
        durationMin: Value(a['durationMin']), name: Value(a['name']),
        intensity: Value(a['intensity'] == null
            ? null
            : _enum(Intensity.values, a['intensity'], Intensity.medium)),
        quality: Value(a['quality']), moodAfter: Value(a['moodAfter']),
        note: Value(a['note']),
        createdAt: _pdt(a['createdAt']), updatedAt: _pdt(a['updatedAt']),
      );
  ExpensesCompanion _expenseCompanion(Map<String, dynamic> e) =>
      ExpensesCompanion.insert(
        id: e['id'], date: e['date'], amountCents: e['amountCents'],
        category: _enum(ExpenseCategory.values, e['category'], ExpenseCategory.other),
        description: e['description'], time: Value(e['time']),
        paymentMethod: Value(e['paymentMethod'] == null
            ? null
            : _enum(PaymentMethod.values, e['paymentMethod'], PaymentMethod.other)),
        note: Value(e['note']),
        createdAt: _pdt(e['createdAt']), updatedAt: _pdt(e['updatedAt']),
      );
  IncomeCompanion _incomeCompanion(Map<String, dynamic> i) =>
      IncomeCompanion.insert(
        id: i['id'], date: i['date'], amountCents: i['amountCents'],
        source: i['source'],
        category: _enum(IncomeCategory.values, i['category'], IncomeCategory.other),
        note: Value(i['note']),
        createdAt: _pdt(i['createdAt']), updatedAt: _pdt(i['updatedAt']),
      );
  HealthEventsCompanion _eventCompanion(Map<String, dynamic> e) =>
      HealthEventsCompanion.insert(
        id: e['id'], date: e['date'],
        type: _enum(HealthEventType.values, e['type'], HealthEventType.other),
        whatWasDone: e['whatWasDone'],
        subtype: Value(e['subtype'] == null
            ? null
            : _enum(DentalSubtype.values, e['subtype'], DentalSubtype.other)),
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
        type: _enum(MedType.values, m['type'], MedType.other),
        status: _enum(MedStatus.values, m['status'], MedStatus.taken),
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
        source: _enum(StepsSource.values, s['source'], StepsSource.stepsModule),
        note: Value(s['note']),
        createdAt: _pdt(s['createdAt']), updatedAt: _pdt(s['updatedAt']),
      );
  BucketItemsCompanion _bucketItemCompanion(Map<String, dynamic> b) =>
      BucketItemsCompanion.insert(
        id: b['id'], title: b['title'],
        priority: _enum(BucketPriority.values, b['priority'], BucketPriority.medium),
        status: _enum(BucketStatus.values, b['status'], BucketStatus.idea),
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
        entityType:
            _enum(AttachmentEntity.values, a['entityType'], AttachmentEntity.meal),
        entityId: a['entityId'],
        role: _enum(AttachmentRole.values, a['role'], AttachmentRole.photo),
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

  T _enum<T extends Coded>(List<T> values, Object? code, T fallback) =>
      parseCode(values, '$code') ?? fallback;

  double? _d(Object? n) => (n as num?)?.toDouble();
  String _json(Object o) => const JsonEncoder.withIndent('  ').convert(o);
  String _iso(DateTime d) => d.toIso8601String();
  DateTime _pdt(Object? s) => DateTime.parse(s as String);
  String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
