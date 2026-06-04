# Weight Tracking Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add per-day body-weight logging to the Health module — a "Тегло" history tab + trend chart, stored as integer grams, one entry per day.

**Architecture:** A new `WeightLogs` drift table (one-per-day, `UNIQUE(date)`, edit-on-existing like Steps) + `WeightDao` + a `WeightSummary` DTO. Wired into the two data-export paths (ZIP backup, AI export) and the wipe paths (clear-all-data `_deleteAll`, dev `clearAll`). Surfaced in the Health screen as a 5th tab with a trend sparkline, fed by a modal form sheet that mirrors the blood-pressure sub-module.

**Tech Stack:** Flutter 3.41.5 · drift (SQLite) · Riverpod · fl_chart · gen-l10n (bg/en). Run all commands from `src/`.

Reference spec: `docs/superpowers/specs/2026-06-04-weight-tracking-design.md`.

**Conventions reminder:**
- Run tests single-threaded — never two `flutter test` runs at once (CLAUDE.md §6).
- Widget tests: `useDeterministicTestEnv()` in `setUp`; async-data screens use `await settleData(tester)`.
- Bulgarian user-facing strings, English identifiers. Integer storage (grams), `yyyy-MM-dd` dates.
- `app_en.arb` is the gen-l10n template; mirror every key into `app_bg.arb`, then `flutter gen-l10n`.

---

## Slice 1 — Data layer (table + DAO + summary + migration)

### Task 1: WeightLogs table

**Files:**
- Modify: `src/lib/data/tables/health.dart` (append the table)

- [ ] **Step 1: Add the table class**

Append to `src/lib/data/tables/health.dart`:

```dart
/// Body weight — exactly one per date (one-per-day, edit-on-existing like
/// Steps). Stored as integer grams (no floats, mirrors EUR cents §4); shown in
/// kilograms. Weight is logged in the Health module ("Тегло" tab).
@DataClassName('WeightLog')
class WeightLogs extends Table {
  TextColumn get id => text()();
  TextColumn get date => text().unique()(); // yyyy-MM-dd, one per day
  IntColumn get weightGrams => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (weight_grams > 0)'];
}
```

- [ ] **Step 2: Register the table + bump schema version + migration**

In `src/lib/data/database.dart`:
1. Add `WeightLogs,` to the `tables:` list in `@DriftDatabase` (after `Steps,`).
2. Add `WeightDao,` to the `daos:` list (after `StepsDao,`) — defined in Task 2; add it now so codegen wires the accessor.
3. Change `int get schemaVersion => 2;` to `=> 3;`.
4. In `onUpgrade`, after the `if (from < 2)` line, add:

```dart
          // v3 (weight tracking): add the one-per-day weight_logs table.
          if (from < 3) await m.createTable(weightLogs);
```

Also update the file's top comment count ("all 15 tables" → "all 16 tables").

- [ ] **Step 3: Do NOT run codegen yet** — `WeightDao` doesn't exist, so codegen would fail. Proceed to Task 2 first.

---

### Task 2: WeightDao

**Files:**
- Modify: `src/lib/data/daos.dart` (add the DAO; mirror `StepsDao`)
- Modify: `src/lib/domain/summaries.dart` (add `WeightSummary` DTO)
- Modify: `src/lib/data/summaries.dart` (add `computeWeight`)

- [ ] **Step 1: Add the WeightSummary DTO**

In `src/lib/domain/summaries.dart`, after the `StepsSummary` class, add:

```dart
/// Body weight over a period. All masses in integer grams (shown in kg).
class WeightSummary {
  WeightSummary({
    required this.latestGrams,
    required this.changeGrams,
    required this.minGrams,
    required this.maxGrams,
    required this.count,
  });

  /// Most recent entry's weight in the range (0 when none).
  final int latestGrams;

  /// latest − earliest in the range (signed; 0 when fewer than 2 entries).
  final int changeGrams;
  final int minGrams;
  final int maxGrams;
  final int count;
}
```

- [ ] **Step 2: Write the failing test for computeWeight**

Create `src/test/domain/weight_summary_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' show Value;
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
```

