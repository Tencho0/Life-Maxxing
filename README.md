# LifeMaxxing

A personal, single-user, offline-first life-tracking app (Bulgarian UI): food, activities, money, health (BP/pulse, meds, events, lab tests), a daily quick log, steps, a visual diary, bucket list and trips — with per-module summaries/charts, AI export (JSON/Markdown), and full ZIP backup/restore.

## Stack

Flutter (Dart) · drift/SQLite · Riverpod · go_router · fl_chart. Local-only; no backend, no network, no auth. See [`docs/technical-spec.md`](docs/technical-spec.md).

## Toolchain

- Flutter **3.41.5** (stable channel) · Dart **3.11.3**
- Android-first (iOS deferred — the stack is iOS-compatible)

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # drift codegen (once tables exist)
flutter run                                                 # Android device/emulator
flutter analyze && flutter test                             # checks
```

## Documentation

- [`docs/functional_spec.md`](docs/functional_spec.md) — functional requirements (**source of truth for behavior/features**)
- [`docs/technical-spec.md`](docs/technical-spec.md) — architecture, data model, decisions
- [`docs/implementation-plan.md`](docs/implementation-plan.md) — sliced build plan / progress checklist
- [`design/`](design/) — finalized design bundle (**source of truth for layout/visuals**)
- [`CLAUDE.md`](CLAUDE.md) — project guide & conventions for contributors (incl. AI agents)
