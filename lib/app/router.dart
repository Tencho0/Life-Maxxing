// App routing: a ShellRoute that keeps the bottom nav persistent across all
// screens (matching the prototype's single-stack model). Tab taps `go` (reset),
// module/detail navigation `push` (back stack). Screens here are placeholders
// in Slice 5.1 — Phase 7 replaces them with the real feature screens.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/tokens.dart';
import '../core/theme/typography.dart';
import '../core/icons/lm_icons.dart';
import '../core/widgets/app_top_bar.dart';
import '../core/widgets/lm_bottom_nav.dart';
import '../core/widgets/lm_row.dart';
import '../core/widgets/screen_body.dart';
import '../dev/dev_home.dart';
import '../presentation/activities/activity_screen.dart';
import '../presentation/bucket/bucket_detail_screen.dart';
import '../presentation/bucket/bucket_screen.dart';
import '../presentation/daily/daily_screen.dart';
import '../presentation/finance/finance_screen.dart';
import '../presentation/food/food_screen.dart';
import '../presentation/health/health_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/stats/stats_screen.dart';
import '../presentation/steps/steps_screen.dart';
import '../presentation/trips/trip_detail_screen.dart';
import '../presentation/trips/trip_screen.dart';
import 'sheets.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          _AppShell(location: state.uri.path, child: child),
      routes: [
        // Tab roots (no back button).
        GoRoute(path: '/', builder: (c, s) => const HomeScreen()),
        GoRoute(path: '/stats', builder: (c, s) => const StatsScreen()),
        GoRoute(
            path: '/memories', builder: (c, s) => const _Placeholder('Спомени')),
        GoRoute(path: '/more', builder: (c, s) => const _MoreScreen()),
        // Module / detail routes (pushed → show back). Real screens land here
        // as their feature slices complete; the rest stay placeholders.
        for (final m in _modules)
          GoRoute(path: m.$1, builder: (c, s) => _moduleScreen(m)),
        GoRoute(
            path: '/bucket/:id',
            builder: (c, s) =>
                BucketDetailScreen(id: s.pathParameters['id']!)),
        GoRoute(
            path: '/trips/:id',
            builder: (c, s) => TripDetailScreen(id: s.pathParameters['id']!)),
      ],
    ),
    // Dev tools (full screen, outside the shell).
    GoRoute(path: '/dev', builder: (c, s) => const DevHome()),
  ],
);

/// Real screen for a module route, or a placeholder until its slice lands.
Widget _moduleScreen((String, String) m) => switch (m.$1) {
      '/finance' => const FinanceScreen(),
      '/food' => const FoodScreen(),
      '/activities' => const ActivityScreen(),
      '/steps' => const StepsScreen(),
      '/health' => const HealthScreen(),
      '/daily' => const DailyScreen(),
      '/bucket' => const BucketScreen(),
      '/trips' => const TripScreen(),
      _ => _Placeholder(m.$2, back: true),
    };

// (route, title) for the pushed module screens.
const _modules = <(String, String)>[
  ('/food', 'Храна'),
  ('/activities', 'Активности'),
  ('/steps', 'Крачки'),
  ('/finance', 'Финанси'),
  ('/health', 'Здраве'),
  ('/daily', 'Дневен отчет'),
  ('/bucket', 'Bucket List'),
  ('/trips', 'Пътувания'),
  ('/search', 'Търсене'),
  ('/export', 'Експорт за AI'),
  ('/backup', 'Backup & Restore'),
];

class _AppShell extends StatelessWidget {
  const _AppShell({required this.location, required this.child});
  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: child,
      bottomNavigationBar: LmBottomNav(
        currentLocation: location,
        onTab: (route) => context.go(route),
        onPlus: () => openQuickSheet(context),
      ),
    );
  }
}

/// Temporary screen placeholder (Slice 5.1).
class _Placeholder extends StatelessWidget {
  const _Placeholder(this.title, {this.back = false});
  final String title;
  final bool back;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(
          title: title,
          showBack: back,
          onBack: back ? () => context.pop() : null,
        ),
        Expanded(
          child: Center(
            child: Text('$title — предстои (Phase 7)', style: AppText.bodyDim),
          ),
        ),
      ],
    );
  }
}

/// "Още" — lists every module so navigation is exercisable end-to-end.
class _MoreScreen extends StatelessWidget {
  const _MoreScreen();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppTopBar(title: 'Всички модули'),
        Expanded(
          child: ScreenBody(
            children: [
              for (final m in _modules)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: LmRow(
                    title: m.$2,
                    onTap: () => context.push(m.$1),
                    trailing: const LmIcon(LmIcons.chevR,
                        size: 17, color: AppColors.textFaint),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: LmRow(
                  icon: LmIcons.bolt,
                  iconColor: AppColors.purple,
                  title: 'Dev: дизайн система',
                  onTap: () => context.push('/dev'),
                  trailing: const LmIcon(LmIcons.chevR,
                      size: 17, color: AppColors.textFaint),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
