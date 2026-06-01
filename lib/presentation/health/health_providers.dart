// Health providers: one stream per sub-module (BP / meds in range, events /
// labs all) → combined HealthSummary (last BP, averages, counts, last dental/
// lab). BP + meds are range-bound; events + labs are shown in full (infrequent).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../data/summaries.dart' show computeHealth;
import '../../domain/enums.dart';
import '../../domain/period.dart';
import '../../domain/summaries.dart';

final healthDaoProvider =
    Provider((ref) => ref.watch(databaseProvider).healthDao);

/// Selected period for the BP chart / vitals (default: last 30 days).
final healthPeriodProvider = StateProvider<Period>((_) => Period.last30);
final healthCustomRangeProvider = StateProvider<DateRange?>((_) => null);

final healthRangeProvider = Provider<DateRange>((ref) {
  final p = ref.watch(healthPeriodProvider);
  if (p == Period.custom) {
    return ref.watch(healthCustomRangeProvider) ?? resolveRange(Period.last30);
  }
  return resolveRange(p);
});

final bpInRangeProvider =
    StreamProvider.autoDispose<List<BloodPressureLog>>((ref) {
  final r = ref.watch(healthRangeProvider);
  return ref.watch(healthDaoProvider).watchBpInRange(r.from, r.to);
});

final medsInRangeProvider =
    StreamProvider.autoDispose<List<MedicationLog>>((ref) {
  final r = ref.watch(healthRangeProvider);
  return ref.watch(healthDaoProvider).watchMedsInRange(r.from, r.to);
});

final eventsProvider = StreamProvider.autoDispose<List<HealthEvent>>(
    (ref) => ref.watch(healthDaoProvider).watchEvents());

final labsProvider = StreamProvider.autoDispose<List<LabTest>>(
    (ref) => ref.watch(healthDaoProvider).watchLabs());

/// Combined summary across the four sub-modules.
final healthSummaryProvider =
    Provider.autoDispose<AsyncValue<HealthSummary>>((ref) {
  final bp = ref.watch(bpInRangeProvider);
  final meds = ref.watch(medsInRangeProvider);
  final events = ref.watch(eventsProvider);
  final labs = ref.watch(labsProvider);
  if (bp.isLoading || meds.isLoading || events.isLoading || labs.isLoading) {
    return const AsyncValue.loading();
  }
  final err = bp.asError ?? meds.asError ?? events.asError ?? labs.asError;
  if (err != null) return AsyncValue.error(err.error, err.stackTrace);
  return AsyncValue.data(computeHealth(
      bp.requireValue, events.requireValue, labs.requireValue, meds.requireValue));
});
