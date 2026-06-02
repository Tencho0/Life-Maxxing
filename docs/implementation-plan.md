# LifeMaxxing V1 — Implementation Plan

> Build order for V1, broken into **small, independently reviewable slices**. Each slice is testable on its own and ends in a runnable/verifiable state.
> Derived from [`technical-spec.md`](technical-spec.md) (the engineering contract) and [`functional_spec.md`](functional_spec.md) (behavior).
> **This file is living** — check off items as they land and add notes/deviations inline.

## How to use this file

- `- [ ]` not started · `- [x]` done · `- [~]` in progress (add a `— note` after any item).
- Slices are ordered so dependencies always precede dependents. Within a feature slice, the order is **DAO → provider → screen → form → tests**.
- **Definition of done** for every slice: code compiles, `flutter analyze` clean, the slice's stated tests pass, and the slice's "Verify" line is demonstrably true.
- No slice is "done" on assertion alone — run the verification and the tests.

---

## Phase 0 — Scaffold & tooling

### Slice 0.1 — Flutter project + repo hygiene ✅ (commit b711653)
- [x] `flutter create` the app (`lifemaxxing`, `com.klevret.lifemaxxing`, `--platforms android`).
- [x] Dart `^3.11.3`; Flutter 3.41.5 stable pinned in README.
- [x] `.gitignore` (Flutter defaults) + `.gitattributes` (LF normalize, binary markers).
- [x] Preserve the design bundle under `design/life-maxxing/` — reference only.
- [x] `analysis_options.yaml` with `flutter_lints`.
- [x] Add all dependencies from technical-spec §10 to `pubspec.yaml` (not wired yet).
- **Verify:** ✅ `flutter analyze` clean. (Boot verified via gallery + widget test rather than the counter app.)

### Slice 0.2 — CI-lite check script (optional but recommended) ✅
- [x] `tool/check.sh` + `tool/check.ps1`: `flutter analyze && flutter test && dart run build_runner build` (cross-platform; added in the Phase 9.3 wrap-up).
- **Verify:** ✅ analyze + suite are green (193 tests).

---

## Phase 1 — Design system foundation

### Slice 1.1 — Fonts ✅ (commit ef8ca91)
- [x] IBM Plex Sans (400/500/600/700) + IBM Plex Mono (400/500/600), Cyrillic ("complete" cut), in `assets/fonts/`.
- [x] Declared in `pubspec.yaml` (families `IBM Plex Sans` / `IBM Plex Mono`).
- **Verify:** ✅ converted WOFF→TTF; verified Cyrillic (А–я) + weight per file; renders in gallery.

### Slice 1.2 — Tokens ✅ (commit c44d3cc)
- [x] `core/theme/tokens.dart` — colors (+ `…Soft` variants), hero gradients, radii, spacing, durations.
- [x] `core/theme/mood_color.dart` — OKLCH→sRGB `moodColor(v)` / `moodHue(v)` / `moodLabel(v)`.
- [x] Unit test: red→green, hue monotonic 25°→150°, gamut bounds, Bulgarian labels.
- **Verify:** ✅ tests pass; ramp shown in gallery.

### Slice 1.3 — Typography + Theme ✅ (commit 37935f1)
- [x] `core/theme/typography.dart` — named Sans/Mono `TextStyle`s.
- [x] `core/theme/theme.dart` — dark `ThemeData` (tokens + fonts; sheet/selection chrome).
- **Verify:** ✅ app boots themed (gallery on `AppColors.bg`).

### Slice 1.4 — Icon set ✅ (commit 7d877c5)
- [x] `core/icons/lm_icons.dart` — `LmIcon` widget + `CustomPainter` for all 39 icons.
- [x] Minimal SVG path parser (M/L/H/V/C/S/Q/T/A + relative → `Path`/`arcToPoint`); circle/rect + affine transforms.
- [x] Unit tests: all icons → finite bounded paths; parser checks.
- **Verify:** ✅ icon gallery section renders all 39 (gallery, commit 52efb70).

> **Phase 1 complete** — `flutter analyze` clean, full suite green (15 tests). Reviewable via the dev gallery (`flutter run`).

---

## Phase 2 — Shared components

