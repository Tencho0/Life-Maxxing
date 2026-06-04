// Health formatting helpers — medication-status color + the "next dental"
// recommendation derived from the latest dental visit (spec §12).

import 'package:flutter/widgets.dart' show Color;

import '../../core/theme/tokens.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';

/// Color for a medication status pill (Прието green / Пропуснато red).
Color medStatusColor(MedStatus s) =>
    s == MedStatus.taken ? AppColors.green : AppColors.red;

/// The recommended next dental date — the `nextRecommendedDate` of the most
/// recent dental visit that has one (null if none). Non-dental events ignored.
String? nextDentalDate(List<HealthEvent> events) {
  final dental = events
      .where((e) => e.type == HealthEventType.dentist && e.nextRecommendedDate != null)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date)); // most recent visit first
  return dental.isEmpty ? null : dental.first.nextRecommendedDate;
}

/// Integer grams → one-decimal kilograms with the Bulgarian unit, e.g.
/// 82500 → "82.5 кг".
String formatKg(int grams) => '${(grams / 1000).toStringAsFixed(1)} кг';

/// Signed kilogram delta for the trend stat: "+1.2 кг", "−0.8 кг", "±0.0 кг".
/// Uses the typographic minus (U+2212) for losses.
String formatKgDelta(int grams) {
  final kg = (grams.abs() / 1000).toStringAsFixed(1);
  final sign = grams > 0 ? '+' : (grams < 0 ? '−' : '±');
  return '$sign$kg кг';
}
