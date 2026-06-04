# Weight tracking — design

**Date:** 2026-06-04
**Status:** Approved, ready for implementation plan

## Purpose

Let the user log body weight over time and see the trend. Weight is a health
vital (like blood pressure), so it lives inside the existing **Health module**
rather than as a standalone screen. Good for spotting direction over weeks/months
and feeding the AI export.

## Decisions (locked)

- **Placement:** a 5th "Тегло" tab in the Health module, plus a weight stat +
  trend chart in the Health vitals header. Reuses the screen, period chips, and
  chart scaffolding.
- **Cardinality:** exactly one entry per day (`UNIQUE(date)`, edit-on-existing),
  mirroring the Steps module. Logging for a date that already has an entry opens
  and edits it — never a duplicate.
- **Fields:** weight + optional note. No body-fat, no time-of-day.
- **Unit / storage:** stored as **integer grams** (no floats, mirrors the
  EUR-cents rule §4); displayed in kilograms, e.g. `82.5 кг`.

Out of scope: body-fat %, goal/target weight, BMI, multiple entries per day,
unit switching (kg only — single-unit, like the single-currency decision).

## Scope note

Weight is **not in the functional spec** (`docs/functional_spec.md`) — this
feature extends the app beyond the original spec. No locked decisions change:
integer-grams follows the cents rule, dates stay `yyyy-MM-dd`, kg is the only
unit. No new dependencies.

## Architecture

Adding a table is cross-cutting. The work spans the data layer, the two
data-export paths (backup + AI export), the wipe paths (clear-all-data + dev
seed), and the Health UI. Each piece mirrors an existing pattern.

### 1. Data layer

**Table** `WeightLogs` in `src/lib/data/tables/health.dart` (it holds the health
vitals tables):

