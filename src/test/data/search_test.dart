import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/domain/search_hit.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.utc(2026, 6, 1, 8, 0);
  setUp(() => db = AppDatabase.memory());
  tearDown(() => db.close());

  Future<void> seed() async {
    await db.mealsDao.save(MealsCompanion.insert(
      id: 'm1', date: '2026-06-01', name: 'Сьомга на скара',
      type: MealType.dinner, createdAt: now, updatedAt: now,
    ));
    await db.financeDao.saveExpense(ExpensesCompanion.insert(
      id: 'e1', date: '2026-06-01', amountCents: 12000,
      category: ExpenseCategory.car, description: 'Гориво OMV',
      createdAt: now, updatedAt: now,
    ));
    await db.tripsDao.save(TripsCompanion.insert(
      id: 't1', title: 'Уикенд в Рим', destination: 'Рим, Италия',
      fromDate: '2025-10-10', toDate: '2025-10-13', overall: 9,
      createdAt: now, updatedAt: now,
    ));
    await db.bucketDao.saveItem(BucketItemsCompanion.insert(
      id: 'b1', title: 'Скок с парашут', priority: BucketPriority.high,
      status: BucketStatus.planned, createdAt: now, updatedAt: now,
    ));
  }

  group('search (Cyrillic-safe)', () {
    test('case-insensitive match on Cyrillic text', () async {
      await seed();
      // Upper-case query must still match lower-cased stored text.
      final hits = await db.searchDao.search('РИМ');
      expect(hits.any((h) => h.kind == SearchKind.trip && h.id == 't1'), isTrue);
    });

    test('matches across multiple modules', () async {
      await seed();
      // 'о' appears in Сьомга, Гориво, Рим, Скок...
      final hits = await db.searchDao.search('о');
      final kinds = hits.map((h) => h.kind).toSet();
      expect(kinds.length, greaterThanOrEqualTo(3));
    });

    test('empty query returns nothing', () async {
      await seed();
      expect(await db.searchDao.search('   '), isEmpty);
    });

    test('no match returns empty', () async {
      await seed();
      expect(await db.searchDao.search('zzzznotfound'), isEmpty);
    });
  });

  group('filters', () {
    test('expenses filtered by category in range', () async {
      await db.financeDao.saveExpense(ExpensesCompanion.insert(
        id: 'e1', date: '2026-06-01', amountCents: 1000,
        category: ExpenseCategory.food, description: 'A',
        createdAt: now, updatedAt: now,
      ));
      await db.financeDao.saveExpense(ExpensesCompanion.insert(
        id: 'e2', date: '2026-06-02', amountCents: 2000,
        category: ExpenseCategory.car, description: 'B',
        createdAt: now, updatedAt: now,
      ));
      final food = await db.financeDao
          .expensesInRange('2026-06-01', '2026-06-30',
              category: ExpenseCategory.food);
      expect(food, hasLength(1));
      expect(food.first.id, 'e1');
    });

    test('bucket items filtered by status', () async {
      await db.bucketDao.saveItem(BucketItemsCompanion.insert(
        id: 'b1', title: 'A', priority: BucketPriority.high,
        status: BucketStatus.idea, createdAt: now, updatedAt: now,
      ));
      await db.bucketDao.saveItem(BucketItemsCompanion.insert(
        id: 'b2', title: 'B', priority: BucketPriority.low,
        status: BucketStatus.completed, createdAt: now, updatedAt: now,
      ));
      final completed =
          await db.bucketDao.watchItems(status: BucketStatus.completed).first;
      expect(completed, hasLength(1));
      expect(completed.first.id, 'b2');
    });

    test('trips filtered by would-repeat', () async {
      Future<void> trip(String id, bool repeat) => db.tripsDao.save(
          TripsCompanion.insert(
              id: id, title: id, destination: 'D',
              fromDate: '2026-06-01', toDate: '2026-06-02', overall: 8,
              wouldRepeat: Value(repeat), createdAt: now, updatedAt: now));
      await trip('t1', true);
      await trip('t2', false);
      final repeats = await db.tripsDao.watchAll(wouldRepeat: true).first;
      expect(repeats, hasLength(1));
      expect(repeats.first.id, 't1');
    });
  });
}
