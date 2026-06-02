// LmLogo — the LifeMaxxing brand mark ("Ascent"): an upward trend line ending
// in an up-arrow, drawn with a blue→green gradient stroke. Hand-painted with a
// CustomPainter (no flutter_svg), mirroring the MoodGauge approach.
//
// LmLogoPainter is the single rendering source of truth — the in-app widget and
// the generated launcher-icon PNGs both use it, so they can never drift. See
// docs/superpowers/specs/2026-06-02-app-logo-design.md.

import 'package:flutter/widgets.dart';

import 'package:lifemaxxing/core/theme/tokens.dart';

/// The LifeMaxxing logo. [LmLogo.icon] draws the mark on the hero-blue
/// rounded-square (matching the launcher icon); [LmLogo.symbol] draws the bare
/// mark for in-app placement (headers, splash, About screen).
class LmLogo extends StatelessWidget {
  const LmLogo.symbol({super.key, this.size = 48}) : withBackground = false;
  const LmLogo.icon({super.key, this.size = 48}) : withBackground = true;

  /// Edge length of the square logo, in logical pixels.
  final double size;

  /// Whether to paint the rounded-square hero-blue background (icon variant).
  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: LmLogoPainter(withBackground: withBackground),
      ),
    );
  }
}

/// Paints the mark on a square canvas of any [Size]. Geometry is authored on a
/// 96×96 reference grid (matching `assets/branding/logo.svg`) and scaled to fit.
class LmLogoPainter extends CustomPainter {
  const LmLogoPainter({required this.withBackground});

  /// Whether to paint the hero-blue rounded-square background + border.
  final bool withBackground;

  /// Reference grid the geometry is authored on.
  static const double _grid = 96;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.shortestSide / _grid);

    if (withBackground) {
      const bgArea = Rect.fromLTWH(6, 6, 84, 84);
      final bgRect = RRect.fromRectAndRadius(bgArea, const Radius.circular(22));
      canvas.drawRRect(
        bgRect,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppGradients.heroBlueStart, AppGradients.heroBlueEnd],
          ).createShader(bgArea),
      );
      canvas.drawRRect(
        bgRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = AppColors.borderHi,
      );
    }

    // The trend line, bottom-left → top-right.
    final line = Path()
      ..moveTo(26, 64)
      ..lineTo(40, 52)
      ..lineTo(50, 58)
      ..lineTo(68, 34);
    // The up-arrow head at the top-right tip.
    final arrow = Path()
      ..moveTo(56, 34)
      ..lineTo(68, 34)
      ..lineTo(68, 46);

    final strokeWidth = withBackground ? 6.5 : 7.0;
    canvas.drawPath(
      line,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..shader = const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [AppColors.accent, AppColors.green],
        ).createShader(const Rect.fromLTWH(26, 34, 42, 30)),
    );
    canvas.drawPath(
      arrow,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = AppColors.green,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(LmLogoPainter oldDelegate) =>
      oldDelegate.withBackground != withBackground;
}
