import 'package:drift/drift.dart';

/// Trips archive (spec §21). Ratings 1..10; cover/gallery via attachments.
@DataClassName('Trip')
class Trips extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get titleLower => text()();
  TextColumn get destination => text()();
  TextColumn get destinationLower => text()();
  TextColumn get fromDate => text()(); // yyyy-MM-dd
  TextColumn get toDate => text()(); // yyyy-MM-dd
  IntColumn get overall => integer()(); // 1..10
  IntColumn get fun => integer().nullable()();
  IntColumn get food => integer().nullable()();
  IntColumn get sights => integer().nullable()();
  IntColumn get value => integer().nullable()();
  BoolColumn get wouldRepeat => boolean().nullable()();
  TextColumn get comment => text().nullable()();
  TextColumn get commentLower => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'CHECK (to_date >= from_date)',
        'CHECK (overall >= 1 AND overall <= 10)',
      ];
}
