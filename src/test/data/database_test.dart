import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/domain/enums.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.utc(2026, 6, 1, 8, 0);

  setUp(() => db = AppDatabase.memory());
  tearDown(() => db.close());

  Future<void> insertBucketItem(String id) => db.into(db.bucketItems).insert(
        BucketItemsCompanion.insert(
          id: id,
          title: 'Желание',
          priority: BucketPriority.high,
          status: BucketStatus.idea,
          createdAt: now,
          updatedAt: now,
        ),
      );

  BloodPressureLogsCompanion bp(int sys, int dia, int pulse, {String id = 'bp1'}) =>
      BloodPressureLogsCompanion.insert(
        id: id,
        date: '2026-06-01',
        time: '08:20',
        systolic: sys,
        diastolic: dia,
        pulse: pulse,
        createdAt: now,
        updatedAt: now,
      );

  test('opens and createAll runs; tables are empty', () async {
    final count = await db.managers.meals.count();
    expect(count, 0);
  });

  test('DateTime columns round-trip (stored as ISO text)', () async {
    await db.into(db.meals).insert(MealsCompanion.insert(
          id: 'm1', date: '2026-06-01', name: 'Каша',
          type: MealType.breakfast, createdAt: now, updatedAt: now,
        ));
    final row = await db.managers.meals.getSingle();
    expect(row.createdAt, now);
    expect(row.type, MealType.breakfast);
    // The underlying column is TEXT (ISO-8601), not an integer.
    final raw = await db
        .customSelect('SELECT created_at FROM meals')
        .getSingle();
    expect(raw.data['created_at'], isA<String>());
    expect(raw.data['created_at'], startsWith('2026-06-01'));
  });

  group('CHECK constraints', () {
    test('BP requires systolic > diastolic', () async {
      await db.into(db.bloodPressureLogs).insert(bp(124, 78, 71)); // ok
      await expectLater(
        db.into(db.bloodPressureLogs).insert(bp(78, 124, 71, id: 'bp2')),
        throwsA(isA<Exception>()),
      );
    });

    test('BP values must be positive', () async {
      await expectLater(
        db.into(db.bloodPressureLogs).insert(bp(120, 80, 0, id: 'bp3')),
        throwsA(isA<Exception>()),
      );
    });

    test('expense amount must be > 0', () async {
      await expectLater(
        db.into(db.expenses).insert(ExpensesCompanion.insert(
              id: 'e1', date: '2026-06-01', amountCents: 0,
              category: ExpenseCategory.food,
              description: 'X',
              createdAt: now, updatedAt: now,
            )),
        throwsA(isA<Exception>()),
      );
    });

    test('trip end date cannot precede start date', () async {
      await expectLater(
        db.into(db.trips).insert(TripsCompanion.insert(
              id: 't1', title: 'Рим', destination: 'Рим',
              fromDate: '2026-06-10', toDate: '2026-06-05', overall: 9,
              createdAt: now, updatedAt: now,
            )),
        throwsA(isA<Exception>()),
      );
    });

    test('mood must be within 1..10', () async {
      await expectLater(
        db.into(db.dailyLogs).insert(DailyLogsCompanion.insert(
              id: 'd1', date: '2026-06-01', mood: 11,
              proud: true, didUncomfortable: false,
              workout: true, drankAlcohol: false,
              createdAt: now, updatedAt: now,
            )),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('UNIQUE(date)', () {
    test('only one daily log per date', () async {
      DailyLogsCompanion daily(String id) => DailyLogsCompanion.insert(
            id: id, date: '2026-06-01', mood: 8,
            proud: true, didUncomfortable: false,
            workout: true, drankAlcohol: false,
            createdAt: now, updatedAt: now,
          );
      await db.into(db.dailyLogs).insert(daily('d1'));
      await expectLater(
        db.into(db.dailyLogs).insert(daily('d2')),
        throwsA(isA<Exception>()),
      );
    });

    test('only one steps row per date', () async {
      StepsCompanion steps(String id) => StepsCompanion.insert(
            id: id, date: '2026-06-01', count: 9420,
            source: StepsSource.stepsModule, createdAt: now, updatedAt: now,
          );
      await db.into(db.steps).insert(steps('s1'));
      await expectLater(
        db.into(db.steps).insert(steps('s2')),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('foreign keys', () {
    BucketExperiencesCompanion exp(String id, String itemId) =>
        BucketExperiencesCompanion.insert(
          id: id, bucketItemId: itemId, completedDate: '2026-06-01',
          feelingRating: 9, worthIt: true, createdAt: now, updatedAt: now,
        );

    test('experience requires an existing bucket item (FK enforced)', () async {
      await expectLater(
        db.into(db.bucketExperiences).insert(exp('x1', 'missing')),
        throwsA(isA<Exception>()),
      );
    });

    test('deleting an item cascades to its experience', () async {
      await insertBucketItem('b1');
      await db.into(db.bucketExperiences).insert(exp('x2', 'b1'));
      expect(await db.managers.bucketExperiences.count(), 1);

      await (db.delete(db.bucketItems)..where((t) => t.id.equals('b1'))).go();
      expect(await db.managers.bucketExperiences.count(), 0); // cascaded
    });
  });
}
