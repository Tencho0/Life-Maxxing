// Global search — a query box and unified, Cyrillic-safe results across modules.
// Tapping a hit navigates to its module (detail for bucket/trip, the day for a
// daily log). Spec §24.2.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/icons/lm_icons.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/field.dart';
import '../../core/widgets/lm_row.dart';
import '../../core/widgets/screen_body.dart';
import '../../core/format/dates.dart';
import '../../domain/search_hit.dart';
import '../daily/daily_providers.dart';
import 'search_providers.dart';

LmIcons _icon(SearchKind k) => switch (k) {
      SearchKind.meal => LmIcons.food,
      SearchKind.activity => LmIcons.run,
      SearchKind.expense => LmIcons.expense,
      SearchKind.income => LmIcons.income,
      SearchKind.healthEvent => LmIcons.event,
      SearchKind.labTest => LmIcons.labs,
      SearchKind.bloodPressure => LmIcons.pulse,
      SearchKind.medication => LmIcons.pill,
      SearchKind.dailyLog => LmIcons.sun,
      SearchKind.bucketItem => LmIcons.flag,
      SearchKind.trip => LmIcons.trip,
    };

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider).asData?.value ?? const [];
    final query = ref.watch(searchQueryProvider);

    return Column(
      children: [
        AppTopBar(
          title: 'Търсене',
          showBack: Navigator.of(context).canPop(),
          onBack: () => Navigator.of(context).maybePop(),
        ),
        Expanded(
          child: ScreenBody(
            children: [
              LmInput(
                hintText: 'Търси във всички модули…',
                onChanged: (v) =>
                    ref.read(searchQueryProvider.notifier).state = v,
              ),
              const SizedBox(height: 12),
              if (query.trim().isEmpty)
                const LmEmpty(
                  icon: LmIcons.search,
                  message: 'Въведи дума за търсене из всички модули',
                )
              else if (results.isEmpty)
                const LmEmpty(
                  icon: LmIcons.search,
                  message: 'Няма резултати',
                )
              else
                for (final h in results)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: LmRow(
                      icon: _icon(h.kind),
                      iconColor: AppColors.accent,
                      title: h.title,
                      subtitle: h.date.isEmpty
                          ? h.subtitle
                          : '${h.subtitle} · ${dmy(h.date)}',
                      onTap: () => _navigate(context, ref, h),
                    ),
                  ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  void _navigate(BuildContext context, WidgetRef ref, SearchHit h) {
    switch (h.kind) {
      case SearchKind.meal:
        context.push('/food');
      case SearchKind.activity:
        context.push('/activities');
      case SearchKind.expense:
      case SearchKind.income:
        context.push('/finance');
      case SearchKind.healthEvent:
      case SearchKind.labTest:
      case SearchKind.bloodPressure:
      case SearchKind.medication:
        context.push('/health');
      case SearchKind.dailyLog:
        if (h.date.isNotEmpty) {
          ref.read(dailyDateProvider.notifier).state = h.date;
        }
        context.push('/daily');
      case SearchKind.bucketItem:
        context.push('/bucket/${h.id}');
      case SearchKind.trip:
        context.push('/trips/${h.id}');
    }
  }
}
