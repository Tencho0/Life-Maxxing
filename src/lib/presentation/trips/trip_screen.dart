// Trips screen — stat cards, a "would repeat" filter, and trip cards (cover +
// overall badge). Tapping a card pushes its detail (/trips/:id).

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/icons/lm_icons.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/card.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/screen_body.dart';
import '../../core/widgets/segmented.dart';
import '../../core/format/dates.dart';
import '../../data/database.dart';
import '../../domain/summaries.dart';
import '../../services/attachment_service.dart';
import 'trip_forms.dart';
import 'trip_providers.dart';

class TripScreen extends ConsumerWidget {
  const TripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(tripStatsProvider);
    final trips = ref.watch(tripsProvider).asData?.value ?? const [];
    final repeatOnly = ref.watch(tripRepeatOnlyProvider);
    final allLabel = context.l10n.tripFilterAll;
    final repeatLabel = context.l10n.tripFilterWouldRepeat;

    return Column(
      children: [
        AppTopBar(
          title: context.l10n.tripTitle,
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
          trailing: _AddButton(onTap: () => showTripSheet(context)),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              stats.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) =>
                    Text(context.l10n.tripError('$e'), style: AppText.bodyDim),
                data: (s) => _StatsCard(s),
              ),
              const SizedBox(height: 12),
              Segmented(
                columns: 2,
                options: [allLabel, repeatLabel],
                value: repeatOnly ? repeatLabel : allLabel,
                onChanged: (l) => ref
                    .read(tripRepeatOnlyProvider.notifier)
                    .state = l == repeatLabel,
              ),
              const SizedBox(height: 12),
              if (trips.isEmpty)
                LmEmpty(
                  icon: LmIcons.trip,
                  message: repeatOnly
                      ? context.l10n.tripEmptyRepeat
                      : context.l10n.tripEmpty,
                  actionLabel: repeatOnly ? null : context.l10n.tripAddAction,
                  onAction: repeatOnly ? null : () => showTripSheet(context),
                )
              else
                for (final t in trips)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _TripCard(trip: t),
                  ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
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
  final TripStats s;
  @override
  Widget build(BuildContext context) {
    return LmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Eyebrow(context.l10n.tripOverview),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _stat('${s.count}', context.l10n.tripStatCount)),
              Expanded(
                  child: _stat(s.avgOverall.toStringAsFixed(1),
                      context.l10n.tripStatAvg)),
              Expanded(
                  child:
                      _stat('${s.repeatCount}', context.l10n.tripStatRepeat)),
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

class _TripCard extends ConsumerWidget {
  const _TripCard({required this.trip});
  final Trip trip;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cover = ref.watch(tripCoverProvider(trip.id)).asData?.value;
    final svc = ref.watch(attachmentServiceProvider);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/trips/${trip.id}'),
      child: LmCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: _CoverHeader(svc: svc, cover: cover, hue: trip.title.hashCode % 360),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trip.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodyStrong),
                        const SizedBox(height: 2),
                        Text('${trip.destination} · ${dmy(trip.fromDate)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodyDim.copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: AppColors.amberSoft,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('${trip.overall}/10',
                        style: AppText.mono12.copyWith(color: AppColors.amber)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A 120-tall cover image (full-bleed) or a gradient placeholder.
class _CoverHeader extends StatelessWidget {
  const _CoverHeader({required this.svc, required this.cover, required this.hue});
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
      height: 120,
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
