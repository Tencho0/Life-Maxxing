import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

import '../core/theme/theme.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';

class LifeMaxxingApp extends StatelessWidget {
  const LifeMaxxingApp({super.key, this.overrides = const []});

  /// Provider overrides for tests (e.g. an in-memory database). Empty in prod.
  final List<Override> overrides;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        // Localization: bg + en via gen-l10n. `locale: null` follows the system
        // locale for now; a persisted localeProvider drives it in Slice 10.2.
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: appRouter,
      ),
    );
  }
}
