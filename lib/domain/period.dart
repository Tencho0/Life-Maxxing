// Resolves a [Period] selection into an inclusive yyyy-MM-dd date range for
// querying (spec §10.2 / §22.3). Pure Dart; takes a `today` anchor so it's
// deterministic in tests. Uses DateTime constructor normalization (not
// Duration) to avoid DST off-by-one issues on date-only math.

import 'enums.dart';

/// An inclusive date range as zero-padded yyyy-MM-dd strings.
class DateRange {
  const DateRange(this.from, this.to);
  final String from;
  final String to;

  @override
  bool operator ==(Object other) =>
      other is DateRange && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);

  @override
  String toString() => 'DateRange($from..$to)';
}

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Resolves [period] to a date range. For [Period.custom], [customFrom] and
/// [customTo] (yyyy-MM-dd) are required. [today] defaults to the current date.
DateRange resolveRange(
  Period period, {
  DateTime? today,
  String? customFrom,
  String? customTo,
}) {
  final base = today ?? DateTime.now();
  final t = DateTime(base.year, base.month, base.day); // date-only

  switch (period) {
    case Period.today:
      return DateRange(_ymd(t), _ymd(t));
    case Period.last7:
      return DateRange(_ymd(DateTime(t.year, t.month, t.day - 6)), _ymd(t));
    case Period.last30:
      return DateRange(_ymd(DateTime(t.year, t.month, t.day - 29)), _ymd(t));
    case Period.thisMonth:
      final first = DateTime(t.year, t.month, 1);
      final last = DateTime(t.year, t.month + 1, 0); // day 0 → last of month
      return DateRange(_ymd(first), _ymd(last));
    case Period.prevMonth:
      final lastPrev = DateTime(t.year, t.month, 0); // last day of prev month
      final firstPrev = DateTime(lastPrev.year, lastPrev.month, 1);
      return DateRange(_ymd(firstPrev), _ymd(lastPrev));
    case Period.custom:
      if (customFrom == null || customTo == null) {
        throw ArgumentError('custom period requires customFrom and customTo');
      }
      return DateRange(customFrom, customTo);
  }
}
