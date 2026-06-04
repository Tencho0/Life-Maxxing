import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';

void main() {
  late AppDatabase db;
  final ts = DateTime.utc(2026, 5, 1, 8);
  setUp(() => db = AppDatabase.memory());
  tearDown(() => db.close());

  WeightLogsCompanion entry(String id, String date, int grams,
          {String? note}) =>
      WeightLogsCompanion.insert(
        id: id, date: date, weightGrams: grams,
        note: Value(note), createdAt: ts, updatedAt: ts,
      );

  test('one entry per day: saving the same date again edits, not duplicates',
      () async {
    await db.weightDao.save(entry('w1', '2026-05-01', 82000));
    await db.weightDao.save(entry('w1', '2026-05-01', 81500, note: 'сутрин'));

    final rows = await db.weightDao.inRange('2026-01-01', '2026-12-31');
    expect(rows.length, 1);
    expect(rows.single.weightGrams, 81500);
    expect(rows.single.note, 'сутрин');
  });

  test('getByDate returns the entry or null', () async {
    await db.weightDao.save(entry('w1', '2026-05-01', 82000));
    expect((await db.weightDao.getByDate('2026-05-01'))!.weightGrams, 82000);
    expect(await db.weightDao.getByDate('2026-05-02'), isNull);
  });

  test('watchInRange returns entries ordered by date ascending', () async {
    await db.weightDao.save(entry('w2', '2026-05-10', 81000));
    await db.weightDao.save(entry('w1', '2026-05-01', 83000));
    final rows = await db.weightDao.watchInRange('2026-05-01', '2026-05-31').first;
    expect(rows.map((r) => r.date).toList(), ['2026-05-01', '2026-05-10']);
  });

  test('summary computes latest/change/min/max/count', () async {
    await db.weightDao.save(entry('w1', '2026-05-01', 83000));
    await db.weightDao.save(entry('w2', '2026-05-10', 81000));
    final s = await db.weightDao.summary('2026-05-01', '2026-05-31');
    expect(s.latestGrams, 81000);
    expect(s.changeGrams, -2000);
    expect(s.minGrams, 81000);
    expect(s.maxGrams, 83000);
    expect(s.count, 2);
  });

  test('CHECK rejects non-positive weight', () async {
    expect(
      db.weightDao.save(entry('bad', '2026-05-01', 0)),
      throwsA(anything),
    );
  });
}
