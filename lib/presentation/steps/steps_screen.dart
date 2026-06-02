// Steps screen — today's ring (toward a 10k reference goal), period stats
// (total / avg / max / days), a steps-by-day chart, and the recent days list
// with provenance (spec §18).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/charts/lm_bar_chart.dart';
import '../../core/charts/ring.dart';
import '../../core/icons/lm_icons.dart';
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
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../domain/period.dart';
import '../../domain/summaries.dart';
import 'steps_format.dart';
import 'steps_forms.dart';
import 'steps_providers.dart';

/// Conventional daily step goal — used only as the today-ring's scale.
const int _goal = 10000;

List<double> _stepsByDay(List<StepEntry> entries, DateRange range) {
  final byDay = {for (final e in entries) e.date: e.count};
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

class StepsScreen extends ConsumerWidget {
  const StepsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(stepsSummaryProvider);
    final entries = ref.watch(stepsInRangeProvider).asData?.value ?? const [];
    final today = ref.watch(todayStepsProvider).asData?.value;
    final period = ref.watch(stepsPeriodProvider);
    final range = ref.watch(stepsRangeProvider);

    return Column(
      children: [
        AppTopBar(
          title: 'Крачки',
          subtitle: period.label,
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
          trailing: _AddButton(onTap: () => showStepsSheet(context)),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              PeriodChips(
                value: period.chipLabel,
                options: Period.values.map((p) => p.chipLabel).toList(),
                onChanged: (label) => _onPeriod(context, ref, label),
              ),
              _TodayCard(count: today?.count ?? 0),
              const SizedBox(height: 12),
              summary.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LmListSkeleton(rows: 2, height: 120),
                ),
                error: (e, _) => const LmInlineError(),
                data: (s) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatsCard(s),
                    const SizedBox(height: 12),
                    _ByDayCard(entries: entries, range: range),
                    const SectionTitle('Дни'),
                    ..._dayRows(context, entries),
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
    final p = Period.values.firstWhere((x) => x.chipLabel == label);
    if (p == Period.custom) {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        ref.read(stepsCustomRangeProvider.notifier).state = DateRange(
          resolveRange(Period.today, today: picked.start).from,
          resolveRange(Period.today, today: picked.end).from,
        );
        ref.read(stepsPeriodProvider.notifier).state = Period.custom;
      }
    } else {
      ref.read(stepsPeriodProvider.notifier).state = p;
    }
  }

  List<Widget> _dayRows(BuildContext context, List<StepEntry> entries) {
    if (entries.isEmpty) {
      return [
        LmEmpty(
          icon: LmIcons.steps,
          message: 'Няма крачки за периода',
          actionLabel: 'Добави крачки',
          onAction: () => showStepsSheet(context),
        ),
      ];
    }
    // watchInRange orders by date asc → show most recent first.
    final ordered = entries.reversed.toList();
    return [
      for (final e in ordered)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: LmRow(
            icon: LmIcons.steps,
            iconColor: AppColors.purple,
            title: '${groupedInt(e.count)} крачки',
            subtitle: '${e.date} · ${stepsProvenance(e.source)}',
            onTap: () => showStepsSheet(context, existing: e),
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

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.count});
  final int count;
  @override
  Widget build(BuildContext context) {
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Днес', color: AppColors.purple),
          const SizedBox(height: 14),
          Center(
            child: Ring(
              value: count.toDouble(),
              max: _goal.toDouble(),
              size: 150,
              strokeWidth: 16,
              color: AppColors.purple,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(groupedInt(count),
                      style: AppText.statXl.copyWith(fontSize: 26)),
                  Text('от ${groupedInt(_goal)}',
                      style: AppText.monoFaint.copyWith(fontSize: 11)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard(this.s);
  final StepsSummary s;
  @override
  Widget build(BuildContext context) {
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Статистика'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _stat(groupedInt(s.total), 'общо')),
              Expanded(child: _stat(groupedInt(s.avg.round()), 'средно')),
              Expanded(child: _stat(groupedInt(s.best), 'макс.')),
              Expanded(child: _stat('${s.daysLogged}', 'дни')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.stat.copyWith(fontSize: 16)),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyDim.copyWith(fontSize: 11)),
        ],
      );
}

class _ByDayCard extends StatelessWidget {
  const _ByDayCard({required this.entries, required this.range});
  final List<StepEntry> entries;
  final DateRange range;
  @override
  Widget build(BuildContext context) {
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Крачки по дни'),
          const SizedBox(height: 14),
          LmBarChart(
            data: _stepsByDay(entries, range),
            color: AppColors.purple,
            highlightLast: true,
          ),
        ],
      ),
    );
  }
}
