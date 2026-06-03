// First-launch welcome screen: the name is required (Continue is inert until
// the field is non-empty), and submitting updates userNameProvider live and
// persists it via SettingsService.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/presentation/onboarding/welcome_screen.dart';
import 'package:lifemaxxing/services/settings_service.dart';

import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  Widget wrap(AppDatabase db) => ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: localizedApp(home: const WelcomeScreen()),
      );

  testWidgets('shows the welcome prompt and starts with no name', (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    await tester.pumpWidget(wrap(db));
    await tester.pumpAndSettle();

    expect(find.text('Добре дошъл!'), findsOneWidget);
    expect(find.text('Как да те наричам?'), findsOneWidget);

    final container =
        ProviderScope.containerOf(tester.element(find.byType(WelcomeScreen)));
    expect(container.read(userNameProvider), isNull);
  });

  testWidgets('Continue is inert until a name is entered', (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    await tester.pumpWidget(wrap(db));
    await tester.pumpAndSettle();

    final container =
        ProviderScope.containerOf(tester.element(find.byType(WelcomeScreen)));

    // Tapping with an empty field does nothing.
    await tester.tap(find.text('Продължи'));
    await tester.pump();
    expect(container.read(userNameProvider), isNull);
  });

  testWidgets('entering a name and continuing sets the provider and persists',
      (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    await tester.pumpWidget(wrap(db));
    await tester.pumpAndSettle();

    final container =
        ProviderScope.containerOf(tester.element(find.byType(WelcomeScreen)));

    await tester.enterText(find.byType(TextFormField), '  Мартин  ');
    await tester.pump();
    await tester.tap(find.text('Продължи'));
    await tester.pump();

    // Provider updates synchronously (trimmed).
    expect(container.read(userNameProvider), 'Мартин');

    // The write is persisted.
    String? persisted;
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      persisted = await SettingsService(db.settingsDao).getUserName();
    });
    expect(persisted, 'Мартин');
  });
}
