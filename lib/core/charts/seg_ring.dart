// Segmented category donut — mirrors the prototype `SegRing`
// (design/life-maxxing/project/lib/ui.jsx). A faint full track sits behind
// one PieChart section per segment, starting at the top (12 o'clock) and
// running clockwise. An optional [center] widget is overlaid in the hole.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';

import 'package:lifemaxxing/core/theme/tokens.dart';

/// One slice of a [SegRing]: a [value] (relative weight) and its [color].
class SegRingSegment {
  final double value;
  final Color color;
  const SegRingSegment(this.value, this.color);
}

/// A segmented donut chart for category breakdowns.
///
/// Renders [segments] as a ring of [strokeWidth] thickness within a
/// [size]×[size] box, with an optional [center] widget in the hole.
class SegRing extends StatelessWidget {
  final List<SegRingSegment> segments;
  final double size;
  final double strokeWidth;
  final Widget? center;

  const SegRing({
    super.key,
    required this.segments,
    this.size = 96,
    this.strokeWidth = 14,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    final radius = size / 2 - strokeWidth;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Faint full track behind the segments (prototype: rgba(255,255,255,0.06)).
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 0,
              centerSpaceRadius: radius,
              pieTouchData: PieTouchData(enabled: false),
              sections: [
                PieChartSectionData(
                  value: 1,
                  color: AppColors.white05,
                  radius: strokeWidth,
                  showTitle: false,
                ),
              ],
            ),
          ),
          // Colored category segments.
          PieChart(
            PieChartData(
              startDegreeOffset: -90,
              sectionsSpace: 2,
              centerSpaceRadius: radius,
              pieTouchData: PieTouchData(enabled: false),
              sections: [
                for (final s in segments)
                  PieChartSectionData(
                    value: s.value,
                    color: s.color,
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
