// Generic list row — ports the prototype's `Row` (app/kit.jsx) as [LmRow]
// (renamed to avoid clashing with Flutter's own Row). See §6.
//
// Layout: optional 40×40 icon tile, then a flexible title (with optional tag
// beside it) over an optional subtitle, then an optional trailing widget.

import 'package:flutter/widgets.dart';
import 'package:lifemaxxing/core/icons/lm_icons.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

/// A tappable list row: card background, hairline border, 15px radius.
///
/// Mirrors the prototype `Row`: a leading 40×40 icon tile (when [icon] is set),
/// a [title] (14/w600, single-line, ellipsised) optionally followed by a [tag],
/// an optional [subtitle] (12/textDim, ellipsised), and an optional [trailing].
class LmRow extends StatelessWidget {
  const LmRow({
    super.key,
    this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.tag,
    this.onTap,
  });

  /// Optional leading icon, rendered inside a 40×40 tile.
  final LmIcons? icon;

  /// Colour for the leading [icon]; defaults to [AppColors.textDim].
  final Color? iconColor;

  /// Primary single-line label.
  final String title;

  /// Optional secondary single-line label below [title].
  final String? subtitle;

  /// Optional widget pinned to the row's trailing edge.
  final Widget? trailing;

  /// Optional widget shown immediately after [title] (e.g. a small pill).
  final Widget? tag;

  /// Tapped callback; the row only reacts to taps when this is non-null.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadii.row),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white05,
                borderRadius: BorderRadius.circular(AppRadii.tile),
              ),
              alignment: Alignment.center,
              child: LmIcon(
                icon!,
                size: 20,
                color: iconColor ?? AppColors.textDim,
              ),
            ),
            const SizedBox(width: 13),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.cardTitle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (tag != null) ...[
                      const SizedBox(width: 8),
                      tag!,
                    ],
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppText.sans,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textDim,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 13),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap == null) return content;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}
