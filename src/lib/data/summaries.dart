// Aggregate computations over fetched rows → typed DTOs (domain/summaries.dart).
// Pure functions (no DB/IO), so the bug-prone math is unit-testable directly.
// Rules: unfilled (null) values never contribute to sums/averages; empty
// inputs yield zero/null rather than throwing (spec §6.6 etc.).

import '../domain/enums.dart';
import '../domain/summaries.dart';
import 'database.dart';

/// Inclusive day count for a yyyy-MM-dd range (at least 1).
int daysInclusive(String fromYmd, String toYmd) {
  final from = DateTime.parse(fromYmd);
  final to = DateTime.parse(toYmd);
  final n = to.difference(from).inDays + 1;
  return n < 1 ? 1 : n;
}

double _mean(Iterable<num> xs) {
  var sum = 0.0, n = 0;
  for (final x in xs) {
    sum += x;
    n++;
  }
  return n == 0 ? 0 : sum / n;
}

// ── Finance (spec §10.3) ────────────────────────────────────────────
FinanceSummary computeFinance(
    List<Expense> expenses, List<IncomeEntry> income, int days) {
  final byCat = <ExpenseCategory, int>{};
  var totalExp = 0;
  for (final e in expenses) {
    totalExp += e.amountCents;
    byCat[e.category] = (byCat[e.category] ?? 0) + e.amountCents;
  }
  final totalInc = income.fold<int>(0, (s, i) => s + i.amountCents);

  ExpenseCategory? topCat;
  var topCents = 0;
  byCat.forEach((cat, cents) {
    if (cents > topCents) {
      topCents = cents;
      topCat = cat;
    }
  });

  return FinanceSummary(
    totalIncomeCents: totalInc,
    totalExpensesCents: totalExp,
    expenseCount: expenses.length,
    incomeCount: income.length,
    avgDailyExpenseCents: days > 0 ? (totalExp / days).round() : 0,
    byCategoryCents: byCat,
    topCategory: topCat,
    topCategoryCents: topCents,
  );
}

// ── Food (spec §6.6 / §6.7) ─────────────────────────────────────────
FoodSummary computeFood(List<Meal> meals, int days) {
  var cals = 0;
  var protein = 0.0, carbs = 0.0, fat = 0.0;
  final byType = <MealType, int>{};
  for (final m in meals) {
    if (m.calories != null) cals += m.calories!;
    if (m.protein != null) protein += m.protein!;
    if (m.carbs != null) carbs += m.carbs!;
    if (m.fat != null) fat += m.fat!;
    byType[m.type] = (byType[m.type] ?? 0) + 1;
  }
  return FoodSummary(
    totalCalories: cals,
    totalProtein: protein,
    totalCarbs: carbs,
    totalFat: fat,
    mealCount: meals.length,
    avgCaloriesPerDay: days > 0 ? cals / days : 0,
    avgProteinPerDay: days > 0 ? protein / days : 0,
    byType: byType,
  );
}

DailyNutrition computeDailyNutrition(List<Meal> meals) {
  var cals = 0;
  var protein = 0.0, carbs = 0.0, fat = 0.0;
  for (final m in meals) {
    if (m.calories != null) cals += m.calories!;
    if (m.protein != null) protein += m.protein!;
    if (m.carbs != null) carbs += m.carbs!;
    if (m.fat != null) fat += m.fat!;
  }
  return DailyNutrition(
      calories: cals, protein: protein, carbs: carbs, fat: fat,
      mealCount: meals.length);
}

// ── Activities (spec §7.7) ──────────────────────────────────────────
ActivitySummary computeActivities(List<Activity> acts) {
  final byType = <ActivityType, int>{};
  final byGroup = <ActivityGroup, int>{};
  var totalMin = 0;
  final durations = <int>[];
  for (final a in acts) {
    byType[a.type] = (byType[a.type] ?? 0) + 1;
    byGroup[a.type.group] = (byGroup[a.type.group] ?? 0) + 1;
    if (a.durationMin != null) {
      totalMin += a.durationMin!;
      durations.add(a.durationMin!);
    }
  }
  ActivityType? mostFrequent;
  var topCount = 0;
  byType.forEach((t, c) {
    if (c > topCount) {
      topCount = c;
      mostFrequent = t;
    }
  });
  return ActivitySummary(
    count: acts.length,
    totalMinutes: totalMin,
    strengthCount: byGroup[ActivityGroup.strength] ?? 0,
    combatCount: byGroup[ActivityGroup.combat] ?? 0,
    outdoorCount: byGroup[ActivityGroup.cardio] ?? 0,
    avgDurationMin: _mean(durations),
    byGroup: byGroup,
    byType: byType,
    mostFrequent: mostFrequent,
  );
}

// ── Steps (spec §18.6) ──────────────────────────────────────────────
StepsSummary computeSteps(List<StepEntry> steps) {
  if (steps.isEmpty) {
    return StepsSummary(total: 0, avg: 0, best: 0, worst: 0, daysLogged: 0);
  }
  final counts = steps.map((s) => s.count).toList();
  final total = counts.fold<int>(0, (s, c) => s + c);
  return StepsSummary(
    total: total,
    avg: total / counts.length,
    best: counts.reduce((a, b) => a > b ? a : b),
    worst: counts.reduce((a, b) => a < b ? a : b),
    daysLogged: counts.length,
  );
}

