// Home aggregation — pure builders for the week rails (last-7 series + averages)
// and today's cross-module timeline. Kept Flutter-light (icons/colors only) and
// pure so they're unit-testable without a widget binding (spec §5 / Home).

import 'package:flutter/widgets.dart' show Color;

import '../../core/icons/lm_icons.dart';
import '../../core/theme/tokens.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';

double _mean(Iterable<num> xs) {
  final list = xs.toList();
  if (list.isEmpty) return 0;
  return list.fold<double>(0, (a, b) => a + b) / list.length;
}

/// Last-7-day series (aligned to [days]) + headline averages for the rails.
class HomeWeek {
  HomeWeek({
    required this.mood,
    required this.steps,
    required this.expense,
    required this.pulse,
    required this.avgMood,
    required this.avgSteps,
    required this.totalExpenseCents,
    required this.avgPulse,
  });

  final List<double> mood;
  final List<double> steps;
  final List<double> expense; // euros per day
  final List<double> pulse;
  final double avgMood;
  final double avgSteps;
  final int totalExpenseCents;
  final double avgPulse;
}

HomeWeek computeHomeWeek({
  required List<String> days,
  required List<DailyLog> logs,
  required List<StepEntry> steps,
  required List<Expense> expenses,
  required List<BloodPressureLog> bp,
}) {
  final moodBy = {for (final l in logs) l.date: l.mood};
  final stepsBy = {for (final s in steps) s.date: s.count};
  final expenseBy = <String, int>{};
  for (final e in expenses) {
    expenseBy[e.date] = (expenseBy[e.date] ?? 0) + e.amountCents;
  }
  final pulseBy = <String, List<int>>{};
  for (final b in bp) {
    (pulseBy[b.date] ??= []).add(b.pulse);
  }

  return HomeWeek(
    mood: [for (final d in days) (moodBy[d] ?? 0).toDouble()],
    steps: [for (final d in days) (stepsBy[d] ?? 0).toDouble()],
    expense: [for (final d in days) (expenseBy[d] ?? 0) / 100],
    pulse: [for (final d in days) _mean(pulseBy[d] ?? const <int>[])],
    avgMood: _mean(logs.map((l) => l.mood)),
    avgSteps: _mean(steps.map((s) => s.count)),
    totalExpenseCents: expenses.fold(0, (s, e) => s + e.amountCents),
    avgPulse: _mean(bp.map((b) => b.pulse)),
  );
}

/// One row in the "Дневен поток · днес" timeline.
class TimelineItem {
  TimelineItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.route,
    required this.sortKey,
  });

  final LmIcons icon;
  final Color color;
  final String title;
  final String subtitle;
  final String meta;
  final String route;
  final String sortKey; // HH:mm for chronological sort ('' → end)
}

List<TimelineItem> buildTodayTimeline({
  required List<Meal> meals,
  required List<Activity> activities,
  required List<Expense> expenses,
  required List<BloodPressureLog> bp,
  required List<MedicationLog> meds,
}) {
  final items = <TimelineItem>[];

  for (final b in bp) {
    items.add(TimelineItem(
      icon: LmIcons.pulse,
      color: AppColors.pink,
      title: '${b.systolic}/${b.diastolic}',
      subtitle: '${b.note ?? 'Кръвно'} · пулс ${b.pulse}',
      meta: b.time,
      route: '/health',
      sortKey: b.time,
    ));
  }
  for (final m in meals) {
    items.add(TimelineItem(
      icon: LmIcons.food,
      color: AppColors.amber,
      title: m.type.label,
      subtitle: m.calories != null ? '${m.name} · ${m.calories} kcal' : m.name,
      meta: m.time ?? '',
      route: '/food',
      sortKey: m.time ?? '',
    ));
  }
  final taken = meds.where((m) => m.status == MedStatus.taken).toList();
  if (taken.isNotEmpty) {
    items.add(TimelineItem(
      icon: LmIcons.pill,
      color: AppColors.accent,
      title: 'Добавки · ${taken.length} приети',
      subtitle: taken.map((m) => m.name).join(', '),
      meta: taken.first.time,
      route: '/health',
      sortKey: taken.first.time,
    ));
  }
  for (final a in activities) {
    items.add(TimelineItem(
      icon: LmIcons.dumbbell,
      color: AppColors.green,
      title: a.name ?? a.type.label,
      subtitle: [
        a.type.label,
        if (a.durationMin != null) '${a.durationMin} мин',
        if (a.intensity != null) a.intensity!.label,
      ].join(' · '),
      meta: a.startTime ?? '',
      route: '/activities',
      sortKey: a.startTime ?? '',
    ));
  }
  for (final e in expenses) {
    items.add(TimelineItem(
      icon: LmIcons.expense,
      color: AppColors.red,
      title: e.description,
      subtitle: e.category.label,
      meta: '−${e.amountCents ~/ 100} €',
      route: '/finance',
      sortKey: e.time ?? '',
    ));
  }

  items.sort((a, b) {
    // Empty sort keys sink to the end.
    if (a.sortKey.isEmpty && b.sortKey.isEmpty) return 0;
    if (a.sortKey.isEmpty) return 1;
    if (b.sortKey.isEmpty) return -1;
    return a.sortKey.compareTo(b.sortKey);
  });
  return items;
}
