// Screen header — optional back button, title (+ optional mono subtitle), and
// an optional trailing slot. Mirrors the prototype `TopBar` (app/kit.jsx):
// row padding '12px 16px 10px', gap 12, semi-transparent bg rgba(12,13,17,0.86)
// behind a blur(12), and a 1px bottom border. A normal header widget (not a
// sliver / AppBar) — pinning is left to the host scaffold.

import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';
import 'package:lifemaxxing/core/icons/lm_icons.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onBack,
    this.showBack = false,
  });

  /// Header title (sans, 18/700).
  final String title;

  /// Optional mono caption below the title (11.5, faint).
  final String? subtitle;

  /// Optional widget pinned to the right (e.g. an add button).
  final Widget? trailing;

  /// Tapping the back button invokes this; only shown when [showBack].
  final VoidCallback? onBack;

  /// Whether to render the leading 38×38 back tile.
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            // rgba(12,13,17,0.86) → AppColors.bg at ~0.86 alpha (0xDB).
            color: Color(0xDB0C0D11),
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Padding(
            // padding: '12px 16px 10px' → top 12, right/left 16, bottom 10.
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showBack) ...[
                  Semantics(
                    button: true,
                    label: 'Назад',
                    child: GestureDetector(
                      onTap: onBack,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(AppRadii.tile),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const LmIcon(
                          LmIcons.chevL,
                          size: 20,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppText.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: AppText.monoFaint.copyWith(fontSize: 11.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
