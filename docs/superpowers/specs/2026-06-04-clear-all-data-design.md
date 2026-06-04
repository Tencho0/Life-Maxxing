# Clear all data — design

**Date:** 2026-06-04
**Status:** Approved, ready for implementation plan

## Purpose

Give the user a one-tap way to wipe all logged data from the app. Primary use
case: resetting to a clean slate while testing the app (so the developer/owner
doesn't have to uninstall + reinstall to clear seeded or trial data).

## Scope

**Wipes:**
- All logged module data: food, activities, expenses, income, blood pressure,
  medication/supplement logs, health events, lab tests, daily logs, steps,
  bucket items + experiences, trips.
- All photo attachment files on disk (the `attachments/` directory).

**Preserves:**
- Display name and UI language (device preferences, not user data — the backup
  layer already treats the `settings` table this way). The app stays past
  onboarding; the first-launch welcome screen does **not** reappear.

Out of scope: any "factory reset" that clears name/onboarding (rejected — would
re-trigger first-launch flow, which is heavier than needed for testing).

## Architecture

Three layers, all reusing existing patterns.

### 1. Service — `BackupService.clearAllData()`

New public method in `src/lib/services/backup_service.dart`.

```
Future<void> clearAllData() async {
  // 1. Delete all user rows in a transaction (FK-safe, children→parents).
  //    Reuses the existing private _deleteAll(), which already excludes the
  //    `settings` table, so name + locale survive.
  await _db.transaction(() async { await _deleteAll(); });

  // 2. Recursively delete the live attachments/ dir on disk (best-effort).
  //    Required by the "deleting a record deletes its files" locked decision so
  //    no photo files orphan. Done AFTER the DB commit.
  final base = await _docsDir();
  final live = Directory(p.join(base.path, _attachmentsDir));
  if (await live.exists()) await live.delete(recursive: true);
}
```

Rationale for ordering: delete DB rows first (transactional, atomic), then files.
If file deletion fails after the commit, the DB is already clean — leftover
files are harmless (no rows reference them) and would be overwritten by future
attachments. The reverse order risks a clean filesystem with intact rows
pointing at missing images.

`BackupService` already accepts a `docsDir` override in its constructor, so this
is unit-testable against a temp directory.

Note: this is distinct from the dev-only `clearAll()` in `src/lib/dev/seed.dart`
and the restore-internal `_deleteAll()` — neither of those touches files on
disk. `clearAllData()` is the only user-facing, files-included wipe.

### 2. UI — new danger row in Settings

A new section at the bottom of `src/lib/presentation/settings/settings_screen.dart`,
below the Language picker:

- An `Eyebrow` + an `LmRow` titled **"Изтрий всички данни"** with a red/trash
  affordance (`LmIcons` trash icon, `AppColors.red`).
- Tapping opens a confirm `AlertDialog` that mirrors the existing
  `_confirmReplaceAll` pattern in `backup_screen.dart`: `AppColors.card`
  background, title + body, "Отказ" (`TextButton`) + a red destructive
  "Изтрий всичко" (`TextButton`).
- On confirm → `ref.read(backupServiceProvider).clearAllData()`, then
  `showLmToast(context, l10n.settingsClearDataDone)`.

Refresh: drift's reactive queries auto-refresh every other screen after the
wipe. The Settings screen itself only shows name + language (untouched), so no
manual invalidation is needed.

`backupServiceProvider` lives in
`src/lib/presentation/backup/backup_providers.dart` and is already bound to the
app database — import and reuse it.

### 3. Strings

Add to both `src/lib/l10n/app_bg.arb` and `src/lib/l10n/app_en.arb`:

| Key | bg | en |
|---|---|---|
| `settingsClearData` | Изтрий всички данни | Clear all data |
| `settingsClearDataTitle` | Изтриване на всички данни | Clear all data |
| `settingsClearDataBody` | Това ще изтрие всички записи и снимки безвъзвратно. Името и езикът се запазват. | This permanently deletes all records and photos. Your name and language are kept. |
| `settingsClearDataConfirm` | Изтрий всичко | Delete everything |
| `settingsClearDataDone` | Данните са изтрити | Data cleared |

Then run l10n codegen (`flutter gen-l10n` / build).

## Testing

- **Unit** (`test/services/backup_service_*`): seed an in-memory DB + write fake
  attachment files into a temp docs dir → `clearAllData()` → assert every user
  table is empty, the `settings` row is preserved, and the `attachments/` dir no
  longer exists.
- **Widget** (`test/presentation/settings/settings_screen_test.dart`): render
  Settings, tap the "Изтрий всички данни" row → dialog appears; tapping cancel
  is a no-op; tapping confirm clears data + shows the toast. Use
  `useDeterministicTestEnv()` and override `backupServiceProvider`.

## Reuses / constraints

- Reuses: confirm-dialog pattern, `LmRow`, `LmIcons`, `showLmToast`,
  `backupServiceProvider`, `AppColors.red`.
- No new dependencies. No locked-decision changes. Bulgarian user-facing
  strings, English identifiers.
