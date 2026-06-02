// DAOs — the single write path per table (every write runs `_withLower`, the
// sole writer of the lowercased shadow columns) plus reactive reads, range/
// filter queries, and aggregate summaries (Slice 3.4). Search is a Cyrillic-
// safe `LIKE` over the `*Lower` columns. See docs/technical-spec.md §3, §9, §24.

import 'package:drift/drift.dart';

import '../domain/enums.dart';
import '../domain/summaries.dart';
import '../domain/search_hit.dart';
import 'database.dart';
import 'summaries.dart';
import 'tables/meals.dart';
import 'tables/activities.dart';
import 'tables/finance.dart';
import 'tables/health.dart';
import 'tables/daily_logs.dart';
import 'tables/steps.dart';
import 'tables/bucket.dart';
import 'tables/trips.dart';
import 'tables/attachments.dart';
import 'tables/settings.dart';

part 'daos.g.dart';

Value<String> _lc(Value<String> v) =>
    v.present ? Value(v.value.toLowerCase()) : const Value.absent();
Value<String?> _lcN(Value<String?> v) =>
    v.present ? Value(v.value?.toLowerCase()) : const Value.absent();

OrderingTerm _asc(Expression<Object> c) => OrderingTerm.asc(c);
OrderingTerm _desc(Expression<Object> c) => OrderingTerm.desc(c);

/// Escapes LIKE wildcards then wraps in `%…%`. Query is lowercased in Dart
/// (Cyrillic-safe) before matching the `*Lower` columns.
String _likePattern(String query) {
  final q = query.trim().toLowerCase().replaceAll('%', '').replaceAll('_', '');
  return '%$q%';
}

// ── Meals ───────────────────────────────────────────────────────────
@DriftAccessor(tables: [Meals])
class MealsDao extends DatabaseAccessor<AppDatabase> with _$MealsDaoMixin {
  MealsDao(super.db);

  MealsCompanion _withLower(MealsCompanion c) =>
      c.copyWith(nameLower: _lc(c.name), noteLower: _lcN(c.note));

  Future<void> save(MealsCompanion c) =>
      into(meals).insertOnConflictUpdate(_withLower(c));
  Future<void> deleteById(String id) =>
      (delete(meals)..where((t) => t.id.equals(id))).go();
  Future<Meal?> getById(String id) =>
      (select(meals)..where((t) => t.id.equals(id))).getSingleOrNull();
  Stream<List<Meal>> watchByDate(String date) => (select(meals)
        ..where((t) => t.date.equals(date))
        ..orderBy([(t) => _asc(t.time)]))
      .watch();

  SimpleSelectStatement<$MealsTable, Meal> _range(String from, String to) =>
      select(meals)
        ..where((t) => t.date.isBetweenValues(from, to))
        ..orderBy([(t) => _desc(t.date), (t) => _asc(t.time)]);
  Stream<List<Meal>> watchInRange(String from, String to) =>
      _range(from, to).watch();
  Future<List<Meal>> inRange(String from, String to) => _range(from, to).get();

  Future<FoodSummary> summary(String from, String to) async =>
      computeFood(await inRange(from, to), daysInclusive(from, to));
  Future<DailyNutrition> dailyTotals(String date) async => computeDailyNutrition(
      await (select(meals)..where((t) => t.date.equals(date))).get());
}

// ── Activities ──────────────────────────────────────────────────────
@DriftAccessor(tables: [Activities])
class ActivitiesDao extends DatabaseAccessor<AppDatabase>
    with _$ActivitiesDaoMixin {
  ActivitiesDao(super.db);

  ActivitiesCompanion _withLower(ActivitiesCompanion c) =>
      c.copyWith(nameLower: _lcN(c.name), noteLower: _lcN(c.note));

  Future<void> save(ActivitiesCompanion c) =>
      into(activities).insertOnConflictUpdate(_withLower(c));
  Future<void> deleteById(String id) =>
      (delete(activities)..where((t) => t.id.equals(id))).go();
  Future<Activity?> getById(String id) =>
      (select(activities)..where((t) => t.id.equals(id))).getSingleOrNull();
  Stream<List<Activity>> watchByDate(String date) => (select(activities)
        ..where((t) => t.date.equals(date))
        ..orderBy([(t) => _asc(t.startTime)]))
      .watch();

  SimpleSelectStatement<$ActivitiesTable, Activity> _range(
      String from, String to, ActivityType? type) {
    final q = select(activities)
      ..where((t) => t.date.isBetweenValues(from, to))
      ..orderBy([(t) => _desc(t.date)]);
    if (type != null) q.where((t) => t.type.equalsValue(type));
    return q;
  }

  Stream<List<Activity>> watchInRange(String from, String to,
          {ActivityType? type}) =>
      _range(from, to, type).watch();
  Future<List<Activity>> inRange(String from, String to,
          {ActivityType? type}) =>
      _range(from, to, type).get();
  Future<ActivitySummary> summary(String from, String to) async =>
      computeActivities(await inRange(from, to));
}