/// Weight over a period. Orders by date so latest/earliest are unambiguous
/// regardless of input order.
WeightSummary computeWeight(List<WeightLog> logs) {
  if (logs.isEmpty) {
    return WeightSummary(
        latestGrams: 0, changeGrams: 0, minGrams: 0, maxGrams: 0, count: 0);
  }
  final sorted = [...logs]..sort((a, b) => a.date.compareTo(b.date));
  final grams = sorted.map((w) => w.weightGrams).toList();
  return WeightSummary(
    latestGrams: sorted.last.weightGrams,
    changeGrams: sorted.last.weightGrams - sorted.first.weightGrams,
    minGrams: grams.reduce((a, b) => a < b ? a : b),
    maxGrams: grams.reduce((a, b) => a > b ? a : b),
    count: sorted.length,
  );
}

// ── Health (spec §16.2) ─────────────────────────────────────────────
HealthSummary computeHealth(
  List<BloodPressureLog> bp,
  List<HealthEvent> events,
  List<LabTest> labs,
  List<MedicationLog> meds,
) {
  final sortedBp = [...bp]
    ..sort((a, b) {
      final d = b.date.compareTo(a.date);
      return d != 0 ? d : b.time.compareTo(a.time);
    });
  final last = sortedBp.isNotEmpty ? sortedBp.first : null;

  String? lastByDate(Iterable<String> dates) {
    String? best;
    for (final d in dates) {
      if (best == null || d.compareTo(best) > 0) best = d;
    }
    return best;
  }

  final dental = events.where((e) => e.type == HealthEventType.dentist);

  return HealthSummary(
    bpCount: bp.length,
    eventCount: events.length,
    labCount: labs.length,
    medCount: meds.length,
    lastSystolic: last?.systolic,
    lastDiastolic: last?.diastolic,
    lastPulse: last?.pulse,
    avgSystolic: bp.isEmpty ? null : _mean(bp.map((x) => x.systolic)),
    avgDiastolic: bp.isEmpty ? null : _mean(bp.map((x) => x.diastolic)),
    avgPulse: bp.isEmpty ? null : _mean(bp.map((x) => x.pulse)),
    lastDentalDate: lastByDate(dental.map((e) => e.date)),
    lastLabDate: lastByDate(labs.map((l) => l.date)),
  );
}

// ── Daily Quick Log (spec §17.6) ────────────────────────────────────
DailyLogSummary computeDailyLogs(List<DailyLog> logs) {
  final alcohol = logs.where((l) => l.drankAlcohol).length;
  final screens = logs
      .where((l) => l.screenTimeMin != null)
      .map((l) => l.screenTimeMin!);
  return DailyLogSummary(
    filled: logs.length,
    avgMood: _mean(logs.map((l) => l.mood)),
    proudDays: logs.where((l) => l.proud).length,
    uncomfortableDays: logs.where((l) => l.didUncomfortable).length,
    workoutDays: logs.where((l) => l.workout).length,
    alcoholDays: alcohol,
    noAlcoholDays: logs.length - alcohol,
    avgScreenMin: _mean(screens),
  );
}

// ── Bucket list (spec §20.11) ───────────────────────────────────────
BucketStats computeBucket(List<BucketItem> items, List<BucketExperience> exps) {
  int byStatus(BucketStatus s) =>
      items.where((i) => i.status == s).length;
  final worth = exps.where((e) => e.worthIt).length;
  return BucketStats(
    total: items.length,
    ideas: byStatus(BucketStatus.idea),
    planned: byStatus(BucketStatus.planned),
    completed: byStatus(BucketStatus.completed),
    abandoned: byStatus(BucketStatus.abandoned),
    high: items.where((i) => i.priority == BucketPriority.high).length,
    avgFeeling: exps.isEmpty ? 0 : _mean(exps.map((e) => e.feelingRating)),
    worthItCount: worth,
    notWorthItCount: exps.length - worth,
  );
}

// ── Trips (spec §21.9) ──────────────────────────────────────────────
TripStats computeTrips(List<Trip> trips) {
  if (trips.isEmpty) {
    return TripStats(
        count: 0, avgOverall: 0, repeatCount: 0,
        avgFun: 0, avgFood: 0, avgSights: 0, avgValue: 0);
  }
  Trip best = trips.first;
  for (final t in trips) {
    if (t.overall > best.overall) best = t;
  }
  double avgOf(Iterable<int?> xs) =>
      _mean(xs.where((x) => x != null).cast<int>());
  return TripStats(
    count: trips.length,
    avgOverall: _mean(trips.map((t) => t.overall)),
    repeatCount: trips.where((t) => t.wouldRepeat == true).length,
    avgFun: avgOf(trips.map((t) => t.fun)),
    avgFood: avgOf(trips.map((t) => t.food)),
    avgSights: avgOf(trips.map((t) => t.sights)),
    avgValue: avgOf(trips.map((t) => t.value)),
    bestTitle: best.title,
  );
}
