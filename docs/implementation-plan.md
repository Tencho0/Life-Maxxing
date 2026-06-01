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

### Slice 3.1 — Enums + converters
- [ ] `domain/enums.dart` — every enum from spec §3.2 with storage codes + Bulgarian labels + `ActivityGroup` derivation.
- [ ] `data/converters.dart` — enum⇄text `TypeConverter`s.
- [ ] Unit tests: round-trip every enum code; unknown code handling.
- **Verify:** tests pass.

### Slice 3.2 — Tables + database
- [ ] `data/tables/*.dart` — all 15 tables per spec §3.3 (TEXT dates, `amountCents`/`priceCents`, `*Lower` shadow columns, BP `systolic>diastolic` check, `daily_logs`/`steps` `UNIQUE(date)`, trips `toDate>=fromDate` check, attachments + index, `bucket_experiences` FK `ON DELETE CASCADE`).
- [ ] `data/database.dart` — `@DriftDatabase`, `schemaVersion=1`, `MigrationStrategy`, `beforeOpen` → `PRAGMA foreign_keys = ON`.
- [ ] `dart run build_runner build` generates cleanly.
- [ ] Test: open in-memory DB; FK enforcement on; CHECK constraints reject bad rows (sys≤dia, trip date order); `UNIQUE(date)` rejects 2nd daily/steps row.
- **Verify:** generated code compiles; constraint tests pass.

### Slice 3.3 — DAOs: CRUD + `*Lower` companion mapping
- [ ] One DAO per module + `AttachmentDao`.
- [ ] Each DAO has the **single companion-mapping helper** that sets `*Lower` columns on insert/update (spec §3.1).
- [ ] CRUD + `watch…` streams for lists/by-date.
- [ ] Tests: insert/update sets every `*Lower`; CRUD round-trips; streams emit on change.
- **Verify:** tests pass with in-memory DB.

### Slice 3.4 — DAOs: search, filter, aggregates
- [ ] Per-module list queries with filter params (date/period, category, type, status, priority, feeling, worthIt, rating, wouldRepeat — spec §24.3).
- [ ] Cyrillic-safe search queries against `*Lower` columns (Dart-lowercased query).
- [ ] Aggregate queries: per-module period summaries, daily summary (§27), monthly summary (§28), finance/health/bucket/trip stats.
- [ ] Tests: search matches Cyrillic case-insensitively; filters; aggregate math (sums ignore NULLs per §6.6); daily/monthly summaries.
- **Verify:** tests pass.

### Slice 3.5 — Steps↔Daily shared-metric service
- [ ] `StepsService` with `upsertFromDaily(date,count)` (create only if absent) and `editFromStepsModule(...)`; read-by-date.
- [ ] Tests: daily can create when absent; daily cannot edit existing; steps module can edit; `source` recorded correctly; one row per date.
- **Verify:** tests pass.

---

## Phase 4 — Domain logic

### Slice 4.1 — Period + summary DTOs
- [ ] `domain/period.dart` — `Period` enum + `resolveRange(period, {custom})` → `(fromYmd, toYmd)` strings (today/7/30/this-month/prev-month/custom), using local date, zero-padded.
- [ ] `domain/summaries.dart` — typed DTOs (FinanceSummary, HealthSummary, FoodSummary, ActivitySummary, StepsSummary, DailySummary, BucketSummary, TripSummary, MonthlySummary).
- [ ] Tests: range resolution incl. month boundaries and prev-month; custom range.
- **Verify:** tests pass.

---

## Phase 5 — App shell & navigation

### Slice 5.1 — Router + nav shell + sheet infra
- [ ] `app/app.dart` (`ProviderScope` + `MaterialApp.router`), `app/router.dart` (`StatefulShellRoute.indexedStack` tabs + pushed routes from spec §4.2).
- [ ] `LmBottomNav` (5 slots + center FAB) wired to shell branches; FAB opens quick sheet.
- [ ] `app/sheets.dart` — `showLmSheet` wrapper + sheet registry keys (spec §4.3); placeholder sheet bodies for now.
- [ ] Placeholder screens for every route (title only) so navigation is exercisable.
- **Verify:** all tabs switch; every pushed route reachable; FAB opens the quick chooser; back works; toast displays.

---

## Phase 6 — Dev seed (review aid)

### Slice 6.1 — Seed helper (debug-only)
- [ ] `dev/seed.dart` — inserts realistic Bulgarian sample data across all tables (mirrors the prototype's `data.jsx`), invoked from a debug menu action; **not** shipped in release.
- **Verify:** running seed populates the DB; subsequent feature screens can be reviewed populated.

---

## Phase 7 — Feature slices

> Each feature slice delivers a **runnable vertical**: DAO wiring → Riverpod providers → screen (with `PeriodChips`, key numbers, charts, record list) → create/edit sheet (validation per §8) → delete → search/filter hooks → tests. Photo-bearing features also wire `AttachmentService`.

### Slice 7.1 — Finance (canonical first vertical; no attachments)
- [ ] Providers for expenses/income lists + finance summary (balance, totals, top category, counts, avg/day) by period.
- [ ] Finance screen: balance hero, income-vs-expense chart, category `SegRing`, records tabs (Разходи/Приходи), `FinRadial` `+`.
- [ ] Expense sheet (amount cents, currency-free EUR, category chips, description, payment method, note) + Income sheet (amount, source, category, note); create+edit; validation.
- [ ] Delete with confirm.
- [ ] Tests: summary math (balance, top category), validation (amount>0, required fields), filter by category.
- **Verify:** add/edit/delete an expense and income; numbers + charts update live for each period.

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