- [ ] **Step 3: Run the test — expect FAIL**

Run: `flutter test test/domain/weight_summary_test.dart`
Expected: compile error — `computeWeight` not defined.

- [ ] **Step 4: Implement computeWeight**

In `src/lib/data/summaries.dart`, after `computeSteps`, add (the `WeightLog` type and `WeightSummary` are already imported via `database.dart` / `domain/summaries.dart` in this file — verify imports, add if missing):

```dart
/// Weight over a period. Orders by date so latest/earliest are unambiguous
/// regardless of input order.
WeightSummary computeWeight(List<WeightLog> logs) {
  if (logs.isEmpty) {
    return WeightSummary(
        latestGrams: 0, changeGrams: 0, minGrams: 0, maxGrams: 0, count: 0);
  }
  final sorted = [...logs]..sort((a, b) => a.date.compareTo(b.date));
  final grams = sorted.map((w) => w.weightGrams).toList();
  return WeightSummary(
    latestGrams: sorted.last.weightGrams,
    changeGrams: sorted.last.weightGrams - sorted.first.weightGrams,
    minGrams: grams.reduce((a, b) => a < b ? a : b),
    maxGrams: grams.reduce((a, b) => a > b ? a : b),
    count: sorted.length,
  );
}
```

- [ ] **Step 5: Run the test — expect PASS**

Run: `flutter test test/domain/weight_summary_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 6: Add the WeightDao (mirror StepsDao)**

In `src/lib/data/daos.dart`, after the `StepsDao` class, add:

```dart
// ── Weight (one per day, edit-on-existing) ──────────────────────────
@DriftAccessor(tables: [WeightLogs])
class WeightDao extends DatabaseAccessor<AppDatabase> with _$WeightDaoMixin {
  WeightDao(super.db);

  Future<void> save(WeightLogsCompanion c) =>
      into(weightLogs).insertOnConflictUpdate(c);
  Future<void> deleteById(String id) =>
      (delete(weightLogs)..where((t) => t.id.equals(id))).go();
  Future<WeightLog?> getByDate(String date) =>
      (select(weightLogs)..where((t) => t.date.equals(date))).getSingleOrNull();
  Stream<List<WeightLog>> watchInRange(String from, String to) =>
      (select(weightLogs)
            ..where((t) => t.date.isBetweenValues(from, to))
            ..orderBy([(t) => _asc(t.date)]))
          .watch();
  Future<List<WeightLog>> inRange(String from, String to) =>
      (select(weightLogs)..where((t) => t.date.isBetweenValues(from, to))).get();
  Future<WeightSummary> summary(String from, String to) async =>
      computeWeight(await inRange(from, to));
}
```

> Note: `StepsDao` has no `@DriftAccessor` annotation in the current file (it relies on the `@DriftDatabase(daos:)` registration). Match the surrounding style — if neighbouring single-table DAOs omit `@DriftAccessor`, omit it here too and rely on the `daos:` registration from Task 1. The mixin name is `_$WeightDaoMixin` either way.

- [ ] **Step 7: Run codegen**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: regenerates `database.g.dart` + `daos.g.dart` with `weightLogs`, `WeightLog`, `WeightLogsCompanion`, `WeightDao` accessor. No errors.

- [ ] **Step 8: Write the failing DAO test**

Create `src/test/data/weight_dao_test.dart`:

```dart
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
```

- [ ] **Step 9: Run the DAO test — expect PASS**

Run: `flutter test test/data/weight_dao_test.dart`
Expected: PASS (5 tests). If `db.weightDao` is undefined, codegen (Step 7) didn't pick up the registration — re-check Task 1 Step 2.

- [ ] **Step 10: Commit**

```bash
git add src/lib/data/ src/lib/domain/summaries.dart src/test/data/weight_dao_test.dart src/test/domain/weight_summary_test.dart
git commit -F - <<'MSG'
feat(weight): WeightLogs table, WeightDao, WeightSummary + migration v3

