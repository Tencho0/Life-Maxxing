// Memories — a trips rail plus the visual diary: a grid of only those days that
// have a daily photo. Tapping a day opens that daily log (spec §19).

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/format/dates.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/screen_body.dart';
import '../../core/widgets/section_title.dart';
import '../../data/database.dart';
import '../../services/attachment_service.dart';
import '../daily/daily_providers.dart';
import '../trips/trip_providers.dart';
import 'memory_providers.dart';

class MemoriesScreen extends ConsumerWidget {
  const MemoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsAllProvider).asData?.value ?? const [];
    final days = ref.watch(memoryDaysProvider).asData?.value ?? const [];
    final svc = ref.watch(attachmentServiceProvider);

    return Column(
      children: [
        AppTopBar(
          title: context.l10n.memoryTitle,
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              Eyebrow(context.l10n.memoryTrips),
              const SizedBox(height: 10),
              if (trips.isEmpty)
                Text(context.l10n.memoryNoTrips, style: AppText.bodyDim)
              else
                SizedBox(
                  height: 130,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [for (final t in trips) _TripRailCard(trip: t)],
                  ),
                ),
              SectionTitle(context.l10n.memoryVisualDiary),
              if (days.isEmpty)
                LmEmpty(
                  icon: LmIcons.camera,
                  message: context.l10n.memoryEmptyDiary,
                )
              else
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    for (final d in days)
                      _DayTile(svc: svc, day: d, onTap: () {
                        ref.read(dailyDateProvider.notifier).state = d.date;
                        context.push('/daily');
                      }),
                  ],
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _TripRailCard extends ConsumerWidget {
  const _TripRailCard({required this.trip});
  final Trip trip;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cover = ref.watch(tripCoverProvider(trip.id)).asData?.value;
    final svc = ref.watch(attachmentServiceProvider);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/trips/${trip.id}'),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _Cover(svc: svc, cover: cover, hue: trip.title.hashCode % 360)),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Text(trip.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bodyStrong.copyWith(fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.svc, required this.cover, required this.hue});
  final AttachmentService svc;
  final Attachment? cover;
  final int hue;
  @override
  Widget build(BuildContext context) {
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            HSLColor.fromAHSL(1, hue % 360, 0.22, 0.30).toColor(),
            HSLColor.fromAHSL(1, (hue + 30) % 360, 0.18, 0.18).toColor(),
          ],
        ),
      ),
    );
    return SizedBox(
      width: double.infinity,
      child: cover == null
          ? placeholder
          : FutureBuilder<String>(
              future: svc.absolutePath(cover!.thumbPath),
              builder: (context, snap) => snap.hasData
                  ? Image.file(File(snap.data!),
                      fit: BoxFit.cover, width: double.infinity)
                  : placeholder,
            ),
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({required this.svc, required this.day, required this.onTap});
  final AttachmentService svc;
  final MemoryDay day;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder<String>(
              future: svc.absolutePath(day.photo.thumbPath),
              builder: (context, snap) => snap.hasData
                  ? Image.file(File(snap.data!), fit: BoxFit.cover)
                  : const ColoredBox(color: AppColors.card),
            ),
            Positioned(
              left: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(dm(day.date), // dd.MM
                    style: AppText.mono12.copyWith(fontSize: 10, color: AppColors.text)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
