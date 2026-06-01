// Scale10 — a row of ten square buttons (1..10) for picking a rating.
// Mirrors the prototype `Scale10` (design/life-maxxing/project/app/kit.jsx).

import 'package:flutter/widgets.dart';

import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// A horizontal row of ten square buttons numbered 1 through 10.
///
/// The currently [value] (if any) is filled with [color] and shows
/// [AppColors.bg] text; the rest use the card surface with a 1px border and
/// dimmed text. Tapping a button reports its number through [onChanged].
class Scale10 extends StatelessWidget {
  const Scale10({
    super.key,
    required this.value,
    required this.onChanged,
    this.color = AppColors.accent,
  });

  /// The selected number (1..10), or null when nothing is selected.
  final int? value;

  /// Called with the tapped number (1..10).
  final ValueChanged<int> onChanged;

  /// Fill/border color of the selected button.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var n = 1; n <= 10; n++) ...[
          if (n > 1) const SizedBox(width: 5),
          Expanded(child: _Cell(n: n, selected: value == n, color: color, onTap: onChanged)),
        ],
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.n,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final int n;
  final bool selected;
  final Color color;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(n),
      behavior: HitTestBehavior.opaque,
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? color : AppColors.card,
            border: Border.all(color: selected ? color : AppColors.border),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '$n',
              style: TextStyle(
                fontFamily: AppText.mono,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.bg : AppColors.textDim,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
