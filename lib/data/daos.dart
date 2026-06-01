// DAOs — the single write path per table. Every write goes through `save`,
// which runs `_withLower` to populate the lowercased shadow columns (Dart
// toLowerCase, Cyrillic-safe). Callers never set `*Lower` directly. Reads are
// reactive (`watch…`). Search/filter/aggregates are added in Slice 3.4.

import 'package:drift/drift.dart';

import '../domain/enums.dart';
import 'database.dart';
import 'tables/meals.dart';
import 'tables/activities.dart';
import 'tables/finance.dart';
import 'tables/health.dart';
import 'tables/daily_logs.dart';
import 'tables/steps.dart';
import 'tables/bucket.dart';
import 'tables/trips.dart';
import 'tables/attachments.dart';

part 'daos.g.dart';

// Lowercase a non-null text Value (absent stays absent).
Value<String> _lc(Value<String> v) =>
    v.present ? Value(v.value.toLowerCase()) : const Value.absent();

// Lowercase a nullable text Value (absent stays absent; null stays null).
Value<String?> _lcN(Value<String?> v) =>
    v.present ? Value(v.value?.toLowerCase()) : const Value.absent();

OrderingTerm _asc(Expression<Object> c) => OrderingTerm.asc(c);
OrderingTerm _desc(Expression<Object> c) => OrderingTerm.desc(c);

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
}

// ── Expenses ────────────────────────────────────────────────────────
@DriftAccessor(tables: [Expenses])
class ExpensesDao extends DatabaseAccessor<AppDatabase>
    with _$ExpensesDaoMixin {
  ExpensesDao(super.db);

  ExpensesCompanion _withLower(ExpensesCompanion c) => c.copyWith(
      descriptionLower: _lc(c.description), noteLower: _lcN(c.note));

  Future<void> save(ExpensesCompanion c) =>
      into(expenses).insertOnConflictUpdate(_withLower(c));
  Future<void> deleteById(String id) =>
      (delete(expenses)..where((t) => t.id.equals(id))).go();
  Future<Expense?> getById(String id) =>
      (select(expenses)..where((t) => t.id.equals(id))).getSingleOrNull();
  Stream<List<Expense>> watchByDate(String date) => (select(expenses)
        ..where((t) => t.date.equals(date))
        ..orderBy([(t) => _asc(t.time)]))
      .watch();
}

// ── Income ──────────────────────────────────────────────────────────
@DriftAccessor(tables: [Income])
class IncomeDao extends DatabaseAccessor<AppDatabase> with _$IncomeDaoMixin {
  IncomeDao(super.db);

  IncomeCompanion _withLower(IncomeCompanion c) =>
      c.copyWith(sourceLower: _lc(c.source), noteLower: _lcN(c.note));

  Future<void> save(IncomeCompanion c) =>
      into(income).insertOnConflictUpdate(_withLower(c));
  Future<void> deleteById(String id) =>
      (delete(income)..where((t) => t.id.equals(id))).go();
  Future<IncomeEntry?> getById(String id) =>
      (select(income)..where((t) => t.id.equals(id))).getSingleOrNull();
  Stream<List<IncomeEntry>> watchByDate(String date) =>
      (select(income)..where((t) => t.date.equals(date))).watch();
}

// ── Health events ───────────────────────────────────────────────────
@DriftAccessor(tables: [HealthEvents])
class HealthEventsDao extends DatabaseAccessor<AppDatabase>
    with _$HealthEventsDaoMixin {
  HealthEventsDao(super.db);

  HealthEventsCompanion _withLower(HealthEventsCompanion c) => c.copyWith(
        clinicLower: _lcN(c.clinic),
        reasonLower: _lcN(c.reason),
        whatWasDoneLower: _lc(c.whatWasDone),
        noteLower: _lcN(c.note),
      );

  Future<void> save(HealthEventsCompanion c) =>
      into(healthEvents).insertOnConflictUpdate(_withLower(c));
  Future<void> deleteById(String id) =>
      (delete(healthEvents)..where((t) => t.id.equals(id))).go();
  Future<HealthEvent?> getById(String id) =>
      (select(healthEvents)..where((t) => t.id.equals(id))).getSingleOrNull();
  Stream<List<HealthEvent>> watchAll() =>
      (select(healthEvents)..orderBy([(t) => _desc(t.date)])).watch();
}

// ── Lab tests ───────────────────────────────────────────────────────
@DriftAccessor(tables: [LabTests])
class LabTestsDao extends DatabaseAccessor<AppDatabase>
    with _$LabTestsDaoMixin {
  LabTestsDao(super.db);

  LabTestsCompanion _withLower(LabTestsCompanion c) => c.copyWith(
        labLower: _lc(c.lab),
        reasonLower: _lc(c.reason),
        resultsTextLower: _lcN(c.resultsText),
        noteLower: _lcN(c.note),
      );

  Future<void> save(LabTestsCompanion c) =>
      into(labTests).insertOnConflictUpdate(_withLower(c));
  Future<void> deleteById(String id) =>
      (delete(labTests)..where((t) => t.id.equals(id))).go();
  Future<LabTest?> getById(String id) =>
      (select(labTests)..where((t) => t.id.equals(id))).getSingleOrNull();
  Stream<List<LabTest>> watchAll() =>
      (select(labTests)..orderBy([(t) => _desc(t.date)])).watch();
}

