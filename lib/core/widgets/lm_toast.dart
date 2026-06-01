// Toast — ported from the prototype (app/kit.jsx `Toast`). A bottom-centred
// pill that confirms an action, shown via an [OverlayEntry] and auto-dismissed
// after ~2.2s with a short fade. Match the prototype's exact sizes, paddings,
// radii and colors. (Provider wiring comes later — this is a bare helper.)

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:lifemaxxing/core/icons/lm_icons.dart';
import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/theme/typography.dart';

// The single active toast (only one is shown at a time).
OverlayEntry? _entry;
Timer? _dismissTimer;

/// How long the toast stays fully visible before fading out. Mutable so the
/// test environment can set it to [Duration.zero] (no lingering auto-dismiss
/// timer at teardown) — see test/support/test_env.dart.
Duration lmToastDuration = const Duration(milliseconds: 2200);

/// Shows a transient confirmation toast with [message] over the nearest
/// [Overlay], cancelling any toast already on screen.
///
/// Mirrors the prototype `Toast`: a bottom-centred pill (84px from the bottom),
/// [AppColors.cardHi] fill with a 1px [AppColors.borderHi] border, radius 13,
/// 11×18 padding, a green check [LmIcon] (size 17, stroke 2.4) + sans 13.5/w500
/// text, a soft shadow, and ignoring pointer events. Auto-removes after ~2.2s.
void showLmToast(BuildContext context, String message) {
  final overlay = Overlay.of(context, rootOverlay: true);

  // Cancel any previous toast first.
  _dismissTimer?.cancel();
  _dismissTimer = null;
  _entry?.remove();
  _entry = null;

  final entry = OverlayEntry(
    builder: (_) => _LmToast(message: message),
  );
  _entry = entry;
  overlay.insert(entry);

  _dismissTimer = Timer(lmToastDuration, () {
    _dismissTimer = null;
    if (_entry == entry) {
      _entry = null;
    }
    entry.remove();
  });
}

class _LmToast extends StatefulWidget {
  const _LmToast({required this.message});

  final String message;

  @override
  State<_LmToast> createState() => _LmToastState();
}

class _LmToastState extends State<_LmToast> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Fade in on the next frame so the implicit transition runs.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 84,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: AppDurations.fade,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.cardHi,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: AppColors.borderHi),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x80000000), // rgba(0,0,0,0.5)
                    blurRadius: 30,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const LmIcon(
                      LmIcons.check,
                      size: 17,
                      color: AppColors.green,
                      strokeWidth: 2.4,
                    ),
                    const SizedBox(width: 9),
                    Text(
                      widget.message,
                      style: AppText.body.copyWith(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
