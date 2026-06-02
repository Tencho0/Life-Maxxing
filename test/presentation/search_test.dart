import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/presentation/search/search_providers.dart';
import 'package:lifemaxxing/presentation/search/search_screen.dart';
import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  Future<void> seedAcross(AppDatabase db) async {
    final ts = DateTime.utc(2026);
    await db.mealsDao.save(MealsCompanion.insert(
      id: 'm1', date: '2026-06-01', name: 'Спортна напитка',
      type: MealType.snack, createdAt: ts, updatedAt: ts,
    ));
    await db.financeDao.saveExpense(ExpensesCompanion.insert(
      id: 'e1', date: '2026-06-01', amountCents: 5000,
      category: ExpenseCategory.sport, description: 'Спортен магазин',
      createdAt: ts, updatedAt: ts,
    ));
    await db.bucketDao.saveItem(BucketItemsCompanion.insert(
      id: 'b1', title: 'Спортна цел', priority: BucketPriority.medium,
      status: BucketStatus.idea, createdAt: ts, updatedAt: ts,
    ));
    await db.activitiesDao.save(ActivitiesCompanion.insert(
      id: 'a1', date: '2026-06-01', type: ActivityType.other,
      name: const Value('Спортен ден'), createdAt: ts, updatedAt: ts,
    ));
  }

  test('search results span ≥3 modules for a Cyrillic query', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedAcross(db);
    final container =
        ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
    addTearDown(container.dispose);

    container.read(searchQueryProvider.notifier).state = 'СПОРТ'; // upper → lower
    final results = await container.read(searchResultsProvider.future);
    final kinds = results.map((h) => h.kind).toSet();
    expect(kinds.length, greaterThanOrEqualTo(3));
    expect(results.any((h) => h.title == 'Спортна напитка'), isTrue);
  });

  test('empty query returns no results', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedAcross(db);
    final container =
        ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
    addTearDown(container.dispose);

    container.read(searchQueryProvider.notifier).state = '   ';
    expect(await container.read(searchResultsProvider.future), isEmpty);
  });

  testWidgets('search screen shows results as you type', (tester) async {
    tester.view.physicalSize = const Size(420, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedAcross(db);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MaterialApp(home: Scaffold(body: SearchScreen())),
    ));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'спортна напитка');
    await tester.pumpAndSettle();
    expect(find.text('Спортна напитка'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
