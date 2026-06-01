import 'package:drift/drift.dart';

/// Daily Quick Log — exactly one per date (spec §17). Steps are NOT stored
/// here; they live in the `steps` table (shared metric, spec §3.4).
@DataClassName('DailyLog')
class DailyLogs extends Table {
  TextColumn get id => text()();
  TextColumn get date => text().unique()(); // yyyy-MM-dd, one per day
  IntColumn get mood => integer()(); // 1..10
  BoolColumn get proud => boolean()();
  BoolColumn get didUncomfortable => boolean()();
  TextColumn get uncomfortableWhat => text().nullable()();
  BoolColumn get workout => boolean()();
  BoolColumn get drankAlcohol => boolean()();
  TextColumn get alcoholWhat => text().nullable()();
  IntColumn get screenTimeMin => integer().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get noteLower => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (mood >= 1 AND mood <= 10)'];
}
