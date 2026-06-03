// Empty / error placeholders in the design's voice — a faint icon tile, a
// centered Bulgarian message, and an optional call-to-action. Used in place of
// bare dim text so "no records yet" reads as a deliberate state, not a gap.

import 'package:flutter/widgets.dart';

import '../icons/lm_icons.dart';
import '../l10n/l10n_ext.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';
import 'lm_button.dart';

/// A centered empty state: a soft icon tile, a [message], and an optional
/// [actionLabel]/[onAction] ghost button. Drop it into a `ScreenBody` list where
/// records would otherwise appear.
class LmEmpty extends StatelessWidget {
  const LmEmpty({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final LmIcons icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: AppColors.white08, shape: BoxShape.circle),
            child: LmIcon(icon, size: 26, color: AppColors.textFaint),
          ),
          const SizedBox(height: 14),
          Text(message, textAlign: TextAlign.center, style: AppText.bodyDim),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            LmButton(actionLabel!,
                variant: LmButtonVariant.ghost, onTap: onAction),
          ],
        ],
      ),
    );
  }
}

/// A compact inline error placeholder for a failed stream/future.
class LmInlineError extends StatelessWidget {
  const LmInlineError({super.key, this.message});

  /// Error text. Falls back to a localized "something went wrong" message
  /// when null.
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LmIcon(LmIcons.close, size: 24, color: AppColors.red),
          const SizedBox(height: 12),
          Text(
            message ?? context.l10n.commonLoadError,
            textAlign: TextAlign.center,
            style: AppText.bodyDim,
          ),
        ],
      ),
    );
  }
}