> **Built via parallel workflow** (24 agents, one widget/file each) → reconciled (4 fixes) → catalogued + tested. Commits 4a3fc37 / 0aac7e3 / 91da12e.

### Slice 2.1 — Primitive widgets (`core/widgets/`) ✅
- [x] `LmCard`, `Eyebrow`, `Pill`, `DeltaBadge`, `Stat`, `LmRow`, `SectionTitle`.
- [x] `AppTopBar` (blur, back+title+sub+right slot), `ScreenBody` (scroll+padding).
- [x] `LmButton` (primary/ghost/danger), `showLmToast` overlay (Riverpod provider deferred to Phase 5).
- [x] Widget tests for `LmButton` variants and `Pill`.
- **Verify:** ✅ component catalog (Компоненти tab) shows each primitive; catalog smoke test passes.

### Slice 2.2 — Form controls (`core/widgets/`) ✅
- [x] `Field`, `LmInput`, `LmTextArea`, `Segmented`, `YesNo`, `Scale10`, `MoodPicker`, `LmStepper`, `PhotoAdd`, `PhotoTile`, `PeriodChips`.
- [x] Widget tests: `YesNo`/`Segmented`/`Scale10` selection; `LmStepper` increment/clamp; `MoodPicker` value.
- **Verify:** ✅ catalog exercises every control; tests pass.

### Slice 2.3 — Charts (`core/charts/`, fl_chart wrappers + MoodGauge) ✅
- [x] `Sparkline`, `MiniBars`, `LmBarChart`, `Ring`, `SegRing` (fl_chart 1.x, chrome/touch off, tokenized).
- [x] `MoodGauge` hand-painted (OKLCH ramp).
- [x] Catalog smoke test renders all with sample data.
- **Verify:** ✅ catalog shows all charts; builds with no exceptions.

> **Phase 2 complete** — `flutter analyze` clean, full suite green (25 tests). Reviewable via `flutter run` → **Компоненти** tab. Note: stacked income/expense bars deferred to the Finance slice (built there with real data).

---

## Phase 3 — Data layer

### Slice 3.1 — Enums + converters ✅ (commit 23778cf)
- [x] `domain/enums.dart` — 17 enums w/ codes + Bulgarian labels (`Coded`/`parseCode`); `ActivityType.group`; `AttachmentEntity.folder`; `Period.chipLabel`.
- [x] `data/converters.dart` — generic `CodedConverter` + a const instance per stored enum.
- [x] Unit tests: round-trip every code; unknown→null/fallback; group derivation; spec income categories.
- **Verify:** ✅ analyze clean, 6 tests pass.

### Slice 3.2 — Tables + database ✅ (commit c1180c4)
- [x] `data/tables/*.dart` — all 14 table classes (15 tables; Expenses+Income share finance.dart): TEXT dates, `amountCents`/`priceCents`, `*Lower` columns, BP `systolic>diastolic` + positive checks, `daily_logs`/`steps` `UNIQUE(date)`, trip `toDate>=fromDate` check, mood/feeling 1–10 checks, attachments + index, `bucket_experiences` FK `ON DELETE CASCADE`.
- [x] `data/database.dart` — `@DriftDatabase` v1, `MigrationStrategy`, `beforeOpen` → `PRAGMA foreign_keys = ON`. `build.yaml`: DateTime stored as ISO-8601 text.
- [x] `build_runner` generates cleanly (`database.g.dart`).
- [x] Tests (in-memory sqlite): FK enforce + cascade, CHECK rejects (sys≤dia, amount 0, trip order, mood 11), `UNIQUE(date)` rejects dup daily/steps, DateTime round-trips as text.
- **Verify:** ✅ analyze clean, 11 db tests pass (42 total).

### Slice 3.3 — DAOs: CRUD + `*Lower` companion mapping ✅ (commit 7154322)
- [x] 14 DAOs in `data/daos.dart`, registered on `AppDatabase`.
- [x] Each DAO's `save()` runs `_withLower` — the single writer of the `*Lower` columns (Dart `toLowerCase`); non-null shadow columns got `withDefault('')` so callers never set them.
- [x] `getById`/`getByDate` + `watchByDate`/`watchAll` streams; `AttachmentsDao.forEntity` by enum.
- [x] Tests: lower mapping (Cyrillic upper→lower), CRUD round-trip, stream emits on insert.
- **Verify:** ✅ analyze clean, 6 DAO tests pass (48 total).

