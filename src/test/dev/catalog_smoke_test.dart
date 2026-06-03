// Smoke test: the whole component catalog builds without render exceptions —
// exercises every shared widget + chart (incl. fl_chart, BackdropFilter, donuts).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/dev/catalog.dart';
import 'package:lifemaxxing/core/charts/sparkline.dart';
import 'package:lifemaxxing/core/charts/seg_ring.dart';
import 'package:lifemaxxing/core/charts/mood_gauge.dart';
import '../support/test_env.dart';

void main() {
  testWidgets('ComponentCatalog builds with no exceptions', (tester) async {
    tester.view.physicalSize = const Size(1000, 6000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      localizedApp(home: Scaffold(body: ComponentCatalog())),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    // A representative widget + chart from top, middle and bottom rendered.
    expect(find.byType(Sparkline), findsOneWidget);
    expect(find.byType(SegRing), findsOneWidget);
    expect(find.byType(MoodGauge), findsOneWidget);
  });
}
