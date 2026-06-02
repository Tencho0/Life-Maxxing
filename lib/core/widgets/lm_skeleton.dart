// Loading skeletons — faint rounded placeholders shown while a stream's first
// values resolve, in place of a raw CircularProgressIndicator (which reads as
// jarring on the dark, card-based layout). Static (no shimmer) by design: the
// local DB resolves in a frame or two, so motion would only flicker.

import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

/// A single faint rounded block. Fills its parent's width unless [width] is set.
class LmSkeleton extends StatelessWidget {
  const LmSkeleton({super.key, this.height = 16, this.width, this.radius = 14});
  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.white08,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// A stack of [rows] skeleton blocks of [height], for a loading list or a set
/// of loading cards (use a taller [height] for card placeholders).
class LmListSkeleton extends StatelessWidget {
  const LmListSkeleton({super.key, this.rows = 3, this.height = 64, this.gap = 10});
  final int rows;
  final double height;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == rows - 1 ? 0 : gap),
            child: LmSkeleton(height: height),
          ),
      ],
    );
  }
}
