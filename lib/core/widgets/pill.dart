// Pill / chip + Delta badge — ported from the prototype (lib/ui.jsx `Pill`,
// `Delta`). Match the prototype's exact sizes, paddings, radii and colors.

import 'package:flutter/widgets.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// Inline chip: a colored label on a soft rounded background.
///
/// Mirrors the prototype `Pill`: mono 11 / w500 / letterSpacing 0.3 text tinted
/// by [color], on a [background] (default [AppColors.white05]), 3×9 padding,
/// fully rounded ([AppRadii.pill]). An optional [leading] widget (e.g. a small
/// [LmIcon]) sits before the text with a 5px gap.
class Pill extends StatelessWidget {
  const Pill(
    this.text, {
    super.key,
    this.color = AppColors.accent,
    this.background,
    this.leading,
  });

  final String text;
  final Color color;
  final Color? background;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background ?? AppColors.white05,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 5),
            ],
            Text(
              text,
              style: AppText.pill.copyWith(color: color, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Delta indicator: a ▲/▼ arrow with the absolute [value] and a [suffix]
/// (default `%`), in mono 12. Green when the change is "good", else red.
///
/// Mirrors the prototype `Delta`: `up = value >= 0`; a positive value is good
/// unless [invert] is set (in which case a negative value is the good one).
class DeltaBadge extends StatelessWidget {
  const DeltaBadge(
    this.value, {
    super.key,
    this.invert = false,
    this.suffix = '%',
  });

  final num value;
  final bool invert;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final up = value >= 0;
    final good = invert ? !up : up;
    final col = good ? AppColors.green : AppColors.red;
    final abs = value < 0 ? -value : value;

    final base = AppText.pill.copyWith(
      fontSize: 12,
      letterSpacing: 0,
      color: col,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(up ? '▲' : '▼', style: base.copyWith(fontSize: 9)),
        const SizedBox(width: 2),
        Text('$abs$suffix', style: base),
      ],
    );
  }
}
