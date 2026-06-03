import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import '../core/theme/theme.dart';
import '../l10n/app_localizations.dart';
import '../presentation/onboarding/welcome_screen.dart';
import 'providers.dart';
import 'router.dart';

class LifeMaxxingApp extends StatelessWidget {
  const LifeMaxxingApp({super.key, this.overrides = const []});

  /// Provider overrides for tests (in-memory DB) and `main()` (persisted
  /// locale + the shared DB instance). Empty by default.
  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(overrides: overrides, child: const _Root());
  }
}

class _Root extends ConsumerWidget {
  const _Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // null = follow system; a user choice (persisted via SettingsService) wins.
    final locale = ref.watch(localeProvider);
    // No name yet → first launch: gate the app behind the welcome screen.
    // Submitting a name flips userNameProvider and this rebuilds into the app.
    final name = ref.watch(userNameProvider);
    final needsName = name == null || name.isEmpty;

    // Shared MaterialApp configuration for both the welcome gate and the app.
    String title(BuildContext context) => AppLocalizations.of(context).appTitle;

    if (needsName) {
      return MaterialApp(
        onGenerateTitle: title,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const WelcomeScreen(),
      );
    }

    return MaterialApp.router(
      onGenerateTitle: title,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
