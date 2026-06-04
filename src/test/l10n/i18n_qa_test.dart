// Slice 10.6 — i18n QA. Renders representative screens in BOTH locales on a
// 412-wide device: a layout overflow or a missing-translation lookup surfaces
// as an uncaught exception and fails the test. Also checks a title localizes.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/presentation/activities/activity_screen.dart';
import 'package:lifemaxxing/presentation/finance/finance_screen.dart';
import 'package:lifemaxxing/presentation/food/food_screen.dart';
import 'package:lifemaxxing/presentation/health/health_screen.dart';
import 'package:lifemaxxing/presentation/home/home_screen.dart';

import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);
  setUp(() async {
    await initializeDateFormatting('bg');
    await initializeDateFormatting('en');
  });

  Future<void> renderAt412(
      WidgetTester tester, Widget screen, Locale locale) async {
    tester.view.physicalSize = const Size(412, 2800); // common phone width
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db, withPhotos: false);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: Scaffold(body: screen), locale: locale),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300)); // drift streams
    await tester.pump(const Duration(milliseconds: 50));

    // A RenderFlex overflow or a missing-key lookup throws → fail loudly.
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1)); // unmount + flush streams
  }

  for (final locale in const [Locale('bg'), Locale('en')]) {
    testWidgets('key screens render at 412w (${locale.languageCode})',
        (tester) async {
      await renderAt412(tester, const FoodScreen(), locale);
      await renderAt412(tester, const FinanceScreen(), locale);
      await renderAt412(tester, const ActivityScreen(), locale);
      await renderAt412(tester, const HealthScreen(), locale);
      await renderAt412(tester, const HomeScreen(), locale);
    });
  }

  testWidgets('the same screen title localizes per locale', (tester) async {
    await renderAt412(tester, const FoodScreen(), const Locale('bg'));
    // (rendered + unmounted inside helper) — re-render to assert on-screen text.
    final db = AppDatabase.memory();
    addTearDown(db.close);

    Future<void> pump(Locale l) => tester.pumpWidget(ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: localizedApp(home: const Scaffold(body: FoodScreen()), locale: l),
        ));

    await pump(const Locale('bg'));
    await settleData(tester);
    expect(find.text('Храна'), findsWidgets); // bg title

    await pump(const Locale('en'));
    await settleData(tester);
    expect(find.text('Food'), findsWidgets); // en title

    await tester.pumpWidget(const SizedBox());
    await settleData(tester);
  });
}
