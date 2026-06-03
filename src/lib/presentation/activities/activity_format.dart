// Activity formatting helpers — duration text and the activity-group color
// palette used by the Activities screen.

import 'package:flutter/widgets.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/tokens.dart';
import '../../domain/enums.dart';

/// Minutes → "1ч 5м" / "45м" / "2ч".
String formatDuration(BuildContext context, int min) {
  if (min <= 0) return '0${context.l10n.unitMin}';
  final h = min ~/ 60;
  final m = min % 60;
  if (h == 0) return '$m${context.l10n.unitMin}';
  if (m == 0) return '$h${context.l10n.unitHour}';
  return '$h${context.l10n.unitHour} $m${context.l10n.unitMin}';
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
