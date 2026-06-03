import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';

void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase.memory());
  tearDown(() => db.close());

  test('seedDatabase populates every module without violating constraints',
      () async {
    await seedDatabase(db, today: DateTime(2026, 5, 31));

    Future<int> count(query) async => (await query.get()).length;

    expect(await count(db.select(db.steps)), 30);
    expect(await count(db.select(db.dailyLogs)), greaterThan(20));
    expect(await count(db.select(db.meals)), greaterThan(0));
    expect(await count(db.select(db.activities)), 12);
    expect(await count(db.select(db.expenses)), 24);
    expect(await count(db.select(db.income)), 2);
    expect(await count(db.select(db.bloodPressureLogs)), greaterThan(0));
    expect(await count(db.select(db.medicationLogs)), 4);
    expect(await count(db.select(db.healthEvents)), 2);
    expect(await count(db.select(db.labTests)), 1);
    expect(await count(db.select(db.bucketItems)), 6);
    expect(await count(db.select(db.bucketExperiences)), 2); // completed items
    expect(await count(db.select(db.trips)), 3);

    // *Lower columns populated (DAO write path) — search works on seeded data.
    final hits = await db.searchDao.search('рим');
    expect(hits, isNotEmpty);

    // Aggregates run over seeded data.
    final fin = await db.financeDao.summary('2026-05-01', '2026-05-31');
    expect(fin.totalExpensesCents, greaterThan(0));
  });

  test('seed is idempotent (clears before repopulating)', () async {
    await seedDatabase(db, today: DateTime(2026, 5, 31));
    await seedDatabase(db, today: DateTime(2026, 5, 31));
    expect((await db.select(db.steps).get()).length, 30); // not 60
  });

  test('clearAll empties the database', () async {
    await seedDatabase(db, today: DateTime(2026, 5, 31));
    await clearAll(db);
    expect((await db.select(db.trips).get()), isEmpty);
    expect((await db.select(db.steps).get()), isEmpty);
  });
}
