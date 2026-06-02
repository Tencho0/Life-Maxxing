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

  // Open the DB once and read the persisted locale before the first frame, so
  // the app starts in the saved language with no flash. The same instance is
  // shared with the provider graph via an override.
  final db = createAppDatabase();
  final savedLocale = await SettingsService(db.settingsDao).getLocale();

  runApp(LifeMaxxingApp(overrides: [
    databaseProvider.overrideWithValue(db),
    initialLocaleProvider.overrideWithValue(savedLocale),
  ]));
}