One-per-day weight stored as integer grams (UNIQUE(date), edit-on-existing
like Steps). Schema v2->v3 creates weight_logs. DAO + computeWeight summary
(latest/change/min/max/count) with unit tests.
MSG
```

---

## Slice 2 — Cross-cutting wiring (backup, export, clear/seed)

### Task 3: Backup round-trip + clear-all-data

**Files:**
- Modify: `src/lib/services/backup_service.dart` (dataKeys, serializer, deserializer, `_deleteAll`, serialize/insert/build maps)
- Modify: `src/lib/dev/seed.dart` (`clearAll` + sample seed)
- Test: `src/test/services/backup_service_test.dart` (extend)

- [ ] **Step 1: Write the failing backup round-trip test**

In `src/test/services/backup_service_test.dart`, inside `seedSmall()` (after the trip insert, before the attachment line), add a weight row:

```dart
    await db.weightDao.save(WeightLogsCompanion.insert(
        id: 'wt1', date: '2026-05-03', weightGrams: 82500,
        note: const Value('сутрин'), createdAt: ts, updatedAt: ts));
```

Then in the `clearAllData (user-facing wipe)` group's first test, after the existing `expect(await db.mealsDao.getById('meal1'), isNull);` assertion, add:

```dart
      expect(await db.weightDao.getByDate('2026-05-03'), isNull);
```

And in the `create + round-trip` group's `restore into a wiped app...` test, after the trip assertion, add:

```dart
      expect((await db.weightDao.getByDate('2026-05-03'))!.weightGrams, 82500);
```

- [ ] **Step 2: Run — expect FAIL**

Run: `flutter test test/services/backup_service_test.dart`
Expected: FAIL — weight not serialized/restored (round-trip assertion fails or `weightDao` row survives only if wired). The compile may pass but assertions fail.

- [ ] **Step 3: Wire weight into BackupService**

In `src/lib/services/backup_service.dart`:

1. Add `'weightLogs'` to the `dataKeys` list, right after `'steps',`.

2. In `_serializeAll`, after the `'steps': [...]` entry, add:

```dart
        'weightLogs': [
          for (final w in await _db.select(_db.weightLogs).get()) _weight(w)
        ],
```

3. Add the row serializer near `_step` (find the `_step(StepEntry s)` method and add after it):

```dart
  Map<String, dynamic> _weight(WeightLog w) => {
        'id': w.id, 'date': w.date, 'weightGrams': w.weightGrams,
        'note': w.note,
        'createdAt': _iso(w.createdAt), 'updatedAt': _iso(w.updatedAt),
      };
```

4. Add the deserializer near `_stepCompanion` (in the "Deserialize → companions" section):

```dart
  WeightLogsCompanion _weightCompanion(Map<String, dynamic> m) =>
      WeightLogsCompanion.insert(
        id: m['id'] as String,
        date: m['date'] as String,
        weightGrams: (m['weightGrams'] as num).toInt(),
        note: Value(m['note'] as String?),
        createdAt: DateTime.parse(m['createdAt'] as String),
        updatedAt: DateTime.parse(m['updatedAt'] as String),
      );
```

5. In `_insertAll`, after the `for (final s in rows('steps'))` loop, add:

```dart
    for (final w in rows('weightLogs')) {
      await _db.weightDao.save(_weightCompanion(w));
    }
```

6. In `_buildAllCompanions`, after `rows('steps').forEach(_stepCompanion);`, add:

```dart
    rows('weightLogs').forEach(_weightCompanion);
```

7. In `_deleteAll`, after `await _db.delete(_db.steps).go();`, add:

```dart
    await _db.delete(_db.weightLogs).go();
```

- [ ] **Step 4: Run — expect PASS**

Run: `flutter test test/services/backup_service_test.dart`
Expected: PASS (all, including the extended weight assertions).

- [ ] **Step 5: Wire weight into dev clearAll + seed sample data**

In `src/lib/dev/seed.dart`:

1. In `clearAll(AppDatabase db)`, after `await db.delete(db.steps).go();`, add:

```dart
  await db.delete(db.weightLogs).go();
