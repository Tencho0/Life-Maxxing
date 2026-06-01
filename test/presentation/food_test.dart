import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/domain/period.dart';
import 'package:lifemaxxing/presentation/food/food_forms.dart';
import 'package:lifemaxxing/presentation/food/food_providers.dart';
import 'package:lifemaxxing/presentation/food/food_screen.dart';
import '../support/test_env.dart';

MealsCompanion _meal(String id, String date, String name, MealType type,
        {int? cals, double? protein, double? carbs, double? fat, String? note}) =>
    MealsCompanion.insert(
      id: id, date: date, name: name, type: type,
      calories: Value(cals), protein: Value(protein),
      carbs: Value(carbs), fat: Value(fat), note: Value(note),
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    );

void main() {
  setUp(useDeterministicTestEnv);

  group('food providers (reactive summary)', () {
    test('summary reflects meals for the custom range (nulls ignored)', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      addTearDown(container.dispose);

      container.read(foodCustomRangeProvider.notifier).state =
          const DateRange('2026-06-01', '2026-06-30');
      container.read(foodPeriodProvider.notifier).state = Period.custom;

      await db.mealsDao.save(_meal(
          'm1', '2026-06-05', 'Закуска', MealType.breakfast,
          cals: 420, protein: 14));
      await db.mealsDao.save(
          _meal('m2', '2026-06-06', 'Обяд', MealType.lunch, cals: 680, protein: 52));
      // No nutrition → contributes to count/byType only.
      await db.mealsDao
          .save(_meal('m3', '2026-06-07', 'Снакче', MealType.snack));

      container.listen(foodMealsProvider, (_, _) {});
      final meals = await container.read(foodMealsProvider.future);
      expect(meals.length, 3);

      final s = container.read(foodSummaryProvider);
      expect(s.hasValue, isTrue);
      expect(s.requireValue.totalCalories, 1100);
      expect(s.requireValue.totalProtein, 66);
      expect(s.requireValue.mealCount, 3);
      expect(s.requireValue.byType[MealType.breakfast], 1);
      expect(s.requireValue.byType[MealType.snack], 1);
    });

    test('daily totals ignore unfilled nutrition fields', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      addTearDown(container.dispose);

      await db.mealsDao.save(
          _meal('m1', '2026-06-02', 'A', MealType.breakfast, cals: 420, protein: 14));
      await db.mealsDao.save(_meal('m2', '2026-06-02', 'B', MealType.lunch));

      container.listen(foodDailyTotalsProvider('2026-06-02'), (_, _) {});
      final day = await container.read(foodDailyTotalsProvider('2026-06-02').future);
      expect(day.calories, 420);
      expect(day.protein, 14);
      expect(day.mealCount, 2);
    });
  });

  group('food form', () {
    Future<void> openForm(WidgetTester tester, AppDatabase db) async {
      tester.view.physicalSize = const Size(500, 2400); // tall: whole form fits
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
                  onPressed: () => showFoodSheet(context),
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

    testWidgets('requires a name', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await openForm(tester, db);

      await tester.tap(find.text('Запази'));
      await tester.pumpAndSettle();
      expect(find.text('Името е задължително'), findsOneWidget);
      expect(await db.select(db.meals).get(), isEmpty);
    });

    testWidgets('saves a valid meal (calories + macros + nameLower)',
        (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await openForm(tester, db);

      // TextField order: name(0), time(1), calories(2), protein(3), carbs(4),
      // fat(5), quantity(6), note(7).
      await tester.enterText(find.byType(TextField).at(0), 'Пилешко с ориз');
      await tester.enterText(find.byType(TextField).at(2), '680');
      await tester.enterText(find.byType(TextField).at(3), '52');
      await tester.tap(find.text('Запази'));
      await tester.pumpAndSettle();

      final rows = await db.select(db.meals).get();
      expect(rows, hasLength(1));
      expect(rows.first.name, 'Пилешко с ориз');
      expect(rows.first.nameLower, 'пилешко с ориз'); // *Lower via DAO
      expect(rows.first.calories, 680);
      expect(rows.first.protein, 52);
    });
  });

  test('meals are searchable by name and note (Cyrillic-safe)', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    await db.mealsDao.save(_meal(
        'm1', '2026-06-05', 'Овесена каша', MealType.breakfast,
        note: 'с боровинки'));

    expect((await db.searchDao.search('ОВЕСЕНА')).any((h) => h.id == 'm1'), isTrue);
    expect(
        (await db.searchDao.search('боровинки')).any((h) => h.id == 'm1'), isTrue);
  });

  testWidgets('food screen renders from seeded data', (tester) async {
    tester.view.physicalSize = const Size(420, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db); // anchored to now → recent days have meals

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MaterialApp(home: Scaffold(body: FoodScreen())),
    ));
    await tester.pump(); // loading frame
    await tester.pump(const Duration(milliseconds: 300)); // drift streams emit
    await tester.pump(const Duration(milliseconds: 50)); // chart anim (zeroed)

    expect(find.text('Храна'), findsOneWidget); // top bar title
    expect(find.text('КАЛОРИИ'), findsOneWidget); // eyebrow (uppercased)

    // Flush drift's stream-close Timer before teardown.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
