// Backup & Restore screen: renders the includes list, create button, and the
// restore picker entry point. Share / file_picker are platform-only and aren't
// exercised here.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/presentation/backup/backup_screen.dart';
import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  testWidgets('renders includes list and the create/restore actions',
      (tester) async {
    tester.view.physicalSize = const Size(420, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: Scaffold(body: BackupScreen())),
    ));
    await tester.pump();

    expect(find.text('Backup & Restore'), findsOneWidget); // top bar
    expect(find.text('КАКВО СЕ ВКЛЮЧВА'), findsOneWidget); // eyebrow (uppercased)
    expect(find.text('ВЪЗСТАНОВЯВАНЕ'), findsOneWidget);
    expect(find.text('Създай backup'), findsOneWidget);
    expect(find.text('Избери backup файл'), findsOneWidget);
  });
}
