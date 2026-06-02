// Home providers — the trailing-7-day window (rails) and today's cross-module
// timeline, each combined from the relevant DAO streams (read-only dashboard).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/database.dart';
import 'home_data.dart';

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Today's date (yyyy-MM-dd).
final homeTodayProvider = Provider<String>((_) => _ymd(DateTime.now()));

/// The seven day-keys ending today (oldest → newest).
final homeWeekDaysProvider = Provider<List<String>>((ref) {
  final today = DateTime.parse(ref.watch(homeTodayProvider));
  return [
    for (var i = 6; i >= 0; i--)
      _ymd(DateTime(today.year, today.month, today.day - i)),
  ];
});

// ── Week streams ────────────────────────────────────────────────────
final _weekLogsProvider = StreamProvider.autoDispose<List<DailyLog>>((ref) {
  final days = ref.watch(homeWeekDaysProvider);
  return ref.watch(databaseProvider).dailyLogsDao.watchInRange(days.first, days.last);
});
final _weekStepsProvider = StreamProvider.autoDispose<List<StepEntry>>((ref) {
  final days = ref.watch(homeWeekDaysProvider);
  return ref.watch(databaseProvider).stepsDao.watchInRange(days.first, days.last);
});
final _weekExpensesProvider = StreamProvider.autoDispose<List<Expense>>((ref) {
  final days = ref.watch(homeWeekDaysProvider);
  return ref
      .watch(databaseProvider)
      .financeDao
      .watchExpensesInRange(days.first, days.last);
});
final _weekBpProvider = StreamProvider.autoDispose<List<BloodPressureLog>>((ref) {
  final days = ref.watch(homeWeekDaysProvider);
  return ref.watch(databaseProvider).healthDao.watchBpInRange(days.first, days.last);
});

final homeWeekProvider = Provider.autoDispose<AsyncValue<HomeWeek>>((ref) {
  final days = ref.watch(homeWeekDaysProvider);
  final logs = ref.watch(_weekLogsProvider);
  final steps = ref.watch(_weekStepsProvider);
  final exp = ref.watch(_weekExpensesProvider);
  final bp = ref.watch(_weekBpProvider);
  if (logs.isLoading || steps.isLoading || exp.isLoading || bp.isLoading) {
    return const AsyncValue.loading();
  }
  final err = logs.asError ?? steps.asError ?? exp.asError ?? bp.asError;
  if (err != null) return AsyncValue.error(err.error, err.stackTrace);
  return AsyncValue.data(computeHomeWeek(
    days: days,
    logs: logs.requireValue,
    steps: steps.requireValue,
    expenses: exp.requireValue,
    bp: bp.requireValue,
  ));
});

// ── Today streams (timeline) ────────────────────────────────────────
final _todayMealsProvider = StreamProvider.autoDispose<List<Meal>>((ref) =>
    ref.watch(databaseProvider).mealsDao.watchByDate(ref.watch(homeTodayProvider)));
final _todayActivitiesProvider = StreamProvider.autoDispose<List<Activity>>(
    (ref) => ref
        .watch(databaseProvider)
        .activitiesDao
        .watchByDate(ref.watch(homeTodayProvider)));
final _todayExpensesProvider = StreamProvider.autoDispose<List<Expense>>((ref) {
  final t = ref.watch(homeTodayProvider);
  return ref.watch(databaseProvider).financeDao.watchExpensesInRange(t, t);
});
final _todayBpProvider = StreamProvider.autoDispose<List<BloodPressureLog>>((ref) {
  final t = ref.watch(homeTodayProvider);
  return ref.watch(databaseProvider).healthDao.watchBpInRange(t, t);
});
final _todayMedsProvider = StreamProvider.autoDispose<List<MedicationLog>>((ref) =>
    ref.watch(databaseProvider).healthDao.watchMedsByDate(ref.watch(homeTodayProvider)));

final homeTimelineProvider =
    Provider.autoDispose<AsyncValue<List<TimelineItem>>>((ref) {
  final meals = ref.watch(_todayMealsProvider);
  final acts = ref.watch(_todayActivitiesProvider);
  final exp = ref.watch(_todayExpensesProvider);
  final bp = ref.watch(_todayBpProvider);
  final meds = ref.watch(_todayMedsProvider);
  if (meals.isLoading ||
      acts.isLoading ||
      exp.isLoading ||
      bp.isLoading ||
      meds.isLoading) {
    return const AsyncValue.loading();
  }
  final err = meals.asError ??
      acts.asError ??
      exp.asError ??
      bp.asError ??
      meds.asError;
  if (err != null) return AsyncValue.error(err.error, err.stackTrace);
  return AsyncValue.data(buildTodayTimeline(
    meals: meals.requireValue,
    activities: acts.requireValue,
    expenses: exp.requireValue,
    bp: bp.requireValue,
    meds: meds.requireValue,
  ));
});
