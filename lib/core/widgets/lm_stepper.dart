// LmStepper — the design system's numeric stepper (prototype `Stepper`,
// app/kit.jsx). Renamed from `Stepper` to avoid clashing with Flutter's
// material Stepper.
//
// A row in a card (card fill, 1px border, radius 13, padding 6×10, gap 10):
// a 38×38 '−' button, a centered mono value (20 / w600) with an optional
// small faint suffix, and a 38×38 '+' button. Each button uses a ~6% white
// fill and a 10px radius. Decrement is clamped at [min] when provided.

import 'package:flutter/widgets.dart';

import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// A numeric stepper matching the prototype `Stepper`.
///
/// ```dart
/// LmStepper(value: _reps, onChanged: (v) => setState(() => _reps = v))
/// LmStepper(value: _ml, step: 50, suffix: 'мл', min: 0, onChanged: _set)
/// ```
class LmStepper extends StatelessWidget {
  const LmStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.suffix,
    this.min,
  });

  /// The current value displayed in the centre.
  final int value;

  /// Called with the new value when '−' or '+' is tapped.
  final ValueChanged<int> onChanged;

  /// Amount added/subtracted per tap.
  final int step;

  /// Optional unit shown after the value in a small, faint style.
  final String? suffix;

  /// Optional lower bound; the value never drops below this when decrementing.
  final int? min;

  void _decrement() {
    final next = value - step;
    onChanged(min != null && next < min! ? min! : next);
  }

  void _increment() => onChanged(value + step);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          _StepButton(symbol: '−', onTap: _decrement),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: '$value',
                style: const TextStyle(
                  fontFamily: AppText.mono,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
                children: [
                  if (suffix != null)
                    TextSpan(
                      text: ' $suffix',
                      style: const TextStyle(
                        fontFamily: AppText.mono,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textFaint,
                      ),
                    ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
          _StepButton(symbol: '+', onTap: _increment),
        ],
      ),
    );
  }
}

/// A single 38×38 stepper button with a ~6% white fill and 10px radius.
class _StepButton extends StatelessWidget {
  const _StepButton({required this.symbol, required this.onTap});

  final String symbol;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white05,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          symbol,
          style: const TextStyle(
            fontFamily: AppText.sans,
            fontSize: 22,
            color: AppColors.text,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
