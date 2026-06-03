# CLAUDE.md — LifeMaxxing project guide

Guidance for anyone (humans and AI agents) working in this repo. Read this first, then the specs.

## 1. Purpose

LifeMaxxing V1 is a **personal, single-user, offline-first** mobile app for logging the important parts of life — food, activities, money (expenses/income), health (blood pressure & pulse, meds/supplements, health events, lab tests), a daily quick log, steps, a visual diary, a bucket list, and trips. It shows per-module summaries and charts, exports data for AI analysis (JSON/Markdown), and supports full ZIP backup & restore. The goal is good, structured personal data the user can review over time. **UI language is Bulgarian.**

## 2. Sources of truth

- **Behavior & features** → [`docs/functional_spec.md`](docs/functional_spec.md). If behavior is unclear, this wins.
- **Layout, components, visual style** → the design bundle in [`design/life-maxxing/`](design/life-maxxing/) (entry: `design/life-maxxing/project/index.html`; read `design/life-maxxing/README.md` and the chat transcript first). The design is **finalized** — match it. It's a React/HTML prototype: **re-implement in Flutter, do not port the code**.
  - Original design URL: `https://api.anthropic.com/v1/design/h/cWrAm9wkEll9SSCXVyhJfA?open_file=index.html`
- **Engineering contract** → [`docs/technical-spec.md`](docs/technical-spec.md) (architecture, schema, services, decisions).
- **Build order & progress** → [`docs/implementation-plan.md`](docs/implementation-plan.md). **Keep it updated** — check off items as slices land; note deviations inline.
- **Promo videos (TikTok/Reels)** → [`promo/VIDEOS.md`](promo/VIDEOS.md) — video history, the build recipe, and the idea backlog. For "make the next promo video": read it, suggest topics, build following the recipe, then log the new video there.

When the design and the functional spec disagree on **data/behavior**, the spec wins; the design wins on **visuals**. (The known divergences are already resolved in the technical spec.)

## 3. Stack

| Concern | Choice |
|---|---|
| Framework / language | Flutter 3.41.5 (stable) · Dart 3.11.3 |
| Local DB | drift (SQLite), reactive queries |
| State | Riverpod (`flutter_riverpod`) |
| Routing | go_router (`StatefulShellRoute` tabs + pushed details; forms are modal bottom sheets) |
| Charts | fl_chart (standard charts) + one hand-painted `MoodGauge` |
| Images | image_picker + flutter_image_compress |
| Files/backup | path_provider · archive (ZIP) · share_plus · file_picker |
| Misc | intl (bg_BG) · uuid · path |

App id: `com.lifemaxxing.app`. Platforms: **Android only** for now (add iOS later with `flutter create --platforms ios .`). No networking/analytics/auth packages — out of scope.

## 4. Locked decisions (do not silently change)

- **Single currency: EUR.** No per-record currency. Money stored as **integer euro cents** (`amountCents`/`priceCents`); format to `€` on display. All totals/charts aggregate in EUR.
- **Date-only fields are `TEXT` `yyyy-MM-dd`** (every `date`, trip `fromDate`/`toDate`, `nextRecommendedDate`, `completedDate`, …). Only `createdAt`/`updatedAt` are `DateTime`. Range queries are lexicographic.
- **Cyrillic-safe search:** never rely on SQLite `LIKE`/`NOCASE` (ASCII-only). Each searchable field has a lowercased shadow column (`*Lower`) set via Dart `toLowerCase()` in **one companion-mapping helper per DAO**; search matches a Dart-lowercased query against those.
- **Attachments:** binaries on the filesystem (app docs dir), metadata in DB (relative `filePath` + `thumbPath` + size/dims). Image pipeline: resize ≤ ~1600px long edge, JPEG ~Q80, plus a ~320px thumbnail. All attachment add/replace/delete and cardinality rules go through `AttachmentService`. Deleting a record deletes its files (full + thumb); deleting a bucket item also deletes its experience's files.
- **FKs:** `PRAGMA foreign_keys = ON` in `beforeOpen`; `bucket_experiences.bucketItemId` is `REFERENCES bucket_items(id) ON DELETE CASCADE` (cascade deletes the row, not files).
- **One per day:** exactly one `daily_logs` and one `steps` row per date (`UNIQUE(date)`); adding for an existing date **opens/edits** the existing one — never a duplicate. Steps are editable only in the Steps module; the Daily Log shows them read-only when present.
- **Restore is all-or-nothing & filesystem-safe:** stage → validate fully → write attachments to a new dir → **swap files first, then commit the DB** (roll the swap back on commit failure). Never delete live data before the replacement is in place. No merge.
- **Export scope:** JSON + Markdown, image attachments only. CSV export and PDF attachments are deferred.
- **No app lock** in V1 (device lock only). **No iOS** build config yet.
- **Dependency pins `file_picker: ^11.0.0` + `share_plus: ^12.0.2` are deliberate — do NOT revert to `file_picker ^3.0.4` / `share_plus ^13.1.0`.** `file_picker` 3.x fails the Android build (`assembleDebug`) under AGP 8 with "Namespace not specified"; only namespace-compliant releases build. `share_plus` is held at 12.x because 13.x needs `win32 ^6`, which conflicts with `file_picker`'s `win32 ^5`. `flutter test` passes either way (tests skip the Gradle/Android build), so this only surfaces when building a real APK — green tests do **not** prove the app builds for a device.

