import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/domain/period.dart';
import 'package:lifemaxxing/presentation/stats/stats_providers.dart';
import 'package:lifemaxxing/presentation/stats/stats_screen.dart';
import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  test('period drives the range; series providers stream in-range rows',
      () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final container =
        ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
    addTearDown(container.dispose);

    container.read(statsCustomRangeProvider.notifier).state =
        const DateRange('2026-06-01', '2026-06-30');
    container.read(statsPeriodProvider.notifier).state = Period.custom;
    expect(container.read(statsRangeProvider).from, '2026-06-01');

    await db.dailyLogsDao.save(DailyLogsCompanion.insert(
      id: 'l1', date: '2026-06-10', mood: 8, proud: true,
      didUncomfortable: false, workout: true, drankAlcohol: false,
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    ));
    // Out of range → excluded.
    await db.dailyLogsDao.save(DailyLogsCompanion.insert(
      id: 'l2', date: '2026-07-10', mood: 5, proud: true,
      didUncomfortable: false, workout: true, drankAlcohol: false,
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    ));

    container.listen(statsDailyLogsProvider, (_, _) {});
    final logs = await container.read(statsDailyLogsProvider.future);
    expect(logs, hasLength(1));
    expect(logs.first.id, 'l1');
  });

  testWidgets('stats screen renders chart cards from seeded data',
      (tester) async {
    tester.view.physicalSize = const Size(420, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: Scaffold(body: StatsScreen())),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Графики'), findsOneWidget); // top bar title
    expect(find.text('НАСТРОЕНИЕ'), findsOneWidget); // mood card eyebrow

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
