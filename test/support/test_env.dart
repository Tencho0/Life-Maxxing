// Shared widget-test helpers (see CLAUDE.md §6).
//
// 1) useDeterministicTestEnv(): zero the toast auto-dismiss timer and fl_chart
//    animation durations for the test, so `pumpAndSettle` terminates (no
//    perpetual chart frames, no lingering toast Timer at teardown) and saves
//    that fire a toast don't leave a pending timer.
// 2) settleData(): for screens whose data arrives from async drift streams —
//    flush real async (FakeAsync won't advance stream timers via bare await),
//    then settle. Pair with useDeterministicTestEnv() so the loading spinner +
//    charts settle once data is in.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lifemaxxing/core/charts/chart_anim.dart';
import 'package:lifemaxxing/core/widgets/lm_toast.dart';

/// Zeroes toast + chart animation durations for the current test, restoring
/// them on teardown. Call from `setUp`.
void useDeterministicTestEnv() {
  final prevToast = lmToastDuration;
  final prevChart = lmChartAnimationDuration;
  lmToastDuration = Duration.zero;
  lmChartAnimationDuration = Duration.zero;
  addTearDown(() {
    lmToastDuration = prevToast;
    lmChartAnimationDuration = prevChart;
  });
}

/// Lets async drift query streams emit (real async, not FakeAsync), then renders
/// with **bounded** pumps. Never uses `pumpAndSettle` — a loading spinner (and,
/// without zeroed durations, chart animations) would make it loop until the
/// 10-minute test timeout. Pair with [useDeterministicTestEnv].
///
/// For screens you can also await the specific providers inside [runAsync] for
/// determinism — see the finance screen test.
Future<void> settleData(
  WidgetTester tester, {
  Duration flush = const Duration(milliseconds: 200),
}) async {
  await tester.runAsync(() => Future<void>.delayed(flush));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

/// The ProviderScope container for a mounted widget found by [finder].
ProviderContainer containerFor(WidgetTester tester, Finder finder) =>
    ProviderScope.containerOf(tester.element(finder));