```

2. In `seedDatabase`, inside the per-day loop (the `for (var i = 29; i >= 0; i--)` block), after the steps `save`, add a gentle downward trend with noise (one entry per day):

```dart
    // Weight — a gentle cut from ~84.0 → ~82.0 kg over 30 days, daily noise.
    final wGrams = 84000 - ((29 - i) * 70) + (rnd.nextInt(700) - 350);
    await db.weightDao.save(WeightLogsCompanion.insert(
      id: 'wt$i', date: d, weightGrams: wGrams,
      createdAt: now, updatedAt: now,
    ));
```

(`d`, `i`, `rnd`, `now` are already in scope in that loop.)

- [ ] **Step 6: Run the full suite (single-threaded)**

Run: `flutter test`
Expected: all green (existing + new). The dev-seed change is exercised by any screen test that seeds.

- [ ] **Step 7: Commit**

```bash
git add src/lib/services/backup_service.dart src/lib/dev/seed.dart src/test/services/backup_service_test.dart
git commit -F - <<'MSG'
feat(weight): wire weight into backup, clear-all-data, and dev seed

weightLogs round-trips through ZIP backup (serialize/deserialize/validate)
and is removed by clearAllData (_deleteAll). Dev clearAll clears it; the
demo dataset seeds a 30-day weight trend.
MSG
```

---

### Task 4: AI export (JSON + Markdown)

**Files:**
- Modify: `src/lib/services/export_service.dart`
- Modify: `src/lib/l10n/app_en.arb` + `src/lib/l10n/app_bg.arb` (export section/line strings)
- Test: `src/test/services/export_test.dart` (extend; if absent, create per existing export test conventions)

- [ ] **Step 1: Inspect the export service shape**

Read `src/lib/services/export_service.dart` end-to-end. Note the exact pattern for an existing one-numeric-per-day module — **Steps** — across: the `ExportModule` enum, the `ExportData` field + constructor param + count getter, `_collect`, the date filter, the single-module switch, `toJson` (`_step` + `'steps'` key), and `toMarkdown` (`exportMdSectionSteps` + `exportMdStepsLine`). Weight mirrors Steps exactly.

- [ ] **Step 2: Add export l10n strings**

In `app_en.arb` (template) add (with `@` metadata blocks like neighbours):

```json
  "exportMdSectionWeight": "Weight",
  "@exportMdSectionWeight": { "description": "Markdown export: weight section heading." },
  "exportMdWeightLine": "{date}: {kg} kg{note}",
  "@exportMdWeightLine": {
    "description": "Markdown export: one weight entry line.",
    "placeholders": { "date": {}, "kg": {}, "note": {} }
  },
  "exportModuleWeight": "Тегло",
  "@exportModuleWeight": { "description": "Weight module label in the export picker." }
```

In `app_bg.arb` add the matching values:

```json
  "exportMdSectionWeight": "Тегло",
  "exportMdWeightLine": "{date}: {kg} кг{note}",
  "exportModuleWeight": "Тегло"
```

(`note` placeholder carries a leading `" — ..."` or empty string, matching how the Steps/other lines format optional notes — follow the neighbour line's note convention.)

- [ ] **Step 3: Write the failing export test**

In `src/test/services/export_test.dart` (extend existing; if none, create following `backup_service_test.dart` setup conventions), add a test that seeds a weight row and asserts:
- `toJson` output contains a `weightLogs` array whose element has `"weightGrams": 82500`.
- `toMarkdown` output contains the weight section heading and a line with `82.5`.

```dart
  test('export includes weight in JSON and Markdown', () async {
    await db.weightDao.save(WeightLogsCompanion.insert(
        id: 'wt1', date: '2026-05-03', weightGrams: 82500,
        createdAt: ts, updatedAt: ts));
    final data = await svc.collectAll(); // use the actual collect method name
    final json = svc.toJson(data);
    expect(json, contains('"weightLogs"'));
    expect(json, contains('82500'));
    final md = svc.toMarkdown(data, testL10n); // use the test l10n instance
    expect(md, contains('82.5'));
  });
