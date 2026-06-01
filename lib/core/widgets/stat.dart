// Stat — a labeled metric block: eyebrow label, large mono value with an
// optional faint unit, and an optional sub line. Mirrors the prototype
// `Stat` (design/life-maxxing/project/app/kit.jsx).

import 'package:flutter/widgets.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// A compact metric block: an uppercase eyebrow [label], a large mono [value]
/// (optionally suffixed by a small faint [unit]), and an optional [sub] line.
///
/// [color] overrides the value's color (defaults to the standard text color).
class Stat extends StatelessWidget {
  const Stat({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.color,
    this.sub,
  });

  final String label;
  final String value;
  final String? unit;
  final Color? color;
  final String? sub;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(), style: AppText.eyebrow),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            text: value,
            children: unit != null
                ? [
                    TextSpan(
                      text: ' $unit',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textFaint,
                      ),
                    ),
                  ]
                : null,
          ),
          style: AppText.stat.copyWith(color: color ?? AppColors.text),
        ),
        if (sub != null) ...[
          const SizedBox(height: 2),
          Text(
            sub!,
            style: const TextStyle(fontSize: 11, color: AppColors.textDim),
          ),
        ],
      ],
    );
  }
}
