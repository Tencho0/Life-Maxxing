// Stats overview — one period selector drives four chart cards (mood, income vs
// expense, steps, blood pressure); each card links to its module (spec, Stats).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/charts/income_expense_bars.dart';
import '../../core/charts/lm_bar_chart.dart';
import '../../core/charts/sparkline.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/card.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/period_chips.dart';
import '../../core/widgets/screen_body.dart';
import '../../domain/enums.dart';
import '../../domain/period.dart';
import 'stats_providers.dart';

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

List<double> _align(DateRange range, double Function(String day) value) {
  final from = DateTime.parse(range.from);
  final to = DateTime.parse(range.to);
  final out = <double>[];
  for (var d = from; !d.isAfter(to); d = DateTime(d.year, d.month, d.day + 1)) {
    out.add(value(_ymd(d)));
  }
  return out;
}

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(statsPeriodProvider);
    final range = ref.watch(statsRangeProvider);
    final logs = ref.watch(statsDailyLogsProvider).asData?.value ?? const [];
    final steps = ref.watch(statsStepsProvider).asData?.value ?? const [];
    final expenses = ref.watch(statsExpensesProvider).asData?.value ?? const [];
    final income = ref.watch(statsIncomeProvider).asData?.value ?? const [];
    final bp = ref.watch(statsBpProvider).asData?.value ?? const [];

    final moodBy = {for (final l in logs) l.date: l.mood};
    final stepsBy = {for (final s in steps) s.date: s.count};
    final expBy = <String, int>{};
    for (final e in expenses) {
      expBy[e.date] = (expBy[e.date] ?? 0) + e.amountCents;
    }
    final incBy = <String, int>{};
    for (final i in income) {
      incBy[i.date] = (incBy[i.date] ?? 0) + i.amountCents;
    }
    final chrono = bp.reversed.toList();

    return Column(
      children: [
        AppTopBar(
          title: 'Графики',
          subtitle: period.label,
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              PeriodChips(
                value: period.chipLabel,
                options: Period.values.map((p) => p.chipLabel).toList(),
                onChanged: (label) => _onPeriod(context, ref, label),
              ),
              _ChartCard(
                eyebrow: 'Настроение',
                color: AppColors.accent,
                onTap: () => context.push('/daily'),
                child: LmBarChart(
                    data: _align(range, (d) => (moodBy[d] ?? 0).toDouble()),
                    color: AppColors.accent),
              ),
              const SizedBox(height: 12),
              _ChartCard(
                eyebrow: 'Приходи срещу разходи',
                onTap: () => context.push('/finance'),
                child: IncomeExpenseBars(
                  income: _align(range, (d) => (incBy[d] ?? 0) / 100),
                  expense: _align(range, (d) => (expBy[d] ?? 0) / 100),
                ),
              ),
              const SizedBox(height: 12),
              _ChartCard(
                eyebrow: 'Крачки',
                color: AppColors.purple,
                onTap: () => context.push('/steps'),
                child: LmBarChart(
                    data: _align(range, (d) => (stepsBy[d] ?? 0).toDouble()),
                    color: AppColors.purple),
              ),
              const SizedBox(height: 12),
              _ChartCard(
                eyebrow: 'Кръвно',
                color: AppColors.pink,
                onTap: () => context.push('/health'),
                child: chrono.length < 2
                    ? Text('Малко данни за графика', style: AppText.bodyDim)
                    : Column(
                        children: [
                          Sparkline(
                              data: [for (final b in chrono) b.systolic.toDouble()],
                              color: AppColors.pink,
                              height: 44),
                          const SizedBox(height: 8),
                          Sparkline(
                              data: [for (final b in chrono) b.diastolic.toDouble()],
                              color: AppColors.accent,
                              height: 44),
                        ],
                      ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onPeriod(
      BuildContext context, WidgetRef ref, String label) async {
    final p = Period.values.firstWhere((x) => x.chipLabel == label);
    if (p == Period.custom) {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        ref.read(statsCustomRangeProvider.notifier).state = DateRange(
          resolveRange(Period.today, today: picked.start).from,
          resolveRange(Period.today, today: picked.end).from,
        );
        ref.read(statsPeriodProvider.notifier).state = Period.custom;
      }
    } else {
      ref.read(statsPeriodProvider.notifier).state = p;
    }
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.eyebrow,
    required this.child,
    required this.onTap,
    this.color,
  });
  final String eyebrow;
  final Widget child;
  final VoidCallback onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return LmCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(eyebrow, color: color ?? AppColors.textDim),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
