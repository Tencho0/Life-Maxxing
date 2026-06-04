// ExportService — AI export (spec §25). Gathers records for one of three scopes
// (Full / Period / Module), applies the §25.5 period-inclusion rules, and
// renders either JSON (§25.8 keys + summary) or Markdown (§25.9 sections, always
// ending with the "Questions for AI Analysis" block).
//
// Read-only consumer of the database (no writes, no filesystem, no share), so
// the gather + render logic is fully unit-testable on an in-memory drift db.
// The platform-only bits (share_plus / clipboard) live in the screen. Money is
// exported in EUR (cents/100) to match the §25.8 example; enums serialize as
// their stable lowercase `code`; attachments are metadata only (binaries go
// through Backup, §25.2). The `*Lower` shadow columns are never exported.

import 'dart:convert';

import '../data/database.dart';
import '../l10n/app_localizations.dart';
import '../domain/enums.dart';
import '../domain/period.dart';

enum ExportScopeType { full, period, module }

enum ExportFormat implements Coded {
  json('json', 'JSON'),
  markdown('markdown', 'Markdown');

  const ExportFormat(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
}

/// A single module for [ExportScopeType.module] export (spec §25.6).
enum ExportModule implements Coded {
  food('food', 'Храна'),
  activities('activities', 'Активности'),
  expenses('expenses', 'Разходи'),
  income('income', 'Приходи'),
  healthEvents('health_events', 'Здравни събития'),
  labTests('lab_tests', 'Изследвания'),
  bloodPressure('blood_pressure', 'Кръвно и пулс'),
  medications('medications', 'Медикаменти и добавки'),
  dailyLogs('daily_logs', 'Daily Quick Logs'),
  steps('steps', 'Крачки'),
  weight('weight', 'Тегло'),
  bucketList('bucket_list', 'Bucket List'),
  trips('trips', 'Пътувания');

  const ExportModule(this.code, this.label);
  @override
  final String code;
  @override
  final String label;
}

class ExportRequest {
  const ExportRequest({required this.scope, this.range, this.module});
  final ExportScopeType scope;
  final DateRange? range; // required for period scope
  final ExportModule? module; // required for module scope
}

/// The gathered + filtered rows for one export, plus the request that produced
/// them. Lists not relevant to the request stay empty.
class ExportData {
  ExportData({
    required this.request,
    required this.exportDate,
    this.meals = const [],
    this.activities = const [],
    this.expenses = const [],
    this.income = const [],
    this.healthEvents = const [],
    this.labTests = const [],
    this.bloodPressure = const [],
    this.medications = const [],
    this.dailyLogs = const [],
    this.steps = const [],
    this.weight = const [],
    this.bucketItems = const [],
    this.bucketExperiences = const [],
    this.trips = const [],
    this.attachments = const [],
  });

  final ExportRequest request;
  final String exportDate;
  final List<Meal> meals;
  final List<Activity> activities;
  final List<Expense> expenses;
  final List<IncomeEntry> income;
  final List<HealthEvent> healthEvents;
  final List<LabTest> labTests;
  final List<BloodPressureLog> bloodPressure;
  final List<MedicationLog> medications;
  final List<DailyLog> dailyLogs;
  final List<StepEntry> steps;
  final List<WeightLog> weight;
  final List<BucketItem> bucketItems;
  final List<BucketExperience> bucketExperiences;
  final List<Trip> trips;
  final List<Attachment> attachments;

