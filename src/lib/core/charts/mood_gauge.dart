// MoodGauge — a compact, read-only mood ramp indicator.
//
// Hand-painted with a [CustomPainter] (no fl_chart). Draws 10 rounded segments
// left→right; segment n (1..10) is filled with `moodColor(n)` when n <= value
// (a low ~0.3 alpha for n < value, full color for the current value's segment),
// otherwise `AppColors.bg2`. Mirrors the segment styling of the prototype's
// MoodPicker (design/life-maxxing/project/app/kit.jsx), as a read-only ramp.

import 'package:flutter/widgets.dart';

import 'package:lifemaxxing/core/theme/mood_color.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';

/// A compact, read-only ramp of 10 segments visualising a mood [value] (1–10).
///
/// Segment n is filled with [moodColor] when `n <= value` — at ~0.3 alpha for
/// passed segments and at full color for the current ([value]) segment — and
/// with [AppColors.bg2] otherwise. Segments have small gaps and rounded ends.
class MoodGauge extends StatelessWidget {
  const MoodGauge({super.key, required this.value, this.height = 12});

  /// Mood value (1–10). Clamped when painted.
  final int value;

  /// Height of the ramp in logical pixels.
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _MoodGaugePainter(value: value.clamp(1, 10)),
      ),
    );
  }
}

class _MoodGaugePainter extends CustomPainter {
  const _MoodGaugePainter({required this.value});

  /// Pre-clamped mood value (1–10).
  final int value;

  /// Gap between segments (matches the prototype's `gap:4`).
  static const double _gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    const segments = 10;
    final segWidth = (size.width - _gap * (segments - 1)) / segments;
    if (segWidth <= 0) return;
    final radius = Radius.circular(size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    for (var n = 1; n <= segments; n++) {
      final left = (n - 1) * (segWidth + _gap);
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, 0, segWidth, size.height),
        radius,
      );

      final Color color;
      if (n == value) {
        color = moodColor(n); // current segment: full color
      } else if (n < value) {
        color = moodColor(n).withValues(alpha: 0.3); // passed: low alpha
      } else {
        color = AppColors.bg2; // empty
      }

      canvas.drawRRect(rect, paint..color = color);
    }
  }

  @override
  bool shouldRepaint(_MoodGaugePainter oldDelegate) => oldDelegate.value != value;
}
