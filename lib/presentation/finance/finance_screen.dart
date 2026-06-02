// Finance screen — balance hero, income-vs-expense chart, category breakdown
// (SegRing), and the records list (expenses / income) with tap-to-edit.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/charts/income_expense_bars.dart';
import '../../core/charts/seg_ring.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/lm_row.dart';
import '../../core/widgets/lm_skeleton.dart';
import '../../core/widgets/screen_body.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/period_chips.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../domain/period.dart';
import '../../domain/summaries.dart';
import 'finance_format.dart';
import 'finance_forms.dart';
import 'finance_providers.dart';

class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});
  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen> {
  int _tab = 0; // 0 = expenses, 1 = income

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(financeSummaryProvider);
    final expenses = ref.watch(financeExpensesProvider).asData?.value ?? const [];
    final income = ref.watch(financeIncomeProvider).asData?.value ?? const [];
    final period = ref.watch(financePeriodProvider);
    final range = ref.watch(financeRangeProvider);

    return Column(
      children: [
        AppTopBar(
          title: 'Финанси',
          subtitle: period.label,
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
          trailing: _AddButton(onTap: () => showFinanceChooser(context)),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              PeriodChips(
                value: period.chipLabel,
                options: Period.values.map((p) => p.chipLabel).toList(),
                onChanged: (label) => _onPeriod(context, label),
              ),
              summary.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LmListSkeleton(rows: 3, height: 110),
                ),
                error: (e, _) => const LmInlineError(),
                data: (s) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BalanceHero(s),
                    const SizedBox(height: 12),
                    _IncomeExpenseCard(range: range, expenses: expenses, income: income),
                    const SizedBox(height: 12),
                    _CategoryCard(s),
                    const SectionTitle('Записи'),
                    _Tabs(value: _tab, onChanged: (i) => setState(() => _tab = i)),
                    const SizedBox(height: 12),
                    if (_tab == 0)
                      ..._expenseRows(context, expenses)
                    else
                      ..._incomeRows(context, income),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onPeriod(BuildContext context, String label) async {
    final p = Period.values.firstWhere((x) => x.chipLabel == label);
    if (p == Period.custom) {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        ref.read(financeCustomRangeProvider.notifier).state = DateRange(
          resolveRange(Period.today, today: picked.start).from,
          resolveRange(Period.today, today: picked.end).from,
        );
        ref.read(financePeriodProvider.notifier).state = Period.custom;
      }
    } else {
      ref.read(financePeriodProvider.notifier).state = p;
    }
  }

  List<Widget> _expenseRows(BuildContext context, List<Expense> items) {
    if (items.isEmpty) {
      return [
        LmEmpty(
          icon: LmIcons.expense,
          message: 'Няма разходи за периода',
          actionLabel: 'Добави разход',
          onAction: () => showExpenseSheet(context),
        ),
      ];
    }
    return [
      for (final e in items)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: LmRow(
            icon: LmIcons.expense,
            iconColor: expenseCategoryColor(e.category),
            title: e.description,
            subtitle: '${e.category.label}${e.time != null ? ' · ${e.time}' : ''}',
            onTap: () => showExpenseSheet(context, existing: e),
            trailing: Text(euroSigned(e.amountCents, negative: true),
                style: AppText.stat.copyWith(fontSize: 15, color: AppColors.red)),
          ),
        ),
    ];
  }

  List<Widget> _incomeRows(BuildContext context, List<IncomeEntry> items) {
    if (items.isEmpty) {
      return [
        LmEmpty(
          icon: LmIcons.income,
          message: 'Няма приходи за периода',
          actionLabel: 'Добави приход',
          onAction: () => showIncomeSheet(context),
        ),
      ];
    }
    return [
      for (final i in items)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: LmRow(
            icon: LmIcons.income,
            iconColor: AppColors.green,
            title: i.source,
            subtitle: '${i.category.label} · ${i.date}',
            onTap: () => showIncomeSheet(context, existing: i),
            trailing: Text(euroSigned(i.amountCents, negative: false),
                style: AppText.stat.copyWith(fontSize: 15, color: AppColors.green)),
          ),
        ),
    ];
  }

}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              color: AppColors.accent, borderRadius: BorderRadius.circular(12)),
          child: const LmIcon(LmIcons.plus,
              size: 20, color: AppColors.bg, strokeWidth: 2.3),
        ),
      );
}

