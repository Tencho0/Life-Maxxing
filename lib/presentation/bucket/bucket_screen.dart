// Bucket List screen — stat cards, a status filter, and the items list.
// Tapping an item pushes its detail (/bucket/:id).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/icons/lm_icons.dart';
import '../../core/l10n/enum_labels.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/lm_row.dart';
import '../../core/widgets/pill.dart';
import '../../core/widgets/screen_body.dart';
import '../../core/widgets/segmented.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../domain/summaries.dart';
import 'bucket_format.dart';
import 'bucket_forms.dart';
import 'bucket_providers.dart';

class BucketScreen extends ConsumerWidget {
  const BucketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(bucketStatsProvider);
    final items = ref.watch(bucketItemsProvider).asData?.value ?? const [];
    final filter = ref.watch(bucketStatusFilterProvider);
    final allLabel = context.l10n.bucketAll;

    return Column(
      children: [
        AppTopBar(
          title: context.l10n.bucketTitle,
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
          trailing: _AddButton(onTap: () => showBucketItemSheet(context)),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              stats.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) =>
                    Text(context.l10n.bucketError('$e'), style: AppText.bodyDim),
                data: (s) => _StatsCard(s),
              ),
              const SizedBox(height: 12),
              Segmented(
                options: [allLabel, for (final s in BucketStatus.values) localizedLabel(context, s)],
                value: filter == null ? allLabel : localizedLabel(context, filter),
                onChanged: (l) =>
                    ref.read(bucketStatusFilterProvider.notifier).state = l == allLabel
                        ? null
                        : BucketStatus.values.firstWhere((s) => localizedLabel(context, s) == l),
              ),
              const SizedBox(height: 12),
              ..._itemRows(context, items),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _itemRows(BuildContext context, List<BucketItem> items) {
    if (items.isEmpty) {
      return [
        LmEmpty(
          icon: LmIcons.bucket,
          message: context.l10n.bucketEmpty,
          actionLabel: context.l10n.bucketAddItem,
          onAction: () => showBucketItemSheet(context),
        ),
      ];
    }
    return [
      for (final it in items)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: LmRow(
            icon: LmIcons.flag,
            iconColor: bucketPriorityColor(it.priority),
            title: it.title,
            subtitle: localizedLabel(context, it.priority),
            onTap: () => context.push('/bucket/${it.id}'),
            trailing: Pill(localizedLabel(context, it.status), color: bucketStatusColor(it.status)),
          ),
        ),
    ];
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: context.l10n.actionAdd,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: AppColors.accent, borderRadius: BorderRadius.circular(12)),
            child: const LmIcon(LmIcons.plus,
                size: 20, color: AppColors.bg, strokeWidth: 2.3),
          ),
        ),
      );
}

class _StatsCard extends StatelessWidget {
  const _StatsCard(this.s);
  final BucketStats s;
  @override
  Widget build(BuildContext context) {
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(context.l10n.bucketOverview),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _stat('${s.total}', context.l10n.bucketStatTotal)),
              Expanded(
                  child: _stat('${s.completed}', context.l10n.bucketStatCompleted)),
              Expanded(
                  child: _stat('${s.planned}', context.l10n.bucketStatPlanned)),
              Expanded(child: _stat('${s.high}', context.l10n.bucketStatHigh)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: AppText.stat.copyWith(fontSize: 18)),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyDim.copyWith(fontSize: 11)),
        ],
      );
}
