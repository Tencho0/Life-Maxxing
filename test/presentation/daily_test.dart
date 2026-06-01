import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/presentation/daily/daily_forms.dart';
import 'package:lifemaxxing/presentation/daily/daily_providers.dart';
import 'package:lifemaxxing/presentation/daily/daily_screen.dart';
import 'package:lifemaxxing/services/steps_service.dart';
import '../support/test_env.dart';

DailyLogsCompanion _log(String id, String date,
        {int mood = 7, bool proud = true, bool workout = false}) =>
    DailyLogsCompanion.insert(
      id: id, date: date, mood: mood, proud: proud,
      didUncomfortable: false, workout: workout, drankAlcohol: false,
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    );

void main() {
  setUp(useDeterministicTestEnv);

  test('daily summary aggregates the trailing-30-day window of the view date',
      () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    container.read(dailyDateProvider.notifier).state = '2026-06-30';

    await db.dailyLogsDao.save(_log('d1', '2026-06-10', mood: 8, workout: true));
    await db.dailyLogsDao.save(_log('d2', '2026-06-20', mood: 6, workout: false));

    container.listen(dailyMonthLogsProvider, (_, _) {});
    await container.read(dailyMonthLogsProvider.future);

    final s = container.read(dailySummaryProvider);
    expect(s.hasValue, isTrue);
    expect(s.requireValue.filled, 2);
    expect(s.requireValue.avgMood, 7);
    expect(s.requireValue.workoutDays, 1);
  });

  group('daily form', () {
    Future<void> openForm(
      WidgetTester tester,
      AppDatabase db, {
      required String date,
      DailyLog? existing,
      StepEntry? existingSteps,
    }) async {
      tester.view.physicalSize = const Size(500, 3000);
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
                  onPressed: () => showDailySheet(context,
                      date: date, existing: existing, existingSteps: existingSteps),
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

    testWidgets('opening an existing date edits the same row (no duplicate)',
        (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      await openForm(tester, db, date: '2026-06-15');
      await tester.tap(find.text('Запази отчета'));
      await tester.pumpAndSettle();
      final first = await db.dailyLogsDao.getByDate('2026-06-15');
      expect(first, isNotNull);

      await openForm(tester, db, date: '2026-06-15', existing: first);
      await tester.tap(find.text('Запази отчета'));
      await tester.pumpAndSettle();

      final all = await db.select(db.dailyLogs).get();
      expect(all, hasLength(1)); // UNIQUE(date) + same id → no dup
      expect(all.first.id, first!.id);
    });

    testWidgets('the "uncomfortable what" field appears only when Да',
        (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await openForm(tester, db, date: '2026-06-15');

      expect(find.text('КАКВО НЕУДОБНО НЕЩО?'), findsNothing);
      // YesNo 'Да' order: proud(0), uncomfortable(1), workout(2), alcohol(3).
      await tester.tap(find.text('Да').at(1));
      await tester.pumpAndSettle();
      expect(find.text('КАКВО НЕУДОБНО НЕЩО?'), findsOneWidget);
    });

    testWidgets('steps: creates the day value when absent (source dailyQuickLog)',
        (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await openForm(tester, db, date: '2026-06-15');

      // TextField order (conditionals hidden): screenTime(0), steps(1), note(2).
      await tester.enterText(find.byType(TextField).at(1), '8500');
      await tester.tap(find.text('Запази отчета'));
      await tester.pumpAndSettle();

      final svc = StepsService(db.stepsDao);
      final row = await svc.forDate('2026-06-15');
      expect(row, isNotNull);
      expect(row!.count, 8500);
      expect(row.source, StepsSource.dailyQuickLog);
      expect(await svc.isLockedForDaily('2026-06-15'), isTrue);
    });
  });

  testWidgets('daily screen renders today from seeded data', (tester) async {
    tester.view.physicalSize = const Size(420, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MaterialApp(home: Scaffold(body: DailyScreen())),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Дневен отчет'), findsOneWidget); // top bar title
    expect(find.text('НАСТРОЕНИЕ'), findsOneWidget); // mood hero eyebrow

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
