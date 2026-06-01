// Tiny dashboard bar chart — mirrors the prototype's `BarChart`
// (design/life-maxxing/project/app/kit.jsx). Rounded bars (radius 5), an
// optional `highlightLast` mode that dims all but the final bar, and optional
// mono bottom-axis labels. Renamed to `LmBarChart` to avoid clashing with
// fl_chart's own `BarChart`.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// A compact bar chart with rounded bars and no chrome (no grid, border, axes,
/// or touch). When [highlightLast] is set, the final bar is drawn solid in
/// [color] and the rest at ~40% opacity. Supply [labels] to show a mono
/// bottom-axis label under each bar.
class LmBarChart extends StatelessWidget {
  const LmBarChart({
    super.key,
    required this.data,
    this.labels,
    this.color = AppColors.accent,
    this.height = 130,
    this.highlightLast = false,
  });

  final List<double> data;
  final List<String>? labels;
  final Color color;
  final double height;
  final bool highlightLast;

  @override
  Widget build(BuildContext context) {
    final maxV = data.fold<double>(0, (m, v) => v > m ? v : m);
    final maxY = maxV > 0 ? maxV : 1.0;
    final last = data.length - 1;
    final hasLabels = labels != null;

    return SizedBox(
      height: hasLabels ? height + 24 : height,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          minY: 0,
          alignment: BarChartAlignment.spaceBetween,
          barTouchData: BarTouchData(enabled: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: hasLabels,
            leftTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            topTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: hasLabels,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  final list = labels!;
                  final label = i >= 0 && i < list.length ? list[i] : '';
                  return Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: AppText.monoFaint.copyWith(fontSize: 9.5),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < data.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: data[i],
                    width: 12,
                    color: highlightLast && i != last
                        ? color.withValues(alpha: 0.4)
                        : color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