### Slice 3.4 — DAOs: search, filter, aggregates ✅ (commit 85814fd)
- [x] Range/filter queries on all module DAOs; consolidated `FinanceDao`/`HealthDao`/`BucketDao` for cross-table reads.
- [x] `SearchDao` — Cyrillic-safe global search (`LIKE` over `*Lower`, Dart-lowercased query) → `SearchHit`s across 11 modules.
- [x] Per-module aggregate `summary()` methods → typed DTOs. **DTOs (`domain/summaries.dart`) defined here** (pulled forward from 4.1); pure null-safe compute in `data/summaries.dart` (EUR cents).
- [x] Tests: finance/food/activity/steps/health/daily/bucket/trip math (NULL-ignoring, averages, top-category, last-by-time), Cyrillic search across modules, category/status/repeat filters.
- **Verify:** ✅ analyze clean, 15 new tests (63 total).
- **Deferred:** cross-module daily-date composite (§27) and monthly composite (§28) are thin compositions of these summaries — built in the Daily/Stats feature slices. Trip stats currently span all trips (period filtering added when the Trips screen needs it).

### Slice 3.5 — Steps↔Daily shared-metric service ✅ (commit 0c6ffc9)
- [x] `services/steps_service.dart`: `setFromDaily` (create-only/locked), `setFromStepsModule` (create or edit-in-place, preserves source+createdAt), `isLockedForDaily`, `forDate`, `deleteForDate`. Injectable id/clock.
- [x] Tests: daily creates when absent + is locked otherwise; steps module edits in place; `source` provenance preserved on edit; one row per date; updatedAt bumped / createdAt preserved.
- **Verify:** ✅ analyze clean, 7 tests pass (70 total).

> **Phase 3 (data layer) complete** — enums/converters, 15-table schema with all constraints, DAOs with central `*Lower` mapping, search/filter/aggregates, and the steps shared-metric service. `flutter analyze` clean, 70 tests green, all on in-memory sqlite.

---

## Phase 4 — Domain logic

### Slice 4.1 — Period range resolution
- [x] `Period` enum (+ chip labels) — done in Slice 3.1 (`domain/enums.dart`).
- [x] Summary DTOs (`domain/summaries.dart`) — done in Slice 3.4.
- [x] `domain/period.dart` — `resolveRange(period, {today, customFrom, customTo})` → `DateRange` (yyyy-MM-dd); DST-safe constructor math; `today` anchor. (commit 5794e21)
- [x] Tests (12): inclusivity, month/year boundaries, leap Feb, zero-padding, custom + throws.
- **Verify:** ✅ analyze clean, 82 tests total. **Phase 4 complete.**

---

## Phase 5 — App shell & navigation

### Slice 5.1 — Router + nav shell + sheet infra ✅ (commit cd39313)
- [x] `app/app.dart` (`ProviderScope` + `MaterialApp.router`), `app/router.dart` (**`ShellRoute`** with persistent bottom nav — single-stack, matches the prototype; `/dev` outside the shell). `app/providers.dart`: `databaseProvider`.
- [x] `core/widgets/lm_bottom_nav.dart` — 5 slots + raised center FAB; tab taps `go`, modules `push`.
- [x] `app/sheets.dart` — `showLmSheet` + quick-log chooser (7 actions) + `openFormSheet` registry (placeholder bodies until Phase 7).
- [x] Placeholder screens for every route; More lists all module links + Dev.
- **Verify:** ✅ widget test — tab switch, FAB chooser, module push + back. analyze clean, 82 tests. **Phase 5 complete.**
- *Note:* used `ShellRoute` (single persistent navigator) rather than `StatefulShellRoute` to match the prototype's reset-on-tab, persistent-bottom-nav model.

---

## Phase 6 — Dev seed (review aid)

### Slice 6.1 — Seed helper (debug-only) ✅ (commit 60fb1db)
- [x] `dev/seed.dart` — `seedDatabase` (~30 days across all modules, respects one-per-day + CHECK constraints) + `clearAll`, anchored to `today`. `dev/seed_panel.dart` is the DevHome "Данни" tab (load/clear).
- [x] Tests: every module populated, idempotent (clear-then-seed → 30 not 60), search + finance summary over seeded data, `clearAll` empties.
- **Verify:** ✅ analyze clean, 85 tests. Feature screens can now be reviewed populated. **Phase 6 complete.**

