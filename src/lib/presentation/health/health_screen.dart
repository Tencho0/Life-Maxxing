// Health screen — vitals (last BP + averages, last/next dental), a BP-over-time
// chart, and a 4-tab history (Кръвно / Добавки / Събития / Изследвания) with a
// per-tab add button (spec §12–§16).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/charts/sparkline.dart';
import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n_ext.dart';
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
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../domain/period.dart';
import '../../domain/summaries.dart';
import '../../core/format/dates.dart';
import '../finance/finance_format.dart' show euro2;
import 'health_format.dart';
import 'health_forms.dart';
import 'health_providers.dart';

List<String> _tabLabels(BuildContext context) => [
      context.l10n.healthTabBp,
      context.l10n.healthTabMeds,
      context.l10n.healthTabEvents,
      context.l10n.healthTabLabs,
      context.l10n.weightTabLabel,
    ];

class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({super.key});
  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(healthSummaryProvider);
    final bp = ref.watch(bpInRangeProvider).asData?.value ?? const [];
    final meds = ref.watch(medsInRangeProvider).asData?.value ?? const [];
    final events = ref.watch(eventsProvider).asData?.value ?? const [];
    final labs = ref.watch(labsProvider).asData?.value ?? const [];
    final weight = ref.watch(weightInRangeProvider).asData?.value ?? const [];
    final weightSummary =
        ref.watch(weightSummaryProvider).asData?.value;
    final period = ref.watch(healthPeriodProvider);

    return Column(
      children: [
        AppTopBar(
          title: context.l10n.healthTitle,
          subtitle: localizedLabel(context, period),
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
          trailing: _AddButton(onTap: _addForCurrentTab),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              PeriodChips(
                value: periodChipLabel(context, period),
                options: Period.values.map((p) => periodChipLabel(context, p)).toList(),
                onChanged: (label) => _onPeriod(context, label),
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
                    _VitalsCard(summary: s, nextDental: nextDentalDate(events)),
                    const SizedBox(height: 12),
                    _BpChartCard(bp: bp),
                    const SizedBox(height: 12),
                    if (weightSummary != null && weightSummary.count > 0) ...[
                      _WeightCard(summary: weightSummary, weight: weight),
                      const SizedBox(height: 12),
                    ],
                    _Tabs(
                        value: _tab, onChanged: (i) => setState(() => _tab = i)),
                    const SizedBox(height: 12),
                    ..._tabBody(bp, meds, events, labs, weight),
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

  void _addForCurrentTab() {
    switch (_tab) {
      case 0:
        showBpSheet(context);
      case 1:
        showMedSheet(context);
      case 2:
        showEventSheet(context);
      case 3:
        showLabSheet(context);
      case 4:
        showWeightSheet(context);
    }
  }

  Future<void> _onPeriod(BuildContext context, String label) async {
    final p = Period.values.firstWhere((x) => periodChipLabel(context, x) == label);
    if (p == Period.custom) {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        ref.read(healthCustomRangeProvider.notifier).state = DateRange(
          resolveRange(Period.today, today: picked.start).from,
          resolveRange(Period.today, today: picked.end).from,
        );
        ref.read(healthPeriodProvider.notifier).state = Period.custom;
      }
    } else {
      ref.read(healthPeriodProvider.notifier).state = p;
    }
  }

  List<Widget> _tabBody(List<BloodPressureLog> bp, List<MedicationLog> meds,
      List<HealthEvent> events, List<LabTest> labs, List<WeightLog> weight) {
    switch (_tab) {
      case 0:
        return _rows(
            bp.isEmpty,
            LmEmpty(
                icon: LmIcons.pulse,
                message: context.l10n.healthBpEmpty,
                actionLabel: context.l10n.healthBpAdd,
                onAction: () => showBpSheet(context)),
            [
          for (final b in bp)
            LmRow(
              icon: LmIcons.pulse,
              iconColor: AppColors.pink,
              title: '${b.systolic}/${b.diastolic}',
              subtitle:
                  '${dmy(b.date)} ${b.time} · ${context.l10n.healthPulseShort} ${b.pulse}${b.note != null ? ' · ${b.note}' : ''}',
              onTap: () => showBpSheet(context, existing: b),
            ),
        ]);
      case 1:
        return _rows(
            meds.isEmpty,
            LmEmpty(
                icon: LmIcons.pill,
                message: context.l10n.healthMedsEmpty,
                actionLabel: context.l10n.healthMedsAdd,
                onAction: () => showMedSheet(context)),
            [
          for (final m in meds)
            LmRow(
              icon: LmIcons.pill,
              iconColor: AppColors.accent,
              title: m.name,
              subtitle:
                  '${localizedLabel(context, m.type)} · ${m.time}${m.dose != null ? ' · ${m.dose}' : ''}',
              onTap: () => showMedSheet(context, existing: m),
              trailing: Pill(localizedLabel(context, m.status), color: medStatusColor(m.status)),
            ),
        ]);
      case 2:
        return _rows(
            events.isEmpty,
            LmEmpty(
                icon: LmIcons.event,
                message: context.l10n.healthEventsEmpty,
                actionLabel: context.l10n.healthEventsAdd,
                onAction: () => showEventSheet(context)),
            [
          for (final e in events)
            LmRow(
              icon: LmIcons.event,
              iconColor: AppColors.amber,
              title: e.type == HealthEventType.dentist && e.subtype != null
                  ? '${localizedLabel(context, e.type)} · ${localizedLabel(context, e.subtype!)}'
                  : localizedLabel(context, e.type),
              subtitle:
                  '${dmy(e.date)}${e.clinic != null ? ' · ${e.clinic}' : ''}',
              onTap: () => showEventSheet(context, existing: e),
              trailing: e.priceCents != null
                  ? Text(euro2(e.priceCents!),
                      style: AppText.mono12.copyWith(color: AppColors.textDim))
                  : null,
            ),
        ]);
      case 3:
        return _rows(
            labs.isEmpty,
            LmEmpty(
                icon: LmIcons.labs,
                message: context.l10n.healthLabsEmpty,
                actionLabel: context.l10n.healthLabsAdd,
                onAction: () => showLabSheet(context)),
            [
          for (final l in labs)
            LmRow(
              icon: LmIcons.labs,
              iconColor: AppColors.purple,
              title: l.lab,
              subtitle: '${dmy(l.date)} · ${l.reason}',
              onTap: () => showLabSheet(context, existing: l),
            ),
        ]);
      default:
        // Weight — newest first in the list (watchInRange is ascending).
        return _rows(
            weight.isEmpty,
            LmEmpty(
                icon: LmIcons.pulse,
                message: context.l10n.weightEmpty,
                actionLabel: context.l10n.weightSheetTitle,
                onAction: () => showWeightSheet(context)),
            [
          for (final w in weight.reversed)
            LmRow(
              icon: LmIcons.pulse,
              iconColor: AppColors.green,
              title: formatKg(w.weightGrams),
              subtitle: '${dmy(w.date)}${w.note != null ? ' · ${w.note}' : ''}',
              onTap: () => showWeightSheet(context, existing: w),
            ),
        ]);
    }
  }

  List<Widget> _rows(bool empty, Widget emptyState, List<Widget> rows) {
    if (empty) return [emptyState];
    return [
      for (final r in rows)
        Padding(padding: const EdgeInsets.only(bottom: 8), child: r),
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

class _VitalsCard extends StatelessWidget {
  const _VitalsCard({required this.summary, required this.nextDental});
  final HealthSummary summary;
  final String? nextDental;
  @override
  Widget build(BuildContext context) {
    final s = summary;
    final lastBp = s.lastSystolic != null
        ? '${s.lastSystolic}/${s.lastDiastolic}'
        : '—';
    String avg(double? v) => v != null ? v.round().toString() : '—';
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(context.l10n.healthVitals, color: AppColors.pink),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _stat(lastBp, context.l10n.healthLastBp)),
              Expanded(
                  child: _stat('${s.lastPulse ?? '—'}', context.l10n.healthPulse)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _stat('${avg(s.avgSystolic)}/${avg(s.avgDiastolic)}',
                      context.l10n.healthAvgBp)),
              Expanded(child: _stat(avg(s.avgPulse), context.l10n.healthAvgPulse)),
            ],
          ),
          if (nextDental != null) ...[
            const SizedBox(height: 12),
            Text(context.l10n.healthNextDental(dmy(nextDental!)),
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
              style: AppText.stat.copyWith(fontSize: 18)),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyDim.copyWith(fontSize: 11)),
        ],
      );
}

class _BpChartCard extends StatelessWidget {
  const _BpChartCard({required this.bp});
  final List<BloodPressureLog> bp;
  @override
  Widget build(BuildContext context) {
    // watchBpInRange is newest-first → reverse for a chronological line.
    final chrono = bp.reversed.toList();
    final sys = [for (final b in chrono) b.systolic.toDouble()];
    final dia = [for (final b in chrono) b.diastolic.toDouble()];
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(context.l10n.healthBpOverTime),
          const SizedBox(height: 12),
          if (sys.length < 2)
            Text(context.l10n.healthChartTooFewData, style: AppText.bodyDim)
          else ...[
            Sparkline(data: sys, color: AppColors.pink, height: 44),
            const SizedBox(height: 8),
            Sparkline(data: dia, color: AppColors.accent, height: 44),
            const SizedBox(height: 8),
            Row(
              children: [
                _Legend(color: AppColors.pink, label: context.l10n.healthSystolic),
                const SizedBox(width: 16),
                _Legend(
                    color: AppColors.accent, label: context.l10n.healthDiastolic),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _WeightCard extends StatelessWidget {
  const _WeightCard({required this.summary, required this.weight});
  final WeightSummary summary;
  final List<WeightLog> weight; // ascending by date

  @override
  Widget build(BuildContext context) {
    final series = [for (final w in weight) w.weightGrams / 1000.0];
    final gain = summary.changeGrams > 0;
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(context.l10n.weightTabLabel, color: AppColors.green),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                  child: _WeightStat(
                      value: formatKg(summary.latestGrams),
                      label: context.l10n.weightStatLatest)),
              Expanded(
                child: _WeightStat(
                  value: formatKgDelta(summary.changeGrams),
                  label: context.l10n.weightStatChange,
                  // Loss is the "good" direction for a cut → green; gain amber.
                  color: summary.changeGrams == 0
                      ? null
                      : (gain ? AppColors.amber : AppColors.green),
                ),
              ),
            ],
          ),
          if (series.length >= 2) ...[
            const SizedBox(height: 12),
            Sparkline(data: series, color: AppColors.green, height: 44),
          ],
        ],
      ),
    );
  }
}

class _WeightStat extends StatelessWidget {
  const _WeightStat({required this.value, required this.label, this.color});
  final String value;
  final String label;
  final Color? color;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.stat.copyWith(
                  fontSize: 18, color: color ?? AppColors.text)),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyDim.copyWith(fontSize: 11)),
        ],
      );
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
    final labels = _tabLabels(context);
    Widget tab(int i) {
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
            child: Text(labels[i],
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyStrong.copyWith(
                    fontSize: 12.5,
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
      child: Row(children: [for (var i = 0; i < labels.length; i++) tab(i)]),
    );
  }
}
