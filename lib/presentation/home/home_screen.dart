// Home dashboard — greeting, quick-log tiles, this-week rails (sparklines), the
// today timeline, and the "finish daily report" CTA. Read-only; actions reuse
// the existing sheets (spec §4.1, Home).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/sheets.dart';
import '../../core/charts/sparkline.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/card.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/screen_body.dart';
import '../../core/widgets/section_title.dart';
import 'home_data.dart';
import 'home_providers.dart';

const _name = 'Martin';

String _greeting(BuildContext c, int hour) => hour < 12
    ? c.l10n.homeGreetMorning
    : (hour < 18 ? c.l10n.homeGreetDay : c.l10n.homeGreetEvening);

/// Locale-aware long date (weekday + month names follow the UI language).
/// Record dates elsewhere stay numeric `dd.MM.yyyy` (locked design, §4).
String _longDate(BuildContext c, DateTime d) =>
    DateFormat('EEEE · d MMMM y', Localizations.localeOf(c).languageCode)
        .format(d);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final week = ref.watch(homeWeekProvider).asData?.value;
    final data = ref.watch(homeTimelineProvider).asData?.value;
    final timeline = data == null
        ? const <TimelineItem>[]
        : buildTodayTimeline(
            l10n: context.l10n,
            meals: data.meals,
            activities: data.activities,
            expenses: data.expenses,
            bp: data.bp,
            meds: data.meds,
          );

    return Column(
      children: [
        _HomeHead(now: now),
        Expanded(
          child: ScreenBody(
            children: [
              Eyebrow(context.l10n.homeQuickEyebrow),
              const SizedBox(height: 10),
              _QuickTiles(),
              const SizedBox(height: 20),
              Eyebrow(context.l10n.homeThisWeek),
              const SizedBox(height: 10),
              if (week != null) _Rails(week: week),
              SectionTitle(context.l10n.homeTimelineSection),
              _TimelineCard(items: timeline),
              const SizedBox(height: 14),
              _FinishCta(onTap: () => openDailyToday(context, ref)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeHead extends StatelessWidget {
  const _HomeHead({required this.now});
  final DateTime now;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 14 + MediaQuery.paddingOf(context).top, 16, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_longDate(context, now),
                    style: AppText.monoFaint.copyWith(fontSize: 12.5)),
                const SizedBox(height: 3),
                Text('${_greeting(context, now.hour)}, $_name',
                    style: AppText.statLg.copyWith(fontSize: 23)),
              ],
            ),
          ),
          _Sq(icon: LmIcons.search, onTap: () => context.push('/search')),
          const SizedBox(width: 8),
          _Sq(icon: LmIcons.calendar, onTap: () => context.push('/daily')),
        ],
      ),
    );
  }
}

class _Sq extends StatelessWidget {
  const _Sq({required this.icon, required this.onTap});
  final LmIcons icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border)),
          child: LmIcon(icon, size: 18, color: AppColors.textDim),
        ),
      );
}

class _QuickTiles extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quick = kQuickActions.take(4).toList();
    Widget tile(QuickAction q) => Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => q.id == 'daily'
                ? openDailyToday(context, ref)
                : openFormSheet(context, q.id),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColors.white05,
                        borderRadius: BorderRadius.circular(12)),
                    child: LmIcon(q.icon, size: 21, color: q.color),
                  ),
                  const SizedBox(height: 12),
                  Text(q.label(context), style: AppText.bodyStrong),
                  Text(context.l10n.homeAddPlus,
                      style: AppText.monoFaint.copyWith(fontSize: 11)),
                ],
              ),
            ),
          ),
        );
    return Column(
      children: [
        Row(children: [tile(quick[0]), const SizedBox(width: 10), tile(quick[1])]),
        const SizedBox(height: 10),
        Row(children: [tile(quick[2]), const SizedBox(width: 10), tile(quick[3])]),
      ],
    );
  }
}

class _Rails extends StatelessWidget {
  const _Rails({required this.week});
  final HomeWeek week;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _RailCard(
              label: context.l10n.homeRailMood,
              value: week.avgMood.toStringAsFixed(1),
              unit: context.l10n.homeAvgUnit,
              data: week.mood,
              color: AppColors.accent,
              route: '/daily'),
          _RailCard(
              label: context.l10n.homeRailSteps,
              value: '${(week.avgSteps / 1000).toStringAsFixed(1)}${context.l10n.unitThousands}',
              unit: context.l10n.homeAvgUnit,
              data: week.steps,
              color: AppColors.purple,
              route: '/steps'),
          _RailCard(
              label: context.l10n.homeRailExpense,
              value: '${week.totalExpenseCents ~/ 100}',
              unit: '€',
              data: week.expense,
              color: AppColors.red,
              route: '/finance'),
          _RailCard(
              label: context.l10n.homeRailPulse,
              value: week.avgPulse > 0 ? '${week.avgPulse.round()}' : '—',
              unit: context.l10n.homeAvgUnit,
              data: week.pulse,
              color: AppColors.pink,
              route: '/health'),
        ],
      ),
    );
  }
}

class _RailCard extends StatelessWidget {
  const _RailCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.data,
    required this.color,
    required this.route,
  });
  final String label;
  final String value;
  final String unit;
  final List<double> data;
  final Color color;
  final String route;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(route),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppText.monoFaint.copyWith(fontSize: 11)),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          AppText.stat.copyWith(fontSize: 22, color: color)),
                ),
                const SizedBox(width: 4),
                Text(unit, style: AppText.monoFaint.copyWith(fontSize: 10)),
              ],
            ),
            const SizedBox(height: 8),
            Sparkline(data: data, color: color, height: 36),
          ],
        ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.items});
  final List<TimelineItem> items;
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return LmCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
              child: Text(context.l10n.homeTimelineEmpty,
                  style: AppText.bodyDim)),
        ),
      );
    }
    return LmCard(
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++)
            _TLRow(item: items[i], last: i == items.length - 1),
        ],
      ),
    );
  }
}

class _TLRow extends StatelessWidget {
  const _TLRow({required this.item, required this.last});
  final TimelineItem item;
  final bool last;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push(item.route),
      child: Padding(
        padding: EdgeInsets.only(bottom: last ? 0 : 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: AppColors.white05,
                  borderRadius: BorderRadius.circular(11)),
              child: LmIcon(item.icon, size: 19, color: item.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodyStrong.copyWith(fontSize: 14)),
                  Text(item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodyDim.copyWith(fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(item.meta, style: AppText.mono12.copyWith(color: AppColors.textDim)),
          ],
        ),
      ),
    );
  }
}

class _FinishCta extends StatelessWidget {
  const _FinishCta({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppGradients.heroBlueStart, AppGradients.heroBlueEnd],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x4D6AA8FF)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(13)),
              child: const LmIcon(LmIcons.sun, size: 22, color: AppColors.accent),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.homeFinishTitle, style: AppText.bodyStrong),
                  Text(context.l10n.homeFinishSub,
                      style: AppText.bodyDim.copyWith(fontSize: 12)),
                ],
              ),
            ),
            const LmIcon(LmIcons.arrowR, size: 18, color: AppColors.accent),
          ],
        ),
      ),
    );
  }
}
