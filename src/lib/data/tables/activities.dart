import 'package:drift/drift.dart';
import '../converters.dart';

/// Physical activities (spec §7). `name` is optional per spec.
@DataClassName('Activity')
class Activities extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();
  TextColumn get startTime => text().nullable()();
  TextColumn get endTime => text().nullable()();
  IntColumn get durationMin => integer().nullable()();
  TextColumn get type => text().map(activityTypeConverter)();
  TextColumn get name => text().nullable()();
  TextColumn get nameLower => text().nullable()();
  TextColumn get intensity => text().map(intensityConverter).nullable()();
  IntColumn get quality => integer().nullable()(); // 1..10
  IntColumn get moodAfter => integer().nullable()(); // 1..10
  TextColumn get note => text().nullable()();
  TextColumn get noteLower => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