---

## Phase 7 — Feature slices

> Each feature slice delivers a **runnable vertical**: DAO wiring → Riverpod providers → screen (with `PeriodChips`, key numbers, charts, record list) → create/edit sheet (validation per §8) → delete → search/filter hooks → tests. Photo-bearing features also wire `AttachmentService`.

### Slice 7.1 — Finance (canonical first vertical; no attachments) ✅ (commit ae5944c)
- [x] Reactive providers: period → range → live expense/income streams → computed `FinanceSummary`.
- [x] Finance screen: balance hero, income-vs-expense chart (`IncomeExpenseBars`, deferred from Phase 2), category `SegRing` + legend, records tabs, `+` chooser, period chips (incl. custom date-range picker), back.
- [x] Expense + Income forms (create/edit/delete, validation amount>0 + required) via `FinanceDao`; `/finance` route + quick-log FAB wired.
- [x] Tests: provider pipeline (range filter + summary), form validation + save (cents + `*Lower`), screen render from seeded data.
- [x] **Test-determinism harness** (reusable): configurable `lmToastDuration`/`lmChartAnimationDuration`; `test/support/test_env.dart` (`useDeterministicTestEnv`, `settleData`); drift-stream widget-test pattern; CLAUDE.md §6 conventions.
- **Verify:** ✅ analyze clean; full suite green (89). Add/edit/delete updates numbers + charts live.
- *Deferred:* the design's radial FAB (`FinRadial`) is a simple expense/income chooser sheet for V1.

### Slice 7.2 — AttachmentService (+ image pipeline) ✅ (commit 8f9fbbe)
- [x] `AttachmentService`: pick (image_picker) → compress ≤1600px/Q80 → ~320px thumb → write full+thumb under `attachments/<folder>/` → insert row (paths, size, dims, sortOrder, role). Image step behind an `ImageProcessor` interface (`FlutterImageProcessor` real / fake in tests).
- [x] Cardinality rules (meal/activity/daily=single, trip cover=single+gallery=many, events/labs/bucket=many); single roles replace + delete old files.
- [x] Delete routes files+rows (`removeAttachment`/`deleteAllForEntity`); `deleteForBucketItem` also removes its experience's files (spec §5.1).
- [x] Tests (8): write+metadata; pipeline params (1600/Q80 + 320/Q70) + thumb smaller; cardinality (replace deletes old file); many append/sortOrder; trip cover+gallery coexist; delete removes files; bucket cascade leaves no orphans.
- **Verify:** ✅ analyze clean; full suite green (97). VM tests exercise real file IO (temp dir) with a faked image step; real `flutter_image_compress` codec is device-only (isolated in `FlutterImageProcessor`).

