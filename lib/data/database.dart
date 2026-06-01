// The drift database: schema v1, all 15 tables, FK enforcement on open.
// DAOs (Slice 3.3+) are registered here as they land. See technical-spec §3.

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../domain/enums.dart';
import 'converters.dart';
import 'tables/meals.dart';
import 'tables/activities.dart';
import 'tables/finance.dart';
import 'tables/health.dart';
import 'tables/daily_logs.dart';
import 'tables/steps.dart';
import 'tables/bucket.dart';
import 'tables/trips.dart';
import 'tables/attachments.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Meals,
    Activities,
    Expenses,
    Income,
    HealthEvents,
    LabTests,
    BloodPressureLogs,
    MedicationLogs,
    DailyLogs,
    Steps,
    BucketItems,
    BucketExperiences,
    Trips,
    Attachments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// In-memory database for tests.
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        beforeOpen: (details) async {
          // Required for ON DELETE CASCADE (bucket_experiences) and any FK
          // enforcement — SQLite has foreign keys off by default.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
