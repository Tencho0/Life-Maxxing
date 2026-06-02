import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/domain/period.dart';
import 'package:lifemaxxing/presentation/finance/finance_forms.dart';
import 'package:lifemaxxing/presentation/finance/finance_providers.dart';
import 'package:lifemaxxing/presentation/finance/finance_screen.dart';
import '../support/test_env.dart';

ExpensesCompanion _exp(String id, String date, int cents, ExpenseCategory cat) =>
    ExpensesCompanion.insert(
      id: id, date: date, amountCents: cents, category: cat,
      description: 'X',
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    );

void main() {
  setUp(useDeterministicTestEnv);

  group('finance providers (reactive summary)', () {
    test('summary reflects expenses + income for the custom range', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      addTearDown(container.dispose);

      container.read(financeCustomRangeProvider.notifier).state =
          const DateRange('2026-06-01', '2026-06-30');
      container.read(financePeriodProvider.notifier).state = Period.custom;

      // Save first; then subscribe so the stream's first emission (.future)
      // reflects the full data (not an early empty snapshot).
      await db.financeDao.saveExpense(_exp('e1', '2026-06-05', 1000, ExpenseCategory.food));
      await db.financeDao.saveExpense(_exp('e2', '2026-06-06', 2000, ExpenseCategory.transport));
      await db.financeDao.saveIncome(IncomeCompanion.insert(
        id: 'i1', date: '2026-06-01', amountCents: 5000,
        source: 'Заплата', category: IncomeCategory.salary,
        createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
      ));

      container.listen(financeExpensesProvider, (_, _) {});
      container.listen(financeIncomeProvider, (_, _) {});
      final ex = await container.read(financeExpensesProvider.future);
      final inc = await container.read(financeIncomeProvider.future);
      expect(ex.length, 2); // range filter wiring
      expect(inc.length, 1);

      final s = container.read(financeSummaryProvider);
      expect(s.hasValue, isTrue);
      expect(s.requireValue.totalExpensesCents, 3000);
      expect(s.requireValue.totalIncomeCents, 5000);
      expect(s.requireValue.balanceCents, 2000);
      expect(s.requireValue.topCategory, ExpenseCategory.transport);
    });
  });

  group('expense form', () {
    Future<void> openForm(WidgetTester tester, AppDatabase db) async {
      tester.view.physicalSize = const Size(500, 2200); // tall: form fits
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
                  onPressed: () => showExpenseSheet(context),
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

    testWidgets('validates amount and description', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await openForm(tester, db);

      await tester.tap(find.text('Запази'));
      await tester.pumpAndSettle();
      expect(find.text('Въведи валидна сума (> 0)'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, '12.50');
      await tester.tap(find.text('Запази'));
      await tester.pumpAndSettle();
      expect(find.text('Описанието е задължително'), findsOneWidget);

      expect(await db.select(db.expenses).get(), isEmpty);
    });

    testWidgets('saves a valid expense (amount in cents)', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await openForm(tester, db);

      await tester.enterText(find.byType(TextField).at(0), '12.50');
      await tester.enterText(find.byType(TextField).at(1), 'Обяд');
      await tester.tap(find.text('Запази'));
      await tester.pumpAndSettle(); // toast timer is zeroed → settles cleanly

      final rows = await db.select(db.expenses).get();
      expect(rows, hasLength(1));
      expect(rows.first.amountCents, 1250);
      expect(rows.first.description, 'Обяд');
      expect(rows.first.descriptionLower, 'обяд'); // *Lower via DAO
    });
  });

  testWidgets('finance screen renders from seeded data', (tester) async {
    tester.view.physicalSize = const Size(420, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db); // anchored to now → current month has data

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: Scaffold(body: FinanceScreen())),
    ));
    await tester.pump(); // loading frame
    // Advance FakeAsync so the drift query streams emit (pump drives their
    // timers; awaiting .future / runAsync would deadlock against FakeAsync).
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 50)); // chart anim (zeroed)

    expect(find.text('Финанси'), findsOneWidget); // top bar title
    expect(find.text('БАЛАНС ЗА ПЕРИОДА'), findsOneWidget); // eyebrow (uppercased)
    expect(find.text('Разходи'), findsWidgets); // records tab

    // Unmount and flush drift's stream-close Timer so none is pending at
    // teardown (StreamQueryStore.markAsClosed schedules a zero-duration timer).
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
