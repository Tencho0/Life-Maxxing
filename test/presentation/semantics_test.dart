// Basic a11y: the bottom-nav tabs and the quick-log FAB expose button
// semantics with labels (Slice 9.2).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lifemaxxing/core/widgets/lm_bottom_nav.dart';
import '../support/test_env.dart';

void main() {
  testWidgets('bottom nav exposes labelled button semantics', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(localizedApp(
      home: Scaffold(
        bottomNavigationBar: LmBottomNav(
          currentLocation: '/',
          onTab: (_) {},
          onPlus: () {},
        ),
      ),
    ));

    expect(find.bySemanticsLabel('Бързо логване'), findsOneWidget); // FAB
    expect(find.bySemanticsLabel('Начало'), findsOneWidget); // home tab
    expect(find.bySemanticsLabel('Още'), findsOneWidget); // more tab

    handle.dispose();
  });
}
