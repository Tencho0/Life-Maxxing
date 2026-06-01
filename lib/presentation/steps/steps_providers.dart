// Steps providers: period → range → live steps stream → StepsSummary, plus
// today's entry (independent of the selected period, for the hero ring) and the
// StepsService (the one-per-date create/edit path, spec §18 / §3.5).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../data/summaries.dart' show computeSteps;
import '../../domain/enums.dart';
import '../../domain/period.dart';
import '../../domain/summaries.dart';
import '../../services/steps_service.dart';

final stepsDaoProvider = Provider((ref) => ref.watch(databaseProvider).stepsDao);

/// The one-per-date create/edit service (provenance-preserving).
final stepsServiceProvider =
    Provider((ref) => StepsService(ref.watch(stepsDaoProvider)));

/// Selected period for the Steps screen (default: last 30 days).
final stepsPeriodProvider = StateProvider<Period>((_) => Period.last30);

/// Custom range, used only when [stepsPeriodProvider] is [Period.custom].
final stepsCustomRangeProvider = StateProvider<DateRange?>((_) => null);

final stepsRangeProvider = Provider<DateRange>((ref) {
  final p = ref.watch(stepsPeriodProvider);
  if (p == Period.custom) {
    return ref.watch(stepsCustomRangeProvider) ?? resolveRange(Period.last30);
  }
  return resolveRange(p);
});

final stepsInRangeProvider = StreamProvider.autoDispose<List<StepEntry>>((ref) {
  final r = ref.watch(stepsRangeProvider);
  return ref.watch(stepsDaoProvider).watchInRange(r.from, r.to);
});

final stepsSummaryProvider = Provider.autoDispose<AsyncValue<StepsSummary>>(
    (ref) => ref.watch(stepsInRangeProvider).whenData(computeSteps));

/// Today's step entry (or null), independent of the selected period.
final todayStepsProvider = StreamProvider.autoDispose<StepEntry?>((ref) {
  final today = resolveRange(Period.today).from;
  return ref
      .watch(stepsDaoProvider)
      .watchInRange(today, today)
      .map((l) => l.isEmpty ? null : l.first);
});
