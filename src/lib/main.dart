import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load date symbols for both supported locales so locale-aware DateFormat
  // patterns work once they land (Slice 10.5); harmless for numeric formats.
  await initializeDateFormatting('bg');
  await initializeDateFormatting('en');

  // Open the DB once and read the persisted locale + user name before the first
  // frame, so the app starts in the saved language and a returning user never
  // flashes the welcome screen. The same instance is shared with the provider
  // graph via an override.
  final db = createAppDatabase();
  final settings = SettingsService(db.settingsDao);
  final savedLocale = await settings.getLocale();
  final savedName = await settings.getUserName();

  runApp(LifeMaxxingApp(overrides: [
    databaseProvider.overrideWithValue(db),
    initialLocaleProvider.overrideWithValue(savedLocale),
    initialUserNameProvider.overrideWithValue(savedName),
  ]));
}
