// Progress donut (ring) — fl_chart port of the prototype `Ring`
// (design/life-maxxing/project/lib/ui.jsx). A two-section PieChart: the filled
// arc (value/max) in [color] and the remainder in [track], starting at 12
// o'clock and sweeping clockwise, with an optional centered [center] widget.

import 'package:flutter/widgets.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:lifemaxxing/core/theme/tokens.dart';

/// A circular progress indicator drawn as a donut.
///
/// Renders [value] / [max] as a filled arc in [color] over a [track] ring,
/// sweeping clockwise from the top. The ring thickness is [strokeWidth] and the
/// overall box is [size] × [size]. An optional [center] widget is overlaid in
/// the middle (e.g. a stat label).
class Ring extends StatelessWidget {
  const Ring({
    super.key,
    required this.value,
    this.max = 100,
    this.size = 92,
    this.strokeWidth = 9,
    this.color = AppColors.accent,
    this.track = AppColors.white08,
    this.center,
  });

  final double value;
  final double max;
  final double size;
  final double strokeWidth;
  final Color color;
  final Color track;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    final frac = (max <= 0 ? 0.0 : (value / max)).clamp(0.0, 1.0);
    final filled = frac;
    final remainder = 1 - frac;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 0,
              centerSpaceRadius: size / 2 - strokeWidth,
              pieTouchData: PieTouchData(enabled: false),
              sections: [
                PieChartSectionData(
                  value: filled,
                  color: color,
                  radius: strokeWidth,
                  showTitle: false,
                ),
                PieChartSectionData(
                  value: remainder,
                  color: track,
                  radius: strokeWidth,
                  showTitle: false,
                ),
              ],
            ),
          ),
          ?center,
        ],
      ),
    );
  }
}
