// Smoke test: the app boots into the design-system gallery (Phase 1).
// Replaced with router/screen tests as features land.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/main.dart';
import 'package:lifemaxxing/core/icons/lm_icons.dart';

void main() {
  testWidgets('app boots and renders the gallery (Cyrillic + icons)',
      (tester) async {
    // Tall surface so the lazy ListView builds all sections (incl. icons).
    tester.view.physicalSize = const Size(1000, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const LifeMaxxingApp());
    await tester.pumpAndSettle();

    // Cyrillic title renders (fonts wired).
    expect(find.text('LifeMaxxing · дизайн система'), findsOneWidget);
    // Icon set renders.
    expect(find.byType(LmIcon), findsWidgets);
  });
}
