// First-launch welcome: asks for the user's display name before the app shell
// renders. Shown by `_Root` whenever [userNameProvider] is null/empty; once a
// non-empty name is submitted the provider flips and the app reveals the home
// screen. The name is required — Continue stays disabled until the trimmed
// field is non-empty. See docs/superpowers/specs/2026-06-03-first-launch-name-design.md.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/field.dart';
import '../../core/widgets/lm_button.dart';
import '../../core/widgets/lm_logo.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canContinue => _controller.text.trim().isNotEmpty;

  Future<void> _submit() async {
    if (!_canContinue) return;
    await ref.read(userNameProvider.notifier).set(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: LmLogo.icon(size: 72)),
                const SizedBox(height: 28),
                Text(l10n.welcomeTitle,
                    textAlign: TextAlign.center, style: AppText.greeting),
                const SizedBox(height: 10),
                Text(l10n.welcomePrompt,
                    textAlign: TextAlign.center, style: AppText.bodyDim),
                const SizedBox(height: 28),
                Field(
                  label: l10n.settingsName,
                  required: true,
                  child: LmInput(
                    controller: _controller,
                    hintText: l10n.welcomeNameHint,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(height: 6),
                Opacity(
                  opacity: _canContinue ? 1 : 0.4,
                  child: LmButton(
                    l10n.welcomeContinue,
                    full: true,
                    onTap: _canContinue ? _submit : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
