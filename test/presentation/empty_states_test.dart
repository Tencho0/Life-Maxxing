// Fresh-install (empty DB) graceful empty states — every list-bearing module
// shows its LmEmpty copy rather than a blank gap or a raw spinner (Slice 9.1).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/presentation/activities/activity_screen.dart';
import 'package:lifemaxxing/presentation/bucket/bucket_screen.dart';
import 'package:lifemaxxing/presentation/finance/finance_screen.dart';
import 'package:lifemaxxing/presentation/food/food_screen.dart';
import 'package:lifemaxxing/presentation/health/health_screen.dart';
import 'package:lifemaxxing/presentation/memories/memory_screen.dart';
import 'package:lifemaxxing/presentation/search/search_screen.dart';
import 'package:lifemaxxing/presentation/steps/steps_screen.dart';
import 'package:lifemaxxing/presentation/trips/trip_screen.dart';
import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  Future<void> pumpScreen(WidgetTester tester, Widget screen) async {
    tester.view.physicalSize = const Size(420, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory(); // empty — no seed
    addTearDown(db.close);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: MaterialApp(home: Scaffold(body: screen)),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 50));
  }

  // Unmount + flush drift's stream-close timer so no Timer outlives the test.
  Future<void> settleClose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  final cases = <String, (Widget, String)>{
    'food': (const FoodScreen(), 'Няма хранения за периода'),
    'finance': (const FinanceScreen(), 'Няма разходи за периода'),
    'activities': (const ActivityScreen(), 'Няма активности за периода'),
    'steps': (const StepsScreen(), 'Няма крачки за периода'),
    'health': (const HealthScreen(), 'Няма измервания за периода'),
    'bucket': (const BucketScreen(), 'Няма желания в списъка'),
    'trips': (const TripScreen(), 'Няма записани пътувания'),
    'search': (const SearchScreen(), 'Въведи дума за търсене из всички модули'),
  };

  cases.forEach((name, c) {
    testWidgets('$name screen shows its empty state on a fresh DB',
        (tester) async {
      await pumpScreen(tester, c.$1);
      expect(find.text(c.$2), findsOneWidget);
      await settleClose(tester);
    });
  });

  testWidgets('memories screen shows the empty visual diary', (tester) async {
    await pumpScreen(tester, const MemoriesScreen());
    expect(find.textContaining('Все още няма снимки в дневника'), findsOneWidget);
    await settleClose(tester);
  });
}
