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

mixin _$FinanceDaoMixin on DatabaseAccessor<AppDatabase> {
  $ExpensesTable get expenses => attachedDatabase.expenses;
  $IncomeTable get income => attachedDatabase.income;
  FinanceDaoManager get managers => FinanceDaoManager(this);
}

class FinanceDaoManager {
  final _$FinanceDaoMixin _db;
  FinanceDaoManager(this._db);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db.attachedDatabase, _db.expenses);
  $$IncomeTableTableManager get income =>
      $$IncomeTableTableManager(_db.attachedDatabase, _db.income);
}

mixin _$HealthDaoMixin on DatabaseAccessor<AppDatabase> {
  $BloodPressureLogsTable get bloodPressureLogs =>
      attachedDatabase.bloodPressureLogs;
  $MedicationLogsTable get medicationLogs => attachedDatabase.medicationLogs;
  $HealthEventsTable get healthEvents => attachedDatabase.healthEvents;
  $LabTestsTable get labTests => attachedDatabase.labTests;
  HealthDaoManager get managers => HealthDaoManager(this);
}

class HealthDaoManager {
  final _$HealthDaoMixin _db;
  HealthDaoManager(this._db);
  $$BloodPressureLogsTableTableManager get bloodPressureLogs =>
      $$BloodPressureLogsTableTableManager(
        _db.attachedDatabase,
        _db.bloodPressureLogs,
      );
  $$MedicationLogsTableTableManager get medicationLogs =>
      $$MedicationLogsTableTableManager(
        _db.attachedDatabase,
        _db.medicationLogs,
      );
  $$HealthEventsTableTableManager get healthEvents =>
      $$HealthEventsTableTableManager(_db.attachedDatabase, _db.healthEvents);
  $$LabTestsTableTableManager get labTests =>
      $$LabTestsTableTableManager(_db.attachedDatabase, _db.labTests);
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

mixin _$BucketDaoMixin on DatabaseAccessor<AppDatabase> {
  $BucketItemsTable get bucketItems => attachedDatabase.bucketItems;
  $BucketExperiencesTable get bucketExperiences =>
      attachedDatabase.bucketExperiences;
  BucketDaoManager get managers => BucketDaoManager(this);
}

class BucketDaoManager {
  final _$BucketDaoMixin _db;
  BucketDaoManager(this._db);
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

mixin _$SearchDaoMixin on DatabaseAccessor<AppDatabase> {
  $MealsTable get meals => attachedDatabase.meals;
  $ActivitiesTable get activities => attachedDatabase.activities;
  $ExpensesTable get expenses => attachedDatabase.expenses;
  $IncomeTable get income => attachedDatabase.income;
  $HealthEventsTable get healthEvents => attachedDatabase.healthEvents;
  $LabTestsTable get labTests => attachedDatabase.labTests;
  $BloodPressureLogsTable get bloodPressureLogs =>
      attachedDatabase.bloodPressureLogs;
  $MedicationLogsTable get medicationLogs => attachedDatabase.medicationLogs;
  $DailyLogsTable get dailyLogs => attachedDatabase.dailyLogs;
  $BucketItemsTable get bucketItems => attachedDatabase.bucketItems;
  $BucketExperiencesTable get bucketExperiences =>
      attachedDatabase.bucketExperiences;
  $TripsTable get trips => attachedDatabase.trips;
  SearchDaoManager get managers => SearchDaoManager(this);
}

class SearchDaoManager {
  final _$SearchDaoMixin _db;
  SearchDaoManager(this._db);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db.attachedDatabase, _db.meals);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db.attachedDatabase, _db.activities);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db.attachedDatabase, _db.expenses);
  $$IncomeTableTableManager get income =>
      $$IncomeTableTableManager(_db.attachedDatabase, _db.income);
  $$HealthEventsTableTableManager get healthEvents =>
      $$HealthEventsTableTableManager(_db.attachedDatabase, _db.healthEvents);
  $$LabTestsTableTableManager get labTests =>
      $$LabTestsTableTableManager(_db.attachedDatabase, _db.labTests);
  $$BloodPressureLogsTableTableManager get bloodPressureLogs =>
      $$BloodPressureLogsTableTableManager(
        _db.attachedDatabase,
        _db.bloodPressureLogs,
      );
  $$MedicationLogsTableTableManager get medicationLogs =>
      $$MedicationLogsTableTableManager(
        _db.attachedDatabase,
        _db.medicationLogs,
      );
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db.attachedDatabase, _db.dailyLogs);
  $$BucketItemsTableTableManager get bucketItems =>
      $$BucketItemsTableTableManager(_db.attachedDatabase, _db.bucketItems);
  $$BucketExperiencesTableTableManager get bucketExperiences =>
      $$BucketExperiencesTableTableManager(
        _db.attachedDatabase,
        _db.bucketExperiences,
      );
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db.attachedDatabase, _db.trips);
}
