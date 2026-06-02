// App-shell smoke test: the DB-backed Home boots, tabs switch, the FAB opens the
// quick-log chooser, and module navigation pushes a screen with a working back
// button. Boots the real router with an in-memory DB override.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/app/router.dart';
import 'package:lifemaxxing/core/icons/lm_icons.dart';
import 'package:lifemaxxing/core/theme/theme.dart';
import 'package:lifemaxxing/data/database.dart';
import 'support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  testWidgets('shell: tabs, FAB sheet, push + back', (tester) async {
    // Tall surface so the full module list builds (Backup & Restore is last).
    tester.view.physicalSize = const Size(500, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: MaterialApp.router(theme: AppTheme.dark, routerConfig: appRouter),
    ));
    await tester.pump(); // first frame
    await tester.pump(const Duration(milliseconds: 300)); // Home drift streams
    await tester.pump(const Duration(milliseconds: 50));

    // DB-backed Home + persistent bottom nav.
    expect(find.textContaining('Мартин'), findsOneWidget);
    expect(find.text('Още'), findsWidgets);

    // Switch to the Графики tab.
    await tester.tap(find.text('Графики'));
    await tester.pumpAndSettle();
    expect(find.text('Графики — предстои (Phase 7)'), findsOneWidget);

    // FAB opens the quick-log chooser.
    await tester.tap(
      find.byWidgetPredicate((w) => w is LmIcon && w.icon == LmIcons.plus),
    );
    await tester.pumpAndSettle();
    expect(find.text('Бързо логване'), findsOneWidget);
    await tester.tapAt(const Offset(10, 10)); // dismiss via scrim
    await tester.pumpAndSettle();

    // More → push a still-placeholder module → back returns to More.
    await tester.tap(find.text('Още'));
    await tester.pumpAndSettle();
    expect(find.text('Всички модули'), findsOneWidget);

    await tester.tap(find.text('Backup & Restore'));
    await tester.pumpAndSettle();
    expect(find.text('Backup & Restore — предстои (Phase 7)'), findsOneWidget);

    await tester.tap(
      find.byWidgetPredicate((w) => w is LmIcon && w.icon == LmIcons.chevL),
    );
    await tester.pumpAndSettle();
    expect(find.text('Всички модули'), findsOneWidget);
  });
}