// ── Blood pressure ──────────────────────────────────────────────────
@DriftAccessor(tables: [BloodPressureLogs])
class BloodPressureDao extends DatabaseAccessor<AppDatabase>
    with _$BloodPressureDaoMixin {
  BloodPressureDao(super.db);

  BloodPressureLogsCompanion _withLower(BloodPressureLogsCompanion c) =>
      c.copyWith(noteLower: _lcN(c.note));

  Future<void> save(BloodPressureLogsCompanion c) =>
      into(bloodPressureLogs).insertOnConflictUpdate(_withLower(c));
  Future<void> deleteById(String id) =>
      (delete(bloodPressureLogs)..where((t) => t.id.equals(id))).go();
  Future<BloodPressureLog?> getById(String id) =>
      (select(bloodPressureLogs)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
  Stream<List<BloodPressureLog>> watchByDate(String date) =>
      (select(bloodPressureLogs)
            ..where((t) => t.date.equals(date))
            ..orderBy([(t) => _asc(t.time)]))
          .watch();
}

// ── Medications ─────────────────────────────────────────────────────
@DriftAccessor(tables: [MedicationLogs])
class MedicationsDao extends DatabaseAccessor<AppDatabase>
    with _$MedicationsDaoMixin {
  MedicationsDao(super.db);

  MedicationLogsCompanion _withLower(MedicationLogsCompanion c) => c.copyWith(
        nameLower: _lc(c.name),
        reasonLower: _lcN(c.reason),
        noteLower: _lcN(c.note),
      );

  Future<void> save(MedicationLogsCompanion c) =>
      into(medicationLogs).insertOnConflictUpdate(_withLower(c));
  Future<void> deleteById(String id) =>
      (delete(medicationLogs)..where((t) => t.id.equals(id))).go();
  Future<MedicationLog?> getById(String id) =>
      (select(medicationLogs)..where((t) => t.id.equals(id)))
          .getSingleOrNull();
  Stream<List<MedicationLog>> watchByDate(String date) =>
      (select(medicationLogs)
            ..where((t) => t.date.equals(date))
            ..orderBy([(t) => _asc(t.time)]))
          .watch();
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
}

// ── Steps (no searchable text) ──────────────────────────────────────
@DriftAccessor(tables: [Steps])
class StepsDao extends DatabaseAccessor<AppDatabase> with _$StepsDaoMixin {
  StepsDao(super.db);

  Future<void> save(StepsCompanion c) =>
      into(steps).insertOnConflictUpdate(c);
  Future<void> deleteById(String id) =>
      (delete(steps)..where((t) => t.id.equals(id))).go();
  Future<StepEntry?> getByDate(String date) =>
      (select(steps)..where((t) => t.date.equals(date))).getSingleOrNull();
  Stream<List<StepEntry>> watchAll() =>
      (select(steps)..orderBy([(t) => _desc(t.date)])).watch();
}

// ── Bucket items ────────────────────────────────────────────────────
@DriftAccessor(tables: [BucketItems])
class BucketItemsDao extends DatabaseAccessor<AppDatabase>
    with _$BucketItemsDaoMixin {
  BucketItemsDao(super.db);

  BucketItemsCompanion _withLower(BucketItemsCompanion c) => c.copyWith(
        titleLower: _lc(c.title),
        descriptionLower: _lcN(c.description),
        whyWantItLower: _lcN(c.whyWantIt),
      );

  Future<void> save(BucketItemsCompanion c) =>
      into(bucketItems).insertOnConflictUpdate(_withLower(c));
  Future<void> deleteById(String id) =>
      (delete(bucketItems)..where((t) => t.id.equals(id))).go();
  Future<BucketItem?> getById(String id) =>
      (select(bucketItems)..where((t) => t.id.equals(id))).getSingleOrNull();
  Stream<List<BucketItem>> watchAll() =>
      (select(bucketItems)..orderBy([(t) => _desc(t.createdAt)])).watch();
}

// ── Bucket experiences ──────────────────────────────────────────────
@DriftAccessor(tables: [BucketExperiences])
class BucketExperiencesDao extends DatabaseAccessor<AppDatabase>
    with _$BucketExperiencesDaoMixin {
  BucketExperiencesDao(super.db);

  BucketExperiencesCompanion _withLower(BucketExperiencesCompanion c) =>
      c.copyWith(reflectionLower: _lcN(c.reflection));

  Future<void> save(BucketExperiencesCompanion c) =>
      into(bucketExperiences).insertOnConflictUpdate(_withLower(c));
  Future<void> deleteById(String id) =>
      (delete(bucketExperiences)..where((t) => t.id.equals(id))).go();
  Future<BucketExperience?> getByItemId(String itemId) =>
      (select(bucketExperiences)..where((t) => t.bucketItemId.equals(itemId)))
          .getSingleOrNull();
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
  Stream<List<Trip>> watchAll() =>
      (select(trips)..orderBy([(t) => _desc(t.fromDate)])).watch();
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
