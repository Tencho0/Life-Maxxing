// Display date formatting — stored yyyy-MM-dd → Bulgarian dd.MM.yyyy / dd.MM.

import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/core/format/dates.dart';

void main() {
  test('dmy formats a stored yyyy-MM-dd as dd.MM.yyyy', () {
    expect(dmy('2026-05-15'), '15.05.2026');
    expect(dmy('2026-01-09'), '09.01.2026'); // zero-padded
  });

  test('dm formats a stored yyyy-MM-dd as dd.MM', () {
    expect(dm('2026-05-15'), '15.05');
  });

  test('dmyDate formats a DateTime as dd.MM.yyyy (for date-picker fields)', () {
    expect(dmyDate(DateTime(2026, 3, 7)), '07.03.2026');
  });

  test('malformed input is returned unchanged rather than throwing', () {
    expect(dmy(''), '');
    expect(dmy('not-a-date'), 'not-a-date');
    expect(dm('2026/05/15'), '2026/05/15');
  });
}
