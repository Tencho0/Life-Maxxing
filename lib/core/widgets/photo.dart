// Photo widgets — the dashed dropzone and the placeholder visual-memory tile.
// Mirrors the prototype `PhotoAdd` and `PhotoTile`
// (design/life-maxxing/project/app/kit.jsx).

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'package:lifemaxxing/core/icons/lm_icons.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// A dashed-border dropzone inviting the user to attach a photo.
///
/// Renders a centered column with a camera glyph, a [label], and — when
/// [multi] is true — a faint "може няколко" caption. The 1.5px dashed border
/// (in [AppColors.borderHi]) is drawn by a [CustomPainter] since Flutter's
/// [Border] has no native dashed style.
class PhotoAdd extends StatelessWidget {
  const PhotoAdd({
    super.key,
    this.label = 'Добави снимка',
    this.multi = false,
    this.onTap,
  });

  /// The primary call-to-action text.
  final String label;

  /// When true, shows a "може няколко" caption hinting multiple photos.
  final bool multi;

  /// Invoked when the dropzone is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: CustomPaint(
        painter: const _DashedBorderPainter(
          color: AppColors.borderHi,
          strokeWidth: 1.5,
          radius: 14,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            // rgba(255,255,255,0.02) — slightly under the white05 token.
            color: const Color(0x05FFFFFF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LmIcon(LmIcons.camera, size: 24, color: AppColors.textFaint),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppText.sans,
                  fontSize: 13,
                  color: AppColors.textDim,
                ),
              ),
              if (multi) ...[
                const SizedBox(height: 8),
                const Text(
                  'може няколко',
                  style: TextStyle(
                    fontFamily: AppText.mono,
                    fontSize: 10.5,
                    color: AppColors.textFaint,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// An honest placeholder for a visual memory: a diagonally-shaded tile with a
/// faint hatch, a camera glyph, and optional [date] / [label] captions.
///
/// The fill is a 150° gradient derived from [hue] (two dark, desaturated
/// stops), approximating the prototype's oklch(0.4 0.06 h) → oklch(0.26 0.05
/// h+30) gradient. [aspectRatio] sets the tile's shape (1 = square).
class PhotoTile extends StatelessWidget {
  const PhotoTile({
    super.key,
    this.date,
    this.hue = 220,
    this.aspectRatio = 1,
    this.label,
  });

  /// Caption shown bottom-left (e.g. a date). Hidden when null.
  final String? date;

  /// Base hue (0..360) for the gradient fill.
  final double hue;

  /// Width-to-height ratio of the tile.
  final double aspectRatio;

  /// Caption shown bottom-right. Hidden when null.
  final String? label;

  @override
  Widget build(BuildContext context) {
    // oklch lightness/chroma → HSL approximation: dark, low-saturation stops.
    final start = HSLColor.fromAHSL(1, hue % 360, 0.22, 0.30).toColor();
    final end = HSLColor.fromAHSL(1, (hue + 30) % 360, 0.18, 0.18).toColor();

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // 150° measured from the x-axis (CSS) ≈ this begin/end.
            begin: const Alignment(-0.5, -1),
            end: const Alignment(0.5, 1),
            colors: [start, end],
          ),
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // 135° hatch overlay: white 5% for 2px then a 7px gap.
              const Positioned.fill(
                child: Opacity(
                  opacity: 0.5,
                  child: CustomPaint(painter: _HatchPainter()),
                ),
              ),
              const Positioned(
                top: 8,
                left: 9,
                child: LmIcon(
                  LmIcons.camera,
                  size: 15,
                  color: Color(0x99FFFFFF), // white 60%
                ),
              ),
              if (date != null)
                Positioned(
                  bottom: 7,
                  left: 9,
                  child: Text(
                    date!,
                    style: const TextStyle(
                      fontFamily: AppText.mono,
                      fontSize: 10.5,
                      color: Color(0xD1FFFFFF), // white 82%
                    ),
                  ),
                ),
              if (label != null)
                Positioned(
                  bottom: 7,
                  right: 9,
                  child: Text(
                    label!,
                    style: const TextStyle(
                      fontFamily: AppText.mono,
                      fontSize: 10,
                      color: Color(0xB3FFFFFF), // white 70%
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Draws a dashed rounded-rectangle border, inset by half the stroke width so
/// the stroke sits fully inside the painted bounds.
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double radius;

  static const double _dash = 5;
  static const double _gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final inset = strokeWidth / 2;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        inset,
        inset,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + _dash),
          paint,
        );
        distance += _dash + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.strokeWidth != strokeWidth ||
      old.radius != radius;
}

/// Repeating 135° hatch: a 2px white line every 9px (matching the prototype's
/// `repeating-linear-gradient(135deg, rgba(255,255,255,0.05) 0 2px, transparent
/// 2px 9px)`).
class _HatchPainter extends CustomPainter {
  const _HatchPainter();

  static const double _line = 2;
  static const double _period = 9;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0DFFFFFF) // white 5%
      ..strokeWidth = _line
      ..style = PaintingStyle.stroke;

    // 135° direction: stripes run along (-1, 1); step perpendicular along (1, 1).
    final diag = size.width + size.height;
    final step = _period * math.sqrt2;
    for (var d = -size.height; d < diag; d += step) {
      // A line of slope +1 (top-left → bottom-right) offset by d.
      canvas.drawLine(Offset(d, 0), Offset(d + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_HatchPainter oldDelegate) => false;
}
