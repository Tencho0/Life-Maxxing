import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/presentation/trips/trip_detail_screen.dart';
import 'package:lifemaxxing/presentation/trips/trip_forms.dart';
import 'package:lifemaxxing/presentation/trips/trip_providers.dart';
import 'package:lifemaxxing/presentation/trips/trip_screen.dart';
import 'package:lifemaxxing/services/attachment_service.dart';
import 'package:lifemaxxing/services/image_processor.dart';
import 'package:path/path.dart' as p;
import '../support/test_env.dart';

class _FakeProc implements ImageProcessor {
  @override
  Future<ProcessedImage> process(String sourcePath,
          {required int maxEdge, required int quality}) async =>
      ProcessedImage(bytes: Uint8List(maxEdge * 4), width: maxEdge, height: maxEdge);
}

TripsCompanion _trip(String id, String title, String dest,
        {String from = '2026-05-01', String to = '2026-05-05',
        int overall = 8, bool? repeat}) =>
    TripsCompanion.insert(
      id: id, title: title, destination: dest, fromDate: from, toDate: to,
      overall: overall, wouldRepeat: Value(repeat),
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    );

void main() {
  setUp(useDeterministicTestEnv);

  test('trip stats: avg overall + repeat count', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final container =
        ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
    addTearDown(container.dispose);

    await db.tripsDao.save(_trip('t1', 'Рим', 'Италия', overall: 9, repeat: true));
    await db.tripsDao.save(_trip('t2', 'Банско', 'България', overall: 7, repeat: false));

    container.listen(tripsAllProvider, (_, _) {});
    await container.read(tripsAllProvider.future);

    final s = container.read(tripStatsProvider);
    expect(s.hasValue, isTrue);
    expect(s.requireValue.count, 2);
    expect(s.requireValue.avgOverall, 8);
    expect(s.requireValue.repeatCount, 1);
  });

  test('trips are searchable by title and destination', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    await db.tripsDao.save(_trip('t1', 'Уикенд в Рим', 'Рим, Италия'));

    expect((await db.searchDao.search('УИКЕНД')).any((h) => h.id == 't1'), isTrue);
    expect((await db.searchDao.search('италия')).any((h) => h.id == 't1'), isTrue);
  });

  test('db rejects toDate < fromDate', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    expect(
      () => db.tripsDao
          .save(_trip('t1', 'X', 'Y', from: '2026-05-10', to: '2026-05-01')),
      throwsA(anything),
    );
  });

  test('one cover + many gallery; deleteTrip cleans all files + rows', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final docs = await Directory.systemTemp.createTemp('lm_trip_test');
    addTearDown(() async {
      if (await docs.exists()) await docs.delete(recursive: true);
    });
    var n = 0;
    final svc = AttachmentService(
      db.attachmentsDao,
      imageProcessor: _FakeProc(),
      docsDir: () async => docs,
      idGen: () => 'a${n++}',
      clock: () => DateTime.utc(2026),
    );
    final src = p.join(docs.path, 'src.jpg');
    await File(src).writeAsBytes(List<int>.filled(10, 1));
    String abs(String rel) => p.join(docs.path, p.joinAll(p.posix.split(rel)));

    await db.tripsDao.save(_trip('t1', 'Рим', 'Италия'));
    await svc.addFromFile(
        entity: AttachmentEntity.trip, entityId: 't1',
        role: AttachmentRole.cover, sourcePath: src);
    final cover2 = await svc.addFromFile(
        entity: AttachmentEntity.trip, entityId: 't1',
        role: AttachmentRole.cover, sourcePath: src); // replaces first cover
    final g1 = await svc.addFromFile(
        entity: AttachmentEntity.trip, entityId: 't1',
        role: AttachmentRole.gallery, sourcePath: src);
    await svc.addFromFile(
        entity: AttachmentEntity.trip, entityId: 't1',
        role: AttachmentRole.gallery, sourcePath: src);

    final rows = await db.attachmentsDao.forEntity(AttachmentEntity.trip, 't1');
    expect(rows.where((a) => a.role == AttachmentRole.cover), hasLength(1));
    expect(rows.where((a) => a.role == AttachmentRole.gallery), hasLength(2));

    await deleteTrip(db.tripsDao, svc, 't1');
    expect(await db.tripsDao.getById('t1'), isNull);
    expect(await db.attachmentsDao.forEntity(AttachmentEntity.trip, 't1'), isEmpty);
    expect(File(abs(cover2.filePath)).existsSync(), isFalse);
    expect(File(abs(g1.filePath)).existsSync(), isFalse);
  });

  group('trip form', () {
    Future<void> openForm(WidgetTester tester, AppDatabase db) async {
      tester.view.physicalSize = const Size(500, 3200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: localizedApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () => showTripSheet(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('requires title and destination', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await openForm(tester, db);

      await tester.tap(find.text('Запази'));
      await tester.pumpAndSettle();
      expect(find.text('Заглавие и дестинация са задължителни'), findsOneWidget);
      expect(await db.select(db.trips).get(), isEmpty);
    });

    testWidgets('saves a valid trip', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await openForm(tester, db);

      await tester.enterText(find.byType(TextField).at(0), 'Уикенд в Рим');
      await tester.enterText(find.byType(TextField).at(1), 'Рим, Италия');
      await tester.tap(find.text('Запази'));
      await tester.pumpAndSettle();

      final rows = await db.select(db.trips).get();
      expect(rows, hasLength(1));
      expect(rows.first.title, 'Уикенд в Рим');
      expect(rows.first.titleLower, 'уикенд в рим');
      expect(rows.first.overall, inInclusiveRange(1, 10));
    });
  });

  testWidgets('trips screen renders from seeded data', (tester) async {
    tester.view.physicalSize = const Size(420, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: Scaffold(body: TripScreen())),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Пътувания'), findsOneWidget);
    expect(find.text('Weekend in Rome'), findsWidgets);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('trip detail renders ratings from seeded data', (tester) async {
    tester.view.physicalSize = const Size(420, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: Scaffold(body: TripDetailScreen(id: 'tr0'))),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Weekend in Rome'), findsWidgets); // title
    expect(find.text('ОЦЕНКИ'), findsOneWidget); // ratings eyebrow

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
