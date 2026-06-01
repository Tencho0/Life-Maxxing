import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/domain/period.dart';
import 'package:lifemaxxing/presentation/steps/steps_format.dart';
import 'package:lifemaxxing/presentation/steps/steps_forms.dart';
import 'package:lifemaxxing/presentation/steps/steps_providers.dart';
import 'package:lifemaxxing/presentation/steps/steps_screen.dart';
import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  test('summary reflects step entries for the custom range', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    container.read(stepsCustomRangeProvider.notifier).state =
        const DateRange('2026-06-01', '2026-06-30');
    container.read(stepsPeriodProvider.notifier).state = Period.custom;

    final svc = container.read(stepsServiceProvider);
    await svc.setFromStepsModule('2026-06-01', 8000);
    await svc.setFromStepsModule('2026-06-02', 12000);
    await svc.setFromStepsModule('2026-06-03', 4000);

    container.listen(stepsInRangeProvider, (_, _) {});
    await container.read(stepsInRangeProvider.future);

    final s = container.read(stepsSummaryProvider);
    expect(s.hasValue, isTrue);
    expect(s.requireValue.total, 24000);
    expect(s.requireValue.best, 12000);
    expect(s.requireValue.worst, 4000);
    expect(s.requireValue.daysLogged, 3);
  });

  test('one value per date; steps-module edit preserves daily provenance',
      () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    final svc = container.read(stepsServiceProvider);

    await svc.setFromDaily('2026-06-01', 5000); // created by the daily log
    await svc.setFromStepsModule('2026-06-01', 9000); // edited here (steps)
    await svc.setFromStepsModule('2026-06-01', 9500); // edited again

    final rows = await db.stepsDao.inRange('2026-06-01', '2026-06-01');
    expect(rows, hasLength(1)); // one per date
    expect(rows.single.count, 9500);
    expect(rows.single.source, StepsSource.dailyQuickLog); // provenance kept
  });

  test('provenance label distinguishes the two sources', () {
    expect(stepsProvenance(StepsSource.dailyQuickLog),
        'въведено от Дневен отчет');
    expect(stepsProvenance(StepsSource.stepsModule), 'въведено от Крачки');
  });

  group('steps form', () {
    Future<void> openForm(WidgetTester tester, AppDatabase db) async {
      tester.view.physicalSize = const Size(500, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () => showStepsSheet(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('requires a count', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await openForm(tester, db);

      await tester.tap(find.text('Запази'));
      await tester.pumpAndSettle();
      expect(find.text('Въведи валиден брой крачки'), findsOneWidget);
      expect(await db.select(db.steps).get(), isEmpty);
    });

    testWidgets('saves via StepsService (source = stepsModule)', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await openForm(tester, db);

      await tester.enterText(find.byType(TextField).at(0), '8200');
      await tester.tap(find.text('Запази'));
      await tester.pumpAndSettle();

      final rows = await db.select(db.steps).get();
      expect(rows, hasLength(1));
      expect(rows.first.count, 8200);
      expect(rows.first.source, StepsSource.stepsModule);
    });
  });

  testWidgets('steps screen renders from seeded data', (tester) async {
    tester.view.physicalSize = const Size(420, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MaterialApp(home: Scaffold(body: StepsScreen())),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Крачки'), findsOneWidget); // top bar title
    expect(find.text('СТАТИСТИКА'), findsOneWidget); // eyebrow (uppercased)

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
