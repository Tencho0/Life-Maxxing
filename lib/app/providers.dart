// Core Riverpod providers. DAO/feature providers are added with their slices.

import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';

/// The app's single drift database (on-device file). Overridden with an
/// in-memory database in tests.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(driftDatabase(name: 'lifemaxxing'));
  ref.onDispose(db.close);
  return db;
});
