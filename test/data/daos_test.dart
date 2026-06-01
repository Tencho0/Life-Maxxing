import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/domain/enums.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.utc(2026, 6, 1, 8, 0);
  setUp(() => db = AppDatabase.memory());
  tearDown(() => db.close());

  group('*Lower shadow columns are populated by the DAO (Cyrillic-safe)', () {
    test('meals: name + note lowercased on save', () async {
      await db.mealsDao.save(MealsCompanion.insert(
        id: 'm1', date: '2026-06-01', name: 'Овесена КАША',
        type: MealType.breakfast, note: const Value('Без ЗАХАР'),
        createdAt: now, updatedAt: now,
      ));
      final m = await db.mealsDao.getById('m1');
      expect(m!.nameLower, 'овесена каша');
      expect(m.noteLower, 'без захар');
      expect(m.name, 'Овесена КАША'); // original preserved
    });

    test('update recomputes the shadow column', () async {
      MealsCompanion meal(String name) => MealsCompanion.insert(
            id: 'm2', date: '2026-06-01', name: name,
            type: MealType.lunch, createdAt: now, updatedAt: now,
          );
      await db.mealsDao.save(meal('Пиле'));
      await db.mealsDao.save(meal('РИБА'));
      final m = await db.mealsDao.getById('m2');
      expect(m!.nameLower, 'риба');
    });

    test('required + nullable text across several tables', () async {
      await db.expensesDao.save(ExpensesCompanion.insert(
        id: 'e1', date: '2026-06-01', amountCents: 1200,
        category: ExpenseCategory.food, description: 'Обяд НАВЪН',
        note: const Value('С Колеги'), createdAt: now, updatedAt: now,
      ));
      final e = await db.expensesDao.getById('e1');
      expect(e!.descriptionLower, 'обяд навън');
      expect(e.noteLower, 'с колеги');

      await db.tripsDao.save(TripsCompanion.insert(
        id: 't1', title: 'Уикенд в РИМ', destination: 'Рим, ИТАЛИЯ',
        fromDate: '2026-06-01', toDate: '2026-06-03', overall: 9,
        comment: const Value('Страхотно!'), createdAt: now, updatedAt: now,
      ));
      final t = await db.tripsDao.getById('t1');
      expect(t!.titleLower, 'уикенд в рим');
      expect(t.destinationLower, 'рим, италия');
      expect(t.commentLower, 'страхотно!');

      await db.healthEventsDao.save(HealthEventsCompanion.insert(
        id: 'h1', date: '2026-06-01', type: HealthEventType.dentist,
        whatWasDone: 'ПОЧИСТВАНЕ', clinic: const Value('Д-р Иванова'),
        createdAt: now, updatedAt: now,
      ));
      final h = await db.healthEventsDao.getById('h1');
      expect(h!.whatWasDoneLower, 'почистване');
      expect(h.clinicLower, 'д-р иванова');
      expect(h.reasonLower, isNull); // absent stays null
    });
  });

  test('CRUD round-trip + delete', () async {
    await db.mealsDao.save(MealsCompanion.insert(
      id: 'm3', date: '2026-06-01', name: 'X',
      type: MealType.snack, createdAt: now, updatedAt: now,
    ));
    expect(await db.mealsDao.getById('m3'), isNotNull);
    await db.mealsDao.deleteById('m3');
    expect(await db.mealsDao.getById('m3'), isNull);
  });

  test('watchByDate stream emits on insert', () async {
    final stream = db.mealsDao.watchByDate('2026-06-01');
    // drift may coalesce the initial empty snapshot if the insert lands first,
    // so assert it emits a 1-element list at some point.
    final expectation = expectLater(stream, emitsThrough(hasLength(1)));
    await db.mealsDao.save(MealsCompanion.insert(
      id: 'm4', date: '2026-06-01', name: 'Y',
      type: MealType.dinner, createdAt: now, updatedAt: now,
    ));
    await expectation;
  });

  test('daily/steps getByDate; attachments filter by entity', () async {
    await db.dailyLogsDao.save(DailyLogsCompanion.insert(
      id: 'd1', date: '2026-06-01', mood: 8, proud: true,
      didUncomfortable: false, workout: true, drankAlcohol: false,
      createdAt: now, updatedAt: now,
    ));
    expect((await db.dailyLogsDao.getByDate('2026-06-01'))!.mood, 8);
    expect(await db.dailyLogsDao.getByDate('2026-06-02'), isNull);

    await db.attachmentsDao.save(AttachmentsCompanion.insert(
      id: 'a1', entityType: AttachmentEntity.meal, entityId: 'm1',
      role: AttachmentRole.photo, filePath: 'p.jpg', thumbPath: 'p_t.jpg',
      fileType: 'image/jpeg', fileSize: 1234, createdAt: now,
    ));
    final forMeal = await db.attachmentsDao.forEntity(AttachmentEntity.meal, 'm1');
    expect(forMeal, hasLength(1));
    final forTrip = await db.attachmentsDao.forEntity(AttachmentEntity.trip, 'm1');
    expect(forTrip, isEmpty);
  });
}
