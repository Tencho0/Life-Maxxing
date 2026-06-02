// "Настройки" / "Settings" — currently just the language picker. Choosing an
// option updates [localeProvider] (the whole UI rebuilds live) and persists it
// via [SettingsService]. `null` = follow the system locale.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/lm_row.dart';
import '../../core/widgets/screen_body.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(localeProvider);
    final options = <(Locale?, String)>[
      (null, l10n.languageSystem),
      (const Locale('bg'), l10n.languageBulgarian),
      (const Locale('en'), l10n.languageEnglish),
    ];

    return Column(
      children: [
        AppTopBar(
          title: l10n.settingsTitle,
          showBack: true,
          onBack: () => context.pop(),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 8),
                child: Eyebrow(l10n.settingsLanguage),
              ),
              for (final (locale, label) in options)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: LmRow(
                    title: label,
                    onTap: () => _select(ref, locale),
                    trailing: _selected(current, locale)
                        ? const LmIcon(LmIcons.check,
                            size: 18, color: AppColors.accent)
                        : null,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // System (null) matches null; otherwise compare language codes.
  bool _selected(Locale? current, Locale? option) =>
      current?.languageCode == option?.languageCode;

  Future<void> _select(WidgetRef ref, Locale? locale) =>
      ref.read(localeProvider.notifier).set(locale);
}