```dart
/// Body weight — exactly one per date (one-per-day, edit-on-existing like Steps).
/// Stored as integer grams (no floats, mirrors EUR cents §4); shown in kg.
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

No `noteLower` shadow column — weight notes are deliberately **not** part of
global search (matches the Steps module; keeps the form minimal). If search over
weight notes is wanted later, add `noteLower` + the companion-mapping helper per
the Cyrillic-safe-search rule (§4).

**`WeightDao`** in `src/lib/data/daos.dart`, mirroring `StepsDao`:
- `save(WeightLogsCompanion)` → `insertOnConflictUpdate` (the unique `date`
  drives one-per-day upsert).
- `deleteById(String)`, `getByDate(String)`, `watchInRange(from, to)`,
  `inRange(from, to)` (ordered by date asc), `summary(from, to)`.

Register `WeightLogs` in the `@DriftDatabase` `tables:` list and `WeightDao` in
`daos:` in `src/lib/data/database.dart`.

**`WeightSummary`** DTO + `computeWeight(List<WeightLog>)` in
`src/lib/domain/summaries.dart`: `latestGrams`, `changeGrams` (latest − earliest
in range), `minGrams`, `maxGrams`, `count`. Empty range → a zeroed/empty summary.

**Migration:** bump `schemaVersion` 2 → 3 in `database.dart`; extend `onUpgrade`:

```dart
if (from < 2) await m.createTable(settings);   // existing
if (from < 3) await m.createTable(weightLogs);  // new
```

Run `dart run build_runner build --delete-conflicting-outputs` after the table +
DAO land (regenerates `database.g.dart` + `daos.g.dart`).

### 2. Cross-cutting data paths

**Backup** (`src/lib/services/backup_service.dart`):
- Add `'weightLogs'` to the `dataKeys` list (weight has no FKs; place it near
  `steps`).
- Add a `_weight(WeightLog)` serializer (exact snapshot: id, date, weightGrams,
  note, ISO timestamps) and a `_weightCompanion(Map)` deserializer.
- Wire `weightLogs` into `_serializeAll`, `_insertAll`, `_buildAllCompanions`,
  and `_deleteAll`.
- The backup screen's existing "Здраве" include line covers weight — no new
  include string needed.

**Clear-all-data + dev seed:**
- `clearAllData`'s wipe routes through `_deleteAll` (covered above) + the
  filesystem step (weight has no attachments) — no extra work beyond adding
  `weightLogs` to `_deleteAll`.
- Add `db.delete(db.weightLogs).go()` to the dev `clearAll` in
  `src/lib/dev/seed.dart`.
- Seed ~30 days of realistic sample weight in `seedDatabase` (a gentle trend with
  daily noise) so the Health screen + promo dataset look lived-in.

**AI export** (`src/lib/services/export_service.dart`):
- Add `ExportModule.weight` (code `'weight'`, label `'Тегло'`).
- Add `ExportData.weight` (`List<WeightLog>`) + its count in the total.
- Handle weight in `_collect`, the date filter, and the single-module export.
- `toJson`: add a `weightLogs` key with a `_weight` row shape (weightGrams kept
  as the stored integer; JSON keys/codes stay language-independent §4).
- `toMarkdown`: add a weight section (date + formatted kg + note) via new l10n
  section/line strings.

### 3. Health UI

**`health_screen.dart`:**
- Add "Тегло" as the 5th history tab (after Изследвания). The tab shows weight
  entries newest-first as `LmRow`s (date + `82.5 кг` + note), tap to edit, with
  the per-tab "+" adding an entry for **today**.
- Add to the vitals header: a weight stat (latest weight + Δ over the selected
  period) and a weight trend `Sparkline` (the same chart widget the BP header
  uses), driven by the existing period chips.

**`health_forms.dart`:** `showWeightSheet(context, {String? date, WeightLog?
existing})` — a decimal kg input (parsed to grams) + optional note. One-per-day:
opening for a date that already has an entry pre-fills and edits it. Delete
action when editing an existing entry. Register `'weight'` in
`src/lib/app/sheets.dart` `openFormSheet` (and the `titles` map).

**`health_providers.dart`:** a weight-in-range stream provider + a weight-summary
provider, mirroring the BP providers.

**`health_format.dart`:** `formatKg(int grams)` → `'82.5 кг'` (one decimal,
trimmed), and a signed-delta formatter for the change stat (`+1.2 кг` / `−0.8 кг`).

**Strings** (`app_en.arb` template + `app_bg.arb`): weight tab label, sheet
title, weight field label + `кг` unit, note label, vitals stat labels (latest /
change), and the export section + line strings. Regenerate with `flutter gen-l10n`.

## Testing

Per technical-spec §12 (DAO/service → unit; forms/screens → widget). New/extended
tests:

- **DAO** (`test/data/...`): saving twice for the same date yields one edited row
  (one-per-day upsert); `getByDate`; `watchInRange` ordering; `summary` returns
  correct latest/change/min/max/count.
- **Summary** (`test/domain/...`): `computeWeight` for empty, single-entry, and
  multi-entry ranges (change sign correct).
- **Backup** (`test/services/backup_service_test.dart`): a weight row round-trips
  byte-for-byte through build → wipe → restore; and is removed by `clearAllData`
  (extend the existing clearAllData test to include a weight row).
- **Export** (`test/services/...`): weight appears in `toJson` (correct key +
  integer grams) and in `toMarkdown` (section present, kg formatted).
- **Widget** (`test/presentation/...`): Health screen renders the "Тегло" tab +
  trend chart from seeded data; the weight form saves a new entry and edits the
  existing entry for the same date (no duplicate). Use `useDeterministicTestEnv`
  + `settleData`.
- **Migration:** a v2→v3 open creates `weight_logs` (follow the existing
  on-upgrade approach; the device migration pass owns final on-device sign-off).

## Reuses / constraints

- Reuses: Steps one-per-day DAO pattern, BP sub-module UI (tab + list + form +
  sparkline), period chips, `LmRow`, `showLmSheet`, the backup/export per-table
  serializers, `computeSteps`-style summary helpers.
- No new dependencies. No locked-decision changes. Integer-grams storage,
  `yyyy-MM-dd` dates, kg-only, Bulgarian UI strings / English identifiers.
- Implementation splits into slices: (1) data layer (table + DAO + summary +
  migration + codegen), (2) backup + export + clear/seed wiring, (3) Health UI
  (tab + chart + form + strings) — each with its own tests and an analyze/test
  gate.
