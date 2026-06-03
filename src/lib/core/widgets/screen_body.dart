// Scrollable screen body — a vertically scrolling column that fills the
// remaining space below the top bar. Mirrors the prototype `Body`
// (app/kit.jsx): flex:1, overflow-y:auto, padding '14px 16px 22px'
// → fromLTRB(16, 14, 16, 22) using the AppSpacing tokens.

import 'package:flutter/widgets.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';

class ScreenBody extends StatelessWidget {
  const ScreenBody({super.key, required this.children, this.padding});

  /// The scrollable content, laid out as a single vertical column.
  final List<Widget> children;

  /// Overrides the default screen padding (16 / 14 / 16 / 22) when supplied.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding ??
          const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            AppSpacing.screenTop,
            AppSpacing.screenH,
            AppSpacing.screenBottom,
          ),
      children: children,
    );
  }
}
