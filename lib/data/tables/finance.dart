import 'package:drift/drift.dart';
import '../converters.dart';

/// Expenses (spec §8). Single currency EUR; amount in integer cents. No photos.
@DataClassName('Expense')
class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();
  TextColumn get time => text().nullable()();
  IntColumn get amountCents => integer()();
  TextColumn get category => text().map(expenseCategoryConverter)();
  TextColumn get description => text()();
  TextColumn get descriptionLower => text()();
  TextColumn get paymentMethod => text().map(paymentMethodConverter).nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get noteLower => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (amount_cents > 0)'];
}

/// Income (spec §9). Single currency EUR; amount in integer cents.
@DataClassName('IncomeEntry')
class Income extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();
  IntColumn get amountCents => integer()();
  TextColumn get source => text()();
  TextColumn get sourceLower => text()();
  TextColumn get category => text().map(incomeCategoryConverter)();
  TextColumn get note => text().nullable()();
  TextColumn get noteLower => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (amount_cents > 0)'];
}
