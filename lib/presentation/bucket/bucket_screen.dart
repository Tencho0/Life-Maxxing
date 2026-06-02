// Bucket List screen — stat cards, a status filter, and the items list.
// Tapping an item pushes its detail (/bucket/:id).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/icons/lm_icons.dart';
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

const _allLabel = 'Всички';

class BucketScreen extends ConsumerWidget {
  const BucketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(bucketStatsProvider);
    final items = ref.watch(bucketItemsProvider).asData?.value ?? const [];
    final filter = ref.watch(bucketStatusFilterProvider);

    return Column(
      children: [
        AppTopBar(
          title: 'Bucket List',
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
          trailing: _AddButton(onTap: () => showBucketItemSheet(context)),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              stats.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => Text('Грешка: $e', style: AppText.bodyDim),
                data: (s) => _StatsCard(s),
              ),
              const SizedBox(height: 12),
              Segmented(
                options: [_allLabel, for (final s in BucketStatus.values) s.label],
                value: filter?.label ?? _allLabel,
                onChanged: (l) =>
                    ref.read(bucketStatusFilterProvider.notifier).state = l == _allLabel
                        ? null
                        : BucketStatus.values.firstWhere((s) => s.label == l),
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
          message: 'Няма желания в списъка',
          actionLabel: 'Добави желание',
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
            subtitle: it.priority.label,
            onTap: () => context.push('/bucket/${it.id}'),
            trailing: Pill(it.status.label, color: bucketStatusColor(it.status)),
          ),
        ),
    ];
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
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
          const Eyebrow('Преглед'),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _stat('${s.total}', 'общо')),
              Expanded(child: _stat('${s.completed}', 'завършени')),
              Expanded(child: _stat('${s.planned}', 'планирани')),
              Expanded(child: _stat('${s.high}', 'висок приор.')),
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
