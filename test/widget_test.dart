// App-shell smoke test: tabs switch, the FAB opens the quick-log chooser, and
// module navigation pushes a screen with a working back button.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/app/app.dart';
import 'package:lifemaxxing/core/icons/lm_icons.dart';

void main() {
  testWidgets('shell: tabs, FAB sheet, push + back', (tester) async {
    // Tall surface so the full module list builds (Backup & Restore is last).
    tester.view.physicalSize = const Size(500, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LifeMaxxingApp());
    await tester.pumpAndSettle();

    // Home tab + persistent bottom nav.
    expect(find.text('Начало — предстои (Phase 7)'), findsOneWidget);
    expect(find.text('Графики'), findsWidgets);
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
    expect(find.text('Храна'), findsOneWidget); // a quick action
    await tester.tapAt(const Offset(10, 10)); // dismiss via scrim
    await tester.pumpAndSettle();

    // More → push a module → back returns to More.
    await tester.tap(find.text('Още'));
    await tester.pumpAndSettle();
    expect(find.text('Всички модули'), findsOneWidget);

    // Use a still-placeholder module (the feature verticals are now real,
    // DB-backed screens; Backup & Restore lands in Phase 8).
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
