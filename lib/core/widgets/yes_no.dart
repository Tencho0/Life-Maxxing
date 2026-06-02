// YesNo — a two-option yes/no toggle.
// Mirrors the finalized prototype (design/life-maxxing/project/app/kit.jsx `YesNo`).

import 'package:flutter/widgets.dart';

import 'package:lifemaxxing/core/theme/tokens.dart';

import '../l10n/l10n_ext.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// A pair of equal-width buttons — 'Да' (true) and 'Не' (false).
///
/// The current [value] selects one button: selected 'Да' uses a green soft fill
/// with a green border and text; selected 'Не' uses a red soft fill with a red
/// border and text. Unselected buttons use the card surface, the default border
/// and dimmed text. A null [value] leaves both unselected. Tapping a button
/// reports its boolean via [onChanged].
class YesNo extends StatelessWidget {
  const YesNo({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool? value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Button(
          label: context.l10n.commonYes,
          selected: value == true,
          color: AppColors.green,
          selectedBg: AppColors.greenSoft,
          onTap: () => onChanged(true),
        ),
        const SizedBox(width: 8),
        _Button(
          label: context.l10n.commonNo,
          selected: value == false,
          color: AppColors.red,
          selectedBg: AppColors.redSoft,
          onTap: () => onChanged(false),
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.label,
    required this.selected,
    required this.color,
    required this.selectedBg,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final Color selectedBg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.all(13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? selectedBg : AppColors.card,
            border: Border.all(color: selected ? color : AppColors.border),
            borderRadius: BorderRadius.circular(AppRadii.input),
          ),
          child: Text(
            label,
            style: AppText.button.copyWith(
              color: selected ? color : AppColors.textDim,
            ),
          ),
        ),
      ),
    );
  }
}
