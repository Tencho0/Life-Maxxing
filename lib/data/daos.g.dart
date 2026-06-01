// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daos.dart';

// ignore_for_file: type=lint
mixin _$MealsDaoMixin on DatabaseAccessor<AppDatabase> {
  $MealsTable get meals => attachedDatabase.meals;
  MealsDaoManager get managers => MealsDaoManager(this);
}

class MealsDaoManager {
  final _$MealsDaoMixin _db;
  MealsDaoManager(this._db);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db.attachedDatabase, _db.meals);
}

mixin _$ActivitiesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ActivitiesTable get activities => attachedDatabase.activities;
  ActivitiesDaoManager get managers => ActivitiesDaoManager(this);
}

class ActivitiesDaoManager {
  final _$ActivitiesDaoMixin _db;
  ActivitiesDaoManager(this._db);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db.attachedDatabase, _db.activities);
}

mixin _$ExpensesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ExpensesTable get expenses => attachedDatabase.expenses;
  ExpensesDaoManager get managers => ExpensesDaoManager(this);
}

class ExpensesDaoManager {
  final _$ExpensesDaoMixin _db;
  ExpensesDaoManager(this._db);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db.attachedDatabase, _db.expenses);
}

mixin _$IncomeDaoMixin on DatabaseAccessor<AppDatabase> {
  $IncomeTable get income => attachedDatabase.income;
  IncomeDaoManager get managers => IncomeDaoManager(this);
}

class IncomeDaoManager {
  final _$IncomeDaoMixin _db;
  IncomeDaoManager(this._db);
  $$IncomeTableTableManager get income =>
      $$IncomeTableTableManager(_db.attachedDatabase, _db.income);
}

mixin _$HealthEventsDaoMixin on DatabaseAccessor<AppDatabase> {
  $HealthEventsTable get healthEvents => attachedDatabase.healthEvents;
  HealthEventsDaoManager get managers => HealthEventsDaoManager(this);
}

class HealthEventsDaoManager {
  final _$HealthEventsDaoMixin _db;
  HealthEventsDaoManager(this._db);
  $$HealthEventsTableTableManager get healthEvents =>
      $$HealthEventsTableTableManager(_db.attachedDatabase, _db.healthEvents);
}

mixin _$LabTestsDaoMixin on DatabaseAccessor<AppDatabase> {
  $LabTestsTable get labTests => attachedDatabase.labTests;
  LabTestsDaoManager get managers => LabTestsDaoManager(this);
}

class LabTestsDaoManager {
  final _$LabTestsDaoMixin _db;
  LabTestsDaoManager(this._db);
  $$LabTestsTableTableManager get labTests =>
      $$LabTestsTableTableManager(_db.attachedDatabase, _db.labTests);
}

mixin _$BloodPressureDaoMixin on DatabaseAccessor<AppDatabase> {
  $BloodPressureLogsTable get bloodPressureLogs =>
      attachedDatabase.bloodPressureLogs;
  BloodPressureDaoManager get managers => BloodPressureDaoManager(this);
}

class BloodPressureDaoManager {
  final _$BloodPressureDaoMixin _db;
  BloodPressureDaoManager(this._db);
  $$BloodPressureLogsTableTableManager get bloodPressureLogs =>
      $$BloodPressureLogsTableTableManager(
        _db.attachedDatabase,
        _db.bloodPressureLogs,
      );
}

mixin _$MedicationsDaoMixin on DatabaseAccessor<AppDatabase> {
  $MedicationLogsTable get medicationLogs => attachedDatabase.medicationLogs;
  MedicationsDaoManager get managers => MedicationsDaoManager(this);
}

class MedicationsDaoManager {
  final _$MedicationsDaoMixin _db;
  MedicationsDaoManager(this._db);
  $$MedicationLogsTableTableManager get medicationLogs =>
      $$MedicationLogsTableTableManager(
        _db.attachedDatabase,
        _db.medicationLogs,
      );
}

mixin _$DailyLogsDaoMixin on DatabaseAccessor<AppDatabase> {
  $DailyLogsTable get dailyLogs => attachedDatabase.dailyLogs;
  DailyLogsDaoManager get managers => DailyLogsDaoManager(this);
}

class DailyLogsDaoManager {
  final _$DailyLogsDaoMixin _db;
  DailyLogsDaoManager(this._db);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db.attachedDatabase, _db.dailyLogs);
}

mixin _$StepsDaoMixin on DatabaseAccessor<AppDatabase> {
  $StepsTable get steps => attachedDatabase.steps;
  StepsDaoManager get managers => StepsDaoManager(this);
}

class StepsDaoManager {
  final _$StepsDaoMixin _db;
  StepsDaoManager(this._db);
  $$StepsTableTableManager get steps =>
      $$StepsTableTableManager(_db.attachedDatabase, _db.steps);
}

mixin _$BucketItemsDaoMixin on DatabaseAccessor<AppDatabase> {
  $BucketItemsTable get bucketItems => attachedDatabase.bucketItems;
  BucketItemsDaoManager get managers => BucketItemsDaoManager(this);
}

class BucketItemsDaoManager {
  final _$BucketItemsDaoMixin _db;
  BucketItemsDaoManager(this._db);
  $$BucketItemsTableTableManager get bucketItems =>
      $$BucketItemsTableTableManager(_db.attachedDatabase, _db.bucketItems);
}

mixin _$BucketExperiencesDaoMixin on DatabaseAccessor<AppDatabase> {
  $BucketItemsTable get bucketItems => attachedDatabase.bucketItems;
  $BucketExperiencesTable get bucketExperiences =>
      attachedDatabase.bucketExperiences;
  BucketExperiencesDaoManager get managers => BucketExperiencesDaoManager(this);
}

class BucketExperiencesDaoManager {
  final _$BucketExperiencesDaoMixin _db;
  BucketExperiencesDaoManager(this._db);
  $$BucketItemsTableTableManager get bucketItems =>
      $$BucketItemsTableTableManager(_db.attachedDatabase, _db.bucketItems);
  $$BucketExperiencesTableTableManager get bucketExperiences =>
      $$BucketExperiencesTableTableManager(
        _db.attachedDatabase,
        _db.bucketExperiences,
      );
}

mixin _$TripsDaoMixin on DatabaseAccessor<AppDatabase> {
  $TripsTable get trips => attachedDatabase.trips;
  TripsDaoManager get managers => TripsDaoManager(this);
}

class TripsDaoManager {
  final _$TripsDaoMixin _db;
  TripsDaoManager(this._db);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db.attachedDatabase, _db.trips);
}

mixin _$AttachmentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $AttachmentsTable get attachments => attachedDatabase.attachments;
  AttachmentsDaoManager get managers => AttachmentsDaoManager(this);
}

class AttachmentsDaoManager {
  final _$AttachmentsDaoMixin _db;
  AttachmentsDaoManager(this._db);
  $$AttachmentsTableTableManager get attachments =>
      $$AttachmentsTableTableManager(_db.attachedDatabase, _db.attachments);
}
