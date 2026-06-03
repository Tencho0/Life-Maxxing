// Display formatting for the app's date-only `yyyy-MM-dd` TEXT fields →
// Bulgarian `dd.MM.yyyy` (and a short `dd.MM`). Storage stays `yyyy-MM-dd`
// (locked decision §4); this is display-only. The dd.MM.yyyy pattern is numeric
// and locale-independent, so no `initializeDateFormatting` is needed.

import 'package:intl/intl.dart';

final DateFormat _dmy = DateFormat('dd.MM.yyyy');
final DateFormat _dm = DateFormat('dd.MM');

/// A stored `yyyy-MM-dd` string → `dd.MM.yyyy`. Returns [ymd] unchanged if it
/// can't be parsed (defensive; valid app data always parses).
String dmy(String ymd) {
  try {
    return _dmy.format(DateTime.parse(ymd));
  } catch (_) {
    return ymd;
  }
}

/// A stored `yyyy-MM-dd` string → short `dd.MM`.
String dm(String ymd) {
  try {
    return _dm.format(DateTime.parse(ymd));
  } catch (_) {
    return ymd;
  }
}

/// A [DateTime] → `dd.MM.yyyy` (for date-picker trigger fields in forms).
String dmyDate(DateTime d) => _dmy.format(d);
