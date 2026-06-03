import 'package:drift/drift.dart';

/// App-level key/value preferences (not user data) — e.g. the selected UI
/// locale. Deliberately excluded from backup/restore and the "empty" check:
/// it's a device preference, language-independent, and never serialized to
/// data.json. Added in schema v2 (Slice 10.2).
@DataClassName('Setting')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
