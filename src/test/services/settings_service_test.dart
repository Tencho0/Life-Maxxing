// Slice 10.2 — SettingsService: persists the UI locale in the drift KV table.
// Storage is a language code string; null = follow system.

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/services/settings_service.dart';

void main() {
  late AppDatabase db;
  late SettingsService settings;

  setUp(() {
    db = AppDatabase.memory();
    settings = SettingsService(db.settingsDao);
  });
  tearDown(() => db.close());

  test('locale defaults to null when unset (follow system)', () async {
    expect(await settings.getLocale(), isNull);
  });

  test('set then get round-trips the locale', () async {
    await settings.setLocale(const Locale('en'));
    expect(await settings.getLocale(), const Locale('en'));
  });

  test('persists across a fresh service on the same db (reload)', () async {
    await settings.setLocale(const Locale('bg'));
    final reloaded = SettingsService(db.settingsDao);
    expect(await reloaded.getLocale(), const Locale('bg'));
  });

  test('setting null clears the preference (back to system)', () async {
    await settings.setLocale(const Locale('en'));
    await settings.setLocale(null);
    expect(await settings.getLocale(), isNull);
  });

  test('user name defaults to null when unset', () async {
    expect(await settings.getUserName(), isNull);
  });

  test('set then get round-trips the user name', () async {
    await settings.setUserName('Мартин');
    expect(await settings.getUserName(), 'Мартин');
  });

  test('user name is trimmed on save', () async {
    await settings.setUserName('  Мартин  ');
    expect(await settings.getUserName(), 'Мартин');
  });

  test('a blank name clears the stored value (null, not empty)', () async {
    await settings.setUserName('Мартин');
    await settings.setUserName('   ');
    expect(await settings.getUserName(), isNull);
  });

  test('user name persists across a fresh service on the same db', () async {
    await settings.setUserName('Иван');
    final reloaded = SettingsService(db.settingsDao);
    expect(await reloaded.getUserName(), 'Иван');
  });
}
