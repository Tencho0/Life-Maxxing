import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/domain/period.dart';

void main() {
  // Anchor mid-month, mid-year.
  final mid = DateTime(2026, 6, 15);

  DateRange r(Period p, {DateTime? today, String? f, String? t}) =>
      resolveRange(p, today: today ?? mid, customFrom: f, customTo: t);

  test('today', () {
    expect(r(Period.today), const DateRange('2026-06-15', '2026-06-15'));
  });

  test('last 7 days (inclusive)', () {
    expect(r(Period.last7), const DateRange('2026-06-09', '2026-06-15'));
  });

  test('last 30 days (inclusive, crosses month)', () {
    expect(r(Period.last30), const DateRange('2026-05-17', '2026-06-15'));
  });

  test('this month → 1st .. last day', () {
    expect(r(Period.thisMonth), const DateRange('2026-06-01', '2026-06-30'));
  });

  test('previous month', () {
    expect(r(Period.prevMonth), const DateRange('2026-05-01', '2026-05-31'));
  });

  test('previous month across year boundary', () {
    expect(
      r(Period.prevMonth, today: DateTime(2026, 1, 10)),
      const DateRange('2025-12-01', '2025-12-31'),
    );
  });

  test('this month for February (non-leap 2026 → 28)', () {
    expect(
      r(Period.thisMonth, today: DateTime(2026, 2, 15)),
      const DateRange('2026-02-01', '2026-02-28'),
    );
  });

  test('this month for February (leap 2024 → 29)', () {
    expect(
      r(Period.thisMonth, today: DateTime(2024, 2, 10)),
      const DateRange('2024-02-01', '2024-02-29'),
    );
  });

  test('last 30 from month start stays valid (no DST off-by-one)', () {
    expect(
      r(Period.last30, today: DateTime(2026, 3, 1)),
      const DateRange('2026-01-31', '2026-03-01'),
    );
  });

  test('custom returns provided range', () {
    expect(
      r(Period.custom, f: '2026-04-01', t: '2026-04-15'),
      const DateRange('2026-04-01', '2026-04-15'),
    );
  });

  test('custom without bounds throws', () {
    expect(() => resolveRange(Period.custom, today: mid),
        throwsArgumentError);
  });

  test('zero-padding for single-digit month/day', () {
    expect(
      resolveRange(Period.today, today: DateTime(2026, 1, 5)),
      const DateRange('2026-01-05', '2026-01-05'),
    );
  });
}
