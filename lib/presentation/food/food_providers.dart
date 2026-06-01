// Food providers: period → date range → live meals stream → computed
// FoodSummary, plus a reactive per-date DailyNutrition (spec §6.6/§6.7).
// Editing any meal re-emits the stream and the summaries recompute.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../data/summaries.dart'
    show daysInclusive, computeFood, computeDailyNutrition;
import '../../domain/enums.dart';
import '../../domain/period.dart';
import '../../domain/summaries.dart';

final mealsDaoProvider = Provider((ref) => ref.watch(databaseProvider).mealsDao);

/// Selected period for the Food screen (default: last 7 days — a clean
/// calories-by-day week).
final foodPeriodProvider = StateProvider<Period>((_) => Period.last7);

/// Custom range, used only when [foodPeriodProvider] is [Period.custom].
final foodCustomRangeProvider = StateProvider<DateRange?>((_) => null);

final foodRangeProvider = Provider<DateRange>((ref) {
  final p = ref.watch(foodPeriodProvider);
  if (p == Period.custom) {
    return ref.watch(foodCustomRangeProvider) ?? resolveRange(Period.last7);
  }
  return resolveRange(p);
});

final foodMealsProvider = StreamProvider.autoDispose<List<Meal>>((ref) {
  final r = ref.watch(foodRangeProvider);
  return ref.watch(mealsDaoProvider).watchInRange(r.from, r.to);
});

/// Computed food summary for the selected range (calories/macros, per-day
/// averages, counts by type).
final foodSummaryProvider = Provider.autoDispose<AsyncValue<FoodSummary>>((ref) {
  final meals = ref.watch(foodMealsProvider);
  final r = ref.watch(foodRangeProvider);
  return meals
      .whenData((list) => computeFood(list, daysInclusive(r.from, r.to)));
});

/// Reactive single-day nutrition totals (spec §6.6) for [date]. Unfilled
/// nutrition fields don't contribute. Consumed by the Home/Daily slices.
final foodDailyTotalsProvider =
    StreamProvider.autoDispose.family<DailyNutrition, String>((ref, date) {
  return ref.watch(mealsDaoProvider).watchByDate(date).map(computeDailyNutrition);
});