### Slice 7.3 — Food ✅ (commit 13836ce)
- [x] Providers: meals by date/period (`foodMealsProvider`) + food summary (cals/macros/day, by type) + reactive daily totals (`foodDailyTotalsProvider`, §6.6).
- [x] Food screen: calories `Ring` (avg/day, scaled to the period's peak day) + macro bars, calories-by-day chart, meals list (tap to edit), period chips.
- [x] Food sheet (type, name*, time, quantity, cals/macros, note, 0–1 photo) create+edit+delete; photo add/remove via `AttachmentService` (stable id; abandoned-new-meal photo cleaned on dispose); thumb→full viewer.
- [x] Tests (6): daily totals ignore NULLs; summary reflects range; required name; save (calories+macros+`*Lower`); search by name/note; screen renders from seed.
- **Verify:** ✅ analyze clean; full suite green (103). Photo pipeline (pick→compress→thumb→display) is device-verified (AttachmentService faked in unit tests, §7.2).

### Slice 7.4 — Activities ✅ (commit d933f9f)
- [x] Providers: activities by period + summary (counts by group, total time, most-frequent, avg duration); client-side type filter (list narrows, summary stays full-range).
- [x] Activities screen: counts card, activity-group `SegRing` + legend, type-filter chips, list with intensity + mood, period chips.
- [x] Activity sheet (type*, name?, start/end/duration, intensity, quality + mood Scale10s, note, 0–1 photo) CRUD; validation (duration>0 if present).
- [x] Tests (5): group derivation counts + most-frequent; filter by type; optional-name accepted; duration>0 rejected; screen renders from seed.
- [x] Extracted shared `SinglePhotoField` (`presentation/common/photo_field.dart`); Food refactored to reuse it.
- **Verify:** ✅ analyze clean; full suite green (108). Photo pipeline device-verified (§7.2).

### Slice 7.5 — Steps ✅ (commit e00fcb3)
- [x] Steps screen: today `Ring` (toward a 10k reference goal), stats (total/avg/max/days), steps-by-day chart, recent days list with provenance, period chips.
- [x] Steps sheet (date, count*, note) create/edit/delete via `StepsService` (edit-in-place per date, source preserved).
- [x] Tests (6): one-value-per-date + steps-module edit preserves daily provenance (edit-only-here); provenance labels; count required; saves (source=stepsModule); summary over range; screen renders from seed.
- **Verify:** ✅ analyze clean; full suite green (114).

### Slice 7.6 — Health (tabbed: Кръвно / Добавки / Събития / Изследвания) ✅ (commit 5306392)
- [x] Providers: BP + meds (range) + events + labs (all) streams → combined health summary (last BP/pulse, averages, counts, last dental/lab); `HealthDao.watchMedsInRange` added.
- [x] Health screen: vitals card (last/avg BP + pulse, next-dental surfacing), BP-over-time sparklines (sys + dia), 4-tab history, per-tab `+`.
- [x] BP sheet (numeric sys/dia/pulse, live sys>dia validation), Med sheet (name/type/time/dose/status), Health-event sheet (type/dentist-only subtype/clinic/reason/whatWasDone*/price/next date/note + 0–many photos), Lab sheet (lab*/reason*/results/0–many photos). CRUD each.
- [x] Event/lab photos (0–many) via `AttachmentService` (`MultiPhotoField` + `PhotoFormMixin` abandon-cleanup).
- [x] Tests (7): BP rejects sys≤dia then saves; multiple BP per day; dental subtype only for dentist; summary last-BP + averages; nextDentalDate surfacing; lab requires lab+reason; screen renders from seed.
- **Verify:** ✅ analyze clean; full suite green (121). Event/lab photo IO device-verified (§7.2).
- *Deviations:* numeric BP inputs (steppers impractical for 3-digit values); med status uses Прието/Пропуснато labels (not Да/Не).

### Slice 7.7 — Daily Quick Log ✅ (commit ef4274d)
- [x] Providers: log + steps + photo by viewed date (reactive); create-or-open existing (caller passes existing → reuses id, no dup). `DailyLogsDao.watchInRange` added.
- [x] Daily screen: mood hero (`Ring` + mood color/label), photo, yes/no grid (+ conditional notes), screen-time/locked steps, notes, 30-day mood trend; empty state.
- [x] Daily sheet (mood*, proud*, uncomfortable*+conditional, workout*, alcohol*+conditional, screen time, steps via `StepsService` create-if-absent/locked, note, 0–1 photo). Opening for an existing date edits it.
- [x] Tests (5): open-existing edits same row (no dup); conditional field on Да; steps create-if-absent + lock; trailing-30-day summary; screen renders from seed.
- **Verify:** ✅ analyze clean; full suite green (126). Photo IO + quick-log resolve device-verified.
- *Note:* screen-time entered as minutes (numeric) rather than the prototype's "Hh Mm" string. ?date= deep-link deferred (screen defaults to today; wired in Memories 7.12).

### Slice 7.8 — Bucket List (+ detail + experience) ✅ (commit 0980f60)
- [x] Providers: filtered list (status) + reactive stats (all items + experiences); item detail/experience/photos streams. `BucketDao` watch methods added.
- [x] Bucket screen: stat cards, status filter, items list → push `/bucket/:id`.
- [x] Detail screen: status/priority pills, why, item photos, complete button (if not completed) → experience sheet; completed shows logged experience + photos; editable; delete.
- [x] Item sheet (title*/why/priority*/status* + 0–many photos) CRUD; Experience sheet (feeling*/date*/worthIt*/reflection/photos) → sets status Completed.
- [x] Item + experience photos (0–many); `deleteBucketItem` cleans both rows + files via `AttachmentService.deleteForBucketItem` (first use, spec §5.1).
- [x] Tests (6): complete-flow sets status+creates experience; edit keeps one row; detail shows complete button only when not completed; delete cascades rows+files (no orphans); bucket stats; screen renders.
- [x] Extracted shared `PhotoFormMixin` (`common/photo_form_mixin.dart`); Health refactored onto it. `LmButton` long labels ellipsize.
- **Verify:** ✅ analyze clean; full suite green (132). Photo IO device-verified (§7.2).

### Slice 7.9 — Trips (+ detail) ✅ (commit 8b04aad)
- [x] Providers: trips list (would-repeat filter) + all-trips stats + per-trip detail/photos/cover. `TripsDao.watchById` added.
- [x] Trips screen: stat cards, would-repeat filter, trip cards (cover header + overall badge).
- [x] Detail screen: cover header, rating bars (overall + sub-ratings), would-repeat + comment, gallery grid; edit + delete.
- [x] Trip sheet (title*/destination*/from*/to*/overall* + sub-ratings/wouldRepeat/comment, cover + gallery) CRUD; date-order validation; cover replace; gallery add/remove.
- [x] Tests (8): toDate≥fromDate (DB); one cover + many gallery + deleteTrip cleanup; stats (avg overall, repeat); search title/destination; form requires title+dest, saves; screen + detail render.
- **Verify:** ✅ analyze clean; full suite green (140). Cover/gallery photo IO device-verified (§7.2).
- *Note:* period filtering of trip stats deferred (spans all trips, per §3.4 note); a would-repeat filter ships instead.

### Slice 7.10 — Home ✅ (commit cb26900)
- [x] Providers: trailing-7-day rails (mood/steps/expense/pulse + averages) + today timeline across modules, combined from the module DAOs.
- [x] Home screen: greeting header, 4 quick-log tiles (open sheets), week rail cards (sparklines), daily-flow timeline, "finish daily report" CTA. Wired `/` → HomeScreen.
- [x] Tests (3): timeline aggregates today's rows (meds collapsed); rails pull last-7 series + averages; screen renders from seed. Shell smoke test reworked to boot the DB-backed Home with an in-memory override.
- **Verify:** ✅ analyze clean; full suite green (143).

### Slice 7.11 — Stats overview ✅ (commit 8d2fe82)
- [x] Providers: one period → range driving per-metric streams (mood, expense, income, steps, BP).
- [x] Stats screen: period chips + chart cards (mood, income-vs-expense, steps, BP) each linking to its module.
- [x] Tests (2): period drives range + series stream in-range; screen renders chart cards from seed.
- **Verify:** ✅ analyze clean; full suite green (145). Period switch recomputes all cards; cards push to their modules.

### Slice 7.12 — Memories / visual diary ✅ (commit 0fe336c)
- [x] Providers: `memoryDaysProvider` (daily logs that have a photo, newest first) + trips rail. `AttachmentsDao.watchByType` + `DailyLogsDao.watchAll` added.
- [x] Memories screen: trips rail (→/trips/:id) + photo grid (only photo-days); tapping a day sets the daily date and opens /daily (wires the ?date flow deferred from 7.7).
- [x] Tests (2): only photo-days appear (correct date/logId, sorted); screen renders trips rail from seed.
- **Verify:** ✅ analyze clean; full suite green (147). Photo thumbs device-verified.

### Slice 7.13 — More menu + Search ✅ (commit e58fa3d)
- [x] More screen: grouped module list (Логване/Пари/Здраве/Живот/Данни) + Dev → routes.
- [x] Search screen: query box → unified Cyrillic-safe results across modules (spec §24.2) → tap navigates to the record's module (detail for bucket/trip, the day for a daily log).
- [x] Tests (3): results span ≥3 modules for a Cyrillic query; empty query → none; screen shows results as you type.
- **Verify:** ✅ analyze clean; full suite green (150).

> **Phase 7 complete** — all 13 feature verticals shipped (Finance, AttachmentService, Food, Activities, Steps, Health, Daily, Bucket, Trips, Home, Stats, Memories, More+Search). Every bottom-nav tab + module is a real, DB-backed screen. `flutter analyze` clean; full suite green (150). Photo file IO and the Android APK build are device-verified (not exercised by `flutter test`).

---

## Phase 8 — Data portability

### Slice 8.1 — ExportService + Export screen ✅ (commit 1332d11)
- [x] `ExportService`: JSON (spec §25.8 keys + summary) and Markdown (§25.9 sections + "Questions for AI"); scopes Full/Period/Module; period inclusion rules (records by date; bucket if created-or-completed; trip if from-or-to in range). Read-only DB consumer (injectable clock) → unit-testable on in-memory drift.
- [x] Export screen: scope/format/period/module selectors, live preview, record/photo/size counts, export via `share_plus`/clipboard.
- [x] Tests (12): JSON shape + keys; euro conversion; period inclusion edge cases (bucket created/completed, trip from/to boundary); module isolation; markdown ends with questions block; record/photo counts; screen render + format toggle.
- **Verify:** ✅ analyze clean; full suite green (162). JSON parses with all §25.8 keys; Markdown ends with the Questions block. Share-sheet step is device-only (verified separately).
- *Decision:* money exported in EUR (cents/100), matching the §25.8 example values; enums serialize as stable lowercase codes; `*Lower` shadow columns excluded; attachments are metadata only.
- *Post-review hardening:* trip period-inclusion now uses interval **overlap** (a trip spanning the whole period is included, a strict superset of §25.5's "from-or-to in range"); share-file extension derives from the selected format, not string sniffing.

### Slice 8.2 — BackupService + Backup/Restore screen ✅ (commit f2cf038)
- [x] `BackupService.buildZipBytes()` — `manifest.json` + `data.json` (exact snapshot incl. attachments metadata; money in cents, enums as codes, ISO timestamps, `*Lower` omitted) + all attachment files (full+thumb) → ZIP. `writeBackupFile()` for `share_plus`.
- [x] `BackupService.restore()` — validate fully → stage to new dir → **swap files first, then commit DB** in one transaction (rollback swap on commit failure; DB auto-rolls-back) → cleanup; inserts route through DAOs so `*Lower` is rebuilt; all-or-nothing. `isEmpty()` for the replace-all warning.
- [x] Backup screen: includes list, session last-backup line, create button (share), restore via `file_picker` (zip, `withData`) + validation checklist + replace-all confirm dialog.
- [x] Tests (10): zip contents; round-trip create→wipe→restore equals original incl. files + recomputed `*Lower` + exact timestamps; validation failures (corrupt zip / missing manifest / bad schema / missing attachment) leave data intact; mid-commit CHECK violation reverts file swap AND DB; `isEmpty`; screen render.
- **Verify:** ✅ analyze clean; full suite green (179). Round-trip restores all records + photos + links; invalid ZIP rejected without touching data; mid-commit failure reverts both swap and DB. APK build (file_picker 11 + share_plus 12) device-verified separately (flutter test skips the Android build).
- *Post-review hardening:* the whole stage→swap→commit sequence now runs inside one try with full partial-rollback (a pre-swap failure leaves data untouched — tested), post-success cleanup is best-effort (won't report a committed restore as failed), `validate()` does row-level structural + strict-enum checks up front (no silent default on restore) and lenient/distinct `schemaVersion` handling, backups omit attachment rows whose files are missing (self-consistent), the zip is decoded once per restore, and the round-trip test asserts full data-class equality so a dropped column fails loudly.

> **Phase 8 complete** — AI export (JSON/Markdown, Full/Period/Module) and full ZIP backup & all-or-nothing restore. `file_picker` 11 + `share_plus` 12 now in use (device-verified). `flutter analyze` clean; full suite green (172).

---

## Phase 9 — Polish & hardening

### Slice 9.1 — Empty states & loading ✅ (commit 0249d0a)
- [x] Shared `LmEmpty` (faint icon tile + Bulgarian message + optional CTA) wired into every list module: food, finance (expenses/income), activities, steps, health (4 tabs), bucket, trips (repeat-filter aware), memories (visual diary), search (empty-query + no-results). Daily's report empty + Home's in-card timeline empty already graceful.
- [x] `LmSkeleton`/`LmListSkeleton` replace all 7 raw `CircularProgressIndicator`s (food/finance/activities/steps/health summary areas + trip/bucket detail).
- [x] Tests (9): every list module renders its empty copy on a fresh (unseeded) DB.
- **Verify:** ✅ analyze clean; full suite green (188). Fresh install shows graceful empties everywhere; no raw spinners remain.

### Slice 9.2 — Motion, formatting, polish ✅ (commit 3d4f707)
- [x] Charts ease via `lmChartAnimationDuration` (150ms, already wired); sheets slide up (modal) — confirmed in place.
- [x] `core/format/dates.dart` (`dmy`/`dm`/`dmyDate` via `intl`) renders stored `yyyy-MM-dd` as `dd.MM.yyyy` (`dd.MM` in the memories grid) across all display sites + form date-pickers; storage stays `yyyy-MM-dd`. EUR `€` + space-grouped thousands already via `finance_format` throughout.
- [x] SafeArea/keyboard insets already handled in `showLmSheet` (viewInsets + bottom padding); added button semantics + labels to bottom-nav tabs, the quick-log FAB, and the sheet close.
- [x] Tests (5): dates formatter; bottom-nav button semantics.
- **Verify:** ✅ analyze clean; full suite green (193). Dates display `dd.MM.yyyy`; same string length as before → no new overflow. Prototype visual pass + 412-wide overflow check are device-verified (parallel session).

### Slice 9.3 — Final QA pass ✅ (commit a7b9232)
- [x] Walked every spec §30 acceptance criterion against the shipped code (goal-backward); all 14 satisfied — see the checklist below.
- [x] Full `flutter analyze` clean + `flutter test` green (193 tests). Interactive smoke of all flows is device-verified (parallel emulator session); host tests skip the Android build.
- [x] Plan finalized — all slices checked; deferrals noted below.
- **Verify:** ✅ acceptance checklist (§30) fully satisfied.

> **Phase 9 complete** — empty states + loading skeletons, dd.MM.yyyy date formatting, a11y semantics, and the final §30 QA pass. `flutter analyze` clean; full suite green (193).

#### Deliberate deferrals / out-of-scope (V1)
- **Date-picker localization:** display dates are bg `dd.MM.yyyy`, but the native `showDatePicker` dialog is still English — adding `flutter_localizations` + `locale: bg` is deferred (a dependency change, not yet approved).
- **Last-backup time is session-only** (V1 has no settings store).
- **CSV export + PDF attachments** deferred per approved scope (§25.7 / export scope).
- **No app lock; no iOS build config** (locked decisions §4).
- **Device-only verification:** photo file IO, the share sheet, file-picker, the APK build (file_picker 11 + share_plus 12), and the visual/no-overflow pass on a 412-wide device are verified outside `flutter test` (parallel session) — green host tests do not prove the APK builds.

---

## Acceptance criteria coverage (spec §30) — final gate

- [x] §30.1 Quick logging (food/expense/BP/daily; saved to real modules)
- [x] §30.2 Food (CRUD, macros, daily totals, period summaries/charts)
- [x] §30.3 Activities (CRUD, types incl. Друго, fields, filters, summaries)
- [x] §30.4 Money (expenses/income, daily+monthly totals, categories, no expense photos, charts)
- [x] §30.5 Health events (add, dental visit, next-recommended date)
- [x] §30.6 Lab tests (date/lab/reason, free-text results, multiple photos)
- [x] §30.7 BP/pulse (CRUD, multiple/day, period views, charts, export)
- [x] §30.8 Meds (CRUD, optional dose, by date, export)
- [x] §30.9 Daily Quick Log (one/day, all fields, summaries/charts)
- [x] §30.10 Steps (entry, Daily↔Steps sync, edit only in module, charts)
- [x] §30.11 Bucket List (CRUD, detail, complete flow, experience, edit, summaries)
- [x] §30.12 Trips (CRUD, cover+gallery, ratings, repeat, comment, search, summaries, exports)
- [x] §30.13 AI export (Full/Period/Module, JSON+Markdown, raw+summary, ChatGPT-ready MD)
- [x] §30.14 Backup & Restore (ZIP w/ manifest+data+attachments, restore links, invalid rejected, non-empty warning, all-or-nothing)
