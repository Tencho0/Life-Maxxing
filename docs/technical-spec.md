# LifeMaxxing V1 — Technical Specification

> Engineering translation of the functional spec and the finalized design.
> **Sources of truth:** behavior/features → [`functional_spec.md`](functional_spec.md) (the functional spec); layout/components/visual style → the Claude Design bundle (`life-maxxing/project/`, entry `index.html`).
> This document is the contract the build plan and all later code follow from.

---

## 1. Architecture overview

### 1.1 Shape of the app

LifeMaxxing V1 is a **single-user, offline-first, local-only mobile app** built in **Flutter (Dart 3)**, Android-first (iOS kept open at no extra cost). There is **no backend, no network, no auth** (per the spec's out-of-scope list and the approved decisions). All data lives on-device:

- **Structured data** → SQLite via **drift** (typed, reactive queries).
- **Binary attachments** (photos) → the app documents directory on the native filesystem; the DB stores only metadata + relative paths.
- **Portability** → a single **ZIP backup** (`manifest.json` + `data.json` + `attachments/`) created/shared via the OS share sheet and re-imported via a file picker. This is the only way data leaves or re-enters the device.

### 1.2 Layered structure

```
UI (widgets/screens)  ──reads──▶  Riverpod providers  ──query/stream──▶  DAOs (drift)  ──▶  SQLite
        │                              │                                     ▲
        └──actions──▶ Services ────────┘                                     │
                       (Attachment / Backup / Export)  ──files──▶  App documents dir (filesystem)
```

- **`data/`** — drift `AppDatabase`, table definitions, DAOs. The single owner of persistence.
- **`domain/`** — plain Dart: enums, value types, the `Period` model, summary/aggregate types. No Flutter imports.
- **`services/`** — side-effectful orchestration that spans DB + filesystem: `AttachmentService`, `BackupService`, `ExportService`. Pure-ish, unit-testable.
- **`presentation/`** — Riverpod providers + screens + feature widgets.
- **`core/`** — design system: `tokens.dart`, `theme.dart`, shared widgets (`core/widgets/`), the icon set, and the `CustomPainter` charts.
- **`app/`** — `go_router` config, root `App` widget, DI/provider scope.

### 1.3 Proposed folder layout

> The Flutter app lives in **`src/`** (the project root — run all `flutter`/`dart`
> commands from there). `promo/`, `docs/`, and `design/` are siblings of `src/`
> at the repo root. The tree below is relative to `src/`.

```
lib/
  main.dart
  app/
    app.dart                 # root MaterialApp.router + ProviderScope
    router.dart              # go_router config (tabs + detail routes)
    sheets.dart              # registry: openQuickSheet(context, type)
  core/
    theme/tokens.dart        # colors, radii, spacing, durations (mirrors ui.jsx T)
    theme/typography.dart    # IBM Plex Sans/Mono text styles
    theme/theme.dart         # ThemeData (dark)
    widgets/                 # LmCard, Pill, Eyebrow, Stat, LmRow, SectionTitle,
                             # LmButton, Field, LmInput, LmTextArea, Segmented,
                             # YesNo, Scale10, MoodPicker, Stepper, PhotoAdd,
                             # PhotoTile, Toast, AppTopBar, LmBottomNav, PeriodChips
    icons/lm_icons.dart      # the design's stroke icon set as IconData/CustomPaint
    charts/                  # fl_chart wrappers (Sparkline, MiniBars, Ring, SegRing, BarChart) + MoodGauge painter
  domain/
    enums.dart               # MealType, ActivityType, ExpenseCategory, ... + bg labels
    period.dart              # Period model + date-range resolution
    summaries.dart           # summary DTOs (FinanceSummary, HealthSummary, ...)
  data/
    database.dart            # AppDatabase (@DriftDatabase)
    tables/*.dart            # table classes
    daos/*.dart              # one DAO per module + AttachmentDao
    converters.dart          # enum<->text type converters
  services/
    attachment_service.dart  # import/compress/thumbnail/delete
    backup_service.dart      # build ZIP / validate / restore (transactional)
    export_service.dart      # JSON + Markdown export
  presentation/
    home/  stats/  finance/  food/  activities/  steps/  health/
    daily/  bucket/  trips/  memories/  search/  export/  backup/  more/
    <feature>/<feature>_screen.dart + providers + form sheet
assets/
  fonts/IBMPlexSans-*.ttf, IBMPlexMono-*.ttf
test/
  data/  services/  widget/
```

### 1.4 Reference design bundle

The design bundle (React/HTML prototype) is **visual reference only** — re-implemented in Flutter widgets, not ported. During scaffolding (Step 6) we will preserve it under `design/` in the repo and record the design URL in `CLAUDE.md` so it never gets lost. Mapping of every prototype component to its Flutter counterpart is in §6.

---

## 2. Design system (from `lib/ui.jsx` + `app/kit.jsx`)

### 2.1 Color tokens (`core/theme/tokens.dart`)

| Token | Hex / value | Use |
|---|---|---|
| `bg` | `#0C0D11` | app background |
| `bg2` | `#111319` | sheet background |
| `card` | `#15171E` | cards, inputs, rows |
| `cardHi` | `#1B1E27` | elevated card / toast |
| `border` | `rgba(255,255,255,0.07)` | hairline borders |
| `borderHi` | `rgba(255,255,255,0.13)` | dashed/emphasis borders |
| `text` | `#F3F5F9` | primary text |
| `textDim` | `#99A0AE` | secondary text |
| `textFaint` | `#5C636F` | tertiary / eyebrow |
| `accent` | `#6AA8FF` (+ `accentSoft` 14% α) | primary blue |
| `green` | `#5FD08A` | income / good / workout |
| `red` | `#FF7A6B` | expense / danger / alcohol |
| `amber` | `#F5C36B` | food / priority / ratings |
| `purple` | `#C9A8FF` | steps |
| `pink` | `#FF9EC4` | pulse / BP |

Each colored token has a `…Soft` variant at ~14% alpha for chip/pill/gradient fills. Mood gauge uses an OKLCH ramp red→amber→green: `oklch(0.74 0.15 H)` where `H = 25 + (v-1)/9*125`. Flutter's `Color` is sRGB, so these are converted by an **OKLCH→sRGB** function in `core/theme/mood_color.dart` (or an equivalent precomputed 10-step ramp) rather than passed through verbatim.

### 2.2 Typography

- **IBM Plex Sans** (400/500/600/700) — UI text, titles, body. Cyrillic + Latin.
- **IBM Plex Mono** (400/500/600) — numbers, eyebrows, metrics, code/JSON previews.
- **Bundled as assets** (offline reliability). Key styles: title 18/700/-0.3; screen greeting 23/700; stat number mono 22/600; eyebrow mono 11/500 uppercase letter-spacing 1.5; body 13–15; pill mono 11.

### 2.3 Shape, spacing, motion

- Radii: cards 18, rows/inputs 13–15, pills 100 (full), icon tiles 12–13, FAB 18.
- Screen body padding `14×16×22`; card padding 16; gap rhythm 8/10/12/14.
- Borders: 1px hairline (`border`); dashed `1.5px borderHi` for photo/file dropzones.
- Motion: `fadeIn` 0.2s; sheet slide-up (`translateY 28→0`, opacity 0→1); ring stroke transition 0.6s ease.
- Device frame is a **prototype-only** detail (the 430×912 Android shell). The real app runs full-screen with `SafeArea`; we keep the internal proportions, not the bezel.

---

## 3. Data model / schema (drift)

### 3.1 Conventions

- Every table PK: `id TEXT` (UUID v4, `uuid` package). Enables stable attachment links and clean backup/restore.
- Audit columns on the records that the spec marks with them: `createdAt`, `updatedAt` (`DateTime`, stored UTC ISO-8601). These are the **only** `DateTime` columns.
- **Date-only fields** — every module's `date`, plus trips `fromDate`/`toDate`, `nextRecommendedDate`, bucket `completedDate`, etc. — stored as **`TEXT` in `yyyy-MM-dd`**, never `DateTime`. This keeps the `UNIQUE(date)` constraints reliable and eliminates timezone off-by-one bugs. **Times** stored as `TEXT 'HH:mm'`. Range queries use lexicographic string comparison (valid for zero-padded ISO dates).
- Enums stored as stable lowercase **text codes** via drift `TypeConverter`; Bulgarian display labels live in `domain/enums.dart` (decoupled from storage so labels can change without migration).
- **Money: single currency — EUR.** Amounts stored as **integer minor units (euro cents)** to avoid floating-point drift; formatted to `€` on display. There is no per-record currency field and no multi-currency handling in V1; all totals, summaries, and charts are in EUR.
- **Searchable text** columns each get a lowercased shadow column (e.g. `name` + `nameLower`), produced by Dart `toLowerCase()` (Cyrillic-safe) on every write. Search compares a Dart-lowercased query against these shadow columns (§9). SQLite `LIKE`/`NOCASE` is ASCII-only and is **not** used for matching Bulgarian text. **The shadow columns are set in exactly one place per table** — a single insert/update companion-mapping helper in each DAO — so no future write path can forget a `*Lower` and silently break search for those rows.
- `PRAGMA foreign_keys = ON` is set in drift's `beforeOpen` callback so the `bucket_experiences → bucket_items` FK and its cascade are actually enforced.
- **Decision (divergence resolved → spec):** income categories, optional activity name, free-text BP note, full med-type labels follow the functional spec, not the prototype's sample values.

### 3.2 Enumerations (`domain/enums.dart`)

| Enum | Codes (storage) | bg label source |
|---|---|---|
| `MealType` | breakfast, lunch, dinner, snack, other | Закуска/Обяд/Вечеря/Snack/Друго |
| `ActivityType` | gym, bjj, boxing, kickboxing, mma, tennis, hiking, folk_dance, cycling, swimming, ski, other | spec §7.3 |
| `ActivityGroup` (derived) | strength, combat, cardio, dance, other | spec §7.6 (computed from type) |
| `Intensity` | low, medium, high | Ниска/Средна/Висока |
| `ExpenseCategory` | food, entertainment, social, transport, education, subscriptions, car, clothing, health_supplements, sport, appearance, vape, other | spec §8.3 |
| `IncomeCategory` | salary, freelance, bonus, sale, gift, business, other | **spec §9.3** |
| `PaymentMethod` | card, cash, other | Карта/В брой/Друго |
| `HealthEventType` | dentist, doctor, procedure, checkup, physiotherapy, other | spec §12.3 |
| `DentalSubtype` | prophylaxis, cleaning, filling, root_canal, whitening, bonding, orthodontics, extraction, other | spec §12.4 |
| `MedType` | medication, supplement, vitamin, mineral, sports_supplement, other | spec §15.3 |
| `MedStatus` | taken, missed | Прието/Пропуснато |
| `StepsSource` | daily_quick_log, steps_module | spec §18.2 |
| `BucketPriority` | low, medium, high | Low/Medium/High |
| `BucketStatus` | idea, planned, completed, abandoned | Idea/Planned/Completed/Abandoned |
| `Period` | today, last7, last30, this_month, prev_month, custom | spec §22.3 |
| `AttachmentEntity` | meal, activity, health_event, lab_test, daily_log, bucket_item, bucket_experience, trip | links |
| `AttachmentRole` | photo, main, cover, gallery | cardinality discriminator |

### 3.3 Tables

Below, `*` = required (NOT NULL), `?` = nullable/optional. All have `id`, and audit columns where noted.

**meals** — `id`, `date* TEXT`, `time?`, `name*` (+ `nameLower`), `type* (MealType)`, `quantity?`, `calories? INT`, `protein? REAL`, `carbs? REAL`, `fat? REAL`, `note?` (+ `noteLower`), `createdAt`, `updatedAt`. Attachments: 0–1 (`role=photo`). *(Nutrition values stay `REAL` — they are measurements, not money.)*

**activities** — `id`, `date* TEXT`, `startTime?`, `endTime?`, `durationMin? INT`, `type* (ActivityType)`, `name?` (+ `nameLower`) *(optional per spec; prototype showed required)*, `intensity? (Intensity)`, `quality? INT 1–10`, `moodAfter? INT 1–10`, `note?` (+ `noteLower`), audit. Attachments: 0–1.

**expenses** — `id`, `date* TEXT`, `time?`, `amountCents* INT`, `category* (ExpenseCategory)`, `description*` (+ `descriptionLower`), `paymentMethod? (PaymentMethod)`, `note?` (+ `noteLower`), audit. **No attachments** (spec §8.6).

**income** — `id`, `date* TEXT`, `amountCents* INT`, `source*` (+ `sourceLower`), `category* (IncomeCategory)`, `note?` (+ `noteLower`), audit. No attachments.

**health_events** — `id`, `date* TEXT`, `type* (HealthEventType)`, `subtype? (DentalSubtype)`, `clinic?` (+ `clinicLower`), `reason?` (+ `reasonLower`), `whatWasDone*` (+ `whatWasDoneLower`), `priceCents? INT`, `nextRecommendedDate? TEXT`, `note?` (+ `noteLower`), audit. Attachments: 0–many.

**lab_tests** — `id`, `date* TEXT` (default today), `lab*` (+ `labLower`), `reason*` (+ `reasonLower`), `resultsText?` (+ `resultsTextLower`), `note?` (+ `noteLower`), audit. Attachments: 0–many.

**blood_pressure_logs** — `id`, `date* TEXT`, `time*`, `systolic* INT`, `diastolic* INT`, `pulse* INT`, `note?` (+ `noteLower`), audit. No attachments. **Constraint:** `systolic > diastolic`; all three > 0; multiple rows per date allowed.

**medication_logs** — `id`, `date* TEXT`, `time*`, `name*` (+ `nameLower`), `type* (MedType)`, `dose?`, `status* (MedStatus)`, `reason?` (+ `reasonLower`), `note?` (+ `noteLower`), audit. No attachments.

**daily_logs** — `id`, `date* TEXT UNIQUE`, `mood* INT 1–10`, `proud* BOOL`, `didUncomfortable* BOOL`, `uncomfortableWhat?`, `workout* BOOL`, `drankAlcohol* BOOL`, `alcoholWhat?`, `screenTimeMin? INT`, `note?` (+ `noteLower`), audit. Attachments: 0–1 (`role=main`, the daily photo). **Steps are NOT stored here** — read/written through `steps` (§3.4).

**steps** — `id`, `date* TEXT UNIQUE`, `count* INT ≥0`, `note?`, `source* (StepsSource)`, `createdAt`, `updatedAt`. No attachments.

**bucket_items** — `id`, `title*` (+ `titleLower`), `description?` (+ `descriptionLower`), `whyWantIt?` (+ `whyWantItLower`), `priority* (BucketPriority)`, `status* (BucketStatus, default idea)`, audit. Attachments: 0–many (item photos).

**bucket_experiences** — `id`, `bucketItemId* UNIQUE REFERENCES bucket_items(id) ON DELETE CASCADE`, `completedDate* TEXT`, `feelingRating* INT 1–10`, `worthIt* BOOL`, `reflection?` (+ `reflectionLower`), audit. Attachments: 0–many (experience photos). Created when an item is marked Completed. The FK is declared **`ON DELETE CASCADE`** (and enforced because `PRAGMA foreign_keys = ON`) — note `PRAGMA foreign_keys = ON` only *enforces* FKs, it does not add cascade behavior by itself. The cascade removes the experience **row**, but **never its attachment files** — those must be deleted via `AttachmentService` (see §5.1).

**trips** — `id`, `title*` (+ `titleLower`), `destination*` (+ `destinationLower`), `fromDate* TEXT`, `toDate* TEXT`, `overall* INT 1–10`, `fun? INT 1–10`, `food? INT`, `sights? INT`, `value? INT`, `wouldRepeat? BOOL`, `comment?` (+ `commentLower`), audit. Attachments: 0–1 `cover` + 0–many `gallery`. **Constraint:** `toDate >= fromDate` (lexicographic on `yyyy-MM-dd`).

**attachments** (polymorphic) —
| col | type | notes |
|---|---|---|
| `id` | TEXT PK | uuid |
| `entityType` | TEXT (AttachmentEntity) | which table |
| `entityId` | TEXT | FK-by-convention to that table |
| `role` | TEXT (AttachmentRole) | photo / main / cover / gallery |
| `filePath` | TEXT | **relative** path to full image, e.g. `attachments/lab-results/<id>.jpg` |
| `thumbPath` | TEXT | **relative** path to ~320px thumbnail |
| `fileType` | TEXT | mime, e.g. `image/jpeg` |
| `originalFileName` | TEXT? | best-effort from picker |
| `fileSize` | INT | bytes of the full (compressed) image |
| `width` / `height` | INT? | full image dimensions |
| `sortOrder` | INT | ordering within galleries |
| `createdAt` | DateTime | |

Index `attachments(entityType, entityId)`. Cardinality (0/1 vs many) is enforced in `AttachmentService`, not the schema, so the rules stay in one place (§5).

### 3.4 Steps ↔ Daily Quick Log shared metric (spec §17.4 / §18 / §29.3)

One value per date, owned by the `steps` table:
- Daily Quick Log **displays** steps for its date; if no row exists, it may **create** one (`source = daily_quick_log`).
- Once a row exists it is **read-only in the Daily Log** ("заключено" badge in the design); edits/deletes happen **only in the Steps module**.
- The Steps module shows the provenance ("въведено от Дневен отчет" vs "от Крачки") from `source`.
- Enforced by `UNIQUE(date)` + a `StepsService.upsertFromDaily()` / `editFromStepsModule()` split.

### 3.5 Migrations

`schemaVersion = 1`. drift migration strategy in place from day one (`MigrationStrategy`), even though V1 ships at v1 — restore validates the backup's `schemaVersion` against the app's supported version.

---

## 4. Navigation & routing (`app/router.dart`)

The prototype uses a custom stack (`history[]`) + a 5-slot bottom nav with a center FAB that opens a quick-log sheet. Translated to **go_router** with a `StatefulShellRoute.indexedStack` for the four tabs, plus pushed detail routes. Forms are **modal bottom sheets**, not routes.

### 4.1 Bottom-nav tabs (persistent shell)

| Slot | Route | Screen | Design source |
|---|---|---|---|
| Начало | `/` | Home | `home.jsx` Home |
| Графики | `/stats` | Stats overview | `home.jsx` Stats |
| **＋** (FAB) | — | opens **Quick-log sheet** | `forms.jsx` QuickSheet |
| Спомени | `/memories` | Memories (diary + trips rail) | `home.jsx` Memories |
| Още | `/more` | All modules menu | `home.jsx` More |

### 4.2 Pushed routes (from More / cards / search)

`/food`, `/activities`, `/steps`, `/finance`, `/health`, `/daily` (today or `?date=`), `/bucket`, `/bucket/:id` (detail), `/trips`, `/trips/:id` (detail), `/search`, `/export`, `/backup`.

### 4.3 Modal sheets (quick-log + create/edit forms) — `app/sheets.dart`

`showModalBottomSheet` (rounded top, drag handle, blurred scrim, slide-up). Registry keys mirror the prototype's `SHEETS`:

`quick` (chooser), `food`, `expense`, `income`, `finance` (expense/income chooser), `bp`, `daily`, `activity`, `steps`, `med`, `bucket`, `bucketComplete`, `trip`.

- Quick-log sheet exposes the 7 actions (`food, expense, bp, daily, activity, steps, med`); the 4 mandatory ones (food, expense, bp, daily) are visually primary (spec §5.2).
- Each form sheet is reused for **create and edit** (seeded with an existing record when editing).
- The Finance screen's `+` opens the radial expense/income chooser (design `FinRadial`); elsewhere the quick chooser is a grid.

### 4.4 Cross-cutting UI

- **Toast** — transient confirmation ("Записано успешно"), shown via an overlay provider (design `Toast`).
- **PeriodChips** — Днес / 7 дни / 30 дни / Месец / Предишен / Custom; drives a per-screen `Period` provider; custom opens a date-range picker.

---

## 5. Services

### 5.1 AttachmentService (filesystem + DB) — includes the approved image pipeline

Owns all attachment writes so cardinality and the image pipeline live in one place.

**Import pipeline (on add):**
1. Pick via `image_picker` (camera or gallery; `multi` where the entity allows many).
2. **Compress + resize**: long edge ≤ **~1600px**, **JPEG quality ~80** (`flutter_image_compress`). Re-encode to JPEG.
3. **Thumbnail**: generate **~320px** long-edge JPEG (~quality 70).
4. Write both into `…/attachments/<entity-folder>/<uuid>.jpg` and `…/<uuid>_thumb.jpg` under the app documents dir.
5. Insert an `attachments` row with `filePath`, `thumbPath`, `fileType`, `fileSize` (full image bytes), `width/height`, `sortOrder`, `originalFileName`.

**Cardinality enforcement:**
- `meal`, `activity` → role `photo`, max 1 (replacing deletes the old file).
- `daily_log` → role `main`, max 1.
- `trip` → exactly one `cover` (replaceable) + many `gallery`.
- `health_event`, `lab_test`, `bucket_item`, `bucket_experience` → many `photo`.

**Delete (must route through `AttachmentService` — two mechanisms, neither covers the other):**
- SQLite never deletes attachment **files** on disk: the `attachments` table is polymorphic (no real FK), so cascades never touch it, and files aren't DB rows regardless.
- Therefore deleting any record **must** call `AttachmentService`, which enumerates that record's attachments, deletes their files (full **+** thumb), then removes the rows (spec §4.4).
- **Bucket item specifically:** the `ON DELETE CASCADE` drops the linked `bucket_experience` row but not its files. So when deleting an item, first collect the file paths of the item's attachments **and** its experience's attachments, delete those files, then delete the rows — otherwise the experience's photos orphan on disk.

Galleries/list views render `thumbPath`; detail/fullscreen renders `filePath`.

**Folder mapping** (matches backup tree §6.3 of spec): meals/, activities/, health-events/, lab-results/, daily-photos/, bucket-list/, bucket-list-experiences/, trips/.

### 5.2 BackupService (ZIP) — spec §26

- **Create:** serialize every table to `data.json` (including the `attachments` metadata array), build `manifest.json` (`appName, backupType:"full", createdAt, schemaVersion:1, appVersion, dataFile, attachmentsFolder`), copy all attachment files (full **and** thumbnails) into `attachments/…`, zip with `archive`, hand to the OS via `share_plus`. Filename `lifemaxxing-backup-YYYY-MM-DD.zip`.
- **Restore (all-or-nothing, filesystem-safe):** filesystem operations are **not** covered by the DB transaction, so the live data is never deleted until the replacement is fully staged and validated:
  1. Pick `.zip` via `file_picker`; **extract + stage** to a temp location.
  2. **Validate fully** — valid zip; `manifest.json` + `data.json` present; `schemaVersion` supported; every attachment listed in `data.json` exists in the zip; structural validity. Abort here leaves everything untouched.
  3. Write restored attachments into a **new** directory (e.g. `attachments_restore/`) — never the live one.
  4. **Commit (final step) — swap files first, then DB:** atomically **swap the attachments directory first** (new → live, old → set aside), **then** import data in a single drift transaction. If the DB commit fails, **roll the directory swap back** (restore the old dir). Swapping before committing avoids the window where committed DB rows point at not-yet-live files — and restore correctness is the whole point of backup.
  5. On success, delete the set-aside old dir + temp staging. Any failure at/before the commit leaves the original DB **and** original attachments dir intact (the swap is reverted on commit failure); cleanup deletes only temp/staging dirs. No merge in V1.
- If the app is non-empty, the **replace-all** confirmation is shown before step 3.
- **Decision:** thumbnails are included in the ZIP (rather than regenerated on restore) so restore is deterministic and offline-correct, at a small size cost.

### 5.3 ExportService (AI export) — spec §25

- Formats: **JSON** and **Markdown** (CSV deferred per approved scope).
- Scopes: **Full**, **Period** (last7/last30/this-month/custom), **Module**.
- Period inclusion rules implemented exactly: records by their date in range; bucket items if created **or** completed in range; trips if `fromDate` **or** `toDate` in range (spec §25.5).
- JSON shape matches §25.8 keys (`exportDate, period, summary, meals, … , attachments` metadata). Markdown follows §25.9 sections and ends with the "Questions for AI Analysis" block. Output shared via `share_plus` / copy-to-clipboard. Attachments are **metadata only** in AI export (binaries go through Backup).

---

## 6. Component breakdown (prototype → Flutter)

### 6.1 Primitives (`core/widgets/`, from `kit.jsx` + `ui.jsx`)

| Prototype | Flutter widget | Notes |
|---|---|---|
| `Card` | `LmCard` | bg/cardHi, 18 radius, hairline border |
| `Eyebrow` | `Eyebrow` | mono 11 uppercase faint |
| `Pill` / `Delta` | `Pill`, `DeltaBadge` | colored soft-bg chips |
| `Icon` (24 set) | `LmIcon` | port the stroke paths as `CustomPainter`/`IconData` |
| `TopBar` | `AppTopBar` | sticky, blur, back + title + right slot |
| `Body` | `ScreenBody` | scroll + padding |
| `PeriodChips` | `PeriodChips` | bound to `Period` provider |
| `Stat` / `Row` / `SectionTitle` | `Stat`, `LmRow`, `SectionTitle` | |
| `BottomNav` | `LmBottomNav` | 5 slots + center FAB |
| `Sheet` | `showLmSheet()` | modal bottom sheet wrapper |
| `Btn` | `LmButton` | primary / ghost / danger |
| `Field`,`Input`,`TextArea`,`Segmented`,`YesNo`,`Scale10`,`MoodPicker`,`Stepper`,`PhotoAdd`,`PhotoTile` | same names | form controls; `MoodPicker` uses the OKLCH ramp |
| `Toast` | overlay provider | |

### 6.2 Charts (`core/charts/`) — fl_chart + one bespoke painter

Standard charts use **`fl_chart`** (favoring build speed), wrapped in thin LifeMaxxing components that apply the design tokens so call sites stay declarative:
- `Sparkline` (line + gradient fill) → `LineChart`
- `MiniBars` / `BarChart` (rounded bars, highlight last) → `BarChart`
- `Ring` (progress donut) and `SegRing` (segmented category donut) → `PieChart` with a center child
- income-vs-expense stacked bars → grouped/stacked `BarChart`

All driven by `List<num>` / segment lists from aggregate queries. The only **hand-painted** piece is the **`MoodGauge`** (the OKLCH red→amber→green ramp), which no chart library reproduces — see §2.1.

### 6.3 Screens (prototype file → feature)

`home.jsx` → Home, Stats, Memories, More · `finance.jsx` → Finance, Food, Activities, Steps · `health.jsx` → Health (tabs: Кръвно/Добавки/Събития/Изследвания) · `lists.jsx` → Daily, Bucket(+detail), Trips(+detail), Search · `forms.jsx` → all sheets + Export · `backup.jsx` → Backup & Restore.

---

## 7. State & data flow (Riverpod)

- **Reactive reads:** DAOs expose `Stream`s (`watch…`); providers wrap them (`StreamProvider`). UI rebuilds automatically when the DB changes after a save — no manual refresh.
- **Per-screen period:** a `StateProvider<Period>` (family by screen) feeds aggregate providers; changing the chip recomputes numbers + charts (spec §22).
- **Summaries** computed in DAOs via SQL aggregates (`SUM/AVG/COUNT/GROUP BY`) parameterized by the resolved date range; daily (§27) and monthly (§28) summaries are dedicated query methods returning typed DTOs (`domain/summaries.dart`).
- **Writes:** form sheets call DAO/service methods inside transactions; success → close sheet + toast. Validation (§8) runs in the form layer before write; DB constraints are the backstop.
- **Today snapshot / home timeline** assembled from the day's rows across modules.

---

## 8. Validation & business rules (spec §29)

Centralized in form-level validators + DB constraints:

- **Dates:** never empty; default today; past allowed; future only where meaningful (next dental visit, planned trip, bucket plan).
- **Daily log:** exactly one per date (`UNIQUE(date)`). Adding for a date that already has a log **opens the existing entry for editing** — it never creates a second row. To change a day's log, open and edit it from the day's view / days list. Mood 1–10; all yes/no required; conditional optional text for uncomfortable/alcohol.
- **Steps:** exactly one per date (`UNIQUE(date)`); integer ≥ 0. To change a day's value, edit the existing row — never create a second; editable only in the Steps module.
- **Money:** amount (cents) > 0; category required (or "Друго").
- **BP:** date/time + all three values required, > 0, `systolic > diastolic`; multiple per date.
- **Meds:** date/time/name/type/status required.
- **Activities:** date + type required; duration > 0 if present.
- **Bucket:** title/priority/status required; default Idea; completing opens experience form; completed shows logged experience and hides the complete button; feeling 1–10; worthIt required.
- **Trips:** title/destination/from/to/overall required; `toDate >= fromDate`; ratings 1–10; ≤1 cover, many gallery.
- **Backup/Restore:** ZIP only; manifest+data+attachments; validate before restore; all-or-nothing; warn + confirm when non-empty; no merge.

---

## 9. Search & filtering (spec §24)

- **Search (Cyrillic-safe):** SQLite `LIKE`/`NOCASE` only case-folds ASCII, so it cannot match Bulgarian text case-insensitively. Instead, every searchable text field has a **lowercased shadow column** (e.g. `nameLower`, `noteLower`) written via Dart `toLowerCase()` (which handles Cyrillic) on each save. Search lowercases the query in Dart and matches against the shadow columns (`shadow LIKE '%' || :q || '%'`, where `:q` is already lowercased — the `LIKE` here only does substring matching on already-folded text, not case folding). Searchable fields: meal name/note, activity name/note, expense description/note, income source/note, health-event clinic/reason/whatWasDone/note, lab lab/reason/resultsText/note, BP note, med name/reason/note, daily note, bucket title/description/why/reflection, trip title/destination/comment. Per-table queries merge into a unified result list (FTS is a possible later optimization, not required for single-user volumes).
- **Filtering:** per-module filters by date/period, category, type, status, priority, feeling, worthIt, overall rating, wouldRepeat, health-event type, med type, activity type — implemented as query parameters on the DAO list methods.

---

## 10. External dependencies

| Package | Purpose |
|---|---|
| `flutter_riverpod` | state management |
| `go_router` | routing / nav shell |
| `drift` + `drift_flutter` (or `sqlite3_flutter_libs`) | SQLite ORM, reactive queries |
| `drift_dev`, `build_runner` | codegen (dev) |
| `path_provider` | app documents dir |
| `image_picker` | camera/gallery selection |
| `flutter_image_compress` | resize/compress + thumbnail generation |
| `fl_chart` | line / bar / pie charts (standard charts) |
| `archive` | ZIP create/extract |
| `share_plus` | share ZIP / export out |
| `file_picker` | pick ZIP for restore |
| `intl` | bg_BG dates (dd.MM.yyyy), EUR formatting (€) |
| `uuid` | IDs |
| `path` | path joins |

(No networking, analytics, crash, or auth packages — out of scope.)

---

## 11. Key technical decisions & tradeoffs

1. **`fl_chart` for standard charts** — favors build speed over pixel-perfect control; thin wrappers apply the design tokens so the look stays on-brand. Only the bespoke OKLCH `MoodGauge` is hand-painted, since no library reproduces it.
2. **drift streams + Riverpod** — live-updating dashboards with minimal glue; aggregates in SQL keep summary logic close to data and fast.
3. **Attachments on filesystem, metadata in DB** — keeps the SQLite file small and backups straightforward; the service centralizes cardinality + the compress/thumbnail pipeline.
4. **Compressed images + stored thumbnails** (approved) — ~1600px/Q80 originals and ~320px thumbs keep device storage and ZIP size small and lists fast; thumbnails are backed up rather than regenerated for deterministic restore.
5. **Single currency — EUR** — no per-record currency; amounts are stored as integer euro cents and all totals/summaries/charts aggregate in EUR. Multi-currency is out of scope for V1. *(Confirmed.)*
6. **Bundled fonts** — no Google Fonts network dependency for an offline app.
7. **Bucket↔Trip and Expense↔Trip links left out of V1** — spec marks them optional/"defer if it complicates"; we defer (trip spend is logged as an expense with the relevant category).
8. **Transactional restore** — staged + single drift transaction + filesystem swap so a mid-restore failure cannot corrupt existing data (spec §26.11).

---

## 12. Testing strategy

- **Unit (drift in-memory DB):** DAO CRUD, uniqueness (daily/steps per date), BP constraint, period aggregates (daily §27 / monthly §28), summary math.
- **Service tests:** AttachmentService cardinality + delete-cascades-files; BackupService round-trip (create→restore equals original); ExportService JSON shape + period inclusion rules; restore validation failure paths (corrupt zip, missing manifest, unsupported schema) leave data intact.
- **Widget tests:** each form's required-field validation + conditional fields; period chip recompute; bucket complete-flow; steps lock behavior in Daily Log.

---

## 13. Resolved decisions & deferrals

- **iOS — deferred.** Android-first for V1; no iOS build config set up now. The stack is already iOS-compatible (JPEG not WebP, all packages cross-platform), so nothing is lost by deferring.

No open items remain. All decisions are locked: single currency EUR (euro-cents), `TEXT yyyy-MM-dd` date-only fields, filesystem-safe swap-then-commit restore, Cyrillic-safe lowercased-shadow search, `fl_chart` for standard charts + hand-painted `MoodGauge`, `ON DELETE CASCADE` + `AttachmentService`-driven file cleanup, `PRAGMA foreign_keys = ON`, OKLCH→sRGB mood ramp.
