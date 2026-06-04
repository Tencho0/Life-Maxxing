// Typed summary DTOs returned by the aggregate queries (spec §6.6/§6.7, §7.7,
// §10.3, §16.2, §17.6, §18.6, §20.11, §21.9). Pure Dart — money in cents,
// all in EUR. Compute logic lives in data/summaries.dart.

import 'enums.dart';

/// Finance over a period (spec §10.3). Money in cents.
class FinanceSummary {
  FinanceSummary({
    required this.totalIncomeCents,
    required this.totalExpensesCents,
    required this.expenseCount,
    required this.incomeCount,
    required this.avgDailyExpenseCents,
    required this.byCategoryCents,
    this.topCategory,
    required this.topCategoryCents,
  });

  final int totalIncomeCents;
  final int totalExpensesCents;
  final int expenseCount;
  final int incomeCount;
  final int avgDailyExpenseCents;
  final Map<ExpenseCategory, int> byCategoryCents;
  final ExpenseCategory? topCategory;
  final int topCategoryCents;

  int get balanceCents => totalIncomeCents - totalExpensesCents;
}

/// Food over a period (spec §6.7). Calories int; macros grams (double).
class FoodSummary {
  FoodSummary({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.mealCount,
    required this.avgCaloriesPerDay,
    required this.avgProteinPerDay,
    required this.byType,
  });

  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final int mealCount;
  final double avgCaloriesPerDay;
  final double avgProteinPerDay;
  final Map<MealType, int> byType;
}

/// Single-day nutrition totals (spec §6.6). Unfilled fields don't contribute.
class DailyNutrition {
  DailyNutrition({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.mealCount,
  });

  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final int mealCount;
}

/// Activities over a period (spec §7.7).
class ActivitySummary {
  ActivitySummary({
    required this.count,
    required this.totalMinutes,
    required this.strengthCount,
    required this.combatCount,
    required this.outdoorCount,
    required this.avgDurationMin,
    required this.byGroup,
    required this.byType,
    this.mostFrequent,
  });

  final int count;
  final int totalMinutes;
  final int strengthCount;
  final int combatCount;
  final int outdoorCount;
  final double avgDurationMin;
  final Map<ActivityGroup, int> byGroup;
  final Map<ActivityType, int> byType;
  final ActivityType? mostFrequent;
}

/// Steps over a period (spec §18.6).
class StepsSummary {
  StepsSummary({
    required this.total,
    required this.avg,
    required this.best,
    required this.worst,
    required this.daysLogged,
  });

  final int total;
  final double avg;
  final int best;
  final int worst;
  final int daysLogged;
}

/// Body weight over a period. All masses in integer grams (shown in kg).
class WeightSummary {
  WeightSummary({
    required this.latestGrams,
    required this.changeGrams,
    required this.minGrams,
    required this.maxGrams,
    required this.count,
  });

  /// Most recent entry's weight in the range (0 when none).
  final int latestGrams;

  /// latest − earliest in the range (signed; 0 when fewer than 2 entries).
  final int changeGrams;
  final int minGrams;
  final int maxGrams;
  final int count;
}

/// Health over a period (spec §16.2).
class HealthSummary {
  HealthSummary({
    required this.bpCount,
    required this.eventCount,
    required this.labCount,
    required this.medCount,
    this.lastSystolic,
    this.lastDiastolic,
    this.lastPulse,
    this.avgSystolic,
    this.avgDiastolic,
    this.avgPulse,
    this.lastDentalDate,
    this.lastLabDate,
  });

  final int bpCount;
  final int eventCount;
  final int labCount;
  final int medCount;
  final int? lastSystolic;
  final int? lastDiastolic;
  final int? lastPulse;
  final double? avgSystolic;
  final double? avgDiastolic;
  final double? avgPulse;
  final String? lastDentalDate;
  final String? lastLabDate;
}

/// Daily Quick Log over a period (spec §17.6).
class DailyLogSummary {
  DailyLogSummary({
    required this.filled,
    required this.avgMood,
    required this.proudDays,
    required this.uncomfortableDays,
    required this.workoutDays,
    required this.alcoholDays,
    required this.noAlcoholDays,
    required this.avgScreenMin,
  });

  final int filled;
  final double avgMood;
  final int proudDays;
  final int uncomfortableDays;
  final int workoutDays;
  final int alcoholDays;
  final int noAlcoholDays;
  final double avgScreenMin;
}

/// Bucket list stats (spec §20.11).
class BucketStats {
  BucketStats({
    required this.total,
    required this.ideas,
    required this.planned,
    required this.completed,
    required this.abandoned,
    required this.high,
    required this.avgFeeling,
    required this.worthItCount,
    required this.notWorthItCount,
  });

  final int total;
  final int ideas;
  final int planned;
  final int completed;
  final int abandoned;
  final int high;
  final double avgFeeling;
  final int worthItCount;
  final int notWorthItCount;
}

/// Trips stats (spec §21.9).
class TripStats {
  TripStats({
    required this.count,
    required this.avgOverall,
    required this.repeatCount,
    required this.avgFun,
    required this.avgFood,
    required this.avgSights,
    required this.avgValue,
    this.bestTitle,
  });

  final int count;
  final double avgOverall;
  final int repeatCount;
  final double avgFun;
  final double avgFood;
  final double avgSights;
  final double avgValue;
  final String? bestTitle;
}
