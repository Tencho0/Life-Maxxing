// Export screen: renders the selectors + live preview/counts from seeded data,
// and toggling the format swaps the rendered preview (Markdown ↔ JSON).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/presentation/export/export_screen.dart';
import '../support/test_env.dart';

void main() {
  setUp(useDeterministicTestEnv);

  testWidgets('renders selectors + preview and toggles format', (tester) async {
    tester.view.physicalSize = const Size(420, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db, today: DateTime(2026, 6, 1));

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const MaterialApp(home: Scaffold(body: ExportScreen())),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Експорт за AI'), findsOneWidget); // top bar
    expect(find.text('ОБХВАТ'), findsOneWidget); // field label (uppercased)
    expect(find.text('ФОРМАТ'), findsOneWidget);
    expect(find.text('ЗАПИСИ'), findsOneWidget); // counts card stat

    // Default format is Markdown → preview shows the markdown title.
    expect(find.textContaining('LifeMaxxing — Експорт за AI'), findsOneWidget);

    // Switch to JSON → preview becomes a JSON document.
    await tester.tap(find.text('JSON'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.textContaining('"exportDate"'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
