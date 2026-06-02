// "Още" — every module, grouped (Логване / Пари / Здраве / Живот / Данни),
// plus the dev tools link. Rows push their route.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/icons/lm_icons.dart';
import '../../core/theme/tokens.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/eyebrow.dart';
import '../../core/widgets/lm_row.dart';
import '../../core/widgets/screen_body.dart';

class _Mod {
  const _Mod(this.route, this.label, this.icon);
  final String route;
  final String label;
  final LmIcons icon;
}

const _groups = <(String, List<_Mod>)>[
  ('Логване', [
    _Mod('/food', 'Храна', LmIcons.food),
    _Mod('/activities', 'Активности', LmIcons.run),
    _Mod('/steps', 'Крачки', LmIcons.steps),
    _Mod('/daily', 'Дневен отчет', LmIcons.sun),
  ]),
  ('Пари', [
    _Mod('/finance', 'Финанси', LmIcons.expense),
  ]),
  ('Здраве', [
    _Mod('/health', 'Здраве', LmIcons.pulse),
  ]),
  ('Живот', [
    _Mod('/bucket', 'Bucket List', LmIcons.flag),
    _Mod('/trips', 'Пътувания', LmIcons.trip),
  ]),
  ('Данни', [
    _Mod('/search', 'Търсене', LmIcons.search),
    _Mod('/export', 'Експорт за AI', LmIcons.export),
    _Mod('/backup', 'Backup & Restore', LmIcons.bolt),
  ]),
];

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppTopBar(title: 'Всички модули'),
        Expanded(
          child: ScreenBody(
            children: [
              for (final group in _groups) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 8),
                  child: Eyebrow(group.$1),
                ),
                for (final m in group.$2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: LmRow(
                      icon: m.icon,
                      iconColor: AppColors.accent,
                      title: m.label,
                      onTap: () => context.push(m.route),
                      trailing: const LmIcon(LmIcons.chevR,
                          size: 17, color: AppColors.textFaint),
                    ),
                  ),
              ],
              const Padding(
                padding: EdgeInsets.only(top: 6, bottom: 8),
                child: Eyebrow('Dev'),
              ),
              LmRow(
                icon: LmIcons.bolt,
                iconColor: AppColors.purple,
                title: 'Dev: дизайн система',
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