class _BalanceHero extends StatelessWidget {
  const _BalanceHero(this.s);
  final FinanceSummary s;
  @override
  Widget build(BuildContext context) {
    final positive = s.balanceCents >= 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppGradients.heroGreenStart, AppGradients.heroGreenEnd],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x405FD08A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Баланс за периода', color: AppColors.green),
          const SizedBox(height: 6),
          Text(
            '${positive ? '+' : '−'}${euroWhole(s.balanceCents)}',
            style: AppText.statXl.copyWith(
                color: positive ? AppColors.green : AppColors.red),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _heroStat(euroWhole(s.totalIncomeCents), 'приходи'),
              const SizedBox(width: 20),
              _heroStat(euroWhole(s.totalExpensesCents), 'разходи'),
              const SizedBox(width: 20),
              _heroStat(euroWhole(s.avgDailyExpenseCents), 'ср. на ден'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroStat(String value, String label) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppText.stat.copyWith(fontSize: 18)),
          Text(label, style: AppText.bodyDim.copyWith(fontSize: 11)),
        ],
      );
}

class _IncomeExpenseCard extends StatelessWidget {
  const _IncomeExpenseCard(
      {required this.range, required this.expenses, required this.income});
  final DateRange range;
  final List<Expense> expenses;
  final List<IncomeEntry> income;

  @override
  Widget build(BuildContext context) {
    // Build aligned per-day series over the range (euros).
    final from = DateTime.parse(range.from);
    final to = DateTime.parse(range.to);
    final exByDay = <String, int>{};
    for (final e in expenses) {
      exByDay[e.date] = (exByDay[e.date] ?? 0) + e.amountCents;
    }
    final incByDay = <String, int>{};
    for (final i in income) {
      incByDay[i.date] = (incByDay[i.date] ?? 0) + i.amountCents;
    }
    final exSeries = <double>[];
    final incSeries = <double>[];
    for (var d = from; !d.isAfter(to); d = DateTime(d.year, d.month, d.day + 1)) {
      final key = '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';
      exSeries.add((exByDay[key] ?? 0) / 100);
      incSeries.add((incByDay[key] ?? 0) / 100);
    }

    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Приходи срещу разходи'),
          const SizedBox(height: 14),
          IncomeExpenseBars(income: incSeries, expense: exSeries),
          const SizedBox(height: 10),
          Row(
            children: const [
              _Legend(color: AppColors.green, label: 'Приход'),
              SizedBox(width: 16),
              _Legend(color: AppColors.red, label: 'Разход'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard(this.s);
  final FinanceSummary s;
  @override
  Widget build(BuildContext context) {
    final entries = s.byCategoryCents.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = s.totalExpensesCents;
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Разходи по категории'),
          const SizedBox(height: 12),
          Row(
            children: [
              SegRing(
                size: 104,
                strokeWidth: 15,
                segments: [
                  for (final e in entries)
                    SegRingSegment(
                        e.value.toDouble(), expenseCategoryColor(e.key)),
                ],
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(euroWhole(total).replaceAll(' €', ''),
                        style: AppText.stat.copyWith(fontSize: 17)),
                    Text('€', style: AppText.monoFaint.copyWith(fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: [
                    for (final e in entries.take(6))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                  color: expenseCategoryColor(e.key),
                                  borderRadius: BorderRadius.circular(3)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(e.key.label,
                                    style: AppText.bodyDim.copyWith(fontSize: 12.5),
                                    overflow: TextOverflow.ellipsis)),
                            Text(
                                total > 0
                                    ? '${(e.value / total * 100).round()}%'
                                    : '0%',
                                style: AppText.mono12),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 6),
          Text(label, style: AppText.mono12.copyWith(fontSize: 11)),
        ],
      );
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) {
    Widget tab(int i, String label) {
      final sel = value == i;
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(i),
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: sel ? AppColors.accentSoft : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(label,
                textAlign: TextAlign.center,
                style: AppText.bodyStrong.copyWith(
                    fontSize: 13.5,
                    color: sel ? AppColors.accent : AppColors.textDim)),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadii.input),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [tab(0, 'Разходи'), tab(1, 'Приходи')]),
    );
  }
}
