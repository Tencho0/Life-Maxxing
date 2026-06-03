// Activity providers: period → range → live activities stream → computed
// ActivitySummary (counts by group, total/avg time, most frequent). A separate
// type-filter narrows the *list* client-side while the summary stays full-range
// (spec §7.6/§7.7).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../data/summaries.dart' show computeActivities;
import '../../domain/enums.dart';
import '../../domain/period.dart';
import '../../domain/summaries.dart';

final activitiesDaoProvider =
    Provider((ref) => ref.watch(databaseProvider).activitiesDao);

/// Selected period for the Activities screen (default: last 30 days).
final activityPeriodProvider = StateProvider<Period>((_) => Period.last30);

/// Custom range, used only when [activityPeriodProvider] is [Period.custom].
final activityCustomRangeProvider = StateProvider<DateRange?>((_) => null);

/// Optional type filter for the records list (null = all).
final activityTypeFilterProvider = StateProvider<ActivityType?>((_) => null);

final activityRangeProvider = Provider<DateRange>((ref) {
  final p = ref.watch(activityPeriodProvider);
  if (p == Period.custom) {
    return ref.watch(activityCustomRangeProvider) ?? resolveRange(Period.last30);
  }
  return resolveRange(p);
});

/// All activities in the selected range (unfiltered — drives the summary).
final activitiesInRangeProvider =
    StreamProvider.autoDispose<List<Activity>>((ref) {
  final r = ref.watch(activityRangeProvider);
  return ref.watch(activitiesDaoProvider).watchInRange(r.from, r.to);
});

/// Period summary, computed over the full (unfiltered) range.
final activitySummaryProvider =
    Provider.autoDispose<AsyncValue<ActivitySummary>>((ref) =>
        ref.watch(activitiesInRangeProvider).whenData(computeActivities));

/// The records list — the range's activities narrowed by the active type filter.
final activitiesProvider = Provider.autoDispose<List<Activity>>((ref) {
  final all =
      ref.watch(activitiesInRangeProvider).asData?.value ?? const <Activity>[];
  final type = ref.watch(activityTypeFilterProvider);
  return type == null ? all : all.where((a) => a.type == type).toList();
});
