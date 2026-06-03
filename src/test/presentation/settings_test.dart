// Slice 10.2 — language switcher + locale provider.
//
// Covers: selecting a language updates localeProvider AND persists it;
// a persisted choice is restored on next launch (startup override);
// default resolution maps the system locale to bg/en with a bg fallback.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/l10n/app_localizations.dart';
import 'package:lifemaxxing/presentation/settings/settings_screen.dart';
import 'package:lifemaxxing/services/settings_service.dart';

import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  Widget wrap(AppDatabase db, {String? name}) => ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          if (name != null) initialUserNameProvider.overrideWithValue(name),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('bg'),
          home: SettingsScreen(),
        ),
      );

  testWidgets('selecting English updates the locale provider and persists',
      (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    await tester.pumpWidget(wrap(db));
    await tester.pumpAndSettle();

    final container =
        ProviderScope.containerOf(tester.element(find.byType(SettingsScreen)));
    expect(container.read(localeProvider), isNull); // follows system initially

    await tester.tap(find.text('English'));
    await tester.pump();

    // Provider updates synchronously (live rebuild driver).
    expect(container.read(localeProvider), const Locale('en'));

    // The write is persisted (verified via a real-async read, §6).
    String? persisted;
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      persisted = (await SettingsService(db.settingsDao).getLocale())?.languageCode;
    });
    expect(persisted, 'en');
  });

  testWidgets('editing the name updates the provider and persists',
      (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    await tester.pumpWidget(wrap(db, name: 'Мартин'));
    await tester.pumpAndSettle();

    final container =
        ProviderScope.containerOf(tester.element(find.byType(SettingsScreen)));
    expect(container.read(userNameProvider), 'Мартин');

    // Open the edit dialog, replace the name, save.
    await tester.tap(find.text('Мартин'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Иван');
    await tester.tap(find.text('Запази'));
    await tester.pumpAndSettle();

    expect(container.read(userNameProvider), 'Иван');

    String? persisted;
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      persisted = await SettingsService(db.settingsDao).getUserName();
    });
    expect(persisted, 'Иван');
  });

  testWidgets('a persisted locale is restored on next launch', (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    // Pre-seed as if a previous session saved English.
    Locale? saved;
    await tester.runAsync(() async {
      await SettingsService(db.settingsDao).setLocale(const Locale('en'));
      saved = await SettingsService(db.settingsDao).getLocale();
    });

    // Simulate main(): seed the startup locale read from settings.
    await tester.pumpWidget(ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        initialLocaleProvider.overrideWithValue(saved),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Consumer(
          builder: (c, ref, _) => Text(
            ref.watch(localeProvider)?.languageCode ?? 'system',
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    ));
    await tester.pump();

    expect(find.text('en'), findsOneWidget);
  });

  testWidgets('system locale resolves to bg/en with a bg fallback',
      (tester) async {
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    Future<String> resolvedFor(String systemLang) async {
      tester.platformDispatcher.localesTestValue = [Locale(systemLang)];
      late Locale resolved;
      await tester.pumpWidget(MaterialApp(
        locale: null, // follow system
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (c) {
          resolved = Localizations.localeOf(c);
          return const SizedBox.shrink();
        }),
      ));
      await tester.pump();
      return resolved.languageCode;
    }

    expect(await resolvedFor('en'), 'en');
    expect(await resolvedFor('bg'), 'bg');
    expect(await resolvedFor('fr'), 'bg'); // unsupported → first supported (bg)
  });
}
