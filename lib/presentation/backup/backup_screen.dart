// Backup & Restore screen (spec §26): create a full ZIP backup and share it, or
// pick a backup ZIP, see the validation checklist, confirm a replace-all when
// the app is non-empty, and restore (all-or-nothing). The ZIP build/validate/
// restore logic is in BackupService; file_picker + share_plus are the platform
// bits and live here.

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/icons/lm_icons.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/card.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/lm_button.dart';
import '../../core/widgets/lm_toast.dart';
import '../../core/widgets/screen_body.dart';
import '../../services/backup_service.dart';
import 'backup_providers.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;
  BackupValidation? _validation;
  List<int>? _pendingBytes;
  String? _pickedName;

  @override
  Widget build(BuildContext context) {
    final last = ref.watch(lastBackupProvider);
    final l10n = context.l10n;
    final includes = <String>[
      l10n.backupIncludeLogs,
      l10n.backupIncludeMoney,
      l10n.backupIncludeHealth,
      l10n.backupIncludeDaily,
      l10n.backupIncludeBucket,
      l10n.backupIncludeTrips,
      l10n.backupIncludeAttachments,
    ];
    return Column(
      children: [
        AppTopBar(
          title: l10n.backupTitle,
          subtitle: l10n.backupSubtitle,
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              LmCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow(l10n.backupIncludesEyebrow),
                    const SizedBox(height: 12),
                    for (final item in includes)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LmIcon(LmIcons.check,
                                size: 16, color: AppColors.green),
                            const SizedBox(width: 8),
                            Expanded(child: Text(item, style: AppText.body)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      last == null
                          ? l10n.backupNoneThisSession
                          : l10n.backupLast(_fmt(last)),
                      style: AppText.bodyDim,
                    ),
                    const SizedBox(height: 14),
                    LmButton(
                      _busy ? l10n.backupPleaseWait : l10n.backupCreate,
                      icon: LmIcons.export,
                      full: true,
                      onTap: _busy ? null : _createBackup,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LmCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow(l10n.backupRestoreEyebrow),
                    const SizedBox(height: 10),
                    Text(
                      l10n.backupRestoreHint,
                      style: AppText.bodyDim,
                    ),
                    const SizedBox(height: 14),
                    LmButton(
                      l10n.backupPickFile,
                      variant: LmButtonVariant.ghost,
                      icon: LmIcons.search,
                      full: true,
                      onTap: _busy ? null : _pickAndValidate,
                    ),
                    if (_validation != null) ...[
                      const SizedBox(height: 14),
                      _ValidationChecklist(
                          validation: _validation!, fileName: _pickedName),
                      const SizedBox(height: 12),
                      LmButton(
                        l10n.backupRestoreAction,
                        variant: LmButtonVariant.danger,
                        icon: LmIcons.bolt,
                        full: true,
                        onTap: (_validation!.ok && !_busy) ? _restore : null,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _createBackup() async {
    setState(() => _busy = true);
    try {
      final svc = ref.read(backupServiceProvider);
      final dir = await getTemporaryDirectory();
      final file = await svc.writeBackupFile(dir);
      ref.read(lastBackupProvider.notifier).state = DateTime.now();
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path)],
        subject: file.uri.pathSegments.last,
      ));
    } catch (e) {
      if (mounted) showLmToast(context, context.l10n.backupFailed('$e'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickAndValidate() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['zip'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      final picked = result.files.single;
      final bytes = picked.bytes;
      if (bytes == null) {
        if (mounted) showLmToast(context, context.l10n.backupCannotRead);
        return;
      }
      final svc = ref.read(backupServiceProvider);
      final validation = await svc.validate(bytes);
      setState(() {
        _validation = validation;
        _pendingBytes = bytes;
        _pickedName = picked.name;
      });
    } catch (e) {
      if (mounted) showLmToast(context, context.l10n.backupPickError('$e'));
    }
  }

  Future<void> _restore() async {
    final bytes = _pendingBytes;
    if (bytes == null) return;
    final svc = ref.read(backupServiceProvider);

    if (!await svc.isEmpty()) {
      final confirmed = await _confirmReplaceAll();
      if (confirmed != true) return;
    }

    setState(() => _busy = true);
    try {
      await svc.restore(bytes);
      if (mounted) {
        showLmToast(context, context.l10n.backupRestored);
        setState(() {
          _validation = null;
          _pendingBytes = null;
          _pickedName = null;
        });
      }
    } catch (e) {
      if (mounted) showLmToast(context, context.l10n.backupRestoreFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool?> _confirmReplaceAll() => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.card,
          title: Text(ctx.l10n.backupReplaceTitle),
          content: Text(ctx.l10n.backupReplaceBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(ctx.l10n.actionCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(ctx.l10n.backupReplaceConfirm,
                  style: const TextStyle(color: AppColors.red)),
            ),
          ],
        ),
      );

  String _fmt(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year} ${two(d.hour)}:${two(d.minute)}';
  }
}

class _ValidationChecklist extends StatelessWidget {
  const _ValidationChecklist({required this.validation, this.fileName});
  final BackupValidation validation;
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: validation.ok ? AppColors.green.withValues(alpha: 0.08) : AppColors.redSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: validation.ok ? AppColors.green : AppColors.red, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LmIcon(validation.ok ? LmIcons.check : LmIcons.close,
                  size: 18, color: validation.ok ? AppColors.green : AppColors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  validation.ok
                      ? context.l10n.backupValid
                      : context.l10n.backupInvalid,
                  style: AppText.body.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (fileName != null) ...[
            const SizedBox(height: 6),
            Text(fileName!, style: AppText.monoFaint),
          ],
          if (validation.ok) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.backupSummary(
                    validation.recordCount,
                    validation.attachmentCount,
                  ) +
                  (validation.createdAt != null
                      ? ' · ${validation.createdAt!.toLocal().toString().split('.').first}'
                      : ''),
              style: AppText.bodyDim,
            ),
          ] else
            for (final err in validation.errors)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('• $err', style: AppText.bodyDim),
              ),
        ],
      ),
    );
  }
}
