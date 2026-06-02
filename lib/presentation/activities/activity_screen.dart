// Activities screen — summary counts (count / total time / avg time + most
// frequent), an activity-group breakdown (SegRing), a type filter, and the
// records list (intensity + mood per row). Mirrors the Finance/Food verticals.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/charts/seg_ring.dart';
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
import '../../core/widgets/pill.dart';
import '../../core/widgets/screen_body.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/segmented.dart';
import '../../core/format/dates.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../domain/period.dart';
import '../../domain/summaries.dart';
import 'activity_format.dart';
import 'activity_forms.dart';
import 'activity_providers.dart';

const _allLabel = 'Всички';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(activitySummaryProvider);
    final activities = ref.watch(activitiesProvider);
    final period = ref.watch(activityPeriodProvider);
    final filter = ref.watch(activityTypeFilterProvider);

    return Column(
      children: [
        AppTopBar(
          title: 'Активности',
          subtitle: period.label,
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
          trailing: _AddButton(onTap: () => showActivitySheet(context)),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              PeriodChips(
                value: period.chipLabel,
                options: Period.values.map((p) => p.chipLabel).toList(),
                onChanged: (label) => _onPeriod(context, ref, label),
              ),
              summary.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LmListSkeleton(rows: 2, height: 120),
                ),
                error: (e, _) => const LmInlineError(),
                data: (s) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CountsCard(s),
                    const SizedBox(height: 12),
                    _GroupsCard(s),
                    if (s.byType.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _TypeFilter(
                        byType: s.byType,
                        selected: filter,
                        onChanged: (t) =>
                            ref.read(activityTypeFilterProvider.notifier).state =
                                t,
                      ),
                    ],
                    const SectionTitle('Записи'),
                    ..._activityRows(context, activities),
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
        ref.read(activityCustomRangeProvider.notifier).state = DateRange(
          resolveRange(Period.today, today: picked.start).from,
          resolveRange(Period.today, today: picked.end).from,
        );
        ref.read(activityPeriodProvider.notifier).state = Period.custom;
      }
    } else {
      ref.read(activityPeriodProvider.notifier).state = p;
    }
  }

  List<Widget> _activityRows(BuildContext context, List<Activity> items) {
    if (items.isEmpty) {
      return [
        LmEmpty(
          icon: LmIcons.run,
          message: 'Няма активности за периода',
          actionLabel: 'Добави активност',
          onAction: () => showActivitySheet(context),
        ),
      ];
    }
    return [
      for (final a in items)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: LmRow(
            icon: LmIcons.run,
            iconColor: activityGroupColor(a.type.group),
            title: a.name ?? a.type.label,
            subtitle: [
              a.type.label,
              if (a.durationMin != null) formatDuration(a.durationMin!),
              if (a.intensity != null) a.intensity!.label,
              dmy(a.date),
            ].join(' · '),
            onTap: () => showActivitySheet(context, existing: a),
            trailing: (a.moodAfter ?? a.quality) != null
                ? Pill('${a.moodAfter ?? a.quality}/10', color: AppColors.amber)
                : null,
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
        label: 'Добави',
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

class _CountsCard extends StatelessWidget {
  const _CountsCard(this.s);
  final ActivitySummary s;
  @override
  Widget build(BuildContext context) {
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Обобщение'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _stat('${s.count}', 'тренировки')),
              Expanded(child: _stat(formatDuration(s.totalMinutes), 'общо')),
              Expanded(
                  child:
                      _stat(formatDuration(s.avgDurationMin.round()), 'ср. време')),
            ],
          ),
          if (s.mostFrequent != null) ...[
            const SizedBox(height: 12),
            Text('Най-често: ${s.mostFrequent!.label}',
                style: AppText.bodyDim.copyWith(fontSize: 12.5)),
          ],
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
              style: AppText.stat.copyWith(fontSize: 17)),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyDim.copyWith(fontSize: 11)),
        ],
      );
}

class _GroupsCard extends StatelessWidget {
  const _GroupsCard(this.s);
  final ActivitySummary s;
  @override
  Widget build(BuildContext context) {
    final entries = s.byGroup.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('По групи'),
          const SizedBox(height: 12),
          Row(
            children: [
              SegRing(
                size: 104,
                strokeWidth: 15,
                segments: [
                  for (final e in entries)
                    SegRingSegment(
                        e.value.toDouble(), activityGroupColor(e.key)),
                ],
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${s.count}', style: AppText.stat.copyWith(fontSize: 18)),
                    Text('общо', style: AppText.monoFaint.copyWith(fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: [
                    for (final e in entries)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                  color: activityGroupColor(e.key),
                                  borderRadius: BorderRadius.circular(3)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(e.key.label,
                                    style: AppText.bodyDim
                                        .copyWith(fontSize: 12.5),
                                    overflow: TextOverflow.ellipsis)),
                            Text('${e.value}', style: AppText.mono12),
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

class _TypeFilter extends StatelessWidget {
  const _TypeFilter(
      {required this.byType, required this.selected, required this.onChanged});
  final Map<ActivityType, int> byType;
  final ActivityType? selected;
  final ValueChanged<ActivityType?> onChanged;

  @override
  Widget build(BuildContext context) {
    final present = byType.keys.toList()
      ..sort((a, b) => byType[b]!.compareTo(byType[a]!));
    final options = [_allLabel, for (final t in present) t.label];
    return Segmented(
      options: options,
      value: selected?.label ?? _allLabel,
      onChanged: (label) => onChanged(label == _allLabel
          ? null
          : ActivityType.values.firstWhere((t) => t.label == label)),
    );
  }
}
