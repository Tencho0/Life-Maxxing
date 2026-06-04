// Settings → "Изтрий всички данни": a destructive confirm flow that wipes all
// records + attachment files (BackupService.clearAllData) while keeping name +
// language. Covers the confirm path (data cleared + toast) and the cancel path
// (data preserved). The on-disk wipe runs against a temp docs dir so the test
// never touches path_provider.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/presentation/backup/backup_providers.dart';
import 'package:lifemaxxing/presentation/settings/settings_screen.dart';
import 'package:lifemaxxing/services/backup_service.dart';

import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  late AppDatabase db;
  late Directory docs;

  setUp(() async {
    db = AppDatabase.memory();
    docs = await Directory.systemTemp.createTemp('lm_settings_clear');
    await db.mealsDao.save(MealsCompanion.insert(
      id: 'm1', date: '2026-05-01', name: 'Обяд', type: MealType.lunch,
      createdAt: DateTime.utc(2026, 5, 1), updatedAt: DateTime.utc(2026, 5, 1),
    ));
  });
  tearDown(() async {
    await db.close();
    if (await docs.exists()) await docs.delete(recursive: true);
  });

  Widget wrap() => ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          initialUserNameProvider.overrideWithValue('Мартин'),
          backupServiceProvider.overrideWithValue(
              BackupService(db, docsDir: () async => docs)),
        ],
        child: localizedApp(home: const SettingsScreen()),
      );

  Future<bool> isEmpty() async =>
      (await db.mealsDao.getById('m1')) == null;

  testWidgets('confirming the dialog wipes all data, keeping the name',
      (tester) async {
    tester.view.physicalSize = const Size(420, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();
    expect(await isEmpty(), isFalse);

    // Open the confirm dialog.
    await tester.tap(find.text('Изтрий всички данни'));
    await tester.pumpAndSettle();
    expect(find.text('Изтрий всичко'), findsOneWidget); // red confirm button

    // Confirm — the wipe runs real file IO, so flush via runAsync.
    await tester.runAsync(() async {
      await tester.tap(find.text('Изтрий всичко'));
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pumpAndSettle();

    expect(await isEmpty(), isTrue); // all records gone
    expect(find.text('Изтрий всичко'), findsNothing); // dialog dismissed
    // Name preserved (the settings table is untouched by the wipe).
    final container = containerFor(tester, find.byType(SettingsScreen));
    expect(container.read(userNameProvider), 'Мартин');
  });

  testWidgets('cancelling the dialog keeps the data', (tester) async {
    tester.view.physicalSize = const Size(420, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Изтрий всички данни'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Отказ'));
    await tester.pumpAndSettle();

    expect(await isEmpty(), isFalse); // nothing deleted
  });
}
