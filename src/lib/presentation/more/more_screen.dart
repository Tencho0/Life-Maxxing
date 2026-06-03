// "Още" — every module, grouped (Логване / Пари / Здраве / Живот / Данни),
// plus the dev tools link. Rows push their route.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/icons/lm_icons.dart';
import '../../core/l10n/l10n_ext.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/lm_row.dart';
import '../../core/widgets/screen_body.dart';

// A module row. `label` is resolved from `context.l10n` at render time; the
// stored values here are stable identifiers, not user-facing strings.
class _Mod {
  const _Mod(this.route, this.label, this.icon);
  final String route;
  final String Function(BuildContext) label;
  final LmIcons icon;
}

// Groups are (eyebrow-resolver, modules). Both eyebrow and module labels are
// resolved via context.l10n in build() so all user-facing text is localized.
final _groups = <(String Function(BuildContext), List<_Mod>)>[
  ((c) => c.l10n.moreGroupLogging, [
    _Mod('/food', (c) => c.l10n.moreModuleFood, LmIcons.food),
    _Mod('/activities', (c) => c.l10n.moreModuleActivities, LmIcons.run),
    _Mod('/steps', (c) => c.l10n.moreModuleSteps, LmIcons.steps),
    _Mod('/daily', (c) => c.l10n.moreModuleDaily, LmIcons.sun),
  ]),
  ((c) => c.l10n.moreGroupMoney, [
    _Mod('/finance', (c) => c.l10n.moreModuleFinance, LmIcons.expense),
  ]),
  ((c) => c.l10n.moreGroupHealth, [
    _Mod('/health', (c) => c.l10n.moreModuleHealth, LmIcons.pulse),
  ]),
  ((c) => c.l10n.moreGroupLife, [
    _Mod('/bucket', (c) => c.l10n.moreModuleBucket, LmIcons.flag),
    _Mod('/trips', (c) => c.l10n.moreModuleTrips, LmIcons.trip),
  ]),
  ((c) => c.l10n.moreGroupData, [
    _Mod('/search', (c) => c.l10n.moreModuleSearch, LmIcons.search),
    _Mod('/export', (c) => c.l10n.moreModuleExport, LmIcons.export),
    _Mod('/backup', (c) => c.l10n.moreModuleBackup, LmIcons.bolt),
  ]),
];

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(title: context.l10n.moreTitle),
        Expanded(
          child: ScreenBody(
            children: [
              for (final group in _groups) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 8),
                  child: Eyebrow(group.$1(context)),
                ),
                for (final m in group.$2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: LmRow(
                      icon: m.icon,
                      iconColor: AppColors.accent,
                      title: m.label(context),
                      onTap: () => context.push(m.route),
                      trailing: const LmIcon(LmIcons.chevR,
                          size: 17, color: AppColors.textFaint),
                    ),
                  ),
              ],
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 8),
                child: Eyebrow(context.l10n.settingsTitle),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: LmRow(
                  icon: LmIcons.dots,
                  iconColor: AppColors.accent,
                  title: context.l10n.settingsLanguage,
                  onTap: () => context.push('/settings'),
                  trailing: const LmIcon(LmIcons.chevR,
                      size: 17, color: AppColors.textFaint),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 8),
                child: Eyebrow(context.l10n.moreGroupDev),
              ),
              LmRow(
                icon: LmIcons.bolt,
                iconColor: AppColors.purple,
                title: context.l10n.moreDevDesignSystem,
                onTap: () => context.push('/dev'),
                trailing: const LmIcon(LmIcons.chevR,
                    size: 17, color: AppColors.textFaint),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}
