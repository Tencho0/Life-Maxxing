import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/data/summaries.dart';

void main() {
  final ts = DateTime.utc(2026, 5, 1);
  WeightLog log(String date, int grams) => WeightLog(
        id: date, date: date, weightGrams: grams, note: null,
        createdAt: ts, updatedAt: ts,
      );

  test('empty range yields a zeroed summary', () {
    final s = computeWeight([]);
    expect(s.count, 0);
    expect(s.latestGrams, 0);
    expect(s.changeGrams, 0);
  });

  test('single entry: latest set, change is 0', () {
    final s = computeWeight([log('2026-05-01', 82000)]);
    expect(s.count, 1);
    expect(s.latestGrams, 82000);
    expect(s.changeGrams, 0);
    expect(s.minGrams, 82000);
    expect(s.maxGrams, 82000);
  });

  test('multi entry: latest = last by date, change = latest − earliest', () {
    // Deliberately unsorted input — compute must order by date.
    final s = computeWeight([
      log('2026-05-10', 81000),
      log('2026-05-01', 83000),
      log('2026-05-05', 82000),
    ]);
    expect(s.latestGrams, 81000); // 05-10
    expect(s.changeGrams, 81000 - 83000); // −2000 g
    expect(s.minGrams, 81000);
    expect(s.maxGrams, 83000);
    expect(s.count, 3);
  });
}
