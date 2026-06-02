// Daily Quick Log screen — the viewed day's report (mood hero, photo, yes/no
// grid, screen-time + locked steps, notes) plus a trailing-30-day mood trend.
// Empty state offers to fill the report (spec §17).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/charts/lm_bar_chart.dart';
import '../../core/charts/ring.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/theme/mood_color.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/card.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/lm_button.dart';
import '../../core/widgets/pill.dart';
import '../../core/widgets/screen_body.dart';
import '../../core/format/dates.dart';
import '../../data/database.dart';
import '../common/photo_field.dart';
import 'daily_forms.dart';
import 'daily_providers.dart';

List<double> _moodByDay(List<DailyLog> logs, String fromDate, String toDate) {
  final byDay = {for (final l in logs) l.date: l.mood};
  final from = DateTime.parse(fromDate);
  final to = DateTime.parse(toDate);
  final out = <double>[];
  for (var d = from; !d.isAfter(to); d = DateTime(d.year, d.month, d.day + 1)) {
    final key = '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
    out.add((byDay[key] ?? 0).toDouble());
  }
  return out;
}

class DailyScreen extends ConsumerWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(dailyDateProvider);
    final log = ref.watch(dailyLogProvider).asData?.value;
    final steps = ref.watch(dailyStepsProvider).asData?.value;
    final photo = ref.watch(dailyPhotoProvider).asData?.value;
    final month = ref.watch(dailyMonthLogsProvider).asData?.value ?? const [];
    final svc = ref.watch(attachmentServiceProvider);

    void open() => showDailySheet(context,
        date: date, existing: log, existingSteps: steps);

    return Column(
      children: [
        AppTopBar(
          title: 'Дневен отчет',
          subtitle: dmy(date),
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
          trailing: _AddButton(onTap: open),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              if (log == null)
                _EmptyReport(onFill: open)
              else ...[
                _MoodHero(log: log),
                if (photo != null) ...[
                  const SizedBox(height: 12),
                  Center(child: AttachmentThumb(svc: svc, attachment: photo, size: 160)),
                ],
                const SizedBox(height: 12),
                _FlagsCard(log: log),
                const SizedBox(height: 12),
                _MetricsCard(log: log, steps: steps),
                if (log.note != null && log.note!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _NoteCard(note: log.note!),
                ],
              ],
              if (month.isNotEmpty) ...[
                const SizedBox(height: 12),
                _MoodTrendCard(
                  data: _moodByDay(
                      month, _from(date), date),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  String _from(String date) {
    final d = DateTime.parse(date);
    final f = DateTime(d.year, d.month, d.day - 29);
    return '${f.year.toString().padLeft(4, '0')}-'
        '${f.month.toString().padLeft(2, '0')}-'
        '${f.day.toString().padLeft(2, '0')}';
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
          child: const LmIcon(LmIcons.edit,
              size: 18, color: AppColors.bg, strokeWidth: 2.3),
        ),
      );
}

class _EmptyReport extends StatelessWidget {
  const _EmptyReport({required this.onFill});
  final VoidCallback onFill;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: Column(
          children: [
            Text('Няма отчет за този ден', style: AppText.bodyDim),
            const SizedBox(height: 16),
            LmButton('Попълни отчета', icon: LmIcons.sun, onTap: onFill),
          ],
        ),
      );
}

class _MoodHero extends StatelessWidget {
  const _MoodHero({required this.log});
  final DailyLog log;
  @override
  Widget build(BuildContext context) {
    final col = moodColor(log.mood);
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow('Настроение', color: col),
          const SizedBox(height: 14),
          Center(
            child: Ring(
              value: log.mood.toDouble(),
              max: 10,
              size: 132,
              strokeWidth: 16,
              color: col,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${log.mood}',
                      style: AppText.statXl.copyWith(fontSize: 30, color: col)),
                  Text(moodLabel(log.mood),
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

class _FlagsCard extends StatelessWidget {
  const _FlagsCard({required this.log});
  final DailyLog log;
  @override
  Widget build(BuildContext context) {
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: _flag('Горд', log.proud)),
            Expanded(child: _flag('Тренировка', log.workout)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _flag('Неудобно нещо', log.didUncomfortable)),
            Expanded(child: _flag('Алкохол', log.drankAlcohol)),
          ]),
          if (log.didUncomfortable && (log.uncomfortableWhat?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text('Неудобно: ${log.uncomfortableWhat}',
                  style: AppText.bodyDim.copyWith(fontSize: 12.5)),
            ),
          if (log.drankAlcohol && (log.alcoholWhat?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text('Алкохол: ${log.alcoholWhat}',
                  style: AppText.bodyDim.copyWith(fontSize: 12.5)),
            ),
        ],
      ),
    );
  }

  Widget _flag(String label, bool yes) => Row(
        children: [
          Pill(yes ? 'Да' : 'Не',
              color: yes ? AppColors.green : AppColors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label,
                style: AppText.bodyDim.copyWith(fontSize: 12.5),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      );
}

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.log, required this.steps});
  final DailyLog log;
  final StepEntry? steps;
  @override
  Widget build(BuildContext context) {
    final screen = log.screenTimeMin != null ? '${log.screenTimeMin} мин' : '—';
    return LmCard(
      child: Row(
        children: [
          Expanded(child: _stat('Screen time', screen)),
          Expanded(
            child: _stat('Крачки',
                steps != null ? '${steps!.count} · заключено' : '—'),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.bodyDim.copyWith(fontSize: 11)),
          const SizedBox(height: 4),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.stat.copyWith(fontSize: 15)),
        ],
      );
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});
  final String note;
  @override
  Widget build(BuildContext context) => LmCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Бележки'),
            const SizedBox(height: 8),
            Text(note, style: AppText.body.copyWith(fontSize: 14, height: 1.5)),
          ],
        ),
      );
}

class _MoodTrendCard extends StatelessWidget {
  const _MoodTrendCard({required this.data});
  final List<double> data;
  @override
  Widget build(BuildContext context) => LmCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('Тренд (30 дни)'),
            const SizedBox(height: 14),
            LmBarChart(data: data, color: AppColors.accent),
          ],
        ),
      );
}
