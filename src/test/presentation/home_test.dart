import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/l10n/app_localizations.dart';
import 'package:lifemaxxing/presentation/home/home_data.dart';
import 'package:lifemaxxing/presentation/home/home_screen.dart';
import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);
  // The home header formats a locale-aware long date (weekday + month names).
  setUp(() async {
    await initializeDateFormatting('bg');
    await initializeDateFormatting('en');
  });

  test('computeHomeWeek builds aligned 7-day series + averages', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final ts = DateTime.utc(2026);
    final days = [for (var d = 1; d <= 7; d++) '2026-06-0$d'];

    await db.dailyLogsDao.save(DailyLogsCompanion.insert(
      id: 'l1', date: '2026-06-01', mood: 8, proud: true,
      didUncomfortable: false, workout: true, drankAlcohol: false,
      createdAt: ts, updatedAt: ts,
    ));
    await db.dailyLogsDao.save(DailyLogsCompanion.insert(
      id: 'l2', date: '2026-06-02', mood: 6, proud: true,
      didUncomfortable: false, workout: false, drankAlcohol: false,
      createdAt: ts, updatedAt: ts,
    ));
    await db.stepsDao.save(StepsCompanion.insert(
      id: 's1', date: '2026-06-01', count: 10000,
      source: StepsSource.stepsModule, createdAt: ts, updatedAt: ts,
    ));
    await db.financeDao.saveExpense(ExpensesCompanion.insert(
      id: 'e1', date: '2026-06-01', amountCents: 1000,
      category: ExpenseCategory.food, description: 'A',
      createdAt: ts, updatedAt: ts,
    ));
    await db.financeDao.saveExpense(ExpensesCompanion.insert(
      id: 'e2', date: '2026-06-01', amountCents: 2000,
      category: ExpenseCategory.transport, description: 'B',
      createdAt: ts, updatedAt: ts,
    ));
    await db.healthDao.saveBp(BloodPressureLogsCompanion.insert(
      id: 'b1', date: '2026-06-01', time: '08:00',
      systolic: 120, diastolic: 80, pulse: 60, createdAt: ts, updatedAt: ts,
    ));
    await db.healthDao.saveBp(BloodPressureLogsCompanion.insert(
      id: 'b2', date: '2026-06-02', time: '08:00',
      systolic: 124, diastolic: 78, pulse: 80, createdAt: ts, updatedAt: ts,
    ));

    final week = computeHomeWeek(
      days: days,
      logs: await db.dailyLogsDao.inRange(days.first, days.last),
      steps: await db.stepsDao.inRange(days.first, days.last),
      expenses: await db.financeDao.expensesInRange(days.first, days.last),
      bp: await (db.select(db.bloodPressureLogs)).get(),
    );

    expect(week.mood, hasLength(7));
    expect(week.mood[0], 8);
    expect(week.avgMood, 7); // (8 + 6) / 2
    expect(week.steps[0], 10000);
    expect(week.totalExpenseCents, 3000);
    expect(week.expense[0], 30.0); // euros
    expect(week.avgPulse, 70); // (60 + 80) / 2
  });

  test('buildTodayTimeline aggregates today rows (meds collapsed)', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final ts = DateTime.utc(2026);
    const today = '2026-06-02';

    await db.mealsDao.save(MealsCompanion.insert(
      id: 'm1', date: today, name: 'Овесена каша', type: MealType.breakfast,
      time: const Value('08:10'), calories: const Value(420),
      createdAt: ts, updatedAt: ts,
    ));
    await db.activitiesDao.save(ActivitiesCompanion.insert(
      id: 'a1', date: today, type: ActivityType.gym,
      name: const Value('Гръб'), durationMin: const Value(65),
      startTime: const Value('18:30'), createdAt: ts, updatedAt: ts,
    ));
    await db.financeDao.saveExpense(ExpensesCompanion.insert(
      id: 'e1', date: today, amountCents: 12000,
      category: ExpenseCategory.transport, description: 'Гориво',
      createdAt: ts, updatedAt: ts,
    ));
    await db.healthDao.saveBp(BloodPressureLogsCompanion.insert(
      id: 'b1', date: today, time: '08:20',
      systolic: 124, diastolic: 78, pulse: 71, createdAt: ts, updatedAt: ts,
    ));
    await db.healthDao.saveMed(MedicationLogsCompanion.insert(
      id: 'd1', date: today, time: '08:15', name: 'Витамин D3',
      type: MedType.vitamin, status: MedStatus.taken, createdAt: ts, updatedAt: ts,
    ));
    await db.healthDao.saveMed(MedicationLogsCompanion.insert(
      id: 'd2', date: today, time: '08:15', name: 'Омега-3',
      type: MedType.supplement, status: MedStatus.taken, createdAt: ts, updatedAt: ts,
    ));

    final items = buildTodayTimeline(
      l10n: lookupAppLocalizations(const Locale('bg')),
      meals: await db.mealsDao.watchByDate(today).first,
      activities: await db.activitiesDao.watchByDate(today).first,
      expenses: await db.financeDao.expensesInRange(today, today),
      bp: await (db.select(db.bloodPressureLogs)).get(),
      meds: await db.healthDao.watchMedsByDate(today).first,
    );

    // bp + meal + meds(collapsed) + activity + expense = 5 rows.
    expect(items, hasLength(5));
    expect(items.any((i) => i.title == 'Закуска'), isTrue);
    expect(items.any((i) => i.title.startsWith('Добавки · 2')), isTrue);
    expect(items.any((i) => i.title == 'Гръб'), isTrue);
    expect(items.any((i) => i.title == 'Гориво'), isTrue);
    expect(items.any((i) => i.title == '124/78'), isTrue);
  });

  testWidgets('home screen renders from seeded data', (tester) async {
    tester.view.physicalSize = const Size(420, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: Scaffold(body: HomeScreen())),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.textContaining('Martin'), findsOneWidget); // greeting
    expect(find.text('ТАЗИ СЕДМИЦА'), findsOneWidget); // eyebrow

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('home screen renders in English under the en locale',
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
      child: localizedApp(
          home: Scaffold(body: HomeScreen()), locale: const Locale('en')),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('THIS WEEK'), findsOneWidget); // localized eyebrow (en)

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