```

Adjust method names (`collectAll`, `testL10n`) to match the existing export test's helpers discovered in Step 1.

- [ ] **Step 4: Run — expect FAIL**

Run: `flutter test test/services/export_test.dart`
Expected: FAIL — no `weightLogs` key / no weight section.

- [ ] **Step 5: Implement weight in export_service**

Mirror the Steps wiring exactly:
1. Add `weight('weight', 'Тегло'),` to the `ExportModule` enum.
2. Add `final List<WeightLog> weight;` field, the `this.weight = const []` constructor default, and `weight.length` in the total-count getter.
3. In `_collect`, fetch `final weight = await _db.select(_db.weightLogs).get();` and pass `weight: weight` to the `ExportData` constructor.
4. In the date filter, add `final fWeight = weight.where((w) => inR(w.date)).toList();` and pass `weight: fWeight`.
5. In the single-module switch, add `case ExportModule.weight: return ...(weight: await _db.select(_db.weightLogs).get());`.
6. In `toJson`, add `'weightLogs': [for (final w in d.weight) _weight(w)],` and a `_weight` row builder (`id, date, weightGrams, note, createdAt, updatedAt` — keep grams as the stored integer).
7. In `toMarkdown`, add a section:

```dart
    section(l10n.exportMdSectionWeight, [
      for (final w in d.weight)
        l10n.exportMdWeightLine(w.date, _kg(w.weightGrams),
            w.note == null ? '' : ' — ${w.note}')
    ]);
```

where `_kg(int g)` formats grams → one-decimal kg string (`(g / 1000).toStringAsFixed(1)`); add it as a private helper if not reusing `health_format`.

- [ ] **Step 6: Run — expect PASS, then run full suite**

Run: `flutter gen-l10n` then `flutter test test/services/export_test.dart`
Expected: PASS. Then `flutter test` — all green.

- [ ] **Step 7: Commit**

```bash
git add src/lib/services/export_service.dart src/lib/l10n/ src/test/services/export_test.dart
git commit -F - <<'MSG'
feat(weight): include weight in AI export (JSON + Markdown)

Adds ExportModule.weight, a weightLogs JSON array (integer grams), and a
Markdown weight section. JSON keys/codes stay language-independent.
MSG
```

---

## Slice 3 — Health UI (tab + chart + form)

### Task 5: Weight formatting helpers

**Files:**
- Modify: `src/lib/presentation/health/health_format.dart`
- Test: `src/test/presentation/health_format_test.dart` (extend or create)

- [ ] **Step 1: Write the failing test**

Create/extend `src/test/presentation/health_format_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/presentation/health/health_format.dart';

void main() {
  test('formatKg renders one decimal with the кг suffix', () {
    expect(formatKg(82500), '82.5 кг');
    expect(formatKg(80000), '80.0 кг');
  });

  test('formatKgDelta is signed with a unicode minus for losses', () {
    expect(formatKgDelta(1200), '+1.2 кг');
    expect(formatKgDelta(-800), '−0.8 кг'); // U+2212 minus
    expect(formatKgDelta(0), '±0.0 кг');
  });
}
```

- [ ] **Step 2: Run — expect FAIL**

Run: `flutter test test/presentation/health_format_test.dart`
Expected: FAIL — `formatKg`/`formatKgDelta` undefined.

- [ ] **Step 3: Implement the helpers**

Append to `src/lib/presentation/health/health_format.dart`:

```dart
/// Integer grams → one-decimal kilograms with the Bulgarian unit, e.g.
/// 82500 → "82.5 кг".
String formatKg(int grams) => '${(grams / 1000).toStringAsFixed(1)} кг';

