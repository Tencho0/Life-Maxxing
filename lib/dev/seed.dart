// Dev-only seed: realistic Bulgarian sample data across all tables, anchored to
// `today` so charts show recent data. Respects one-per-day (daily/steps) and
// all CHECK constraints. NOT shipped in release builds. Mirrors the prototype's
// sample data (design/.../lib/data.jsx).

import 'dart:math';
import 'package:drift/drift.dart' show Value;

import '../data/database.dart';
import '../domain/enums.dart';

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Deletes all rows (children before parents for FK safety).
Future<void> clearAll(AppDatabase db) async {
  await db.delete(db.attachments).go();
  await db.delete(db.bucketExperiences).go();
  await db.delete(db.bucketItems).go();
  await db.delete(db.trips).go();
  await db.delete(db.meals).go();
  await db.delete(db.activities).go();
  await db.delete(db.expenses).go();
  await db.delete(db.income).go();
  await db.delete(db.bloodPressureLogs).go();
  await db.delete(db.medicationLogs).go();
  await db.delete(db.healthEvents).go();
  await db.delete(db.labTests).go();
  await db.delete(db.dailyLogs).go();
  await db.delete(db.steps).go();
}

/// Wipes and repopulates the database with ~30 days of sample data.
Future<void> seedDatabase(AppDatabase db, {DateTime? today}) async {
  final rnd = Random(42);
  final b = today ?? DateTime.now();
  final t0 = DateTime(b.year, b.month, b.day);
  final now = DateTime.now().toUtc();
  DateTime day(int back) => DateTime(t0.year, t0.month, t0.day - back);

  await clearAll(db);

  // ── Steps + daily logs: one per date over the last 30 days ────────
  for (var i = 29; i >= 0; i--) {
    final d = _ymd(day(i));
    final weekend = day(i).weekday >= 6;
    await db.stepsDao.save(StepsCompanion.insert(
      id: 'st$i', date: d,
      count: 4200 + rnd.nextInt(7800) + (weekend ? 1500 : 0),
      source: i % 4 == 0 ? StepsSource.dailyQuickLog : StepsSource.stepsModule,
      createdAt: now, updatedAt: now,
    ));
    if (i % 5 != 3) {
      // ~24 of 30 days filled
      final alcohol = weekend && rnd.nextBool();
      await db.dailyLogsDao.save(DailyLogsCompanion.insert(
        id: 'dl$i', date: d,
        mood: 4 + rnd.nextInt(6),
        proud: rnd.nextBool(),
        didUncomfortable: rnd.nextBool(),
        uncomfortableWhat: const Value('Обадих се на клиент, който отлагах'),
        workout: rnd.nextDouble() > 0.45,
        drankAlcohol: alcohol,
        alcoholWhat: alcohol ? const Value('2 бири') : const Value.absent(),
        screenTimeMin: Value(150 + rnd.nextInt(250)),
        note: const Value('Силен ден. Тренировката беше тежка но качествена.'),
        createdAt: now, updatedAt: now,
      ));
    }
  }

  // ── Meals: a few on the most recent 10 days ───────────────────────
  const mealNames = [
    ('Овесена каша с банан', MealType.breakfast, 420, 14.0, 58.0, 15.0),
    ('Пилешко с ориз и салата', MealType.lunch, 680, 52.0, 64.0, 22.0),
    ('Протеинов шейк + ябълка', MealType.snack, 280, 32.0, 34.0, 4.0),
    ('Сьомга на скара със зеленчуци', MealType.dinner, 560, 44.0, 18.0, 34.0),
  ];
  var mealId = 0;
  for (var i = 9; i >= 0; i--) {
    final d = _ymd(day(i));
    for (final m in mealNames.take(2 + rnd.nextInt(3))) {
      await db.mealsDao.save(MealsCompanion.insert(
        id: 'me${mealId++}', date: d, name: m.$1, type: m.$2,
        time: Value('${8 + rnd.nextInt(12)}:${rnd.nextBool() ? '15' : '40'}'),
        calories: Value(m.$3), protein: Value(m.$4),
        carbs: Value(m.$5), fat: Value(m.$6),
        createdAt: now, updatedAt: now,
      ));
    }
  }

  // ── Activities ────────────────────────────────────────────────────
  const acts = [
    (ActivityType.gym, 'Гръб и бицепс', 65, Intensity.high, 8),
    (ActivityType.bjj, 'Вечерна тренировка — gi', 90, Intensity.high, 9),
    (ActivityType.cycling, 'Обиколка на Витоша', 120, Intensity.medium, 8),
    (ActivityType.swimming, 'Сутрешно плуване — 1500м', 45, Intensity.medium, 7),
    (ActivityType.boxing, 'Спаринг', 60, Intensity.high, 8),
    (ActivityType.hiking, 'Черни връх', 240, Intensity.medium, 9),
  ];
  for (var i = 0; i < 12; i++) {
    final a = acts[i % acts.length];
    await db.activitiesDao.save(ActivitiesCompanion.insert(
      id: 'ac$i', date: _ymd(day(i * 2)), type: a.$1, name: Value(a.$2),
      durationMin: Value(a.$3), intensity: Value(a.$4), moodAfter: Value(a.$5),
      createdAt: now, updatedAt: now,
    ));
  }

  // ── Money ─────────────────────────────────────────────────────────
  const exp = [
    ('Обяд навън — Happy', ExpenseCategory.food, 3200),
    ('Зареждане OMV', ExpenseCategory.car, 12000),
    ('Креатин + витамин D', ExpenseCategory.healthSupplements, 5400),
    ('Кафе с приятели', ExpenseCategory.social, 1800),
    ('Netflix + iCloud', ExpenseCategory.subscriptions, 4200),
  ];
  var eid = 0;
  for (var i = 0; i < 24; i++) {
    final e = exp[i % exp.length];
    await db.financeDao.saveExpense(ExpensesCompanion.insert(
      id: 'ex${eid++}', date: _ymd(day(i)), amountCents: e.$3,
      category: e.$2, description: e.$1,
      paymentMethod: Value(i.isEven ? PaymentMethod.card : PaymentMethod.cash),
      createdAt: now, updatedAt: now,
    ));
  }
  await db.financeDao.saveIncome(IncomeCompanion.insert(
    id: 'in0', date: _ymd(day(29)), amountCents: 250000,
    source: 'Заплата — Klevret', category: IncomeCategory.salary,
    createdAt: now, updatedAt: now,
  ));
  await db.financeDao.saveIncome(IncomeCompanion.insert(
    id: 'in1', date: _ymd(day(16)), amountCents: 60000,
    source: 'Overtime — нощни смени', category: IncomeCategory.bonus,
    createdAt: now, updatedAt: now,
  ));

  // ── Health ────────────────────────────────────────────────────────
  const notes = ['Сутрин след събуждане', 'Вечер преди лягане', 'В покой', 'След кафе'];
  var bpId = 0;
  for (var i = 0; i < 30; i += 2) {
    await db.healthDao.saveBp(BloodPressureLogsCompanion.insert(
      id: 'bp${bpId++}', date: _ymd(day(i)),
      time: '0${7 + rnd.nextInt(2)}:${rnd.nextBool() ? '20' : '05'}',
      systolic: 118 + rnd.nextInt(18),
      diastolic: 72 + rnd.nextInt(10),
      pulse: 64 + rnd.nextInt(16),
      note: Value(notes[rnd.nextInt(notes.length)]),
      createdAt: now, updatedAt: now,
    ));
  }
  const meds = [
    ('Витамин D3', MedType.vitamin, '4000 IU', '08:15', MedStatus.taken),
    ('Омега-3', MedType.supplement, '2 капс.', '08:15', MedStatus.taken),
    ('Магнезий', MedType.mineral, '400 mg', '22:00', MedStatus.taken),
    ('Креатин', MedType.sportsSupplement, '5 g', '—', MedStatus.missed),
  ];
  for (var i = 0; i < meds.length; i++) {
    final m = meds[i];
    await db.healthDao.saveMed(MedicationLogsCompanion.insert(
      id: 'md$i', date: _ymd(t0), time: m.$4, name: m.$1, type: m.$2,
      dose: Value(m.$3), status: m.$5, createdAt: now, updatedAt: now,
    ));
  }
  await db.healthDao.saveEvent(HealthEventsCompanion.insert(
    id: 'he0', date: _ymd(day(13)), type: HealthEventType.dentist,
    subtype: const Value(DentalSubtype.cleaning),
    clinic: const Value('Д-р Иванова'), whatWasDone: 'Профилактично почистване',
    priceCents: const Value(8000),
    nextRecommendedDate: Value(_ymd(DateTime(t0.year, t0.month + 6, t0.day))),
    createdAt: now, updatedAt: now,
  ));
  await db.healthDao.saveEvent(HealthEventsCompanion.insert(
    id: 'he1', date: _ymd(day(27)), type: HealthEventType.doctor,
    clinic: const Value('Д-р Петров — кардиолог'),
    whatWasDone: 'Профилактичен преглед, ЕКГ — норма',
    priceCents: const Value(12000), createdAt: now, updatedAt: now,
  ));
  await db.healthDao.saveLab(LabTestsCompanion.insert(
    id: 'lb0', date: _ymd(day(19)), lab: 'Цибалаб', reason: 'Хормони',
    resultsText: const Value('Testosterone: 24.1 nmol/L\nTSH: 1.8 mIU/L\n'
        'Vitamin D: 32 ng/ml\nGlucose: 5.1 mmol/L'),
    createdAt: now, updatedAt: now,
  ));

  // ── Bucket list ───────────────────────────────────────────────────
  const bucket = [
    ('Скок с парашут', 'Да победя страха си от височини', BucketPriority.high, BucketStatus.planned),
    ('Северно сияние в Исландия', 'Откакто се помня искам да го видя', BucketPriority.high, BucketStatus.idea),
    ('Маратон под 4 часа', 'Дисциплина и доказателство', BucketPriority.medium, BucketStatus.planned),
    ('Да науча сноуборд', '', BucketPriority.low, BucketStatus.completed),
    ('Уикенд в Рим', 'Архитектура и храна', BucketPriority.medium, BucketStatus.completed),
    ('Татуировка', '', BucketPriority.low, BucketStatus.abandoned),
  ];
  for (var i = 0; i < bucket.length; i++) {
    final it = bucket[i];
    await db.bucketDao.saveItem(BucketItemsCompanion.insert(
      id: 'bk$i', title: it.$1, whyWantIt: Value(it.$2),
      priority: it.$3, status: it.$4, createdAt: now, updatedAt: now,
    ));
    if (it.$4 == BucketStatus.completed) {
      await db.bucketDao.saveExperience(BucketExperiencesCompanion.insert(
        id: 'bx$i', bucketItemId: 'bk$i', completedDate: _ymd(day(60 + i * 30)),
        feelingRating: 8 + (i % 2), worthIt: true,
        reflection: const Value('Определено си заслужаваше. Бих го повторил.'),
        createdAt: now, updatedAt: now,
      ));
    }
  }

  // ── Trips ─────────────────────────────────────────────────────────
  const trips = [
    ('Уикенд в Рим', 'Рим, Италия', 9, 9, 10, 9, 7),
    ('Ски в Банско', 'Банско, България', 8, 9, 7, 8, 8),
    ('Гръцко лято', 'Тасос, Гърция', 9, 8, 8, 10, 9),
  ];
  for (var i = 0; i < trips.length; i++) {
    final tr = trips[i];
    final start = DateTime(t0.year, t0.month - 2 - i, 10);
    await db.tripsDao.save(TripsCompanion.insert(
      id: 'tr$i', title: tr.$1, destination: tr.$2,
      fromDate: _ymd(start), toDate: _ymd(DateTime(start.year, start.month, 14)),
      overall: tr.$3, fun: Value(tr.$4), food: Value(tr.$5),
      sights: Value(tr.$6), value: Value(tr.$7), wouldRepeat: const Value(true),
      comment: const Value('Невероятно изживяване, всяка крачка си заслужаваше.'),
      createdAt: now, updatedAt: now,
    ));
  }
}
