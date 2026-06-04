// Slice 10.1 — i18n infrastructure (pipeline proof).
//
// Verifies the `context.l10n` extension resolves seeded strings per active
// locale, and that the app installs the gen-l10n delegates for bg + en.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:lifemaxxing/app/app.dart';
import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/core/l10n/l10n_ext.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/l10n/app_localizations.dart';

import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  testWidgets('context.l10n resolves seeded strings per locale',
      (tester) async {
    Future<String> labelFor(Locale locale) async {
      late String value;
      await tester.pumpWidget(MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(builder: (context) {
          value = context.l10n.settingsLanguage;
          return const SizedBox.shrink();
        }),
      ));
      return value;
    }

    expect(await labelFor(const Locale('bg')), 'Език');
    expect(await labelFor(const Locale('en')), 'Language');
  });

  testWidgets('app wires bg + en localization delegates', (tester) async {
    // Tall/wide surface so the DB-backed Home builds without overflow.
    tester.view.physicalSize = const Size(500, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);

    await tester.pumpWidget(LifeMaxxingApp(
      overrides: [
        databaseProvider.overrideWithValue(db),
        // Name set → skip the first-launch welcome gate, render the real app.
        initialUserNameProvider.overrideWithValue('Martin'),
      ],
    ));
    // Let Home's drift streams emit (real async) so no fake timer stays pending.
    await settleData(tester);

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(app.supportedLocales, const [Locale('bg'), Locale('en')]);
    expect(app.localizationsDelegates, contains(AppLocalizations.delegate));
    expect(
      app.localizationsDelegates,
      contains(GlobalMaterialLocalizations.delegate),
    );

    // Unmount + flush so stream subscriptions tear down before teardown (§6).
    await tester.pumpWidget(const SizedBox());
    await settleData(tester);
  }, timeout: const Timeout(Duration(seconds: 30)));
}
