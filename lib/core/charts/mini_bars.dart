// Tiny dashboard bar chart — mirrors the prototype `MiniBars` (lib/ui.jsx).
// One rounded rod per value, small gaps, no chrome. Optional single-bar
// highlight dims the rest to a faint white.

import 'package:fl_chart/fl_chart.dart';
import 'chart_anim.dart';
import 'package:flutter/widgets.dart';

import 'package:lifemaxxing/core/theme/tokens.dart';

/// Compact bar chart for dashboard tiles.
///
/// Renders one rod per [data] value with rounded top corners and small gaps,
/// scaled so the tallest value fills the height. When [highlightIndex] is
/// `>= 0`, only that bar uses [color]; the others fade to a faint white
/// (matching the prototype's `rgba(255,255,255,0.13)`). With no highlight,
/// every bar uses [color].
class MiniBars extends StatelessWidget {
  const MiniBars({
    super.key,
    required this.data,
    this.height = 40,
    this.color = AppColors.accent,
    this.highlightIndex = -1,
  });

  final List<double> data;
  final double height;
  final Color color;
  final int highlightIndex;

  @override
  Widget build(BuildContext context) {
    // Prototype: max = Math.max(...data) || 1.
    var maxV = 0.0;
    for (final v in data) {
      if (v > maxV) maxV = v;
    }
    if (maxV <= 0) maxV = 1;

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          maxY: maxV,
          minY: 0,
          alignment: BarChartAlignment.spaceBetween,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: false),
          barGroups: [
            for (var i = 0; i < data.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: data[i],
                    color: highlightIndex >= 0
                        ? (i == highlightIndex ? color : _faint)
                        : color,
                    width: 8,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                    ),
                  ),
                ],
              ),
          ],
        ),
        duration: lmChartAnimationDuration,
      ),
    );
  }

  // Prototype non-highlighted bars: rgba(255,255,255,0.13) ≈ AppColors.borderHi.
  static const Color _faint = AppColors.borderHi;
}
