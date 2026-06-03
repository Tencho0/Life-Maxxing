import 'package:drift/drift.dart';
import '../converters.dart';

/// Bucket list items (spec §20).
@DataClassName('BucketItem')
class BucketItems extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get titleLower => text().withDefault(const Constant(''))();
  TextColumn get description => text().nullable()();
  TextColumn get descriptionLower => text().nullable()();
  TextColumn get whyWantIt => text().nullable()();
  TextColumn get whyWantItLower => text().nullable()();
  TextColumn get priority => text().map(bucketPriorityConverter)();
  TextColumn get status => text().map(bucketStatusConverter)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The logged experience for a completed bucket item (spec §20.6–20.9).
/// One-to-one with [BucketItems]; cascade-deletes with its item.
@DataClassName('BucketExperience')
class BucketExperiences extends Table {
  TextColumn get id => text()();
  TextColumn get bucketItemId =>
      text().unique().references(BucketItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get completedDate => text()(); // yyyy-MM-dd
  IntColumn get feelingRating => integer()(); // 1..10
  BoolColumn get worthIt => boolean()();
  TextColumn get reflection => text().nullable()();
  TextColumn get reflectionLower => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints =>
      ['CHECK (feeling_rating >= 1 AND feeling_rating <= 10)'];
}
