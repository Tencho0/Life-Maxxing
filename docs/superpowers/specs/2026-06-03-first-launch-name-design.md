# First-launch name onboarding — design

**Date:** 2026-06-03

## Goal

On first launch (after install), ask the user for their name. Persist it and use it
in the home greeting (`Добър вечер, <Name>`). The name is editable later in Settings.

## Decisions (confirmed with user)

- **UI:** full-screen welcome screen on first launch (name unset).
- **Editable later:** yes — a "Name" entry in the Settings screen.
- **Empty handling:** name is required — Continue is disabled until non-empty (trimmed).
- **Backup:** name lives in the `settings` KV table, which is excluded from
  backup/restore (a device preference, same as locale).

## Data layer (no schema change)

`settings` KV table already exists. Add key `userName`. In `SettingsService`:
- `Future<String?> getUserName()` — stored name or `null`.
- `Future<void> setUserName(String name)` — persists the trimmed name.

## State & startup (mirrors locale flow)

- `initialUserNameProvider` (`Provider<String?>`, default `null`) — seeded by `main()`.
- `userNameProvider` (`NotifierProvider<UserNameController, String?>`) — active name;
  `.set(name)` updates state live and persists. Parallel to `LocaleController`.
- `main()` reads the saved name before the first frame and overrides
  `initialUserNameProvider` so returning users never flash the welcome screen.

## First-launch gate (`_Root`)

`_Root` watches `userNameProvider`:
- null/empty → render `WelcomeScreen` (themed, localized).
- set → render the normal `MaterialApp.router` app.

Shared MaterialApp props (theme, locale, localization delegates) are factored to
avoid duplication. Submitting a name flips `userNameProvider`; `_Root` rebuilds into home.

## WelcomeScreen

Full-screen, dark-themed: app title + greeting + prompt, a text field, and a
**Продължи** button disabled until the trimmed field is non-empty. On submit:
`userNameProvider.set(trimmed)`.

## Greeting

`HomeScreen` reads `ref.watch(userNameProvider)` and passes it into `_HomeHead`,
replacing the hardcoded `const _name = 'Martin'`.

## Settings edit

Add an "Име" entry to Settings showing the current name; tapping opens a small
editor (sheet/dialog) that calls `userNameProvider.set(...)`. Empty rejected.

## Localization

New bg + en strings (welcome title, prompt, field hint, continue button, settings
"Name" label) added through the project's l10n (.arb) flow.

## Tests

- `SettingsService` get/set name (in-memory drift).
- Widget: `_Root` shows WelcomeScreen when unset, app when set; Continue disabled
  on empty; submit saves and reveals home.
- Update `home_test` to override `userNameProvider` instead of the `'Martin'` const.
- Settings name-edit widget test.
