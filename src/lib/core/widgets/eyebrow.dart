// Eyebrow — a small uppercase mono section label.
// Mirrors the prototype `Eyebrow` (design/life-maxxing/project/lib/ui.jsx):
// IBM Plex Mono 11, letterSpacing 1.5, weight 500, textFaint, uppercased.
// Pass [color] to tint it (e.g. an accent-colored label).

import 'package:flutter/widgets.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// Uppercase mono section label. Renders [text] in upper case using
/// [AppText.eyebrow]; override its color via [color].
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: color == null ? AppText.eyebrow : AppText.eyebrow.copyWith(color: color),
    );
  }
}
