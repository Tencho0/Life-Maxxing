// Stats providers: one period drives the range for every chart card; each
// metric streams its rows over that range (mood, expense/income, steps, BP).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../domain/period.dart';

final statsPeriodProvider = StateProvider<Period>((_) => Period.last30);
final statsCustomRangeProvider = StateProvider<DateRange?>((_) => null);

final statsRangeProvider = Provider<DateRange>((ref) {
  final p = ref.watch(statsPeriodProvider);
  if (p == Period.custom) {
    return ref.watch(statsCustomRangeProvider) ?? resolveRange(Period.last30);
  }
  return resolveRange(p);
});

final statsDailyLogsProvider = StreamProvider.autoDispose<List<DailyLog>>((ref) {
  final r = ref.watch(statsRangeProvider);
  return ref.watch(databaseProvider).dailyLogsDao.watchInRange(r.from, r.to);
});

final statsStepsProvider = StreamProvider.autoDispose<List<StepEntry>>((ref) {
  final r = ref.watch(statsRangeProvider);
  return ref.watch(databaseProvider).stepsDao.watchInRange(r.from, r.to);
});

final statsExpensesProvider = StreamProvider.autoDispose<List<Expense>>((ref) {
  final r = ref.watch(statsRangeProvider);
  return ref.watch(databaseProvider).financeDao.watchExpensesInRange(r.from, r.to);
});

final statsIncomeProvider = StreamProvider.autoDispose<List<IncomeEntry>>((ref) {
  final r = ref.watch(statsRangeProvider);
  return ref.watch(databaseProvider).financeDao.watchIncomeInRange(r.from, r.to);
});

final statsBpProvider = StreamProvider.autoDispose<List<BloodPressureLog>>((ref) {
  final r = ref.watch(statsRangeProvider);
  return ref.watch(databaseProvider).healthDao.watchBpInRange(r.from, r.to);
});
