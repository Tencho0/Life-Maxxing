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

### Slice 0.2 — CI-lite check script (optional but recommended)
- [ ] A `make`/script target: `flutter analyze && flutter test && dart run build_runner build`.
- **Verify:** script runs green on the empty project.

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

### Slice 7.2 — AttachmentService (+ image pipeline)
- [ ] `AttachmentService`: pick (image_picker) → compress ≤1600px/Q80 → ~320px thumb → write full+thumb under `attachments/<folder>/` → insert row (paths, size, dims, sortOrder, role).
- [ ] Cardinality rules (meal/activity/daily=single, trip cover=single+gallery=many, events/labs/bucket=many).
- [ ] Delete routes files+rows; bucket-item delete also removes its experience's files (spec §5.1).
- [ ] Tests: compression bounds; thumb generated; cardinality (replace deletes old file); delete removes files; bucket cascade file cleanup leaves no orphans.
- **Verify:** tests pass on device/emulator (real file IO).

### Slice 7.3 — Food
- [ ] Providers: meals by date/period + food summary (cals/macros/day, by type) + daily totals (§6.6).
- [ ] Food screen: calories `Ring` + macro bars, calories-by-day chart, meals list.
- [ ] Food sheet (type, name*, time, cals/macros, note, 0–1 photo) create+edit+delete; photo add/remove via `AttachmentService`.
- [ ] Tests: daily totals ignore NULLs; required date+name; search by name/note.
- **Verify:** log a meal with a photo; daily totals + charts update; photo shows as thumb then full.

### Slice 7.4 — Activities
- [ ] Providers: activities by date/period + activity summary (counts by group, total time, most-frequent, avg duration).
- [ ] Activities screen: counts cards, category `SegRing`, list with intensity/mood.
- [ ] Activity sheet (type*, name?, start/end/duration, intensity, quality/mood, note, 0–1 photo) CRUD; validation (duration>0 if present).
- [ ] Tests: group derivation counts; filter by type; optional-name accepted.
- **Verify:** log activities of different types; grouping + charts correct.

### Slice 7.5 — Steps
- [ ] Steps screen: today `Ring`, stats (avg/max/total/days), steps-by-day chart, recent days list with provenance.
- [ ] Steps sheet (date, count*, note) CRUD via `StepsService`.
- [ ] Tests: one-per-date; edit only here; provenance label.
- **Verify:** add/edit steps; chart + stats update; provenance shows correctly.

### Slice 7.6 — Health (tabbed: Кръвно / Добавки / Събития / Изследвания)
- [ ] Providers: BP logs + meds + events + labs; health summary (last BP/pulse, averages, counts, last dental/lab).
- [ ] Health screen: vitals cards, BP-over-time chart, tabbed history; per-tab `+`.
- [ ] BP sheet (date/time/sys/dia/pulse* + note; live sys>dia validation), Med sheet (name/type/time/dose/status; Да=Прието), Health-event sheet (type/subtype/clinic/reason/whatWasDone*/price/next date/note + photos), Lab sheet (date/lab*/reason*/resultsText/photos). CRUD each.
- [ ] Wire event/lab photos (0–many) via `AttachmentService`.
- [ ] Tests: BP constraint; multiple BP per day; dental subtype only for dentist; summary averages; "next dental" surfacing.
- **Verify:** add BP twice in one day; add a lab with 2 photos; charts/averages update.

### Slice 7.7 — Daily Quick Log
- [ ] Provider: log by date; create-or-open existing (uniqueness).
- [ ] Daily screen: mood hero (`Ring`), photo, yes/no grid, screen-time/steps (steps read-only/"заключено" if present), notes, mood-30-day bars.
- [ ] Daily sheet (mood*, proud*, uncomfortable*+conditional, workout*, alcohol*+conditional, screen time, steps via `StepsService`, note, 0–1 photo). Opening for an existing date edits it.
- [ ] Tests: second-add-for-date opens existing (no dup); conditional fields; steps create-if-absent + lock; daily summary (§17.6).
- **Verify:** fill today's log incl. photo + steps; re-open edits same row; steps appear locked and in Steps module.

### Slice 7.8 — Bucket List (+ detail + experience)
- [ ] Providers: items (filter by status/priority) + bucket stats; item detail; experience.
- [ ] Bucket screen: stat cards, status filter chips, cards list.
- [ ] Detail screen: status/priority pills, why, complete button (if not completed) → experience sheet; completed shows logged experience + photos; experience editable.
- [ ] Item sheet (title*/why/priority*/status*) CRUD; Experience sheet (feeling*/date*/worthIt*/photos/reflection) → sets status Completed.
- [ ] Wire item + experience photos (0–many); delete item cleans both (spec §5.1).
- [ ] Tests: complete flow sets status+creates experience; completed hides complete button; edit experience; delete cascades rows+files; bucket stats.
- **Verify:** create → complete (with photos + reflection) → detail shows experience → edit → delete leaves no orphan files.

### Slice 7.9 — Trips (+ detail)
- [ ] Providers: trips (filter by period/rating/repeat) + trip stats; trip detail.
- [ ] Trips screen: stat cards, trip cards with cover + overall badge.
- [ ] Detail screen: cover header, rating bars, comment, gallery grid.
- [ ] Trip sheet (title*/destination*/from*/to*/overall* + sub-ratings/wouldRepeat/comment, cover photo + gallery) CRUD; date-order validation; cover replace; gallery add/remove.
- [ ] Tests: toDate≥fromDate; one cover + many gallery; stats (avg overall, repeat count); search title/destination.
- **Verify:** create a trip with cover + gallery; ratings render; edit/delete works.

