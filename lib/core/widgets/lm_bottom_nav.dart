// Bottom navigation bar (design BottomNav): 5 slots — Начало / Графики / ＋ /
// Спомени / Още — with a raised center FAB that opens the quick-log sheet.
// Presentational: takes the current location + tap callbacks.

import 'dart:ui';
import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/typography.dart';
import '../icons/lm_icons.dart';

class LmNavItem {
  const LmNavItem(this.route, this.icon, this.label);
  final String route;
  final LmIcons icon;
  final String label;
}

const kNavItems = [
  LmNavItem('/', LmIcons.home, 'Начало'),
  LmNavItem('/stats', LmIcons.chart, 'Графики'),
  LmNavItem('/memories', LmIcons.camera, 'Спомени'),
  LmNavItem('/more', LmIcons.dots, 'Още'),
];

class LmBottomNav extends StatelessWidget {
  const LmBottomNav({
    super.key,
    required this.currentLocation,
    required this.onTab,
    required this.onPlus,
  });

  final String currentLocation;
  final ValueChanged<String> onTab;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    // home, stats, [FAB], memories, more
    final left = kNavItems.take(2).toList();
    final right = kNavItems.skip(2).toList();

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xF00C0D11), // bg @ ~94%
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final it in left) _Slot(it, currentLocation, onTab),
                  _Fab(onPlus),
                  for (final it in right) _Slot(it, currentLocation, onTab),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot(this.item, this.current, this.onTab);
  final LmNavItem item;
  final String current;
  final ValueChanged<String> onTab;

  @override
  Widget build(BuildContext context) {
    final active = current == item.route;
    final color = active ? AppColors.accent : AppColors.textFaint;
    return Semantics(
      button: true,
      selected: active,
      label: item.label,
      excludeSemantics: true,
      child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTab(item.route),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LmIcon(item.icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(item.label,
                style: TextStyle(
                    fontFamily: AppText.sans, fontSize: 10, color: color)),
          ],
        ),
      ),
    ),
    );
  }
}

class _Fab extends StatelessWidget {
  const _Fab(this.onTap);
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Бързо логване',
      child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(AppRadii.fab),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.45),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const LmIcon(LmIcons.plus, size: 26, color: AppColors.bg, strokeWidth: 2.4),
      ),
    ),
    );
  }
}