/// Signed kilogram delta for the trend stat: "+1.2 кг", "−0.8 кг", "±0.0 кг".
/// Uses the typographic minus (U+2212) for losses.
String formatKgDelta(int grams) {
  final kg = (grams.abs() / 1000).toStringAsFixed(1);
  final sign = grams > 0 ? '+' : (grams < 0 ? '−' : '±');
  return '$sign$kg кг';
}
```

- [ ] **Step 4: Run — expect PASS**

Run: `flutter test test/presentation/health_format_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add src/lib/presentation/health/health_format.dart src/test/presentation/health_format_test.dart
git commit -m "feat(weight): kg + signed-delta formatting helpers"
```

---

### Task 6: Weight providers

**Files:**
- Modify: `src/lib/presentation/health/health_providers.dart`

- [ ] **Step 1: Inspect existing BP providers**

Read `src/lib/presentation/health/health_providers.dart`. Find the blood-pressure in-range stream provider and the health-summary provider, plus how the active `Period`/date-range is sourced (the period provider feeding `from`/`to`). Weight mirrors the BP in-range + summary providers.

- [ ] **Step 2: Add weight providers**

Add (matching the exact provider style — `StreamProvider`/`FutureProvider` + the `weightDaoProvider` if DAOs are exposed via providers, else `ref.watch(databaseProvider).weightDao`):

```dart
/// Weight entries in the active period (ascending by date) for the chart + tab.
final weightInRangeProvider = StreamProvider.autoDispose<List<WeightLog>>((ref) {
  final range = ref.watch(/* the existing period-range provider */);
  return ref.watch(databaseProvider).weightDao.watchInRange(range.from, range.to);
});

/// Weight summary (latest + change over the period) for the vitals header.
final weightSummaryProvider =
    FutureProvider.autoDispose<WeightSummary>((ref) async {
  final range = ref.watch(/* the existing period-range provider */);
  return ref.watch(databaseProvider).weightDao.summary(range.from, range.to);
});
```

Replace `/* the existing period-range provider */` with the actual provider discovered in Step 1 (mirror exactly how `bpInRangeProvider` derives its range). Add imports for `WeightLog`, `WeightSummary`, `databaseProvider` as needed.

- [ ] **Step 3: Verify it compiles**

Run: `flutter analyze lib/presentation/health/health_providers.dart`
Expected: No issues. (No standalone test — exercised via the screen test in Task 8.)

- [ ] **Step 4: Commit**

```bash
git add src/lib/presentation/health/health_providers.dart
git commit -m "feat(weight): in-range + summary providers for the Health screen"
```

---

### Task 7: Weight form sheet

**Files:**
- Modify: `src/lib/presentation/health/health_forms.dart` (add `showWeightSheet`)
- Modify: `src/lib/app/sheets.dart` (register `'weight'`)
- Modify: `src/lib/l10n/app_en.arb` + `app_bg.arb` (form strings)
- Test: `src/test/presentation/weight_form_test.dart`

- [ ] **Step 1: Inspect the BP form sheet**

Read `showBpSheet` in `src/lib/presentation/health/health_forms.dart`. Note: the sheet scaffold (`showLmSheet`), the numeric field widget used, the save handler (DAO save + toast + pop), the delete action when editing, and how it reads the DAO via `ref`. The weight sheet mirrors this with a single decimal field.

- [ ] **Step 2: Add form l10n strings**

`app_en.arb` (template):

```json
  "weightSheetTitle": "Weight",
  "@weightSheetTitle": { "description": "Title of the weight entry sheet." },
  "weightFieldLabel": "Weight (kg)",
  "@weightFieldLabel": { "description": "Label for the kg weight input." },
  "weightTabLabel": "Weight",
  "@weightTabLabel": { "description": "Health-screen history tab for weight." },
  "weightStatLatest": "Latest",
  "@weightStatLatest": { "description": "Vitals-header label for the most recent weight." },
  "weightStatChange": "Change",
  "@weightStatChange": { "description": "Vitals-header label for the period weight change." },
  "weightEmpty": "No weight entries for this period yet.",
  "@weightEmpty": { "description": "Empty state for the weight tab." }
```

`app_bg.arb`:

```json
  "weightSheetTitle": "Тегло",
  "weightFieldLabel": "Тегло (кг)",
  "weightTabLabel": "Тегло",
  "weightStatLatest": "Последно",
  "weightStatChange": "Промяна",
  "weightEmpty": "Все още няма записи за теглото в този период."
