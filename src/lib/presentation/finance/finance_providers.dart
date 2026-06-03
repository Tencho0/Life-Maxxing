// Finance providers: period → date range → live expense/income streams →
// computed FinanceSummary. Editing any record re-emits the streams and the
// summary recomputes automatically.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../data/summaries.dart' show daysInclusive, computeFinance;
import '../../domain/enums.dart';
import '../../domain/period.dart';
import '../../domain/summaries.dart';

final financeDaoProvider =
    Provider((ref) => ref.watch(databaseProvider).financeDao);

/// Selected period for the Finance screen (design default: current month).
final financePeriodProvider = StateProvider<Period>((_) => Period.thisMonth);

/// Custom range, used only when [financePeriodProvider] is [Period.custom].
final financeCustomRangeProvider = StateProvider<DateRange?>((_) => null);

final financeRangeProvider = Provider<DateRange>((ref) {
  final p = ref.watch(financePeriodProvider);
  if (p == Period.custom) {
    return ref.watch(financeCustomRangeProvider) ?? resolveRange(Period.thisMonth);
  }
  return resolveRange(p);
});

final financeExpensesProvider = StreamProvider.autoDispose<List<Expense>>((ref) {
  final r = ref.watch(financeRangeProvider);
  return ref.watch(financeDaoProvider).watchExpensesInRange(r.from, r.to);
});

final financeIncomeProvider =
    StreamProvider.autoDispose<List<IncomeEntry>>((ref) {
  final r = ref.watch(financeRangeProvider);
  return ref.watch(financeDaoProvider).watchIncomeInRange(r.from, r.to);
});

/// Combined, computed summary for the selected range.
final financeSummaryProvider =
    Provider.autoDispose<AsyncValue<FinanceSummary>>((ref) {
  final ex = ref.watch(financeExpensesProvider);
  final inc = ref.watch(financeIncomeProvider);
  final r = ref.watch(financeRangeProvider);
  if (ex.isLoading || inc.isLoading) return const AsyncValue.loading();
  final err = ex.asError ?? inc.asError;
  if (err != null) return AsyncValue.error(err.error, err.stackTrace);
  return AsyncValue.data(
    computeFinance(ex.requireValue, inc.requireValue, daysInclusive(r.from, r.to)),
  );
});