### Slice 7.10 — Home
- [ ] Providers: today snapshot + week rails (mood/steps/expense/pulse) + today timeline across modules.
- [ ] Home screen: greeting header, 4 quick-action tiles (open sheets), week rail cards, daily-flow timeline, "finish daily report" CTA.
- [ ] Tests: timeline aggregates today's rows; rails pull last-7 series.
- **Verify:** with seed data, Home matches the prototype layout and reflects real data; quick tiles open the right sheets.

### Slice 7.11 — Stats overview
- [ ] Provider: cross-module series by period.
- [ ] Stats screen: period chips + chart cards (mood, income-vs-expense, steps, BP) each linking to its module.
- **Verify:** period switch recomputes all cards; links navigate.

### Slice 7.12 — Memories / visual diary
- [ ] Providers: dates-with-daily-photo + trips rail.
- [ ] Memories screen: trips rail + photo grid (only days with a photo, spec §19.4); tapping a day opens that daily log.
- **Verify:** only photo-days appear; tap opens correct daily log; trips rail navigates.

### Slice 7.13 — More menu + Search
- [ ] More screen: grouped module list (Логване/Пари/Здраве/Живот/Данни) → routes.
- [ ] Search screen: query box → unified Cyrillic-safe results across modules (spec §24.2) → tap navigates to the record's module.
- [ ] Tests: search returns hits across ≥3 modules for a Cyrillic query.
- **Verify:** searching a Cyrillic term surfaces results from multiple modules and navigates correctly.

---

## Phase 8 — Data portability

### Slice 8.1 — ExportService + Export screen
- [ ] `ExportService`: JSON (spec §25.8 keys + summary) and Markdown (§25.9 sections + "Questions for AI"); scopes Full/Period/Module; period inclusion rules (records by date; bucket if created-or-completed; trip if from-or-to in range).
- [ ] Export screen: scope/format/period/module selectors, live preview, record/photo/size counts, export via `share_plus`/clipboard.
- [ ] Tests: JSON shape + keys; period inclusion edge cases; markdown ends with questions block.
- **Verify:** export Full JSON and a Period Markdown; output opens in share sheet and is valid.

### Slice 8.2 — BackupService + Backup/Restore screen
- [ ] `BackupService.createZip()` — `manifest.json` + `data.json` (incl. attachments metadata) + all attachment files (full+thumb) → ZIP → `share_plus`.
- [ ] `BackupService.restore()` — pick → stage to temp → **validate fully** → write to new dir → **swap files first, then commit DB** (rollback swap on commit failure) → cleanup; replace-all confirm when non-empty; all-or-nothing.
- [ ] Backup screen: includes list, last-backup line, create button + result tree/manifest, restore dropzone + validation checklist + replace warning.
- [ ] Tests: round-trip (create→wipe→restore equals original, incl. files); validation failures (corrupt zip / missing manifest / bad schema / missing attachment) leave data intact; mid-commit failure reverts swap.
- **Verify:** create a backup, wipe app data, restore from ZIP → all records + photos + links return; invalid ZIP is rejected without touching data.

---

## Phase 9 — Polish & hardening

### Slice 9.1 — Empty states & loading
- [ ] Per-module empty states (no records / no photos / no search results) in the design's voice.
- [ ] Stream loading/error states (no raw spinners where a skeleton fits).
- **Verify:** fresh install (no seed) shows graceful empties everywhere.

### Slice 9.2 — Motion, formatting, polish
- [ ] Sheet slide-up + fade transitions; ring/chart easing.
- [ ] `intl` bg_BG dates (dd.MM.yyyy), EUR `€` formatting, thousands separators throughout.
- [ ] SafeArea/keyboard insets on sheets; tap targets; basic semantics labels.
- **Verify:** visual pass against prototype screenshots; no overflow/clipping on a 412-wide device.

### Slice 9.3 — Final QA pass
- [ ] Walk every spec §30 acceptance criterion; tick each.
- [ ] Full `flutter analyze` + `flutter test` green; manual smoke of all flows.
- [ ] Update this file: all slices checked; note any deliberate deferrals.
- **Verify:** acceptance checklist (§30) fully satisfied.

---

## Acceptance criteria coverage (spec §30) — final gate

- [ ] §30.1 Quick logging (food/expense/BP/daily; saved to real modules)
- [ ] §30.2 Food (CRUD, macros, daily totals, period summaries/charts)
- [ ] §30.3 Activities (CRUD, types incl. Друго, fields, filters, summaries)
- [ ] §30.4 Money (expenses/income, daily+monthly totals, categories, no expense photos, charts)
- [ ] §30.5 Health events (add, dental visit, next-recommended date)
- [ ] §30.6 Lab tests (date/lab/reason, free-text results, multiple photos)
- [ ] §30.7 BP/pulse (CRUD, multiple/day, period views, charts, export)
- [ ] §30.8 Meds (CRUD, optional dose, by date, export)
- [ ] §30.9 Daily Quick Log (one/day, all fields, summaries/charts)
- [ ] §30.10 Steps (entry, Daily↔Steps sync, edit only in module, charts)
- [ ] §30.11 Bucket List (CRUD, detail, complete flow, experience, edit, summaries)
- [ ] §30.12 Trips (CRUD, cover+gallery, ratings, repeat, comment, search, summaries, exports)
- [ ] §30.13 AI export (Full/Period/Module, JSON+Markdown, raw+summary, ChatGPT-ready MD)
- [ ] §30.14 Backup & Restore (ZIP w/ manifest+data+attachments, restore links, invalid rejected, non-empty warning, all-or-nothing)