```

Run `flutter gen-l10n`.

- [ ] **Step 3: Write the failing form test**

Create `src/test/presentation/weight_form_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/presentation/health/health_forms.dart';
import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  testWidgets('saving a weight creates one entry; same date edits it',
      (tester) async {
    tester.view.physicalSize = const Size(420, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(
        home: Builder(
          builder: (ctx) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showWeightSheet(ctx, date: '2026-05-01'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '82.5');
    await tester.tap(find.text('Запази')); // existing save-button label
    await tester.pumpAndSettle();

    final rows = await db.weightDao.inRange('2026-01-01', '2026-12-31');
    expect(rows.length, 1);
    expect(rows.single.weightGrams, 82500);
  });
}
```

Adjust `find.byType(TextField)` and the save-button label to the actual widgets used by the BP sheet (discovered in Step 1 — e.g. `LmInput`, label `Запази`).

- [ ] **Step 4: Run — expect FAIL**

Run: `flutter test test/presentation/weight_form_test.dart`
Expected: FAIL — `showWeightSheet` undefined.

- [ ] **Step 5: Implement showWeightSheet**

In `src/lib/presentation/health/health_forms.dart`, add a `showWeightSheet(BuildContext context, {String? date, WeightLog? existing})` mirroring `showBpSheet`:
- Pre-fill the kg field from `existing?.weightGrams` (grams → `toStringAsFixed(1)`).
- Parse the kg input → grams: `(double.parse(input.replaceAll(',', '.')) * 1000).round()`. Reject empty/non-positive (disable save, like BP's validation).
- Default `date` to today (`ymd(DateTime.now())`) when not provided.
- Save via `ref.read(databaseProvider).weightDao.save(WeightLogsCompanion.insert(id: existing?.id ?? const Uuid().v4(), date: date, weightGrams: grams, note: Value(noteOrNull), createdAt: existing?.createdAt ?? now, updatedAt: now))`. (Use the same id/clock approach the BP sheet uses.)
- Show the existing save toast and pop. Add a delete action when `existing != null` (mirror BP's delete → `weightDao.deleteById`).

- [ ] **Step 6: Register the sheet opener**

In `src/lib/app/sheets.dart`:
- Add `case 'weight': showWeightSheet(context); return;` in `openFormSheet`.
- Add `'weight': l10n.weightSheetTitle,` to the `titles` map.

- [ ] **Step 7: Run — expect PASS, then full suite**

Run: `flutter test test/presentation/weight_form_test.dart` → PASS.
Then `flutter test` → all green.

- [ ] **Step 8: Commit**

```bash
git add src/lib/presentation/health/health_forms.dart src/lib/app/sheets.dart src/lib/l10n/ src/test/presentation/weight_form_test.dart
git commit -F - <<'MSG'
feat(weight): weight entry form sheet (one-per-day, edit-on-existing)

Decimal kg input parsed to integer grams, optional note, delete when
editing. Registered in openFormSheet as 'weight'.
MSG
```

---

### Task 8: Health screen — "Тегло" tab + trend chart

**Files:**
- Modify: `src/lib/presentation/health/health_screen.dart`
- Test: `src/test/presentation/health_test.dart` (extend) or `src/test/presentation/weight_health_screen_test.dart` (new)

- [ ] **Step 1: Inspect the Health screen tab + vitals structure**

Read `src/lib/presentation/health/health_screen.dart`. Note: `_tabLabels`, the `TabBar`/`TabBarView` (currently 4 tabs), the per-tab add-button wiring, the vitals header card (last BP + averages), and the BP `Sparkline` usage. Weight adds a 5th tab and a header weight stat + sparkline.

- [ ] **Step 2: Write the failing screen test**

Create `src/test/presentation/weight_health_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' show Value;
import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/presentation/health/health_screen.dart';
import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  testWidgets('Health screen shows the Тегло tab and renders an entry',
      (tester) async {
    tester.view.physicalSize = const Size(420, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    final now = DateTime.utc(2026, 6, 1);
    await db.weightDao.save(WeightLogsCompanion.insert(
        id: 'w1', date: '2026-06-01', weightGrams: 82500,
        createdAt: now, updatedAt: now));

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: const Scaffold(body: HealthScreen())),
    ));
    await settleData(tester);

    expect(find.text('Тегло'), findsWidgets); // tab label (+ maybe header)
    await tester.tap(find.text('Тегло').first);
    await settleData(tester);
    expect(find.textContaining('82.5'), findsWidgets);
  });
}
```

- [ ] **Step 3: Run — expect FAIL**

Run: `flutter test test/presentation/weight_health_screen_test.dart`
Expected: FAIL — no "Тегло" tab.

- [ ] **Step 4: Add the tab + chart + header stat**

In `health_screen.dart`:
1. Add `context.l10n.weightTabLabel` to `_tabLabels` (5th entry). Update the `TabController` length / `DefaultTabController(length: 5)` and any hardcoded tab-count.
2. Add a `TabBarView` child for weight: watch `weightInRangeProvider`; render the entries as `LmRow`s (date + `formatKg(w.weightGrams)` + note), newest-first, tap → `showWeightSheet(context, date: w.date, existing: w)`; empty → `EmptyState(l10n.weightEmpty)`. The per-tab "+" calls `showWeightSheet(context)` (defaults to today).
3. In the vitals header, watch `weightSummaryProvider`: show a `Stat`/`Pill` with `weightStatLatest` → `formatKg(s.latestGrams)` and `weightStatChange` → `formatKgDelta(s.changeGrams)`, plus a `Sparkline` fed by the in-range grams (mirror the BP sparkline; map `weightGrams` to the y-series). Guard the empty case (count == 0 → hide or show a dash).

Match the exact widget names/props found in Step 1 (`Sparkline`, `Stat`, `Pill`, period chips).

- [ ] **Step 5: Run — expect PASS, then full suite + analyze**

Run: `flutter test test/presentation/weight_health_screen_test.dart` → PASS.
Run: `flutter test` → all green.
Run: `flutter analyze` → No issues found.

- [ ] **Step 6: Commit**

```bash
git add src/lib/presentation/health/health_screen.dart src/test/presentation/weight_health_screen_test.dart
git commit -F - <<'MSG'
feat(weight): Тегло tab + trend chart in the Health screen

