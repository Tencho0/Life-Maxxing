import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/domain/period.dart';
import 'package:lifemaxxing/presentation/health/health_format.dart';
import 'package:lifemaxxing/presentation/health/health_forms.dart';
import 'package:lifemaxxing/presentation/health/health_providers.dart';
import 'package:lifemaxxing/presentation/health/health_screen.dart';
import '../support/test_env.dart';

BloodPressureLogsCompanion _bp(String id, String date, String time, int s, int d,
        int p) =>
    BloodPressureLogsCompanion.insert(
      id: id, date: date, time: time, systolic: s, diastolic: d, pulse: p,
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    );

void main() {
  setUp(useDeterministicTestEnv);

  ProviderContainer customRange(AppDatabase db) {
    final c = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    c.read(healthCustomRangeProvider.notifier).state =
        const DateRange('2026-06-01', '2026-06-30');
    c.read(healthPeriodProvider.notifier).state = Period.custom;
    return c;
  }

  test('summary: last BP + averages over range', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final container = customRange(db);
    addTearDown(container.dispose);

    await db.healthDao.saveBp(_bp('b1', '2026-06-05', '08:00', 120, 80, 60));
    await db.healthDao.saveBp(_bp('b2', '2026-06-06', '08:00', 130, 84, 70));

    container.listen(bpInRangeProvider, (_, _) {});
    container.listen(medsInRangeProvider, (_, _) {});
    container.listen(eventsProvider, (_, _) {});
    container.listen(labsProvider, (_, _) {});
    await container.read(bpInRangeProvider.future);
    await container.read(medsInRangeProvider.future);
    await container.read(eventsProvider.future);
    await container.read(labsProvider.future);

    final s = container.read(healthSummaryProvider);
    expect(s.hasValue, isTrue);
    expect(s.requireValue.bpCount, 2);
    expect(s.requireValue.lastSystolic, 130); // most recent (2026-06-06)
    expect(s.requireValue.avgSystolic, 125);
    expect(s.requireValue.avgDiastolic, 82);
  });

  test('multiple BP entries per day are allowed', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final container = customRange(db);
    addTearDown(container.dispose);

    await db.healthDao.saveBp(_bp('b1', '2026-06-05', '08:00', 120, 80, 60));
    await db.healthDao.saveBp(_bp('b2', '2026-06-05', '20:00', 124, 78, 64));

    container.listen(bpInRangeProvider, (_, _) {});
    final rows = await container.read(bpInRangeProvider.future);
    expect(rows.where((b) => b.date == '2026-06-05'), hasLength(2));
  });

  test('nextDentalDate surfaces the latest dental visit recommendation', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    await db.healthDao.saveEvent(HealthEventsCompanion.insert(
      id: 'e1', date: '2026-01-10', type: HealthEventType.dentist,
      whatWasDone: 'Почистване',
      nextRecommendedDate: const Value('2026-07-10'),
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    ));
    await db.healthDao.saveEvent(HealthEventsCompanion.insert(
      id: 'e2', date: '2026-03-01', type: HealthEventType.doctor,
      whatWasDone: 'Преглед',
      nextRecommendedDate: const Value('2026-09-01'), // not dental → ignored
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    ));

    final events = await db.healthDao.watchEvents().first;
    expect(nextDentalDate(events), '2026-07-10');
  });

  Future<void> pumpForm(WidgetTester tester, AppDatabase db,
      void Function(BuildContext) open) async {
    tester.view.physicalSize = const Size(500, 2800);
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
                onPressed: () => open(context),
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

  testWidgets('BP form rejects systolic <= diastolic, then saves when valid',
      (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    await pumpForm(tester, db, showBpSheet);

    // TextField order: time(0), systolic(1), diastolic(2), pulse(3), note(4).
    await tester.enterText(find.byType(TextField).at(1), '120');
    await tester.enterText(find.byType(TextField).at(2), '130'); // dia > sys
    await tester.enterText(find.byType(TextField).at(3), '70');
    await tester.tap(find.text('Запази'));
    await tester.pumpAndSettle();
    expect(find.text('Систоличното трябва да е по-голямо от диастоличното'),
        findsOneWidget);
    expect(await db.select(db.bloodPressureLogs).get(), isEmpty);

    await tester.enterText(find.byType(TextField).at(2), '80'); // dia < sys
    await tester.tap(find.text('Запази'));
    await tester.pumpAndSettle();
    final rows = await db.select(db.bloodPressureLogs).get();
    expect(rows, hasLength(1));
    expect(rows.first.systolic, 120);
    expect(rows.first.diastolic, 80);
  });

  testWidgets('event subtype is saved only for the dentist type', (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    await pumpForm(tester, db, showEventSheet);

    // Default type = dentist. Fill required whatWasDone (TextField order:
    // clinic(0), reason(1), whatWasDone(2), note(3)).
    await tester.enterText(find.byType(TextField).at(2), 'Почистване');
    await tester.tap(find.text('Запази'));
    await tester.pumpAndSettle();

    var rows = await db.select(db.healthEvents).get();
    expect(rows, hasLength(1));
    expect(rows.first.type, HealthEventType.dentist);
    expect(rows.first.subtype, isNotNull); // dentist → subtype kept

    // Edit to a non-dentist type → subtype cleared.
    await pumpForm(tester, db, showEventSheet);
    await tester.enterText(find.byType(TextField).at(2), 'Преглед');
    await tester.tap(find.text('Лекар')); // switch type
    await tester.pumpAndSettle();
    await tester.tap(find.text('Запази'));
    await tester.pumpAndSettle();
    rows = await db.select(db.healthEvents).get();
    final doctor = rows.firstWhere((e) => e.type == HealthEventType.doctor);
    expect(doctor.subtype, isNull);
  });

  testWidgets('lab form requires lab + reason, then saves', (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    await pumpForm(tester, db, showLabSheet);

    await tester.tap(find.text('Запази'));
    await tester.pumpAndSettle();
    expect(find.text('Лаборатория и причина са задължителни'), findsOneWidget);

    // TextField order: lab(0), reason(1), results(2), note(3).
    await tester.enterText(find.byType(TextField).at(0), 'Цибалаб');
    await tester.enterText(find.byType(TextField).at(1), 'Хормони');
    await tester.tap(find.text('Запази'));
    await tester.pumpAndSettle();
    final rows = await db.select(db.labTests).get();
    expect(rows, hasLength(1));
    expect(rows.first.lab, 'Цибалаб');
    expect(rows.first.labLower, 'цибалаб');
    expect(rows.first.reason, 'Хормони');
  });

  testWidgets('health screen renders from seeded data', (tester) async {
    tester.view.physicalSize = const Size(420, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MaterialApp(home: Scaffold(body: HealthScreen())),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Здраве'), findsOneWidget); // top bar title
    expect(find.text('ВИТАЛНИ'), findsOneWidget); // eyebrow (uppercased)

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
