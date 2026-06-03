// Segmented — a row/grid of mutually-exclusive option buttons.
// Mirrors the prototype's `Segmented` (design/life-maxxing/project/app/kit.jsx).
//
// Selected option: 1px accent border, accentSoft fill, accent text, w600.
// Unselected: 1px border, card fill, dim text, w500.
// When [columns] is set, options lay out in an equal-width grid of that many
// columns; otherwise they flow in a wrap, each expanding to fill its line.

import 'package:flutter/widgets.dart';

import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// A set of selectable option buttons where exactly one [value] is active.
class Segmented extends StatelessWidget {
  const Segmented({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.columns,
  });

  /// The selectable option labels (also used as the values).
  final List<String> options;

  /// The currently selected option.
  final String value;

  /// Called with the tapped option's value.
  final ValueChanged<String> onChanged;

  /// When non-null, lay out as a grid of this many equal-width columns.
  /// When null, the options flow in a wrap.
  final int? columns;

  static const double _gap = 7;

  @override
  Widget build(BuildContext context) {
    if (columns != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final cols = columns!;
          final totalGap = _gap * (cols - 1);
          final tileWidth = (constraints.maxWidth - totalGap) / cols;
          return Wrap(
            spacing: _gap,
            runSpacing: _gap,
            children: [
              for (final o in options)
                SizedBox(
                  width: tileWidth,
                  child: _SegmentButton(
                    label: o,
                    selected: o == value,
                    onTap: () => onChanged(o),
                  ),
                ),
            ],
          );
        },
      );
    }

    return Wrap(
      spacing: _gap,
      runSpacing: _gap,
      children: [
        for (final o in options)
          _SegmentButton(
            label: o,
            selected: o == value,
            onTap: () => onChanged(o),
          ),
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentSoft : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppText.sans,
            fontSize: 13.5,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.accent : AppColors.textDim,
          ),
        ),
      ),
    );
  }
}
