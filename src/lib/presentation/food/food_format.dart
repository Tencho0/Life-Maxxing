// Food formatting helpers — calories, macro grams, and the meal-type /
// macro color palette used by the Food screen.

import 'package:flutter/widgets.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/tokens.dart';
import '../../domain/enums.dart';

/// Calories as a whole number, e.g. 680 → "680 kcal".
String kcal(int calories) => '$calories kcal';

/// Macro grams, rounded to whole grams, e.g. 14.0 → "14 г".
String grams(BuildContext context, double g) => '${g.round()} ${context.l10n.unitGrams}';

// Macro colors (protein / carbs / fat).
const Color proteinColor = AppColors.accent;
const Color carbsColor = AppColors.amber;
const Color fatColor = AppColors.pink;

const _mealPalette = [
  AppColors.amber, // breakfast
  AppColors.green, // lunch
  AppColors.accent, // dinner
  AppColors.purple, // snack
  AppColors.pink, // other
];

Color mealTypeColor(MealType t) => _mealPalette[t.index % _mealPalette.length];