Fifth history tab (list + add/edit via the weight sheet) and a vitals-header
weight stat (latest + signed change) with a trend sparkline over the period.
MSG
```

---

### Task 9: Final verification + plan/docs update

- [ ] **Step 1: Full gate**

Run from `src/`:
- `flutter analyze` → No issues found.
- `flutter test` → all green (note the new total count).

- [ ] **Step 2: Update the implementation plan doc**

In `docs/implementation-plan.md`, under "## Utilities" (or a new "## Weight" subsection), add a one-line entry summarizing the weight module and pointing to `docs/superpowers/specs/2026-06-04-weight-tracking-design.md`.

- [ ] **Step 3: Commit**

```bash
git add docs/implementation-plan.md
git commit -m "docs: log weight-tracking module in the implementation plan"
```

- [ ] **Step 4: Note for the user**

Remind the user: green `flutter test` does NOT prove the APK builds (CLAUDE §4). The schema v2→v3 migration and the new UI need an on-device verification pass (build APK, log a weight, confirm the trend chart, run an export, run a backup→restore round-trip) before sign-off.

---

## Self-Review notes

- **Spec coverage:** data layer (Tasks 1–2), backup (Task 3), clear-all-data + seed (Task 3), export (Task 4), Health UI tab/chart/form/format/providers (Tasks 5–8), strings (Tasks 4/7), migration (Task 1), tests across all. All spec sections mapped.
- **Type consistency:** `WeightLog` (data class), `WeightLogsCompanion`, `WeightDao`, `WeightSummary`, `computeWeight`, `formatKg`, `formatKgDelta`, `showWeightSheet`, `weightInRangeProvider`, `weightSummaryProvider`, `ExportModule.weight` used consistently throughout.
- **Known read-and-mirror points (not placeholders — concrete templates named):** Tasks 6/7/8 require reading the BP provider/form/screen code first because the exact widget/provider names (period-range provider, `Sparkline`, `Stat`, save-button label) belong to existing code; each step names the exact template symbol to mirror and the concrete code to add.
