import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lifemaxxing/app/providers.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/dev/seed.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/presentation/memories/memory_providers.dart';
import 'package:lifemaxxing/presentation/memories/memory_screen.dart';
import '../support/test_env.dart';

DailyLogsCompanion _log(String id, String date) => DailyLogsCompanion.insert(
      id: id, date: date, mood: 7, proud: true,
      didUncomfortable: false, workout: true, drankAlcohol: false,
      createdAt: DateTime.utc(2026), updatedAt: DateTime.utc(2026),
    );

AttachmentsCompanion _photo(String id, String logId) =>
    AttachmentsCompanion.insert(
      id: id, entityType: AttachmentEntity.dailyLog, entityId: logId,
      role: AttachmentRole.main,
      filePath: 'attachments/daily-photos/$id.jpg',
      thumbPath: 'attachments/daily-photos/${id}_thumb.jpg',
      fileType: 'image/jpeg', fileSize: 100, createdAt: DateTime.utc(2026),
    );

void main() {
  setUp(useDeterministicTestEnv);

  test('memoryDays lists only days that have a daily photo, newest first',
      () async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final container =
        ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);
    addTearDown(container.dispose);

    await db.dailyLogsDao.save(_log('d1', '2026-06-01'));
    await db.dailyLogsDao.save(_log('d2', '2026-06-02')); // no photo → excluded
    await db.dailyLogsDao.save(_log('d3', '2026-06-03'));
    await db.attachmentsDao.save(_photo('p1', 'd1'));
    await db.attachmentsDao.save(_photo('p3', 'd3'));

    container.listen(memoryDaysProvider, (_, _) {});
    // Drain both upstream streams.
    await container.read(memoryDailyPhotosProvider.future);
    await container.read(memoryAllLogsProvider.future);

    final days = container.read(memoryDaysProvider).requireValue;
    expect(days.map((m) => m.date), ['2026-06-03', '2026-06-01']); // desc
    expect(days.map((m) => m.logId), ['d3', 'd1']);
  });

  testWidgets('memories screen renders the trips rail from seeded data',
      (tester) async {
    tester.view.physicalSize = const Size(420, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.memory();
    addTearDown(db.close);
    await seedDatabase(db); // trips present; no daily photos

    await tester.pumpWidget(ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: localizedApp(home: Scaffold(body: MemoriesScreen())),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Спомени'), findsOneWidget); // top bar title
    expect(find.text('Weekend in Rome'), findsWidgets); // a trip in the rail

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
