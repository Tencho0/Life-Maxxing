// MoodPicker — a prominent mood gauge for the daily report whose color shifts
// red → amber → green with the value. Mirrors the prototype `MoodPicker`
// (design/life-maxxing/project/app/kit.jsx).

import 'package:flutter/widgets.dart';

import 'package:lifemaxxing/core/theme/mood_color.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

import '../l10n/enum_labels.dart';
import '../l10n/l10n_ext.dart';

/// A mood gauge: a big colored number + label over a row of ten segment
/// buttons (1..10). The card border and number tint follow [moodColor] of the
/// current [value]. Tapping a segment reports its number through [onChanged].
class MoodPicker extends StatelessWidget {
  const MoodPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// The selected mood (1..10).
  final int value;

  /// Called with the tapped number (1..10).
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final col = moodColor(value);
    return AnimatedContainer(
      duration: AppDurations.sheet,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: col),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: big number + label/sub on the left, '/ 10' on the right.
          Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 40),
                  child: Text(
                    '$value',
                    style: TextStyle(
                      fontFamily: AppText.mono,
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      color: col,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizedMoodLabel(context, value),
                        style: TextStyle(
                          fontFamily: AppText.sans,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: col,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        context.l10n.moodPickerPrompt,
                        style: const TextStyle(
                          fontFamily: AppText.mono,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textFaint,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 11),
                const Text(
                  '/ 10',
                  style: AppText.monoFaint,
                ),
              ],
            ),
          ),
          // Ten segment buttons.
          Row(
            children: [
              for (var n = 1; n <= 10; n++) ...[
                if (n > 1) const SizedBox(width: 4),
                Expanded(
                  child: _Segment(
                    n: n,
                    selected: n == value,
                    on: n <= value,
                    onTap: onChanged,
                  ),
                ),
              ],
            ],
          ),
          // Min/max captions.
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.moodPickerLow,
                  style: const TextStyle(
                    fontFamily: AppText.mono,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textFaint,
                  ),
                ),
                Text(
                  context.l10n.moodPickerHigh,
                  style: const TextStyle(
                    fontFamily: AppText.mono,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textFaint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.n,
    required this.selected,
    required this.on,
    required this.onTap,
  });

  final int n;
  final bool selected;
  final bool on;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final segColor = moodColor(n);
    final Color background;
    final Color borderColor;
    final Color textColor;
    if (selected) {
      background = segColor;
      borderColor = segColor;
      textColor = AppColors.bg;
    } else if (on) {
      background = segColor.withValues(alpha: 0.32);
      borderColor = const Color(0x00000000); // transparent
      textColor = AppColors.text;
    } else {
      background = AppColors.bg2;
      borderColor = AppColors.border;
      textColor = AppColors.textFaint;
    }

    return GestureDetector(
      onTap: () => onTap(n),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppDurations.fade,
        curve: Curves.easeOut,
        height: 34,
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          '$n',
          style: TextStyle(
            fontFamily: AppText.mono,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
