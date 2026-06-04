// Weight entry sheet — one-per-day create/edit. Saving parses kg → integer
// grams; saving again for the same date edits the row (no duplicate).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/presentation/health/health_forms.dart';
import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  Future<void> openAndSave(WidgetTester tester, AppDatabase db, String kg,
      {String date = '2026-05-01'}) async {
    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(
        home: Builder(
          builder: (ctx) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showWeightSheet(ctx, date: date),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, kg);
    await tester.tap(find.text('Запази')); // actionSave (bg)
    await tester.pumpAndSettle();
  }

  testWidgets('saving a weight creates one entry (kg → grams)', (tester) async {
    tester.view.physicalSize = const Size(420, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);

    await openAndSave(tester, db, '82.5');

    final rows = await db.weightDao.inRange('2026-01-01', '2026-12-31');
    expect(rows.length, 1);
    expect(rows.single.weightGrams, 82500);
  });

  testWidgets('saving again for the same date edits, not duplicates',
      (tester) async {
    tester.view.physicalSize = const Size(420, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);

    await openAndSave(tester, db, '82.5');
    await openAndSave(tester, db, '81.0'); // same default date

    final rows = await db.weightDao.inRange('2026-01-01', '2026-12-31');
    expect(rows.length, 1); // still one row for the date
    expect(rows.single.weightGrams, 81000);
  });
}
