import 'package:drift/drift.dart';
import '../converters.dart';

/// Food log (spec §6). Date is TEXT yyyy-MM-dd; nutrition values are REAL.
@DataClassName('Meal')
class Meals extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()(); // yyyy-MM-dd
  TextColumn get time => text().nullable()(); // HH:mm
  TextColumn get name => text()();
  TextColumn get nameLower => text()();
  TextColumn get type => text().map(mealTypeConverter)();
  TextColumn get quantity => text().nullable()();
  IntColumn get calories => integer().nullable()();
  RealColumn get protein => real().nullable()();
  RealColumn get carbs => real().nullable()();
  RealColumn get fat => real().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get noteLower => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
