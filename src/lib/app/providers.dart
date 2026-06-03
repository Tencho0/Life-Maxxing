// Core Riverpod providers. DAO/feature providers are added with their slices.

import 'dart:ui' show Locale;

import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../services/attachment_service.dart';
import '../services/settings_service.dart';

/// Creates the on-device drift database. Used by [databaseProvider] in the app
/// and directly in `main()` to read the persisted locale before the first frame.
AppDatabase createAppDatabase() => AppDatabase(driftDatabase(name: 'lifemaxxing'));

/// The app's single drift database (on-device file). Overridden with an
/// in-memory database in tests, or the `main()`-created instance in prod.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = createAppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Persists app preferences (currently the UI locale) in the drift KV table.
final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService(ref.watch(databaseProvider).settingsDao);
});

/// The locale loaded from settings at startup. `main()` overrides this with the
/// persisted value (read before the first frame); it seeds [localeProvider]'s
/// initial state. Defaults to `null` (follow system) in tests/cold start.
final initialLocaleProvider = Provider<Locale?>((ref) => null);

/// The active UI locale. `null` = follow the system locale, which Flutter
/// resolves against `supportedLocales` ([bg, en]) — falling back to bg (first
/// in the list) for any unsupported system language. A persisted user choice
/// overrides this. `MaterialApp` watches this; the switcher calls
/// [LocaleController.set], which updates state live and persists.
final localeProvider =
    NotifierProvider<LocaleController, Locale?>(LocaleController.new);

class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() => ref.read(initialLocaleProvider);

  /// Updates the active locale live and persists the choice (`null` = system).
  Future<void> set(Locale? locale) async {
    state = locale;
    await ref.read(settingsServiceProvider).setLocale(locale);
  }
}

/// The user display name loaded from settings at startup. `main()` overrides
/// this with the persisted value (read before the first frame); it seeds
/// [userNameProvider]'s initial state. Defaults to `null` (no name yet) in
/// tests/cold start, which drives the first-launch welcome screen.
final initialUserNameProvider = Provider<String?>((ref) => null);

/// The active user display name shown in the home greeting. `null` = no name
/// set yet → the app shell shows the welcome screen instead of the router.
/// [WelcomeScreen] and Settings call [UserNameController.set], which updates
/// state live and persists.
final userNameProvider =
    NotifierProvider<UserNameController, String?>(UserNameController.new);

class UserNameController extends Notifier<String?> {
  @override
  String? build() => ref.read(initialUserNameProvider);

  /// Updates the active name live and persists it (trimmed). A blank name is
  /// ignored — the greeting always has a real name once onboarding completes.
  Future<void> set(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    state = trimmed;
    await ref.read(settingsServiceProvider).setUserName(trimmed);
  }
}

/// The single write path for photo attachments (image pipeline + cardinality +
/// delete-cascades-files). Used by every photo-bearing feature slice.
final attachmentServiceProvider = Provider<AttachmentService>((ref) {
  return AttachmentService(ref.watch(databaseProvider).attachmentsDao);
});
