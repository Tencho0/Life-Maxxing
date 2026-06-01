// Period selector — a horizontally scrollable row of mono chips.
// Mirrors the prototype `PeriodChips` + `PERIODS` (design/life-maxxing/project/app/kit.jsx).
//
// Label-based for now; domain `Period` wiring comes later.

import 'package:flutter/material.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// Default period labels, matching the prototype's `PERIODS`.
const List<String> kPeriods = ['Днес', '7 дни', '30 дни', 'Месец', 'Custom'];

/// A horizontally scrollable row of period-selection chips.
///
/// The chip matching [value] is highlighted (1px accent border, accent-soft
/// fill, accent text); the rest use a faint border, transparent fill and
/// dimmed text.
class PeriodChips extends StatelessWidget {
  const PeriodChips({
    super.key,
    required this.value,
    required this.onChanged,
    this.options = kPeriods,
  });

  /// Currently-selected period label.
  final String value;

  /// Called with the tapped period label.
  final ValueChanged<String> onChanged;

  /// The chip labels to render.
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: 7),
            _Chip(
              label: options[i],
              selected: options[i] == value,
              onTap: () => onChanged(options[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accent : AppColors.textDim;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.accentSoft : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.pill),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Text(label, style: AppText.mono12.copyWith(color: color)),
      ),
    );
  }
}
