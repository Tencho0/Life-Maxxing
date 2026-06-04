import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';

void main() {
  // withPhotos:false — these tests assert DB content only; the photo-seeding
  // tail needs the Flutter binding + path_provider + image plugin (not unit-testable).
  late AppDatabase db;
  setUp(() => db = AppDatabase.memory());
  tearDown(() => db.close());

  test('seedDatabase populates every module without violating constraints',
      () async {
    await seedDatabase(db, today: DateTime(2026, 5, 31), withPhotos: false);

    Future<int> count(query) async => (await query.get()).length;

    // Structural invariants (deterministic): one steps row per day, and the
    // tables seeded from fixed lists. Exact counts here catch real regressions.
    expect(await count(db.select(db.steps)), 30); // one per day, UNIQUE(date)
    expect(await count(db.select(db.income)), 4);
    expect(await count(db.select(db.healthEvents)), 4);
    expect(await count(db.select(db.labTests)), 2);
    expect(await count(db.select(db.bucketItems)), 7);
    expect(await count(db.select(db.bucketExperiences)), 2); // completed items
    expect(await count(db.select(db.trips)), 4);

    // Randomized per-day tables: assert the module is populated, not an exact
    // count — the demo's richness is tuned over time (e.g. for promo videos).
    expect(await count(db.select(db.dailyLogs)), greaterThan(20));
    expect(await count(db.select(db.meals)), greaterThan(0));
    expect(await count(db.select(db.activities)), greaterThan(0));
    expect(await count(db.select(db.expenses)), greaterThan(0));
    expect(await count(db.select(db.bloodPressureLogs)), greaterThan(0));
    expect(await count(db.select(db.medicationLogs)), greaterThan(0));

    // *Lower columns populated (DAO write path) — search works on seeded data.
    final hits = await db.searchDao.search('rome'); // matches the Rome trip
    expect(hits, isNotEmpty);

    // Aggregates run over seeded data.
    final fin = await db.financeDao.summary('2026-05-01', '2026-05-31');
    expect(fin.totalExpensesCents, greaterThan(0));
  });

  test('seed is idempotent (clears before repopulating)', () async {
    await seedDatabase(db, today: DateTime(2026, 5, 31), withPhotos: false);
    await seedDatabase(db, today: DateTime(2026, 5, 31), withPhotos: false);
    expect((await db.select(db.steps).get()).length, 30); // not 60
  });

  test('clearAll empties the database', () async {
    await seedDatabase(db, today: DateTime(2026, 5, 31), withPhotos: false);
    await clearAll(db);
    expect((await db.select(db.trips).get()), isEmpty);
    expect((await db.select(db.steps).get()), isEmpty);
  });
}
