// Section heading — an uppercased mono eyebrow label with an optional
// trailing action, laid out space-between. Mirrors the prototype
// `SectionTitle` (app/kit.jsx): margin 18px 2px 10px.

import 'package:flutter/widgets.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // margin: '18px 2px 10px' → top 18, right 2, bottom 10, left 2.
      padding: const EdgeInsets.fromLTRB(2, 18, 2, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title.toUpperCase(), style: AppText.eyebrow),
          ?action,
        ],
      ),
    );
  }
}
