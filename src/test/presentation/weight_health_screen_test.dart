// Health screen weight integration: a "Тегло" history tab + a weight trend card
// rendered from seeded entries. Mirrors the existing health-screen render test's
// bounded-pump pattern (no settleData) and unmounts at the end to drain timers.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/presentation/health/health_screen.dart';
import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  testWidgets('Health screen shows the Тегло tab and renders an entry',
      (tester) async {
    tester.view.physicalSize = const Size(420, 2800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    final now = DateTime.utc(2026, 6, 1);
    await db.weightDao.save(WeightLogsCompanion.insert(
        id: 'w0', date: '2026-05-20', weightGrams: 84000,
        createdAt: now, updatedAt: now));
    await db.weightDao.save(WeightLogsCompanion.insert(
        id: 'w1', date: '2026-06-01', weightGrams: 82500,
        createdAt: now, updatedAt: now));

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: Scaffold(body: HealthScreen())),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 50));

    // The "Тегло" tab is present (the weight card eyebrow is uppercased, so this
    // matches only the tab label).
    expect(find.text('Тегло'), findsWidgets);

    // Switch to the weight tab → the latest entry's formatted weight shows.
    await tester.tap(find.text('Тегло').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.textContaining('82.5'), findsWidgets);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
