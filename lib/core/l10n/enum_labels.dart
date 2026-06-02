// Presentation-layer resolver for enum display labels. Storage keeps the stable
// lowercase `code` (search/export/backup); the UI shows a localized label,
// looked up from ARB by code. Enums not yet migrated fall back to their
// (Bulgarian) `enum.label` — used by export_service/SearchDao until Slice 10.4.

import 'package:flutter/widgets.dart';

import '../../domain/enums.dart';
import 'l10n_ext.dart';

/// The localized display label for a [Coded] enum value in the active locale.
String localizedLabel(BuildContext context, Coded value) {
  final l = context.l10n;
  return switch (value) {
    MealType() => l.mealTypeLabel(value.code),
    ActivityType() => l.activityTypeLabel(value.code),
    ActivityGroup() => l.activityGroupLabel(value.code),
    Intensity() => l.intensityLabel(value.code),
    ExpenseCategory() => l.expenseCategoryLabel(value.code),
    IncomeCategory() => l.incomeCategoryLabel(value.code),
    PaymentMethod() => l.paymentMethodLabel(value.code),
    HealthEventType() => l.healthEventTypeLabel(value.code),
    DentalSubtype() => l.dentalSubtypeLabel(value.code),
    MedType() => l.medTypeLabel(value.code),
    MedStatus() => l.medStatusLabel(value.code),
    BucketPriority() => l.bucketPriorityLabel(value.code),
    BucketStatus() => l.bucketStatusLabel(value.code),
    Period() => l.periodLabel(value.code),
    _ => value.label,
  };
}

/// The short label used by the period selector chips (distinct from the full
/// [localizedLabel] of a [Period]).
String periodChipLabel(BuildContext context, Period value) =>
    context.l10n.periodChipLabel(value.code);

/// Localized 1–10 mood descriptor (mirrors the ranges of `moodLabel`, which
/// returns the stable storage-independent bands — here resolved per locale).
String localizedMoodLabel(BuildContext context, int value) {
  final l = context.l10n;
  final v = value.clamp(1, 10);
  if (v <= 2) return l.moodVeryBad;
  if (v <= 4) return l.moodBad;
  if (v <= 6) return l.moodMid;
  if (v <= 8) return l.moodGood;
  if (v <= 9) return l.moodVeryGood;
  return l.moodGreat;
}
