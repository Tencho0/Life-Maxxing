// Bucket item detail — status/priority, why, photos, the complete button (when
// not yet completed) and, once completed, the logged experience (editable).
// Deleting cleans the item's and experience's rows + files (spec §20).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/l10n/enum_labels.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/card.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/lm_button.dart';
import '../../core/widgets/lm_skeleton.dart';
import '../../core/widgets/pill.dart';
import '../../core/widgets/screen_body.dart';
import '../../core/format/dates.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';
import '../../services/attachment_service.dart';
import '../common/photo_field.dart';
import 'bucket_format.dart';
import 'bucket_forms.dart';
import 'bucket_providers.dart';

class BucketDetailScreen extends ConsumerWidget {
  const BucketDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(bucketItemProvider(id)).asData?.value;
    final exp = ref.watch(bucketExperienceProvider(id)).asData?.value;
    final svc = ref.watch(attachmentServiceProvider);

    if (item == null) {
      return Column(
        children: [
          AppTopBar(
              title: 'Желание',
              showBack: true,
              onBack: () => context.pop()),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: LmListSkeleton(rows: 3, height: 120),
            ),
          ),
        ],
      );
    }

    final itemPhotos =
        ref.watch(bucketItemPhotosProvider(id)).asData?.value ?? const [];
    final expPhotos = exp == null
        ? const <Attachment>[]
        : ref.watch(bucketExperiencePhotosProvider(exp.id)).asData?.value ??
            const [];

    return Column(
      children: [
        AppTopBar(
          title: item.title,
          showBack: true,
          onBack: () => context.pop(),
          trailing: _IconBtn(
              icon: LmIcons.edit,
              onTap: () => showBucketItemSheet(context, existing: item)),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              Row(
                children: [
                  Pill(localizedLabel(context, item.status), color: bucketStatusColor(item.status)),
                  const SizedBox(width: 8),
                  Pill(localizedLabel(context, item.priority),
                      color: bucketPriorityColor(item.priority)),
                ],
              ),
              if (item.whyWantIt != null && item.whyWantIt!.isNotEmpty) ...[
                const SizedBox(height: 14),
                LmCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Eyebrow('Защо го искам'),
                      const SizedBox(height: 8),
                      Text(item.whyWantIt!,
                          style: AppText.body.copyWith(fontSize: 14, height: 1.5)),
                    ],
                  ),
                ),
              ],
              if (itemPhotos.isNotEmpty) ...[
                const SizedBox(height: 14),
                _PhotoWrap(svc: svc, photos: itemPhotos),
              ],
              if (item.status != BucketStatus.completed) ...[
                const SizedBox(height: 16),
                LmButton('Завърши го',
                    full: true,
                    icon: LmIcons.check,
                    onTap: () => showBucketCompleteSheet(context, item: item)),
              ],
              if (exp != null) ...[
                const SizedBox(height: 16),
                _ExperienceCard(exp: exp),
                if (expPhotos.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _PhotoWrap(svc: svc, photos: expPhotos),
                ],
                const SizedBox(height: 12),
                LmButton('Редактирай преживяването',
                    full: true,
                    variant: LmButtonVariant.ghost,
                    icon: LmIcons.edit,
                    onTap: () =>
                        showBucketCompleteSheet(context, item: item, existing: exp)),
              ],
              const SizedBox(height: 20),
              LmButton('Изтрий желанието',
                  full: true,
                  variant: LmButtonVariant.danger,
                  icon: LmIcons.trash,
                  onTap: () => _confirmDelete(context, ref)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bg2,
        title: Text('Изтриване', style: AppText.sheetTitle),
        content: Text('Да изтрия желанието и преживяването му?',
            style: AppText.bodyDim),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Отказ')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Изтрий')),
        ],
      ),
    );
    if (ok != true) return;
    await deleteBucketItem(
        ref.read(bucketDaoProvider), ref.read(attachmentServiceProvider), id);
    if (context.mounted) context.pop();
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});
  final LmIcons icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border)),
          child: LmIcon(icon, size: 18, color: AppColors.textDim),
        ),
      );
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.exp});
  final BucketExperience exp;
  @override
  Widget build(BuildContext context) {
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Преживяване', color: AppColors.green),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _stat('${exp.feelingRating}/10', 'усещане')),
              Expanded(child: _stat(exp.worthIt ? 'Да' : 'Не', 'струваше ли си')),
              Expanded(child: _stat(dmy(exp.completedDate), 'дата')),
            ],
          ),
          if (exp.reflection != null && exp.reflection!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(exp.reflection!,
                style: AppText.body.copyWith(fontSize: 14, height: 1.5)),
          ],
        ],
      ),
    );
  }

  Widget _stat(String value, String label) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.stat.copyWith(fontSize: 15)),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyDim.copyWith(fontSize: 10.5)),
        ],
      );
}

class _PhotoWrap extends StatelessWidget {
  const _PhotoWrap({required this.svc, required this.photos});
  final AttachmentService svc;
  final List<Attachment> photos;
  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final a in photos)
            AttachmentThumb(svc: svc, attachment: a, size: 96),
        ],
      );
}
