// "Настройки" / "Settings" — the display name (shown in the home greeting) and
// the language picker. Editing either updates its provider (the whole UI
// rebuilds live) and persists it via [SettingsService]. `null` locale = follow
// the system locale.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/field.dart';
import '../../core/widgets/lm_button.dart';
import '../../core/widgets/lm_row.dart';
import '../../core/widgets/lm_toast.dart';
import '../../core/widgets/screen_body.dart';
import '../backup/backup_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(localeProvider);
    final name = ref.watch(userNameProvider) ?? '';
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
                child: Eyebrow(l10n.settingsName),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: LmRow(
                  icon: LmIcons.edit,
                  iconColor: AppColors.accent,
                  title: name,
                  onTap: () => _editName(context, name),
                  trailing: const LmIcon(LmIcons.chevR,
                      size: 17, color: AppColors.textFaint),
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 8),
                child: Eyebrow(l10n.settingsDataSection),
              ),
              LmRow(
                icon: LmIcons.trash,
                iconColor: AppColors.red,
                title: l10n.settingsClearData,
                onTap: () => _confirmAndClear(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Confirms, then wipes all records + attachment files via
  /// [backupServiceProvider]. Name + language are preserved (the `settings`
  /// table is untouched). Drift's reactive queries refresh every other screen.
  Future<void> _confirmAndClear(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(ctx.l10n.settingsClearDataTitle),
        content: Text(ctx.l10n.settingsClearDataBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(ctx.l10n.actionCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(ctx.l10n.settingsClearDataConfirm,
                style: const TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(backupServiceProvider).clearAllData();
    if (context.mounted) showLmToast(context, l10n.settingsClearDataDone);
  }

  // System (null) matches null; otherwise compare language codes.
  bool _selected(Locale? current, Locale? option) =>
      current?.languageCode == option?.languageCode;

  Future<void> _select(WidgetRef ref, Locale? locale) =>
      ref.read(localeProvider.notifier).set(locale);

  /// Opens a small dialog to edit the display name.
  void _editName(BuildContext context, String current) {
    showDialog<void>(
      context: context,
      builder: (_) => _NameDialog(initial: current),
    );
  }
}

/// The display-name editor shown by [SettingsScreen]. Owns its [TextEditingController]
/// so disposal is tied to this widget's lifecycle (disposing it in the opener's
/// `finally` would free it mid-exit-animation → "used after disposed"). Save is
/// rejected when the field is blank — the greeting always keeps a real name.
class _NameDialog extends ConsumerStatefulWidget {
  const _NameDialog({required this.initial});
  final String initial;

  @override
  ConsumerState<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends ConsumerState<_NameDialog> {
  late final _controller = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    ref.read(userNameProvider.notifier).set(value);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      backgroundColor: AppColors.card,
      content: Field(
        label: l10n.settingsName,
        child: LmInput(controller: _controller, hintText: l10n.welcomeNameHint),
      ),
      actions: [
        LmButton(l10n.actionCancel,
            variant: LmButtonVariant.ghost,
            onTap: () => Navigator.of(context).pop()),
        LmButton(l10n.actionSave, onTap: _save),
      ],
    );
  }
}
