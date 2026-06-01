import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/domain/enums.dart';

void main() {
  late AppDatabase db;
  final now = DateTime.utc(2026, 6, 1, 8, 0);
  const from = '2026-06-01', to = '2026-06-30'; // 30 days
  setUp(() => db = AppDatabase.memory());
  tearDown(() => db.close());

  test('finance summary: totals, balance, top category, avg/day', () async {
    await db.financeDao.saveExpense(ExpensesCompanion.insert(
      id: 'e1', date: '2026-06-05', amountCents: 1000,
      category: ExpenseCategory.food, description: 'A',
      createdAt: now, updatedAt: now,
    ));
    await db.financeDao.saveExpense(ExpensesCompanion.insert(
      id: 'e2', date: '2026-06-06', amountCents: 2000,
      category: ExpenseCategory.transport, description: 'B',
      createdAt: now, updatedAt: now,
    ));
    await db.financeDao.saveIncome(IncomeCompanion.insert(
      id: 'i1', date: '2026-06-01', amountCents: 5000,
      source: 'Заплата', category: IncomeCategory.salary,
      createdAt: now, updatedAt: now,
    ));
    final s = await db.financeDao.summary(from, to);
    expect(s.totalExpensesCents, 3000);
    expect(s.totalIncomeCents, 5000);
    expect(s.balanceCents, 2000);
    expect(s.expenseCount, 2);
    expect(s.incomeCount, 1);
    expect(s.topCategory, ExpenseCategory.transport);
    expect(s.topCategoryCents, 2000);
    expect(s.byCategoryCents[ExpenseCategory.food], 1000);
    expect(s.avgDailyExpenseCents, 100); // 3000 / 30
  });

  test('food summary ignores null nutrition; daily totals', () async {
    await db.mealsDao.save(MealsCompanion.insert(
      id: 'm1', date: '2026-06-02', name: 'A', type: MealType.breakfast,
      calories: const Value(420), protein: const Value(14),
      createdAt: now, updatedAt: now,
    ));
    await db.mealsDao.save(MealsCompanion.insert(
      id: 'm2', date: '2026-06-02', name: 'B', type: MealType.lunch,
      createdAt: now, updatedAt: now, // calories/protein null → excluded
    ));
    final s = await db.mealsDao.summary(from, to);
    expect(s.totalCalories, 420);
    expect(s.totalProtein, 14);
    expect(s.mealCount, 2);
    expect(s.byType[MealType.breakfast], 1);

    final day = await db.mealsDao.dailyTotals('2026-06-02');
    expect(day.calories, 420);
    expect(day.mealCount, 2);
  });

  test('activity summary: groups, total time, most frequent', () async {
    Future<void> act(String id, ActivityType t, int? dur) =>
        db.activitiesDao.save(ActivitiesCompanion.insert(
          id: id, date: '2026-06-03', type: t,
          durationMin: Value(dur), createdAt: now, updatedAt: now,
        ));
    await act('a1', ActivityType.gym, 60);
    await act('a2', ActivityType.gym, 50);
    await act('a3', ActivityType.bjj, 90);
    final s = await db.activitiesDao.summary(from, to);
    expect(s.count, 3);
    expect(s.totalMinutes, 200);
    expect(s.strengthCount, 2);
    expect(s.combatCount, 1);
    expect(s.mostFrequent, ActivityType.gym);
    expect(s.avgDurationMin, closeTo(200 / 3, 1e-9));
  });

  test('steps summary: total/avg/best/worst', () async {
    Future<void> st(String id, String date, int c) => db.stepsDao.save(
        StepsCompanion.insert(id: id, date: date, count: c,
            source: StepsSource.stepsModule, createdAt: now, updatedAt: now));
    await st('s1', '2026-06-01', 4000);
    await st('s2', '2026-06-02', 8000);
    await st('s3', '2026-06-03', 12000);
    final s = await db.stepsDao.summary(from, to);
    expect(s.total, 24000);
    expect(s.avg, 8000);
    expect(s.best, 12000);
    expect(s.worst, 4000);
    expect(s.daysLogged, 3);
  });

  test('health summary: averages + last measurement by time', () async {
    Future<void> bp(String id, String time, int sys, int dia, int p) =>
        db.healthDao.saveBp(BloodPressureLogsCompanion.insert(
          id: id, date: '2026-06-15', time: time,
          systolic: sys, diastolic: dia, pulse: p,
          createdAt: now, updatedAt: now,
        ));
    await bp('b1', '08:20', 124, 78, 70);
    await bp('b2', '22:10', 132, 82, 76);
    await db.healthDao.saveEvent(HealthEventsCompanion.insert(
      id: 'h1', date: '2026-06-10', type: HealthEventType.dentist,
      whatWasDone: 'Почистване', createdAt: now, updatedAt: now,
    ));
    final s = await db.healthDao.summary(from, to);
    expect(s.bpCount, 2);
    expect(s.avgSystolic, 128);
    expect(s.lastSystolic, 132); // latest time wins
    expect(s.lastPulse, 76);
    expect(s.lastDentalDate, '2026-06-10');
    expect(s.eventCount, 1);
  });

  test('daily log summary: counts + averages', () async {
    Future<void> log(String id, String date, int mood, bool alcohol) =>
        db.dailyLogsDao.save(DailyLogsCompanion.insert(
          id: id, date: date, mood: mood, proud: true,
          didUncomfortable: false, workout: true, drankAlcohol: alcohol,
          screenTimeMin: const Value(300), createdAt: now, updatedAt: now,
        ));
    await log('d1', '2026-06-01', 8, false);
    await log('d2', '2026-06-02', 6, true);
    final s = await db.dailyLogsDao.summary(from, to);
    expect(s.filled, 2);
    expect(s.avgMood, 7);
    expect(s.workoutDays, 2);
    expect(s.alcoholDays, 1);
    expect(s.noAlcoholDays, 1);
    expect(s.avgScreenMin, 300);
  });

  test('bucket stats: status counts + completed feeling/worth', () async {
    Future<void> item(String id, BucketStatus st, BucketPriority pr) =>
        db.bucketDao.saveItem(BucketItemsCompanion.insert(
          id: id, title: 'T', priority: pr, status: st,
          createdAt: now, updatedAt: now,
        ));
    await item('b1', BucketStatus.idea, BucketPriority.high);
    await item('b2', BucketStatus.planned, BucketPriority.medium);
    await item('b3', BucketStatus.completed, BucketPriority.low);
    await db.bucketDao.saveExperience(BucketExperiencesCompanion.insert(
      id: 'x1', bucketItemId: 'b3', completedDate: '2026-06-10',
      feelingRating: 9, worthIt: true, createdAt: now, updatedAt: now,
    ));
    final s = await db.bucketDao.stats();
    expect(s.total, 3);
    expect(s.ideas, 1);
    expect(s.planned, 1);
    expect(s.completed, 1);
    expect(s.high, 1);
    expect(s.avgFeeling, 9);
    expect(s.worthItCount, 1);
    expect(s.notWorthItCount, 0);
  });

  test('trip stats: averages, best, repeat count', () async {
    Future<void> trip(String id, int overall, bool repeat) =>
        db.tripsDao.save(TripsCompanion.insert(
          id: id, title: 'Trip $id', destination: 'D',
          fromDate: '2026-06-01', toDate: '2026-06-03', overall: overall,
          fun: Value(overall), wouldRepeat: Value(repeat),
          createdAt: now, updatedAt: now,
        ));
    await trip('t1', 9, true);
    await trip('t2', 7, false);
    final s = await db.tripsDao.stats();
    expect(s.count, 2);
    expect(s.avgOverall, 8);
    expect(s.bestTitle, 'Trip t1');
    expect(s.repeatCount, 1);
    expect(s.avgFun, 8);
  });
}
