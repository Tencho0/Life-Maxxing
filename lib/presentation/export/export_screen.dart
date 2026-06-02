// Export for AI screen (spec §25): choose scope (Full / Period / Module) and
// format (JSON / Markdown), see a live preview with record/photo/size counts,
// then share via the system sheet or copy to clipboard. The rendering is done
// by ExportService; share_plus + clipboard are the only platform bits here.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/card.dart';
import '../../core/widgets/field.dart';
import '../../core/widgets/lm_button.dart';
import '../../core/widgets/lm_toast.dart';
import '../../core/widgets/period_chips.dart';
import '../../core/widgets/screen_body.dart';
import '../../core/widgets/segmented.dart';
import '../../core/widgets/stat.dart';
import '../../core/icons/lm_icons.dart';
import '../../domain/enums.dart';
import '../../domain/period.dart';
import '../../services/export_service.dart';
import 'export_providers.dart';

const _scopeLabels = <ExportScopeType, String>{
  ExportScopeType.full: 'Всичко',
  ExportScopeType.period: 'Период',
  ExportScopeType.module: 'Модул',
};

/// First ~2400 chars of the export, so a huge export doesn't blow up the view.
const _previewLimit = 2400;

class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(exportScopeProvider);
    final format = ref.watch(exportFormatProvider);
    final dataAsync = ref.watch(exportDataProvider);
    final textAsync = ref.watch(exportTextProvider);
    final text = textAsync.asData?.value;

    return Column(
      children: [
        AppTopBar(
          title: 'Експорт за AI',
          subtitle: 'JSON / Markdown за анализ',
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              Field(
                label: 'Обхват',
                child: Segmented(
                  options: _scopeLabels.values.toList(),
                  value: _scopeLabels[scope]!,
                  onChanged: (label) {
                    ref.read(exportScopeProvider.notifier).state = _scopeLabels
                        .entries
                        .firstWhere((e) => e.value == label)
                        .key;
                  },
                ),
              ),
              if (scope == ExportScopeType.period) _PeriodSelector(),
              if (scope == ExportScopeType.module) _ModuleSelector(),
              Field(
                label: 'Формат',
                child: Segmented(
                  options: const ['Markdown', 'JSON'],
                  value: format == ExportFormat.json ? 'JSON' : 'Markdown',
                  onChanged: (label) =>
                      ref.read(exportFormatProvider.notifier).state =
                          label == 'JSON' ? ExportFormat.json : ExportFormat.markdown,
                ),
              ),
              _CountsCard(dataAsync: dataAsync, text: text),
              const SizedBox(height: 12),
              _PreviewCard(textAsync: textAsync),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: LmButton(
                      'Сподели',
                      icon: LmIcons.export,
                      onTap: text == null
                          ? null
                          : () => _share(context, text, format),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LmButton(
                      'Копирай',
                      variant: LmButtonVariant.ghost,
                      icon: LmIcons.check,
                      onTap: text == null ? null : () => _copy(context, text),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _share(BuildContext context, String text, ExportFormat format) async {
    final fmt = format == ExportFormat.json ? 'json' : 'md';
    try {
      await SharePlus.instance.share(
          ShareParams(text: text, subject: 'lifemaxxing-export.$fmt'));
    } catch (_) {
      if (context.mounted) showLmToast(context, 'Споделянето не е налично');
    }
  }

  Future<void> _copy(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) showLmToast(context, 'Копирано в клипборда');
  }
}

class _PeriodSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(exportPeriodProvider);
    return Field(
      label: 'Период',
      child: PeriodChips(
        value: period.chipLabel,
        options: Period.values.map((p) => p.chipLabel).toList(),
        onChanged: (label) => _onPeriod(context, ref, label),
      ),
    );
  }

  Future<void> _onPeriod(BuildContext context, WidgetRef ref, String label) async {
    final p = Period.values.firstWhere((x) => x.chipLabel == label);
    if (p == Period.custom) {
      final picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        ref.read(exportCustomRangeProvider.notifier).state = DateRange(
          resolveRange(Period.today, today: picked.start).from,
          resolveRange(Period.today, today: picked.end).from,
        );
        ref.read(exportPeriodProvider.notifier).state = Period.custom;
      }
    } else {
      ref.read(exportPeriodProvider.notifier).state = p;
    }
  }
}

class _ModuleSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final module = ref.watch(exportModuleProvider);
    return Field(
      label: 'Модул',
      child: Segmented(
        columns: 2,
        options: ExportModule.values.map((m) => m.label).toList(),
        value: module.label,
        onChanged: (label) => ref.read(exportModuleProvider.notifier).state =
            ExportModule.values.firstWhere((m) => m.label == label),
      ),
    );
  }
}

class _CountsCard extends StatelessWidget {
  const _CountsCard({required this.dataAsync, required this.text});
  final AsyncValue<ExportData> dataAsync;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final data = dataAsync.asData?.value;
    final sizeKb = text == null ? 0 : (utf8.encode(text!).length / 1024);
    return LmCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stat(label: 'Записи', value: '${data?.recordCount ?? '—'}'),
          Stat(label: 'Снимки', value: '${data?.photoCount ?? '—'}'),
          Stat(
            label: 'Размер',
            value: data == null ? '—' : sizeKb.toStringAsFixed(1),
            unit: ' KB',
          ),
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({required this.textAsync});
  final AsyncValue<String> textAsync;

  @override
  Widget build(BuildContext context) {
    return LmCard(
      child: textAsync.when(
        loading: () => Text('Подготвяне…', style: AppText.bodyDim),
        error: (e, _) => Text('Грешка: $e', style: AppText.bodyDim),
        data: (text) {
          if (text.isEmpty) {
            return Text('Няма данни за този обхват', style: AppText.bodyDim);
          }
          final preview = text.length > _previewLimit
              ? '${text.substring(0, _previewLimit)}\n…'
              : text;
          return ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 320),
            child: SingleChildScrollView(
              child: Text(
                preview,
                style: const TextStyle(
                  fontFamily: AppText.mono,
                  fontSize: 12,
                  height: 1.45,
                  color: AppColors.textDim,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
