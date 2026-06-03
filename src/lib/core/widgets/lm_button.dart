// LmButton — the design system's button (prototype `Btn`, app/kit.jsx).
//
// Three variants: a solid accent primary, a bordered ghost, and a tinted
// danger. Text is AppText.button (15 / w600), padding 13×18, radius 14, with
// an optional leading icon (18px) tinted to match the text colour, gap 8.

import 'package:flutter/widgets.dart';

import 'package:lifemaxxing/core/icons/lm_icons.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// Visual style of an [LmButton].
enum LmButtonVariant {
  /// Solid accent fill, dark label/icon, no border.
  primary,

  /// Card fill, light label, thin border.
  ghost,

  /// Soft-red fill, red label/icon and border.
  danger,
}

/// A button matching the prototype `Btn`.
///
/// ```dart
/// LmButton('Запази', onTap: _save)
/// LmButton('Отказ', variant: LmButtonVariant.ghost, onTap: _cancel)
/// LmButton('Изтрий', variant: LmButtonVariant.danger, icon: LmIcons.trash)
/// ```
class LmButton extends StatelessWidget {
  const LmButton(
    this.label, {
    super.key,
    this.onTap,
    this.variant = LmButtonVariant.primary,
    this.full = false,
    this.icon,
  });

  /// The button's text label.
  final String label;

  /// Tapped callback. When null the button is non-interactive.
  final VoidCallback? onTap;

  /// Which visual style to render.
  final LmButtonVariant variant;

  /// When true the button expands to fill its parent's width.
  final bool full;

  /// Optional leading icon, drawn at 18px in the label colour.
  final LmIcons? icon;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, border) = switch (variant) {
      LmButtonVariant.primary => (AppColors.accent, AppColors.bg, null),
      LmButtonVariant.ghost => (AppColors.card, AppColors.text, AppColors.border),
      LmButtonVariant.danger => (AppColors.redSoft, AppColors.red, AppColors.red),
    };

    final content = Row(
      mainAxisSize: full ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          LmIcon(icon!, size: 18, color: foreground, strokeWidth: 2),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppText.button.copyWith(color: foreground)),
        ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: full ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
          border: border == null ? null : Border.all(color: border, width: 1),
        ),
        child: content,
      ),
    );
  }
}
