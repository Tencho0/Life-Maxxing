// Sparkline — a tiny, axis-less line chart for dashboard cards.
// Mirrors the finalized design system (design/life-maxxing/project/lib/ui.jsx
// `Sparkline`): a single curved-ish line with an optional vertical gradient
// fill from color@~0.28 alpha to transparent. No axes, grid, border, or touch.

import 'package:fl_chart/fl_chart.dart';
import 'chart_anim.dart';
import 'package:flutter/widgets.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';

/// A minimal line chart over [data], mapped to x = 0..n-1.
///
/// Renders a single [color] stroke of [strokeWidth] with hidden dots and,
/// when [fill] is true, a vertical gradient area beneath the line
/// (color@~0.28 alpha → transparent). Y bounds auto-fit the data.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.data,
    this.height = 36,
    this.color = AppColors.accent,
    this.fill = true,
    this.strokeWidth = 2,
  });

  final List<double> data;
  final double height;
  final Color color;
  final bool fill;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[
      for (var i = 0; i < data.length; i++) FlSpot(i.toDouble(), data[i]),
    ];

    double? minY;
    double? maxY;
    if (data.isNotEmpty) {
      minY = data.reduce((a, b) => a < b ? a : b);
      maxY = data.reduce((a, b) => a > b ? a : b);
      // Guard against a flat series (rng == 0) so the line stays centred.
      if (minY == maxY) {
        minY = minY - 1;
        maxY = maxY + 1;
      }
    }

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.2,
              preventCurveOverShooting: true,
              color: color,
              barWidth: strokeWidth,
              isStrokeCapRound: true,
              isStrokeJoinRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: fill,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.28),
                    color.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: lmChartAnimationDuration,
      ),
    );
  }
}
