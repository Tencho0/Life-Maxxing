// Trip detail — cover header, rating bars (overall + sub-ratings), would-repeat
// + comment, and the gallery grid. Edit reopens the sheet; delete removes the
// trip and all its photos (spec §21).

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/icons/lm_icons.dart';
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
import 'trip_forms.dart';
import 'trip_providers.dart';

class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trip = ref.watch(tripProvider(id)).asData?.value;
    final photos = ref.watch(tripPhotosProvider(id)).asData?.value ?? const [];
    final svc = ref.watch(attachmentServiceProvider);

    if (trip == null) {
      return Column(
        children: [
          AppTopBar(title: 'Пътуване', showBack: true, onBack: () => context.pop()),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: LmListSkeleton(rows: 3, height: 120),
            ),
          ),
        ],
      );
    }

    final cover = photos.where((a) => a.role == AttachmentRole.cover);
    final gallery =
        photos.where((a) => a.role == AttachmentRole.gallery).toList();

    return Column(
      children: [
        AppTopBar(
          title: trip.title,
          showBack: true,
          onBack: () => context.pop(),
          trailing: _IconBtn(
              icon: LmIcons.edit,
              onTap: () => showTripSheet(context, existing: trip)),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              if (cover.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _Cover(svc: svc, cover: cover.first),
                ),
              const SizedBox(height: 12),
              Text('${trip.destination} · ${dmy(trip.fromDate)} → ${dmy(trip.toDate)}',
                  style: AppText.bodyDim.copyWith(fontSize: 13)),
              const SizedBox(height: 14),
              _RatingsCard(trip: trip),
              if (trip.wouldRepeat != null || (trip.comment?.isNotEmpty ?? false)) ...[
                const SizedBox(height: 12),
                LmCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (trip.wouldRepeat != null)
                        Pill(trip.wouldRepeat! ? 'Бих повторил' : 'Не бих повторил',
                            color: trip.wouldRepeat! ? AppColors.green : AppColors.red),
                      if (trip.comment != null && trip.comment!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(trip.comment!,
                            style: AppText.body.copyWith(fontSize: 14, height: 1.5)),
                      ],
                    ],
                  ),
                ),
              ],
              if (gallery.isNotEmpty) ...[
                const SizedBox(height: 14),
                const Eyebrow('Галерия'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final a in gallery)
                      AttachmentThumb(svc: svc, attachment: a, size: 96),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              LmButton('Изтрий пътуването',
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
        content: Text('Да изтрия пътуването и снимките му?', style: AppText.bodyDim),
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
    await deleteTrip(
        ref.read(tripsDaoProvider), ref.read(attachmentServiceProvider), id);
    if (context.mounted) context.pop();
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.svc, required this.cover});
  final AttachmentService svc;
  final Attachment cover;
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 180,
        width: double.infinity,
        child: FutureBuilder<String>(
          future: svc.absolutePath(cover.filePath),
          builder: (context, snap) => snap.hasData
              ? Image.file(File(snap.data!),
                  fit: BoxFit.cover, width: double.infinity)
              : const ColoredBox(color: AppColors.card),
        ),
      );
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

class _RatingsCard extends StatelessWidget {
  const _RatingsCard({required this.trip});
  final Trip trip;
  @override
  Widget build(BuildContext context) {
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Eyebrow('Оценки', color: AppColors.amber),
          const SizedBox(height: 12),
          _bar('Обща', trip.overall),
          if (trip.fun != null) _bar('Забавление', trip.fun!),
          if (trip.food != null) _bar('Храна', trip.food!),
          if (trip.sights != null) _bar('Забележителности', trip.sights!),
          if (trip.value != null) _bar('Стойност', trip.value!),
        ],
      ),
    );
  }

  Widget _bar(String label, int v) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            SizedBox(
                width: 120,
                child: Text(label,
                    style: AppText.bodyDim.copyWith(fontSize: 12.5),
                    overflow: TextOverflow.ellipsis)),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 7,
                  color: AppColors.white08,
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: (v / 10).clamp(0.0, 1.0),
                    child: Container(color: AppColors.amber),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
                width: 34,
                child: Text('$v/10',
                    textAlign: TextAlign.right, style: AppText.mono12)),
          ],
        ),
      );
}
