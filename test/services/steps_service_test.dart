import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/services/steps_service.dart';

void main() {
  late AppDatabase db;
  late StepsService svc;
  var idN = 0;
  var clock = DateTime.utc(2026, 6, 1, 8, 0);

  setUp(() {
    db = AppDatabase.memory();
    idN = 0;
    clock = DateTime.utc(2026, 6, 1, 8, 0);
    svc = StepsService(
      db.stepsDao,
      idGen: () => 's${idN++}',
      clock: () => clock,
    );
  });
  tearDown(() => db.close());

  const date = '2026-06-01';

  test('setFromDaily creates when absent (source = dailyQuickLog)', () async {
    final row = await svc.setFromDaily(date, 9420);
    expect(row.count, 9420);
    expect(row.source, StepsSource.dailyQuickLog);
    expect(await svc.isLockedForDaily(date), isTrue);
  });

  test('setFromDaily is a no-op when a value already exists (locked)', () async {
    await svc.setFromStepsModule(date, 5000); // entered in steps module
    final returned = await svc.setFromDaily(date, 9999); // daily tries to change
    expect(returned.count, 5000); // unchanged
    expect(returned.source, StepsSource.stepsModule);
    expect((await svc.forDate(date))!.count, 5000);
  });

  test('isLockedForDaily reflects existence', () async {
    expect(await svc.isLockedForDaily(date), isFalse);
    await svc.setFromDaily(date, 8000);
    expect(await svc.isLockedForDaily(date), isTrue);
  });

  test('steps module creates (source = stepsModule) then edits in place',
      () async {
    await svc.setFromStepsModule(date, 8000, note: 'сутрин');
    final created = (await svc.forDate(date))!;
    expect(created.source, StepsSource.stepsModule);

    clock = DateTime.utc(2026, 6, 1, 22, 0); // later edit
    await svc.setFromStepsModule(date, 12000);
    final edited = (await svc.forDate(date))!;
    expect(edited.id, created.id); // same row (one per date)
    expect(edited.count, 12000);
    expect(edited.note, 'сутрин'); // preserved when not provided
    expect(edited.createdAt, created.createdAt); // preserved
    expect(edited.updatedAt.isAfter(created.updatedAt), isTrue); // bumped
  });

  test('editing a daily-created value preserves its provenance', () async {
    await svc.setFromDaily(date, 9000); // source dailyQuickLog
    await svc.setFromStepsModule(date, 9500); // corrected in steps module
    final row = (await svc.forDate(date))!;
    expect(row.count, 9500);
    expect(row.source, StepsSource.dailyQuickLog); // origin preserved
  });

  test('only one row per date regardless of path', () async {
    await svc.setFromDaily(date, 1000);
    await svc.setFromStepsModule(date, 2000);
    await svc.setFromDaily(date, 3000);
    expect(await db.stepsDao.inRange(date, date), hasLength(1));
  });

  test('deleteForDate removes (steps-module-only)', () async {
    await svc.setFromStepsModule(date, 8000);
    await svc.deleteForDate(date);
    expect(await svc.forDate(date), isNull);
  });
}
