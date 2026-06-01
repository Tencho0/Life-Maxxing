// Activity formatting helpers — duration text and the activity-group color
// palette used by the Activities screen.

import 'package:flutter/widgets.dart';
import '../../core/theme/tokens.dart';
import '../../domain/enums.dart';

/// Minutes → "1ч 5м" / "45м" / "2ч".
String formatDuration(int min) {
  if (min <= 0) return '0м';
  final h = min ~/ 60;
  final m = min % 60;
  if (h == 0) return '$mм';
  if (m == 0) return '$hч';
  return '$hч $mм';
}

const _groupPalette = {
  ActivityGroup.strength: AppColors.accent,
  ActivityGroup.combat: AppColors.red,
  ActivityGroup.cardio: AppColors.green,
  ActivityGroup.dance: AppColors.purple,
  ActivityGroup.other: AppColors.amber,
};

Color activityGroupColor(ActivityGroup g) =>
    _groupPalette[g] ?? AppColors.accent;