// ── Finance (expenses + income) ─────────────────────────────────────
@DriftAccessor(tables: [Expenses, Income])
class FinanceDao extends DatabaseAccessor<AppDatabase> with _$FinanceDaoMixin {
  FinanceDao(super.db);

  ExpensesCompanion _expLower(ExpensesCompanion c) => c.copyWith(
      descriptionLower: _lc(c.description), noteLower: _lcN(c.note));
  IncomeCompanion _incLower(IncomeCompanion c) =>
      c.copyWith(sourceLower: _lc(c.source), noteLower: _lcN(c.note));

  Future<void> saveExpense(ExpensesCompanion c) =>
      into(expenses).insertOnConflictUpdate(_expLower(c));
  Future<void> saveIncome(IncomeCompanion c) =>
      into(income).insertOnConflictUpdate(_incLower(c));
  Future<void> deleteExpense(String id) =>
      (delete(expenses)..where((t) => t.id.equals(id))).go();
  Future<void> deleteIncome(String id) =>
      (delete(income)..where((t) => t.id.equals(id))).go();
  Future<Expense?> getExpense(String id) =>
      (select(expenses)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<IncomeEntry?> getIncome(String id) =>
      (select(income)..where((t) => t.id.equals(id))).getSingleOrNull();

  SimpleSelectStatement<$ExpensesTable, Expense> _expRange(
      String from, String to, ExpenseCategory? cat) {
    final q = select(expenses)
      ..where((t) => t.date.isBetweenValues(from, to))
      ..orderBy([(t) => _desc(t.date), (t) => _asc(t.time)]);
    if (cat != null) q.where((t) => t.category.equalsValue(cat));
    return q;
  }

  Stream<List<Expense>> watchExpensesInRange(String from, String to,
          {ExpenseCategory? category}) =>
      _expRange(from, to, category).watch();
  Future<List<Expense>> expensesInRange(String from, String to,
          {ExpenseCategory? category}) =>
      _expRange(from, to, category).get();

  Stream<List<IncomeEntry>> watchIncomeInRange(String from, String to) =>
      (select(income)
            ..where((t) => t.date.isBetweenValues(from, to))
            ..orderBy([(t) => _desc(t.date)]))
          .watch();
  Future<List<IncomeEntry>> incomeInRange(String from, String to) =>
      (select(income)..where((t) => t.date.isBetweenValues(from, to))).get();

  Future<FinanceSummary> summary(String from, String to) async => computeFinance(
        await expensesInRange(from, to),
        await incomeInRange(from, to),
        daysInclusive(from, to),
      );
}

// ── Health (vitals, meds, events, labs) ─────────────────────────────
@DriftAccessor(
    tables: [BloodPressureLogs, MedicationLogs, HealthEvents, LabTests])
class HealthDao extends DatabaseAccessor<AppDatabase> with _$HealthDaoMixin {
  HealthDao(super.db);

  BloodPressureLogsCompanion _bpLower(BloodPressureLogsCompanion c) =>
      c.copyWith(noteLower: _lcN(c.note));
  MedicationLogsCompanion _medLower(MedicationLogsCompanion c) => c.copyWith(
      nameLower: _lc(c.name), reasonLower: _lcN(c.reason), noteLower: _lcN(c.note));
  HealthEventsCompanion _eventLower(HealthEventsCompanion c) => c.copyWith(
        clinicLower: _lcN(c.clinic),
        reasonLower: _lcN(c.reason),
        whatWasDoneLower: _lc(c.whatWasDone),
        noteLower: _lcN(c.note),
      );
  LabTestsCompanion _labLower(LabTestsCompanion c) => c.copyWith(
        labLower: _lc(c.lab),
        reasonLower: _lc(c.reason),
        resultsTextLower: _lcN(c.resultsText),
        noteLower: _lcN(c.note),
      );

