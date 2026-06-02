// Food screen — calories Ring + macro bars, a calories-by-day chart, and the
// meals list (tap to edit). Mirrors the Finance vertical's structure.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/charts/lm_bar_chart.dart';
import '../../core/charts/ring.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/lm_row.dart';
import '../../core/widgets/lm_skeleton.dart';
import '../../core/widgets/period_chips.dart';
import '../../core/widgets/screen_body.dart';
import '../../core/widgets/section_title.dart';
import '../../core/format/dates.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../domain/period.dart';
import '../../domain/summaries.dart';
import 'food_format.dart';
import 'food_forms.dart';
import 'food_providers.dart';

/// Aligned per-day calorie series (euros-style) over [range], for the chart and
/// the hero ring's scale.
List<double> _caloriesByDay(List<Meal> meals, DateRange range) {
  final byDay = <String, int>{};
  for (final m in meals) {
    byDay[m.date] = (byDay[m.date] ?? 0) + (m.calories ?? 0);
  }
  final from = DateTime.parse(range.from);
  final to = DateTime.parse(range.to);
  final out = <double>[];
  for (var d = from; !d.isAfter(to); d = DateTime(d.year, d.month, d.day + 1)) {
    final key = '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
    out.add((byDay[key] ?? 0).toDouble());
  }
  return out;
}

class FoodScreen extends ConsumerWidget {
  const FoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(foodSummaryProvider);
    final meals = ref.watch(foodMealsProvider).asData?.value ?? const [];
    final period = ref.watch(foodPeriodProvider);
    final range = ref.watch(foodRangeProvider);

    return Column(
      children: [
        AppTopBar(
          title: context.l10n.foodTitle,
          subtitle: localizedLabel(context, period),
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
          trailing: _AddButton(onTap: () => showFoodSheet(context)),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              PeriodChips(
                value: periodChipLabel(context, period),
                options:
                    Period.values.map((p) => periodChipLabel(context, p)).toList(),
                onChanged: (label) => _onPeriod(context, ref, label),
              ),
              summary.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LmListSkeleton(rows: 2, height: 130),
                ),
                error: (e, _) => const LmInlineError(),
                data: (s) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CaloriesCard(summary: s, meals: meals, range: range),
                    const SizedBox(height: 12),
                    _CaloriesByDayCard(meals: meals, range: range),
                    SectionTitle(context.l10n.foodEntries),
                    ..._mealRows(context, meals),
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

  Future<void> _onPeriod(
      BuildContext context, WidgetRef ref, String label) async {
    final p = Period.values.firstWhere((x) => periodChipLabel(context, x) == label);
    if (p == Period.custom) {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        ref.read(foodCustomRangeProvider.notifier).state = DateRange(
          resolveRange(Period.today, today: picked.start).from,
          resolveRange(Period.today, today: picked.end).from,
        );
        ref.read(foodPeriodProvider.notifier).state = Period.custom;
      }
    } else {
      ref.read(foodPeriodProvider.notifier).state = p;
    }
  }

  List<Widget> _mealRows(BuildContext context, List<Meal> items) {
    if (items.isEmpty) {
      return [
        LmEmpty(
          icon: LmIcons.food,
          message: context.l10n.foodEmpty,
          actionLabel: context.l10n.foodAddMeal,
          onAction: () => showFoodSheet(context),
        ),
      ];
    }
    return [
      for (final m in items)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: LmRow(
            icon: LmIcons.food,
            iconColor: mealTypeColor(m.type),
            title: m.name,
            subtitle:
                '${localizedLabel(context, m.type)}${m.time != null ? ' · ${m.time}' : ''} · ${dmy(m.date)}',
            onTap: () => showFoodSheet(context, existing: m),
            trailing: Text(
              m.calories != null ? kcal(m.calories!) : '—',
              style: AppText.mono12.copyWith(color: AppColors.amber),
            ),
          ),
        ),
    ];
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: context.l10n.actionAdd,
        child: GestureDetector(
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
        ),
      );
}

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard(
      {required this.summary, required this.meals, required this.range});
  final FoodSummary summary;
  final List<Meal> meals;
  final DateRange range;

  @override
  Widget build(BuildContext context) {
    final byDay = _caloriesByDay(meals, range);
    final peak = byDay.fold<double>(0, math.max);
    final maxMacro = math.max(
        1.0,
        [summary.totalProtein, summary.totalCarbs, summary.totalFat]
            .fold<double>(0, math.max));

    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(context.l10n.foodCalories, color: AppColors.amber),
          const SizedBox(height: 14),
          Row(
            children: [
              Ring(
                value: summary.avgCaloriesPerDay,
                max: peak <= 0 ? 1 : peak,
                size: 104,
                strokeWidth: 15,
                color: AppColors.amber,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(summary.avgCaloriesPerDay.round().toString(),
                        style: AppText.stat.copyWith(fontSize: 19)),
                    Text(context.l10n.foodKcalPerDay,
                        style: AppText.monoFaint.copyWith(fontSize: 9.5)),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: [
                    _MacroBar(context.l10n.foodProtein, summary.totalProtein,
                        proteinColor, maxMacro),
                    _MacroBar(context.l10n.foodCarbs, summary.totalCarbs,
                        carbsColor, maxMacro),
                    _MacroBar(context.l10n.foodFat, summary.totalFat, fatColor,
                        maxMacro),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                  child: _heroStat(
                      '${summary.totalCalories}', context.l10n.foodTotalKcal)),
              Expanded(
                  child: _heroStat(
                      '${summary.mealCount}', context.l10n.foodMealCount)),
              Expanded(
                  child: _heroStat(grams(summary.avgProteinPerDay),
                      context.l10n.foodAvgProtein)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroStat(String value, String label) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.stat.copyWith(fontSize: 17)),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyDim.copyWith(fontSize: 11)),
        ],
      );
}

class _MacroBar extends StatelessWidget {
  const _MacroBar(this.label, this.value, this.color, this.maxV);
  final String label;
  final double value;
  final Color color;
  final double maxV;

  @override
  Widget build(BuildContext context) {
    final frac = (value / maxV).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: Text(label,
                style: AppText.bodyDim.copyWith(fontSize: 12),
                overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 7,
                color: AppColors.white08,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: frac,
                  child: Container(color: color),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 42,
            child: Text(grams(value),
                textAlign: TextAlign.right, style: AppText.mono12),
          ),
        ],
      ),
    );
  }
}

class _CaloriesByDayCard extends StatelessWidget {
  const _CaloriesByDayCard({required this.meals, required this.range});
  final List<Meal> meals;
  final DateRange range;

  @override
  Widget build(BuildContext context) {
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(context.l10n.foodCaloriesByDay),
          const SizedBox(height: 14),
          LmBarChart(
              data: _caloriesByDay(meals, range), color: AppColors.amber),
        ],
      ),
    );
  }
}
