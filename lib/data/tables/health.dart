import 'package:drift/drift.dart';
import '../converters.dart';

/// Health events: dentist/doctor/procedure/etc. (spec §12).
@DataClassName('HealthEvent')
class HealthEvents extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();
  TextColumn get type => text().map(healthEventTypeConverter)();
  TextColumn get subtype => text().map(dentalSubtypeConverter).nullable()();
  TextColumn get clinic => text().nullable()();
  TextColumn get clinicLower => text().nullable()();
  TextColumn get reason => text().nullable()();
  TextColumn get reasonLower => text().nullable()();
  TextColumn get whatWasDone => text()();
  TextColumn get whatWasDoneLower => text().withDefault(const Constant(''))();
  IntColumn get priceCents => integer().nullable()();
  TextColumn get nextRecommendedDate => text().nullable()(); // yyyy-MM-dd
  TextColumn get note => text().nullable()();
  TextColumn get noteLower => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Lab tests — free-text results archive (spec §13).
@DataClassName('LabTest')
class LabTests extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();
  TextColumn get lab => text()();
  TextColumn get labLower => text().withDefault(const Constant(''))();
  TextColumn get reason => text()();
  TextColumn get reasonLower => text().withDefault(const Constant(''))();
  TextColumn get resultsText => text().nullable()();
  TextColumn get resultsTextLower => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get noteLower => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Blood pressure + pulse measurements (spec §14). Multiple per date allowed.
@DataClassName('BloodPressureLog')
class BloodPressureLogs extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();
  TextColumn get time => text()(); // HH:mm (required)
  IntColumn get systolic => integer()();
  IntColumn get diastolic => integer()();
  IntColumn get pulse => integer()();
  TextColumn get note => text().nullable()();
  TextColumn get noteLower => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'CHECK (systolic > diastolic)',
        'CHECK (systolic > 0)',
        'CHECK (diastolic > 0)',
        'CHECK (pulse > 0)',
      ];
}

/// Medication / supplement intake (spec §15).
@DataClassName('MedicationLog')
class MedicationLogs extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();
  TextColumn get time => text()(); // HH:mm (required)
  TextColumn get name => text()();
  TextColumn get nameLower => text().withDefault(const Constant(''))();
  TextColumn get type => text().map(medTypeConverter)();
  TextColumn get dose => text().nullable()();
  TextColumn get status => text().map(medStatusConverter)();
  TextColumn get reason => text().nullable()();
  TextColumn get reasonLower => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get noteLower => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