  Future<void> saveBp(BloodPressureLogsCompanion c) =>
      into(bloodPressureLogs).insertOnConflictUpdate(_bpLower(c));
  Future<void> saveMed(MedicationLogsCompanion c) =>
      into(medicationLogs).insertOnConflictUpdate(_medLower(c));
  Future<void> saveEvent(HealthEventsCompanion c) =>
      into(healthEvents).insertOnConflictUpdate(_eventLower(c));
  Future<void> saveLab(LabTestsCompanion c) =>
      into(labTests).insertOnConflictUpdate(_labLower(c));

  Future<void> deleteBp(String id) =>
      (delete(bloodPressureLogs)..where((t) => t.id.equals(id))).go();
  Future<void> deleteMed(String id) =>
      (delete(medicationLogs)..where((t) => t.id.equals(id))).go();
  Future<void> deleteEvent(String id) =>
      (delete(healthEvents)..where((t) => t.id.equals(id))).go();
  Future<void> deleteLab(String id) =>
      (delete(labTests)..where((t) => t.id.equals(id))).go();

  Future<BloodPressureLog?> getBp(String id) =>
      (select(bloodPressureLogs)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
  Future<MedicationLog?> getMed(String id) =>
      (select(medicationLogs)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<HealthEvent?> getEvent(String id) =>
      (select(healthEvents)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<LabTest?> getLab(String id) =>
      (select(labTests)..where((t) => t.id.equals(id))).getSingleOrNull();

  Stream<List<BloodPressureLog>> watchBpInRange(String from, String to) =>
      (select(bloodPressureLogs)
            ..where((t) => t.date.isBetweenValues(from, to))
            ..orderBy([(t) => _desc(t.date), (t) => _desc(t.time)]))
          .watch();
  Stream<List<MedicationLog>> watchMedsByDate(String date) =>
      (select(medicationLogs)
            ..where((t) => t.date.equals(date))
            ..orderBy([(t) => _asc(t.time)]))
          .watch();
  Stream<List<MedicationLog>> watchMedsInRange(String from, String to) =>
      (select(medicationLogs)
            ..where((t) => t.date.isBetweenValues(from, to))
            ..orderBy([(t) => _desc(t.date), (t) => _asc(t.time)]))
          .watch();
  Stream<List<HealthEvent>> watchEvents({HealthEventType? type}) {
    final q = select(healthEvents)..orderBy([(t) => _desc(t.date)]);
    if (type != null) q.where((t) => t.type.equalsValue(type));
    return q.watch();
  }

  Stream<List<LabTest>> watchLabs() =>
      (select(labTests)..orderBy([(t) => _desc(t.date)])).watch();

  Future<HealthSummary> summary(String from, String to) async {
    final bp = await (select(bloodPressureLogs)
          ..where((t) => t.date.isBetweenValues(from, to)))
        .get();
    final meds = await (select(medicationLogs)
          ..where((t) => t.date.isBetweenValues(from, to)))
        .get();
    final events = await (select(healthEvents)
          ..where((t) => t.date.isBetweenValues(from, to)))
        .get();
    final labs = await (select(labTests)
          ..where((t) => t.date.isBetweenValues(from, to)))
        .get();
    return computeHealth(bp, events, labs, meds);
  }
}

// ── Daily logs ──────────────────────────────────────────────────────
@DriftAccessor(tables: [DailyLogs])
class DailyLogsDao extends DatabaseAccessor<AppDatabase>
    with _$DailyLogsDaoMixin {
  DailyLogsDao(super.db);

  DailyLogsCompanion _withLower(DailyLogsCompanion c) =>
      c.copyWith(noteLower: _lcN(c.note));

  Future<void> save(DailyLogsCompanion c) =>
      into(dailyLogs).insertOnConflictUpdate(_withLower(c));
  Future<void> deleteById(String id) =>
      (delete(dailyLogs)..where((t) => t.id.equals(id))).go();
  Future<DailyLog?> getByDate(String date) =>
      (select(dailyLogs)..where((t) => t.date.equals(date))).getSingleOrNull();
  Stream<DailyLog?> watchByDate(String date) =>
      (select(dailyLogs)..where((t) => t.date.equals(date)))
          .watchSingleOrNull();

  Future<List<DailyLog>> inRange(String from, String to) =>
      (select(dailyLogs)..where((t) => t.date.isBetweenValues(from, to))).get();
  Stream<List<DailyLog>> watchAll() =>
      (select(dailyLogs)..orderBy([(t) => _desc(t.date)])).watch();
  Stream<List<DailyLog>> watchInRange(String from, String to) =>
      (select(dailyLogs)
            ..where((t) => t.date.isBetweenValues(from, to))
            ..orderBy([(t) => _asc(t.date)]))
          .watch();
  Future<DailyLogSummary> summary(String from, String to) async =>
      computeDailyLogs(await inRange(from, to));
}

// ── Steps ───────────────────────────────────────────────────────────
@DriftAccessor(tables: [Steps])
class StepsDao extends DatabaseAccessor<AppDatabase> with _$StepsDaoMixin {
  StepsDao(super.db);

  Future<void> save(StepsCompanion c) =>
      into(steps).insertOnConflictUpdate(c);
  Future<void> deleteById(String id) =>
      (delete(steps)..where((t) => t.id.equals(id))).go();
  Future<StepEntry?> getByDate(String date) =>
      (select(steps)..where((t) => t.date.equals(date))).getSingleOrNull();
  Stream<List<StepEntry>> watchInRange(String from, String to) =>
      (select(steps)
            ..where((t) => t.date.isBetweenValues(from, to))
            ..orderBy([(t) => _asc(t.date)]))
          .watch();
  Future<List<StepEntry>> inRange(String from, String to) =>
      (select(steps)..where((t) => t.date.isBetweenValues(from, to))).get();
  Future<StepsSummary> summary(String from, String to) async =>
      computeSteps(await inRange(from, to));
}

// ── Bucket (items + experiences) ────────────────────────────────────
@DriftAccessor(tables: [BucketItems, BucketExperiences])
class BucketDao extends DatabaseAccessor<AppDatabase> with _$BucketDaoMixin {
  BucketDao(super.db);

  BucketItemsCompanion _itemLower(BucketItemsCompanion c) => c.copyWith(
        titleLower: _lc(c.title),
        descriptionLower: _lcN(c.description),
        whyWantItLower: _lcN(c.whyWantIt),
      );
  BucketExperiencesCompanion _expLower(BucketExperiencesCompanion c) =>
      c.copyWith(reflectionLower: _lcN(c.reflection));

  Future<void> saveItem(BucketItemsCompanion c) =>
      into(bucketItems).insertOnConflictUpdate(_itemLower(c));
  Future<void> saveExperience(BucketExperiencesCompanion c) =>
      into(bucketExperiences).insertOnConflictUpdate(_expLower(c));
  Future<void> deleteItem(String id) =>
      (delete(bucketItems)..where((t) => t.id.equals(id))).go();
  Future<BucketItem?> getItem(String id) =>
      (select(bucketItems)..where((t) => t.id.equals(id))).getSingleOrNull();
  Stream<BucketItem?> watchItem(String id) =>
      (select(bucketItems)..where((t) => t.id.equals(id))).watchSingleOrNull();
  Future<BucketExperience?> experienceForItem(String itemId) =>
      (select(bucketExperiences)..where((t) => t.bucketItemId.equals(itemId)))
          .getSingleOrNull();
  Stream<BucketExperience?> watchExperienceForItem(String itemId) =>
      (select(bucketExperiences)..where((t) => t.bucketItemId.equals(itemId)))
          .watchSingleOrNull();
  Stream<List<BucketExperience>> watchAllExperiences() =>
      select(bucketExperiences).watch();

  Stream<List<BucketItem>> watchItems(
      {BucketStatus? status, BucketPriority? priority}) {
    final q = select(bucketItems)..orderBy([(t) => _desc(t.createdAt)]);
    if (status != null) q.where((t) => t.status.equalsValue(status));
    if (priority != null) q.where((t) => t.priority.equalsValue(priority));
    return q.watch();
  }

  Future<BucketStats> stats() async {
    final items = await select(bucketItems).get();
    final exps = await select(bucketExperiences).get();
    return computeBucket(items, exps);
  }
}

// ── Trips ───────────────────────────────────────────────────────────
@DriftAccessor(tables: [Trips])
class TripsDao extends DatabaseAccessor<AppDatabase> with _$TripsDaoMixin {
  TripsDao(super.db);

  TripsCompanion _withLower(TripsCompanion c) => c.copyWith(
        titleLower: _lc(c.title),
        destinationLower: _lc(c.destination),
        commentLower: _lcN(c.comment),
      );

  Future<void> save(TripsCompanion c) =>
      into(trips).insertOnConflictUpdate(_withLower(c));
  Future<void> deleteById(String id) =>
      (delete(trips)..where((t) => t.id.equals(id))).go();
  Future<Trip?> getById(String id) =>
      (select(trips)..where((t) => t.id.equals(id))).getSingleOrNull();
  Stream<Trip?> watchById(String id) =>
      (select(trips)..where((t) => t.id.equals(id))).watchSingleOrNull();

  Stream<List<Trip>> watchAll({int? minOverall, bool? wouldRepeat}) {
    final q = select(trips)..orderBy([(t) => _desc(t.fromDate)]);
    if (minOverall != null) {
      q.where((t) => t.overall.isBiggerOrEqualValue(minOverall));
    }
    if (wouldRepeat != null) {
      q.where((t) => t.wouldRepeat.equals(wouldRepeat));
    }
    return q.watch();
  }

  Future<TripStats> stats() async => computeTrips(await select(trips).get());
}

// ── Attachments (cardinality enforced by AttachmentService, Phase 7.2) ──
@DriftAccessor(tables: [Attachments])
class AttachmentsDao extends DatabaseAccessor<AppDatabase>
    with _$AttachmentsDaoMixin {
  AttachmentsDao(super.db);

  Future<void> save(AttachmentsCompanion c) =>
      into(attachments).insertOnConflictUpdate(c);
  Future<void> deleteById(String id) =>
      (delete(attachments)..where((t) => t.id.equals(id))).go();
  Stream<List<Attachment>> watchByType(AttachmentEntity type) =>
      (select(attachments)..where((t) => t.entityType.equalsValue(type))).watch();
  Future<List<Attachment>> forEntity(AttachmentEntity type, String entityId) =>
      (select(attachments)
            ..where((t) =>
                t.entityType.equalsValue(type) & t.entityId.equals(entityId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();
  Stream<List<Attachment>> watchForEntity(
          AttachmentEntity type, String entityId) =>
      (select(attachments)
            ..where((t) =>
                t.entityType.equalsValue(type) & t.entityId.equals(entityId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();
}

// ── Global search (Cyrillic-safe, over *Lower columns) ──────────────
@DriftAccessor(tables: [
  Meals,
  Activities,
  Expenses,
  Income,
  HealthEvents,
  LabTests,
  BloodPressureLogs,
  MedicationLogs,
  DailyLogs,
  BucketItems,
  BucketExperiences,
  Trips,
])
class SearchDao extends DatabaseAccessor<AppDatabase> with _$SearchDaoMixin {
  SearchDao(super.db);

  /// Substring search across every searchable module (spec §24.2). Empty
  /// query returns nothing.
  Future<List<SearchHit>> search(String query) async {
    if (query.trim().isEmpty) return const [];
    final p = _likePattern(query);
    final hits = <SearchHit>[];

    for (final m in await (select(meals)
          ..where((t) => t.nameLower.like(p) | t.noteLower.like(p)))
        .get()) {
      hits.add(SearchHit(
          kind: SearchKind.meal, id: m.id, title: m.name,
          subtitle: m.type.label, date: m.date));
    }
    for (final a in await (select(activities)
          ..where((t) => t.nameLower.like(p) | t.noteLower.like(p)))
        .get()) {
      hits.add(SearchHit(
          kind: SearchKind.activity, id: a.id, title: a.name ?? a.type.label,
          subtitle: a.type.label, date: a.date));
    }
    for (final e in await (select(expenses)
          ..where((t) => t.descriptionLower.like(p) | t.noteLower.like(p)))
        .get()) {
      hits.add(SearchHit(
          kind: SearchKind.expense, id: e.id, title: e.description,
          subtitle: e.category.label, date: e.date));
    }
    for (final i in await (select(income)
          ..where((t) => t.sourceLower.like(p) | t.noteLower.like(p)))
        .get()) {
      hits.add(SearchHit(
          kind: SearchKind.income, id: i.id, title: i.source,
          subtitle: i.category.label, date: i.date));
    }
    for (final h in await (select(healthEvents)
          ..where((t) =>
              t.clinicLower.like(p) |
              t.reasonLower.like(p) |
              t.whatWasDoneLower.like(p) |
              t.noteLower.like(p)))
        .get()) {
      hits.add(SearchHit(
          kind: SearchKind.healthEvent, id: h.id, title: h.type.label,
          subtitle: h.clinic ?? h.whatWasDone, date: h.date));
    }
    for (final l in await (select(labTests)
          ..where((t) =>
              t.labLower.like(p) |
              t.reasonLower.like(p) |
              t.resultsTextLower.like(p) |
              t.noteLower.like(p)))
        .get()) {
      hits.add(SearchHit(
          kind: SearchKind.labTest, id: l.id, title: l.lab,
          subtitle: l.reason, date: l.date));
    }
    for (final b in await (select(bloodPressureLogs)
          ..where((t) => t.noteLower.like(p)))
        .get()) {
      hits.add(SearchHit(
          kind: SearchKind.bloodPressure, id: b.id,
          title: '${b.systolic}/${b.diastolic}', subtitle: b.note ?? '',
          date: b.date));
    }
    for (final md in await (select(medicationLogs)
          ..where((t) =>
              t.nameLower.like(p) | t.reasonLower.like(p) | t.noteLower.like(p)))
        .get()) {
      hits.add(SearchHit(
          kind: SearchKind.medication, id: md.id, title: md.name,
          subtitle: md.type.label, date: md.date));
    }
    for (final d in await (select(dailyLogs)..where((t) => t.noteLower.like(p)))
        .get()) {
      hits.add(SearchHit(
          kind: SearchKind.dailyLog, id: d.id, title: 'Дневен отчет',
          subtitle: d.note ?? '', date: d.date));
    }
    final seenItems = <String>{};
    for (final bi in await (select(bucketItems)
          ..where((t) =>
              t.titleLower.like(p) |
              t.descriptionLower.like(p) |
              t.whyWantItLower.like(p)))
        .get()) {
      seenItems.add(bi.id);
      hits.add(SearchHit(
          kind: SearchKind.bucketItem, id: bi.id, title: bi.title,
          subtitle: bi.status.label));
    }
    // Bucket experiences (reflection) → map back to their item.
    for (final ex in await (select(bucketExperiences)
          ..where((t) => t.reflectionLower.like(p)))
        .get()) {
      if (seenItems.contains(ex.bucketItemId)) continue;
      final item = await (select(bucketItems)
            ..where((t) => t.id.equals(ex.bucketItemId)))
          .getSingleOrNull();
      if (item != null) {
        seenItems.add(item.id);
        hits.add(SearchHit(
            kind: SearchKind.bucketItem, id: item.id, title: item.title,
            subtitle: item.status.label));
      }
    }
    for (final tr in await (select(trips)
          ..where((t) =>
              t.titleLower.like(p) |
              t.destinationLower.like(p) |
              t.commentLower.like(p)))
        .get()) {
      hits.add(SearchHit(
          kind: SearchKind.trip, id: tr.id, title: tr.title,
          subtitle: tr.destination, date: tr.fromDate));
    }

    // Newest first; undated (bucket) sink to the end.
    hits.sort((a, b) => b.date.compareTo(a.date));
    return hits;
  }
}

// ── Settings (key/value preferences) ────────────────────────────────
@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<String?> getValue(String key) async {
    final row =
        await (select(settings)..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setValue(String key, String value) => into(settings)
      .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));

  Future<void> deleteKey(String key) =>
      (delete(settings)..where((t) => t.key.equals(key))).go();
}
