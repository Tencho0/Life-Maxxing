// Card — the design system's base surface container.
// Mirrors the finalized prototype (design/life-maxxing/project/lib/ui.jsx `Card`).

import 'package:flutter/widgets.dart';

import 'package:lifemaxxing/core/theme/tokens.dart';

/// A rounded surface with a 1px border, used as the base container for most
/// content blocks. Background is [AppColors.card] (or [AppColors.cardHi] when
/// [highlighted]); corners use [AppRadii.card] (18) and the default padding is
/// `EdgeInsets.all(16)`.
///
/// When [onTap] is provided the card becomes tappable without a splash, to
/// match the prototype (the app disables ink splashes).
class LmCard extends StatelessWidget {
  const LmCard({
    super.key,
    required this.child,
    this.padding,
    this.highlighted = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget card = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.cardHi : AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      child: child,
    );

    if (onTap == null) return card;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: card,
    );
  }
}
