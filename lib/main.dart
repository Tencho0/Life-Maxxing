import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load date symbols for both supported locales so locale-aware DateFormat
  // patterns work once they land (Slice 10.5); harmless for numeric formats.
  await initializeDateFormatting('bg');
  await initializeDateFormatting('en');
  runApp(const LifeMaxxingApp());
}
