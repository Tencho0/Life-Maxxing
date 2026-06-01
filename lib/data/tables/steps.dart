import 'package:drift/drift.dart';
import '../converters.dart';

/// Daily step count — exactly one per date (spec §18). Shared with the Daily
/// Quick Log; `source` records where the value was entered.
@DataClassName('StepEntry')
class Steps extends Table {
  TextColumn get id => text()();
  TextColumn get date => text().unique()(); // yyyy-MM-dd, one per day
  IntColumn get count => integer()();
  TextColumn get note => text().nullable()();
  TextColumn get source => text().map(stepsSourceConverter)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK ("count" >= 0)'];
}
