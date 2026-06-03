import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/domain/period.dart';
import 'package:lifemaxxing/presentation/activities/activity_forms.dart';
import 'package:lifemaxxing/presentation/activities/activity_providers.dart';
import 'package:lifemaxxing/presentation/activities/activity_screen.dart';
import '../support/test_env.dart';

ActivitiesCompanion _act(String id, String date, ActivityType type,
        {String? name, int? dur}) =>
    ActivitiesCompanion.insert(
      id: id, date: date, type: type,
      name: Value(name), durationMin: Value(dur),
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    );

void main() {
  setUp(useDeterministicTestEnv);

  ProviderContainer customRange(AppDatabase db) {
    final c = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    c.read(activityCustomRangeProvider.notifier).state =
        const DateRange('2026-06-01', '2026-06-30');
    c.read(activityPeriodProvider.notifier).state = Period.custom;
    return c;
  }

  group('activity providers', () {
    test('summary groups by activity group + most frequent', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final container = customRange(db);
      addTearDown(container.dispose);

      await db.activitiesDao.save(_act('a1', '2026-06-05', ActivityType.gym, dur: 60));
      await db.activitiesDao.save(_act('a2', '2026-06-06', ActivityType.gym, dur: 50));
      await db.activitiesDao.save(_act('a3', '2026-06-07', ActivityType.bjj, dur: 90));

      container.listen(activitiesInRangeProvider, (_, _) {});
      await container.read(activitiesInRangeProvider.future);

      final s = container.read(activitySummaryProvider);
      expect(s.hasValue, isTrue);
      expect(s.requireValue.count, 3);
      expect(s.requireValue.totalMinutes, 200);
      expect(s.requireValue.strengthCount, 2); // gym → strength
      expect(s.requireValue.combatCount, 1); // bjj → combat
      expect(s.requireValue.mostFrequent, ActivityType.gym);
    });

    test('type filter narrows the list (summary stays full-range)', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final container = customRange(db);
      addTearDown(container.dispose);

      await db.activitiesDao.save(_act('a1', '2026-06-05', ActivityType.gym));
      await db.activitiesDao.save(_act('a2', '2026-06-06', ActivityType.gym));
      await db.activitiesDao.save(_act('a3', '2026-06-07', ActivityType.bjj));

      container.listen(activitiesInRangeProvider, (_, _) {});
      await container.read(activitiesInRangeProvider.future);

      container.read(activityTypeFilterProvider.notifier).state = ActivityType.gym;
      final list = container.read(activitiesProvider);
      expect(list, hasLength(2));
      expect(list.every((a) => a.type == ActivityType.gym), isTrue);
      // Summary reflects the whole range, not the filter.
      expect(container.read(activitySummaryProvider).requireValue.count, 3);
    });
  });

  group('activity form', () {
    Future<void> openForm(WidgetTester tester, AppDatabase db) async {
      tester.view.physicalSize = const Size(500, 2600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: localizedApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () => showActivitySheet(context),
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

    testWidgets('accepts an activity with no name (name optional)', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await openForm(tester, db);

      await tester.tap(find.text('Запази')); // default type, no name
      await tester.pumpAndSettle();

      final rows = await db.select(db.activities).get();
      expect(rows, hasLength(1));
      expect(rows.first.name, isNull);
      expect(rows.first.type, ActivityType.gym); // default
    });

    testWidgets('rejects a non-positive duration', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await openForm(tester, db);

      // TextField order: name(0), start(1), end(2), duration(3), note(4).
      await tester.enterText(find.byType(TextField).at(3), '0');
      await tester.tap(find.text('Запази'));
      await tester.pumpAndSettle();
      expect(find.text('Времетраенето трябва да е > 0'), findsOneWidget);
      expect(await db.select(db.activities).get(), isEmpty);
    });
  });

  testWidgets('activities screen renders from seeded data', (tester) async {
    tester.view.physicalSize = const Size(420, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: Scaffold(body: ActivityScreen())),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Активности'), findsOneWidget); // top bar title
    expect(find.text('ПО ГРУПИ'), findsOneWidget); // eyebrow (uppercased)

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
