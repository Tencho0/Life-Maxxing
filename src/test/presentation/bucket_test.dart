import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/presentation/bucket/bucket_detail_screen.dart';
import 'package:lifemaxxing/presentation/bucket/bucket_forms.dart';
import 'package:lifemaxxing/presentation/bucket/bucket_providers.dart';
import 'package:lifemaxxing/presentation/bucket/bucket_screen.dart';
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

BucketItemsCompanion _item(String id, String title,
        {BucketPriority priority = BucketPriority.medium,
        BucketStatus status = BucketStatus.idea}) =>
    BucketItemsCompanion.insert(
      id: id, title: title, priority: priority, status: status,
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    );

void main() {
  setUp(useDeterministicTestEnv);

  test('bucket stats reflect items + experiences', () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final container =
        ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
    addTearDown(container.dispose);

    await db.bucketDao
        .saveItem(_item('i1', 'A', priority: BucketPriority.high));
    await db.bucketDao
        .saveItem(_item('i2', 'B', status: BucketStatus.completed));
    await db.bucketDao.saveExperience(BucketExperiencesCompanion.insert(
      id: 'x2', bucketItemId: 'i2', completedDate: '2026-05-01',
      feelingRating: 9, worthIt: true,
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    ));

    container.listen(bucketAllItemsProvider, (_, _) {});
    container.listen(bucketExperiencesProvider, (_, _) {});
    await container.read(bucketAllItemsProvider.future);
    await container.read(bucketExperiencesProvider.future);

    final s = container.read(bucketStatsProvider);
    expect(s.hasValue, isTrue);
    expect(s.requireValue.total, 2);
    expect(s.requireValue.completed, 1);
    expect(s.requireValue.high, 1);
    expect(s.requireValue.worthItCount, 1);
  });

  group('experience (complete) flow', () {
    Future<void> openComplete(
        WidgetTester tester, AppDatabase db, BucketItem item,
        {BucketExperience? existing}) async {
      tester.view.physicalSize = const Size(500, 2600);
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
                  onPressed: () => showBucketCompleteSheet(context,
                      item: item, existing: existing),
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

    testWidgets('completing creates the experience and sets status completed',
        (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await db.bucketDao.saveItem(_item('i1', 'Скок с парашут'));
      final item = (await db.bucketDao.getItem('i1'))!;

      await openComplete(tester, db, item);
      await tester.tap(find.text('Маркирай като завършено'));
      await tester.pumpAndSettle();

      final exp = await db.bucketDao.experienceForItem('i1');
      expect(exp, isNotNull);
      expect((await db.bucketDao.getItem('i1'))!.status, BucketStatus.completed);
    });

    testWidgets('editing the experience keeps one row + completed status',
        (tester) async {
      final db = AppDatabase.memory();
      addTearDown(db.close);
      await db.bucketDao
          .saveItem(_item('i1', 'A', status: BucketStatus.completed));
      await db.bucketDao.saveExperience(BucketExperiencesCompanion.insert(
        id: 'x1', bucketItemId: 'i1', completedDate: '2026-05-01',
        feelingRating: 7, worthIt: true,
        createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
      ));
      final item = (await db.bucketDao.getItem('i1'))!;
      final existing = await db.bucketDao.experienceForItem('i1');

      await openComplete(tester, db, item, existing: existing);
      await tester.tap(find.text('Маркирай като завършено'));
      await tester.pumpAndSettle();

      final all = await db.select(db.bucketExperiences).get();
      expect(all, hasLength(1));
      expect((await db.bucketDao.getItem('i1'))!.status, BucketStatus.completed);
    });
  });

  testWidgets('detail shows the complete button only when not completed',
      (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    await db.bucketDao.saveItem(_item('i1', 'Идея ред', status: BucketStatus.idea));

    tester.view.physicalSize = const Size(420, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: Scaffold(body: BucketDetailScreen(id: 'i1'))),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Завърши го'), findsOneWidget);

    // Complete it → button gone.
    await db.bucketDao.saveExperience(BucketExperiencesCompanion.insert(
      id: 'x1', bucketItemId: 'i1', completedDate: '2026-05-01',
      feelingRating: 8, worthIt: true,
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    ));
    await db.bucketDao.saveItem(_item('i1', 'Идея ред', status: BucketStatus.completed));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Завърши го'), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  test('deleteBucketItem removes item + experience rows and their files',
      () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final docs = await Directory.systemTemp.createTemp('lm_bucket_test');
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

    await db.bucketDao.saveItem(_item('i1', 'A', status: BucketStatus.completed));
    await db.bucketDao.saveExperience(BucketExperiencesCompanion.insert(
      id: 'x1', bucketItemId: 'i1', completedDate: '2026-05-01',
      feelingRating: 8, worthIt: true,
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    ));
    final itemPhoto = await svc.addFromFile(
        entity: AttachmentEntity.bucketItem, entityId: 'i1',
        role: AttachmentRole.photo, sourcePath: src);
    final expPhoto = await svc.addFromFile(
        entity: AttachmentEntity.bucketExperience, entityId: 'x1',
        role: AttachmentRole.photo, sourcePath: src);

    await deleteBucketItem(db.bucketDao, svc, 'i1');

    expect(await db.bucketDao.getItem('i1'), isNull);
    expect(await db.bucketDao.experienceForItem('i1'), isNull);
    expect(await db.attachmentsDao.forEntity(AttachmentEntity.bucketItem, 'i1'),
        isEmpty);
    expect(
        await db.attachmentsDao
            .forEntity(AttachmentEntity.bucketExperience, 'x1'),
        isEmpty);
    expect(File(abs(itemPhoto.filePath)).existsSync(), isFalse);
    expect(File(abs(expPhoto.filePath)).existsSync(), isFalse);
  });

  testWidgets('bucket screen renders from seeded data', (tester) async {
    tester.view.physicalSize = const Size(420, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db, withPhotos: false);

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: Scaffold(body: BucketScreen())),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Bucket List'), findsOneWidget); // top bar title
    expect(find.text('Skydiving'), findsWidgets); // a seeded item

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