  int get recordCount =>
      meals.length +
      activities.length +
      expenses.length +
      income.length +
      healthEvents.length +
      labTests.length +
      bloodPressure.length +
      medications.length +
      dailyLogs.length +
      steps.length +
      weight.length +
      bucketItems.length +
      bucketExperiences.length +
      trips.length;
  int get photoCount => attachments.length;
}

class ExportService {
  ExportService(this._db, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _clock;

  // ── Gather ───────────────────────────────────────────────────────────

  Future<ExportData> gather(ExportRequest req) async {
    final exportDate = _ymd(_clock());

    if (req.scope == ExportScopeType.module) {
      return _gatherModule(req, exportDate);
    }

    // Full + period both read every table; period then filters by §25.5.
    final meals = await _db.select(_db.meals).get();
    final activities = await _db.select(_db.activities).get();
    final expenses = await _db.select(_db.expenses).get();
    final income = await _db.select(_db.income).get();
    final healthEvents = await _db.select(_db.healthEvents).get();
    final labTests = await _db.select(_db.labTests).get();
    final bp = await _db.select(_db.bloodPressureLogs).get();
    final meds = await _db.select(_db.medicationLogs).get();
    final dailyLogs = await _db.select(_db.dailyLogs).get();
    final steps = await _db.select(_db.steps).get();
    final weight = await _db.select(_db.weightLogs).get();
    final items = await _db.select(_db.bucketItems).get();
    final experiences = await _db.select(_db.bucketExperiences).get();
    final trips = await _db.select(_db.trips).get();
    final attachments = await _db.select(_db.attachments).get();

    if (req.scope == ExportScopeType.full) {
      return ExportData(
        request: req, exportDate: exportDate,
        meals: meals, activities: activities, expenses: expenses,
        income: income, healthEvents: healthEvents, labTests: labTests,
        bloodPressure: bp, medications: meds, dailyLogs: dailyLogs,
        steps: steps, weight: weight, bucketItems: items,
        bucketExperiences: experiences,
        trips: trips, attachments: attachments,
      );
    }

    // Period scope (§25.5).
    final r = req.range!;
    bool inR(String date) => date.compareTo(r.from) >= 0 && date.compareTo(r.to) <= 0;

    // Bucket items: created OR completed (its experience's date) in range.
    final expByItem = {for (final e in experiences) e.bucketItemId: e};
    final fItems = items.where((it) {
      final created = inR(_ymd(it.createdAt.toLocal()));
      final exp = expByItem[it.id];
      final completed = exp != null && inR(exp.completedDate);
      return created || completed;
    }).toList();
    final itemIds = {for (final it in fItems) it.id};
    final fExperiences =
        experiences.where((e) => itemIds.contains(e.bucketItemId)).toList();

    // Trips: included if the trip overlaps the range at all (§25.5 says
    // "fromDate OR toDate in range"; we use the strict superset — interval
    // overlap — so a trip that fully spans the period isn't dropped).
    final fTrips = trips
        .where((t) => t.fromDate.compareTo(r.to) <= 0 && t.toDate.compareTo(r.from) >= 0)
        .toList();

    final fMeals = meals.where((m) => inR(m.date)).toList();
    final fActivities = activities.where((a) => inR(a.date)).toList();
    final fExpenses = expenses.where((e) => inR(e.date)).toList();
    final fIncome = income.where((i) => inR(i.date)).toList();
    final fEvents = healthEvents.where((e) => inR(e.date)).toList();
    final fLabs = labTests.where((l) => inR(l.date)).toList();
    final fBp = bp.where((b) => inR(b.date)).toList();
    final fMeds = meds.where((m) => inR(m.date)).toList();
    final fDaily = dailyLogs.where((d) => inR(d.date)).toList();
    final fSteps = steps.where((s) => inR(s.date)).toList();
    final fWeight = weight.where((w) => inR(w.date)).toList();

    final included = <AttachmentEntity, Set<String>>{
      AttachmentEntity.meal: {for (final m in fMeals) m.id},
      AttachmentEntity.activity: {for (final a in fActivities) a.id},
      AttachmentEntity.healthEvent: {for (final e in fEvents) e.id},
      AttachmentEntity.labTest: {for (final l in fLabs) l.id},
      AttachmentEntity.dailyLog: {for (final d in fDaily) d.id},
      AttachmentEntity.bucketItem: itemIds,
      AttachmentEntity.bucketExperience: {for (final e in fExperiences) e.id},
      AttachmentEntity.trip: {for (final t in fTrips) t.id},
    };
    final fAttachments = attachments
        .where((a) => included[a.entityType]?.contains(a.entityId) ?? false)
        .toList();

    return ExportData(
      request: req, exportDate: exportDate,
      meals: fMeals, activities: fActivities, expenses: fExpenses,
      income: fIncome, healthEvents: fEvents, labTests: fLabs,
      bloodPressure: fBp, medications: fMeds, dailyLogs: fDaily,
      steps: fSteps, weight: fWeight, bucketItems: fItems,
      bucketExperiences: fExperiences,
      trips: fTrips, attachments: fAttachments,
    );
  }

  /// Module scope (§25.6): the whole of one module, period ignored. Photo-
  /// bearing modules also carry their attachments metadata.
  Future<ExportData> _gatherModule(ExportRequest req, String exportDate) async {
    final m = req.module!;
    Future<List<Attachment>> attachmentsFor(AttachmentEntity e) async =>
        (await _db.select(_db.attachments).get())
            .where((a) => a.entityType == e)
            .toList();

    switch (m) {
      case ExportModule.food:
        return ExportData(
            request: req, exportDate: exportDate,
            meals: await _db.select(_db.meals).get(),
            attachments: await attachmentsFor(AttachmentEntity.meal));
      case ExportModule.activities:
        return ExportData(
            request: req, exportDate: exportDate,
            activities: await _db.select(_db.activities).get(),
            attachments: await attachmentsFor(AttachmentEntity.activity));
      case ExportModule.expenses:
        return ExportData(
            request: req, exportDate: exportDate,
            expenses: await _db.select(_db.expenses).get());
      case ExportModule.income:
        return ExportData(
            request: req, exportDate: exportDate,
            income: await _db.select(_db.income).get());
      case ExportModule.healthEvents:
        return ExportData(
            request: req, exportDate: exportDate,
            healthEvents: await _db.select(_db.healthEvents).get(),
            attachments: await attachmentsFor(AttachmentEntity.healthEvent));
      case ExportModule.labTests:
        return ExportData(
            request: req, exportDate: exportDate,
            labTests: await _db.select(_db.labTests).get(),
            attachments: await attachmentsFor(AttachmentEntity.labTest));
      case ExportModule.bloodPressure:
        return ExportData(
            request: req, exportDate: exportDate,
            bloodPressure: await _db.select(_db.bloodPressureLogs).get());
      case ExportModule.medications:
        return ExportData(
            request: req, exportDate: exportDate,
            medications: await _db.select(_db.medicationLogs).get());
      case ExportModule.dailyLogs:
        return ExportData(
            request: req, exportDate: exportDate,
            dailyLogs: await _db.select(_db.dailyLogs).get(),
            attachments: await attachmentsFor(AttachmentEntity.dailyLog));
      case ExportModule.steps:
        return ExportData(
            request: req, exportDate: exportDate,
            steps: await _db.select(_db.steps).get());
      case ExportModule.weight:
        return ExportData(
            request: req, exportDate: exportDate,
            weight: await _db.select(_db.weightLogs).get());
      case ExportModule.bucketList:
        final atts = await _db.select(_db.attachments).get();
        return ExportData(
            request: req, exportDate: exportDate,
            bucketItems: await _db.select(_db.bucketItems).get(),
            bucketExperiences: await _db.select(_db.bucketExperiences).get(),
            attachments: atts
                .where((a) =>
                    a.entityType == AttachmentEntity.bucketItem ||
                    a.entityType == AttachmentEntity.bucketExperience)
                .toList());
      case ExportModule.trips:
        return ExportData(
            request: req, exportDate: exportDate,
            trips: await _db.select(_db.trips).get(),
            attachments: await attachmentsFor(AttachmentEntity.trip));
    }
  }

  // ── JSON (§25.8) ───────────────────────────────────────────────────

  String toJson(ExportData d) {
    final range = d.request.range;
    final map = <String, dynamic>{
      'exportDate': d.exportDate,
      'scope': d.request.scope.name,
      'period': range == null ? null : {'from': range.from, 'to': range.to},
      'summary': _summary(d),
      'meals': [for (final m in d.meals) _meal(m)],
      'activities': [for (final a in d.activities) _activity(a)],
      'expenses': [for (final e in d.expenses) _expense(e)],
      'income': [for (final i in d.income) _income(i)],
      'healthEvents': [for (final e in d.healthEvents) _event(e)],
      'labTests': [for (final l in d.labTests) _lab(l)],
      'bloodPressurePulseLogs': [for (final b in d.bloodPressure) _bp(b)],
      'medicationSupplementLogs': [for (final m in d.medications) _med(m)],
      'dailyQuickLogs': [for (final l in d.dailyLogs) _daily(l)],
      'steps': [for (final s in d.steps) _step(s)],
      'weightLogs': [for (final w in d.weight) _weight(w)],
      'bucketList': [for (final b in d.bucketItems) _bucketItem(b)],
      'bucketListExperiences':
          [for (final e in d.bucketExperiences) _bucketExperience(e)],
      'trips': [for (final t in d.trips) _trip(t)],
      'attachments': [for (final a in d.attachments) _attachment(a)],
    };
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  Map<String, dynamic> _summary(ExportData d) {
    final out = <String, dynamic>{};
    if (d.expenses.isNotEmpty || d.income.isNotEmpty) {
      final exp = d.expenses.fold<int>(0, (s, e) => s + e.amountCents);
      final inc = d.income.fold<int>(0, (s, i) => s + i.amountCents);
      out['finance'] = {
        'totalIncome': _eur(inc),
        'totalExpenses': _eur(exp),
        'balance': _eur(inc - exp),
      };
    }
    if (d.bloodPressure.isNotEmpty) {
      final bp = d.bloodPressure;
      out['health'] = {
        'bloodPressureMeasurementsCount': bp.length,
        'averageSystolic': _avg(bp.map((b) => b.systolic)),
        'averageDiastolic': _avg(bp.map((b) => b.diastolic)),
        'averagePulse': _avg(bp.map((b) => b.pulse)),
      };
    }
    if (d.bucketItems.isNotEmpty || d.bucketExperiences.isNotEmpty) {
      final exps = d.bucketExperiences;
      out['bucketList'] = {
        'completedCount':
            d.bucketItems.where((b) => b.status == BucketStatus.completed).length,
        'averageFeelingRating': exps.isEmpty
            ? null
            : double.parse((exps.map((e) => e.feelingRating).reduce((a, b) => a + b) /
                    exps.length)
                .toStringAsFixed(1)),
        'worthItCount': exps.where((e) => e.worthIt).length,
      };
    }
    return out;
  }

  // ── Markdown (§25.9) ─────────────────────────────────────────────────

  String toMarkdown(ExportData d, AppLocalizations l10n) {
    final b = StringBuffer();
    b.writeln('# ${l10n.exportMdTitle}');
    b.writeln();
    b.writeln('**${l10n.exportMdPeriodLabel}** ${_periodLabel(d, l10n)}');
    b.writeln();

    final summaryLines = _summaryLines(d, l10n);
    if (summaryLines.isNotEmpty) {
      b.writeln('## ${l10n.exportMdSummary}');
      b.writeln();
      for (final line in summaryLines) {
        b.writeln('- $line');
      }
      b.writeln();
    }

    void section(String title, List<String> lines) {
      if (lines.isEmpty) return;
      b.writeln('## $title');
      b.writeln();
      for (final line in lines) {
        b.writeln('- $line');
      }
      b.writeln();
    }

    section(l10n.exportMdSectionDaily,
        [for (final l in d.dailyLogs) _dailyLine(l, l10n)]);
    section(l10n.exportMdSectionFood,
        [for (final m in d.meals) _mealLine(m, l10n)]);
    section(l10n.exportMdSectionActivities,
        [for (final a in d.activities) _activityLine(a, l10n)]);
    section(l10n.exportMdSectionSteps,
        [for (final s in d.steps) l10n.exportMdStepsLine(s.date, s.count)]);
    section(l10n.exportMdSectionWeight, [
      for (final w in d.weight)
        l10n.exportMdWeightLine(w.date, _kg(w.weightGrams),
            w.note == null || w.note!.isEmpty ? '' : ' — ${w.note}')
    ]);
    section(l10n.exportMdSectionMoney, [
      for (final i in d.income)
        l10n.exportMdIncomeLine(i.date, _eur(i.amountCents),
            l10n.incomeCategoryLabel(i.category.code), i.source),
      for (final e in d.expenses)
        l10n.exportMdExpenseLine(e.date, _eur(e.amountCents),
            l10n.expenseCategoryLabel(e.category.code), e.description),
    ]);
    section(l10n.exportMdSectionHealthEvents,
        [for (final e in d.healthEvents) _eventLine(e, l10n)]);
    section(l10n.exportMdSectionLabTests,
        [for (final l in d.labTests) l10n.exportMdLabLine(l.date, l.lab, l.reason)]);
    section(l10n.exportMdSectionBloodPressure, [
      for (final p in d.bloodPressure)
        l10n.exportMdBloodPressureLine(
            p.date, p.time, p.systolic, p.diastolic, p.pulse),
    ]);
    section(l10n.exportMdSectionMedications, [
      for (final m in d.medications)
        l10n.exportMdMedicationLine(m.date, m.time, m.name,
            l10n.medTypeLabel(m.type.code), l10n.medStatusLabel(m.status.code)),
    ]);
    section(l10n.exportMdSectionBucketList,
        [for (final i in d.bucketItems) _bucketLine(i, l10n)]);
    section(l10n.exportMdSectionBucketExperiences, [
      for (final e in d.bucketExperiences)
        l10n.exportMdBucketExperienceLine(
                e.completedDate,
                e.feelingRating,
                e.worthIt ? l10n.exportMdWorthIt : l10n.exportMdNotWorthIt) +
            (e.reflection != null ? ' — ${e.reflection}' : ''),
    ]);
    section(l10n.exportMdSectionTrips, [
      for (final t in d.trips)
        l10n.exportMdTripLine(
            t.fromDate, t.toDate, t.title, t.destination, t.overall),
    ]);

    b.writeln('## Questions for AI Analysis');
    b.writeln();
    b.writeln('1. Analyze my last 30 days.');
    b.writeln('2. Find patterns in my food, money, activities, mood, health, '
        'blood pressure, pulse, bucket list progress and trips.');
    b.writeln('3. Tell me where I am improving.');
    b.writeln('4. Tell me where I am self-sabotaging.');
    b.write('5. Suggest concrete changes for next month.');
    return b.toString();
  }

  String _periodLabel(ExportData d, AppLocalizations l10n) {
    switch (d.request.scope) {
      case ExportScopeType.full:
        return l10n.exportMdPeriodAll;
      case ExportScopeType.module:
        return l10n.exportMdPeriodModule(
            l10n.exportModuleLabel(d.request.module!.code));
      case ExportScopeType.period:
        final r = d.request.range!;
        return '${r.from} – ${r.to}';
    }
  }

  List<String> _summaryLines(ExportData d, AppLocalizations l10n) {
    final lines = <String>[];
    final s = _summary(d);
    final fin = s['finance'] as Map<String, dynamic>?;
    if (fin != null) {
      lines.add(l10n.exportMdSummaryFinance(
          fin['totalIncome'], fin['totalExpenses'], fin['balance']));
    }
    final health = s['health'] as Map<String, dynamic>?;
    if (health != null) {
      lines.add(l10n.exportMdSummaryHealth(
          health['averageSystolic'],
          health['averageDiastolic'],
          health['averagePulse'],
          health['bloodPressureMeasurementsCount']));
    }
    final bucket = s['bucketList'] as Map<String, dynamic>?;
    if (bucket != null) {
      lines.add(l10n.exportMdSummaryBucket(
          bucket['completedCount'], bucket['averageFeelingRating'] ?? '—'));
    }
    return lines;
  }

  // ── Per-record serialization (excludes *Lower; enums → code; € from cents) ──

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
        'id': e.id, 'date': e.date, 'time': e.time, 'amount': _eur(e.amountCents),
        'category': e.category.code, 'description': e.description,
        'paymentMethod': e.paymentMethod?.code, 'note': e.note,
        'createdAt': _iso(e.createdAt), 'updatedAt': _iso(e.updatedAt),
      };

  Map<String, dynamic> _income(IncomeEntry i) => {
        'id': i.id, 'date': i.date, 'amount': _eur(i.amountCents),
        'source': i.source, 'category': i.category.code, 'note': i.note,
        'createdAt': _iso(i.createdAt), 'updatedAt': _iso(i.updatedAt),
      };

  Map<String, dynamic> _event(HealthEvent e) => {
        'id': e.id, 'date': e.date, 'type': e.type.code,
        'subtype': e.subtype?.code, 'clinic': e.clinic, 'reason': e.reason,
        'whatWasDone': e.whatWasDone,
        'price': e.priceCents == null ? null : _eur(e.priceCents!),
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
        'source': s.source.code,
        'createdAt': _iso(s.createdAt), 'updatedAt': _iso(s.updatedAt),
      };

  Map<String, dynamic> _weight(WeightLog w) => {
        'id': w.id, 'date': w.date, 'weightGrams': w.weightGrams,
        'note': w.note,
        'createdAt': _iso(w.createdAt), 'updatedAt': _iso(w.updatedAt),
      };

  Map<String, dynamic> _bucketItem(BucketItem b) => {
        'id': b.id, 'title': b.title, 'description': b.description,
        'whyWantIt': b.whyWantIt, 'priority': b.priority.code,
        'status': b.status.code,
        'createdAt': _iso(b.createdAt), 'updatedAt': _iso(b.updatedAt),
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

  // ── Markdown line helpers ────────────────────────────────────────────

  String _dailyLine(DailyLog l, AppLocalizations l10n) {
    final parts = [l10n.exportMdDailyMood(l.mood)];
    if (l.workout) parts.add(l10n.exportMdDailyWorkout);
    if (l.drankAlcohol) parts.add(l10n.exportMdDailyAlcohol);
    if (l.note != null && l.note!.isNotEmpty) parts.add(l.note!);
    return '${l.date}: ${parts.join(', ')}';
  }

  String _mealLine(Meal m, AppLocalizations l10n) {
    final cal = m.calories != null ? l10n.exportMdMealCalories(m.calories!) : '';
    return '${m.date}: ${m.name} (${l10n.mealTypeLabel(m.type.code)})$cal';
  }

  String _activityLine(Activity a, AppLocalizations l10n) {
    final dur =
        a.durationMin != null ? l10n.exportMdActivityDuration(a.durationMin!) : '';
    final typeLabel = l10n.activityTypeLabel(a.type.code);
    return '${a.date}: ${a.name ?? typeLabel} ($typeLabel)$dur';
  }

  String _eventLine(HealthEvent e, AppLocalizations l10n) {
    final next = e.nextRecommendedDate != null
        ? l10n.exportMdEventNext(e.nextRecommendedDate!)
        : '';
    return '${e.date}: ${l10n.healthEventTypeLabel(e.type.code)} — ${e.whatWasDone}$next';
  }

  String _bucketLine(BucketItem i, AppLocalizations l10n) =>
      l10n.exportMdBucketLine(i.title, l10n.bucketStatusLabel(i.status.code),
          l10n.bucketPriorityLabel(i.priority.code));

  // ── Primitives ─────────────────────────────────────────────────────

  /// Cents → euros as a `num` (int when whole, e.g. 12000 → 120; else 32.5).
  num _eur(int cents) {
    final v = cents / 100;
    return v == v.roundToDouble() ? v.toInt() : v;
  }

  /// Integer grams → one-decimal kilograms string (e.g. 82500 → "82.5").
  String _kg(int grams) => (grams / 1000).toStringAsFixed(1);

  int _avg(Iterable<int> xs) {
    var sum = 0, n = 0;
    for (final x in xs) {
      sum += x;
      n++;
    }
    return n == 0 ? 0 : (sum / n).round();
  }

  String _iso(DateTime d) => d.toIso8601String();

  String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