## 5. Code layout & conventions

The Flutter app lives in **`src/`** (run `flutter`/`dart` from there); `promo/`, `docs/`, and `design/` sit beside `src/` at the repo root. Folder structure is defined in `docs/technical-spec.md §1.3`. In short:

- `src/lib/core/` — design system: `theme/` (tokens, typography, theme, mood_color), `widgets/` (shared UI), `icons/`, `charts/`.
- `src/lib/domain/` — plain Dart (enums, `Period`, summary DTOs). **No Flutter imports.**
- `src/lib/data/` — drift `database.dart`, `tables/`, `daos/`, `converters.dart`.
- `src/lib/services/` — `attachment_service.dart`, `backup_service.dart`, `export_service.dart`.
- `src/lib/presentation/<feature>/` — feature-first: screen + providers + form sheet per module.
- `src/lib/app/` — `app.dart`, `router.dart`, `sheets.dart`.

Conventions:
- **Bulgarian** for all user-facing strings; **English** for identifiers, comments, file names.
- Shared design-system widgets are prefixed `Lm` (`LmCard`, `LmButton`, `LmRow`, …) per the technical spec's component map.
- Enums stored as **stable lowercase text codes**; Bulgarian display labels live in `src/lib/domain/enums.dart`, decoupled from storage.
- drift generates `*.g.dart` via build_runner — run codegen after touching tables/DAOs; generated files are committed.
- Keep widgets `const` where possible; respect `flutter_lints` (`src/analysis_options.yaml`).
- Match the surrounding code's style, comment density, and naming.

## 6. Workflow rules

- **Work one slice at a time** from `docs/implementation-plan.md`, in order; check in for review at slice boundaries rather than running ahead.
- **TDD-leaning:** follow the testing strategy in technical-spec §12 — DAO/service logic gets unit tests (in-memory drift), forms/flows get widget tests. Write/extend tests with the slice, not after.
- **Verify before claiming done:** a slice is complete only when `flutter analyze` is clean, its tests pass, and its "Verify" line is demonstrably true. Don't assert success without running the checks.
- **Update the plan** (`docs/implementation-plan.md`) as part of finishing a slice.
- Don't introduce new dependencies or change a locked decision (§4) without raising it first.

### Test conventions

- **Run tests single-threaded — never two `flutter test` runs at once.** `flutter test` builds native code assets (`sqlite3.dll`); overlapping runs race and crash with `PathExistsException`, leaving a locked `flutter_tester` process holding the dll. Run one at a time (background a single run and wait on it). If a run is interrupted: kill stray `dart`/`flutter_tester` processes, then delete `build/native_assets`, before retrying.
- **Deterministic env:** widget tests call `useDeterministicTestEnv()` (`src/test/support/test_env.dart`) in `setUp`. It zeroes the toast auto-dismiss timer (`lmToastDuration`) and fl_chart animation duration (`lmChartAnimationDuration`) so `pumpAndSettle` terminates and a save that fires a toast leaves no pending `Timer` at teardown.
- **Async-data screens:** use `await settleData(tester)` (real-async flush via `runAsync`, then `pumpAndSettle`) — a bare `pumpAndSettle` never settles against a loading spinner, and awaiting a provider `.future` inside `testWidgets` hangs (FakeAsync won't advance the drift stream's timers). This is the standard for every feature screen.
- Forms taller than the default 600px test surface: set `tester.view.physicalSize` tall so off-screen buttons are tappable. Remember `Eyebrow`/`SectionTitle` render their text **uppercased** — assert the uppercased string.

## 7. Common commands

Run all of these from `src/` (the Flutter project root):

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # drift codegen
dart run build_runner watch  --delete-conflicting-outputs   # codegen on save
flutter analyze
flutter test
flutter run                                                 # Android device/emulator
```
