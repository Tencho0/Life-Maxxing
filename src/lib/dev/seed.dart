// Dev-only seed: realistic sample data across all tables, anchored to `today`
// so charts show recent data. Respects one-per-day (daily/steps) and all CHECK
// constraints. NOT shipped in release builds.
//
// The data models one coherent person over the last 30 days — Martin, a
// disciplined guy in Sofia who lifts + trains BJJ, works a full-time job, tracks
// health, and travels. Values are correlated (mood is higher on training days,
// steps spike on hikes, supplements are taken most mornings, weekend dinners
// drift into cheat meals) so every screen looks like a real, lived-in log
// rather than random noise.

import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/database.dart';
import '../domain/enums.dart';
import '../services/attachment_service.dart';

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

String _hm(int h, int m) =>
    '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

/// Copies a bundled seed photo to a temp file and returns its path, so the
/// AttachmentService pipeline (which expects a file on disk) can ingest it.
Future<String> _assetToTemp(String name) async {
  final data = await rootBundle.load('assets/seed_photos/$name');
  final dir = await getTemporaryDirectory();
  final f = File(p.join(dir.path, name));
  await f.writeAsBytes(data.buffer.asUint8List(), flush: true);
  return f.path;
}

/// A meal template: name, type, kcal, protein, carbs, fat.
typedef _Meal = (String, MealType, int, double, double, double);

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
  await db.delete(db.weightLogs).go();
}

/// Wipes and repopulates the database with ~30 days of realistic sample data.
/// Seeds the database with the demo "Martin" dataset.
///
/// [withPhotos] (default true) also seeds trip covers + visual-diary photos
/// through the real AttachmentService pipeline (asset bundle → temp file →
/// image compression). That path needs the Flutter binding, path_provider, and
/// the image plugin, so unit tests asserting only the DB content pass
/// `withPhotos: false`.
Future<void> seedDatabase(AppDatabase db,
    {DateTime? today, bool withPhotos = true}) async {
  final rnd = Random(42);
  final b = today ?? DateTime.now();
  final t0 = DateTime(b.year, b.month, b.day);
  final now = DateTime.now().toUtc();
  DateTime day(int back) => DateTime(t0.year, t0.month, t0.day - back);
  T pick<T>(List<T> xs) => xs[rnd.nextInt(xs.length)];

  await clearAll(db);

  final att = AttachmentService(db.attachmentsDao);
  final dailyLogIds = <String>[];

  // Running id counters per table.
  var mealId = 0, actId = 0, expId = 0, bpId = 0, medId = 0;

  // ── Content pools ──────────────────────────────────────────────────
  final breakfasts = <_Meal>[
    ('Oatmeal with banana and peanut butter', MealType.breakfast, 480, 16, 62, 16),
    ('Scrambled eggs with avocado and toast', MealType.breakfast, 520, 26, 30, 32),
    ('Greek yogurt with blueberries and honey', MealType.breakfast, 320, 22, 38, 8),
    ('Protein pancakes with cottage cheese', MealType.breakfast, 450, 38, 44, 12),
    ('Three-egg omelette with spinach', MealType.breakfast, 380, 28, 6, 27),
  ];
  final lunches = <_Meal>[
    ('Chicken breast with rice and green salad', MealType.lunch, 680, 52, 64, 22),
    ('Beef with potatoes and vegetables', MealType.lunch, 740, 48, 58, 34),
    ('Pasta with chicken and tomato sauce', MealType.lunch, 700, 42, 78, 20),
    ('Quinoa bowl with chickpeas and veggies', MealType.lunch, 560, 24, 70, 18),
    ('Tuna with bulgur and broccoli', MealType.lunch, 540, 46, 52, 14),
    ('Beef tripe soup with bread', MealType.lunch, 420, 22, 28, 24),
  ];
  final dinners = <_Meal>[
    ('Grilled salmon with vegetables', MealType.dinner, 560, 44, 18, 34),
    ('Roast pork with sides', MealType.dinner, 720, 46, 40, 40),
    ('Salad with grilled chicken and egg', MealType.dinner, 430, 38, 14, 24),
    ('Baked meatballs with potatoes', MealType.dinner, 650, 40, 48, 34),
    ('Cheese omelette with salad', MealType.dinner, 470, 30, 10, 34),
  ];
  const cheatDinner =
      ('Margherita pizza (cheat meal)', MealType.dinner, 900, 34.0, 96.0, 38.0);
  final snacks = <_Meal>[
    ('Protein shake and an apple', MealType.snack, 280, 32, 34, 4),
    ('Nuts and dried fruit', MealType.snack, 320, 10, 24, 22),
    ('Cottage cheese with honey', MealType.snack, 220, 24, 18, 6),
    ('Protein bar', MealType.snack, 210, 20, 22, 7),
  ];
  const preWorkout =
      ('Banana and dates pre-workout', MealType.snack, 240, 3.0, 58.0, 1.0);

  final notes = [
    'Strong day. The workout was hard but high quality.',
    'Slept poorly but got through everything on the plan.',
    'Productive day at work — closed two tasks I had been putting off.',
    'Calm day. Evening walk, early to bed.',
    'A bit distracted, too much phone. Better tomorrow.',
    'Great mood after BJJ training.',
    'Tough day at work, but trained despite the fatigue.',
    'Family dinner, recharged my batteries.',
    'Focused day — deep work in the morning.',
    'Feeling progress in strength, the squat is going up.',
    'Rainy and lazy, but got the essentials done.',
  ];
  final uncomfortable = [
    'Called a client I had been avoiding.',
    'Cold shower in the morning.',
    'Asked my boss for feedback.',
    'Spoke up at the team standup.',
    'Skipped dessert even though I wanted it.',
    'Woke up at 5:30 and trained before work.',
    'Admitted a mistake to a colleague.',
  ];
  final actNotes = [
    'Strong session, good form.',
    'Heavy, but finished everything.',
    'Felt light and fast.',
    'A bit tired, but solid quality.',
    'New PR on the main lift.',
  ];
  final gymNames = [
    'Back and biceps',
    'Chest and triceps',
    'Legs — squat focus',
    'Shoulders and core',
    'Full body',
  ];
  final bjjNames = ['Evening session — gi', 'No-gi rolling', 'Technique and sparring'];
  final bpNotes = ['Morning after waking', 'Evening before bed', 'At rest'];

  // ── Per-day loop: the daily fabric of life ─────────────────────────
  for (var i = 29; i >= 0; i--) {
    final dt = day(i);
    final d = _ymd(dt);
    final wd = dt.weekday; // 1=Mon … 7=Sun
    final weekend = wd >= 6;

    // Weekly training split: gym Mon/Wed/Fri, BJJ Tue/Thu, cardio Sat,
    // mostly rest Sun — with the occasional skipped session.
    ActivityType? at;
    if (wd == 1 || wd == 3) {
      at = ActivityType.gym;
    } else if (wd == 5) {
      at = rnd.nextInt(5) == 0 ? null : ActivityType.gym;
    } else if (wd == 2 || wd == 4) {
      at = ActivityType.bjj;
    } else if (wd == 6) {
      at = pick([
        ActivityType.cycling,
        ActivityType.hiking,
        ActivityType.swimming,
        ActivityType.tennis,
      ]);
    } else {
      at = rnd.nextInt(3) == 0 ? ActivityType.swimming : null;
    }
    if (at != null && rnd.nextInt(8) == 0) at = null; // life happens
    final trained = at != null;

    if (at != null) {
      final (String name, int dur, Intensity intn, int qual, int mood) =
          switch (at) {
        ActivityType.gym => (pick(gymNames), 55 + rnd.nextInt(25), Intensity.high, 7 + rnd.nextInt(3), 7 + rnd.nextInt(3)),
        ActivityType.bjj => (pick(bjjNames), 75 + rnd.nextInt(30), Intensity.high, 7 + rnd.nextInt(3), 8 + rnd.nextInt(2)),
        ActivityType.cycling => ('Vitosha loop', 90 + rnd.nextInt(60), Intensity.medium, 7 + rnd.nextInt(3), 8 + rnd.nextInt(2)),
        ActivityType.hiking => (pick(['Cherni Vrah peak', 'Vitosha — Aleko']), 180 + rnd.nextInt(120), Intensity.medium, 8 + rnd.nextInt(2), 9),
        ActivityType.swimming => ('Morning swim — 1500m', 40 + rnd.nextInt(20), Intensity.medium, 7 + rnd.nextInt(2), 7 + rnd.nextInt(2)),
        ActivityType.tennis => ('Match with a friend', 60 + rnd.nextInt(30), Intensity.medium, 7 + rnd.nextInt(3), 8),
        _ => ('Workout', 60, Intensity.medium, 7, 7),
      };
      await db.activitiesDao.save(ActivitiesCompanion.insert(
        id: 'ac${actId++}', date: d, type: at, name: Value(name),
        startTime: Value(at == ActivityType.bjj ? _hm(19, 30) : _hm(7 + rnd.nextInt(2), pick([0, 15, 30]))),
        durationMin: Value(dur), intensity: Value(intn),
        quality: Value(qual.clamp(1, 10)), moodAfter: Value(mood.clamp(1, 10)),
        note: Value(pick(actNotes)), createdAt: now, updatedAt: now,
      ));
    }

    // Steps — one per day, correlated with the day's activity.
    var steps = (weekend ? 7000 : 6000) + rnd.nextInt(3500);
    if (at == ActivityType.hiking) {
      steps = 16000 + rnd.nextInt(7000);
    } else if (at == ActivityType.cycling) {
      steps += 2500;
    } else if (trained) {
      steps += 1500;
    } else if (!weekend && rnd.nextInt(6) == 0) {
      steps = 3000 + rnd.nextInt(1500); // a lazy desk day
    }
    await db.stepsDao.save(StepsCompanion.insert(
      id: 'st$i', date: d, count: steps,
      source: i % 4 == 0 ? StepsSource.dailyQuickLog : StepsSource.stepsModule,
      createdAt: now, updatedAt: now,
    ));

    // Weight — a gentle cut from ~84.0 → ~82.0 kg over 30 days, daily noise.
    final wGrams = 84000 - ((29 - i) * 70) + (rnd.nextInt(700) - 350);
    await db.weightDao.save(WeightLogsCompanion.insert(
      id: 'wt$i', date: d, weightGrams: wGrams,
      createdAt: now, updatedAt: now,
    ));

    // Daily Quick Log — most days, with a few honest gaps.
    if (rnd.nextInt(8) != 0) {
      final alcohol = weekend && rnd.nextInt(3) == 0;
      final wasUncomfortable = rnd.nextInt(3) == 0;
      var mood = 6 + (trained ? 1 : 0) + (weekend ? 1 : 0) + (rnd.nextInt(3) - 1);
      await db.dailyLogsDao.save(DailyLogsCompanion.insert(
        id: 'dl$i', date: d, mood: mood.clamp(3, 10),
        proud: trained || rnd.nextBool(),
        didUncomfortable: wasUncomfortable,
        uncomfortableWhat:
            wasUncomfortable ? Value(pick(uncomfortable)) : const Value.absent(),
        workout: trained,
        drankAlcohol: alcohol,
        alcoholWhat: alcohol
            ? Value(pick(['2 beers', 'A glass of red wine', 'Drinks with friends']))
            : const Value.absent(),
        screenTimeMin: Value(120 + rnd.nextInt(220) + (trained ? 0 : 40)),
        note: Value(pick(notes)), createdAt: now, updatedAt: now,
      ));
      dailyLogIds.add('dl$i');
    }

    // Meals — breakfast/lunch/dinner most days, plus snacks.
    Future<void> meal(_Meal m, String time) => db.mealsDao.save(
          MealsCompanion.insert(
            id: 'me${mealId++}', date: d, name: m.$1, type: m.$2,
            time: Value(time), calories: Value(m.$3), protein: Value(m.$4),
            carbs: Value(m.$5), fat: Value(m.$6), createdAt: now, updatedAt: now,
          ),
        );
    if (rnd.nextInt(10) != 0) {
      await meal(pick(breakfasts), _hm(7 + rnd.nextInt(2), pick([15, 30, 45])));
    }
    if (trained && at != ActivityType.bjj) {
      await meal(preWorkout, _hm(6, 45));
    }
    await meal(pick(lunches), _hm(12 + rnd.nextInt(2), pick([10, 30, 45])));
    if (rnd.nextInt(2) == 0 || trained) {
      await meal(pick(snacks), _hm(16, pick([0, 20, 40])));
    }
    if (rnd.nextInt(12) != 0) {
      final weekendCheat = weekend && rnd.nextInt(3) == 0;
      await meal(weekendCheat ? cheatDinner : pick(dinners),
          _hm(19 + rnd.nextInt(2), pick([0, 15, 30])));
    }

    // Money — everyday food + the odd social outing.
    Future<void> expense(ExpenseCategory cat, String desc, int cents) =>
        db.financeDao.saveExpense(ExpensesCompanion.insert(
          id: 'ex${expId++}', date: d, amountCents: cents, category: cat,
          description: desc,
          paymentMethod:
              Value(rnd.nextBool() ? PaymentMethod.card : PaymentMethod.cash),
          createdAt: now, updatedAt: now,
        ));
    if (rnd.nextInt(3) != 0) {
      await expense(ExpenseCategory.food, 'Coffee', pick([550, 650, 750]));
    }
    if (!weekend && rnd.nextInt(2) == 0) {
      await expense(ExpenseCategory.food, 'Lunch out', 2600 + rnd.nextInt(1400));
    }
    if (weekend && rnd.nextInt(2) == 0) {
      await expense(ExpenseCategory.social,
          pick(['Dinner with friends', 'Beers with colleagues', 'Coffee downtown']),
          1800 + rnd.nextInt(4200));
    }

    // Supplements — the daily stack, taken most mornings/evenings.
    Future<void> med(String time, String name, MedType type, String dose,
            {int missChance = 10}) =>
        db.healthDao.saveMed(MedicationLogsCompanion.insert(
          id: 'md${medId++}', date: d, time: time, name: name, type: type,
          dose: Value(dose),
          status:
              rnd.nextInt(missChance) == 0 ? MedStatus.missed : MedStatus.taken,
          createdAt: now, updatedAt: now,
        ));
    await med('08:15', 'Vitamin D3', MedType.vitamin, '4000 IU');
    await med('08:15', 'Omega-3', MedType.supplement, '2 caps');
    await med('22:30', 'Magnesium', MedType.mineral, '400 mg', missChance: 7);
    if (trained) {
      await med('17:30', 'Creatine', MedType.sportsSupplement, '5 g', missChance: 20);
    }

    // Blood pressure — roughly every third day, mostly textbook-normal.
    if (i % 3 == 1) {
      if (i == 10) {
        await db.healthDao.saveBp(BloodPressureLogsCompanion.insert(
          id: 'bp${bpId++}', date: d, time: _hm(22, 10),
          systolic: 138, diastolic: 88, pulse: 80,
          note: const Value('After a salty dinner — a bit high'),
          createdAt: now, updatedAt: now,
        ));
      } else {
        await db.healthDao.saveBp(BloodPressureLogsCompanion.insert(
          id: 'bp${bpId++}', date: d, time: _hm(7, pick([5, 20, 35])),
          systolic: 116 + rnd.nextInt(16),
          diastolic: 72 + rnd.nextInt(10),
          pulse: 58 + rnd.nextInt(18),
          note: Value(pick(bpNotes)), createdAt: now, updatedAt: now,
        ));
      }
    }
  }

  // ── Periodic / larger expenses (subscriptions, fuel, gear, …) ──────
  final periodic = <(int, ExpenseCategory, String, int)>[
    (29, ExpenseCategory.sport, 'Monthly gym membership', 6000),
    (27, ExpenseCategory.subscriptions, 'Netflix', 1299),
    (27, ExpenseCategory.subscriptions, 'Spotify Premium', 1099),
    (27, ExpenseCategory.subscriptions, 'iCloud 200GB', 299),
    (26, ExpenseCategory.car, 'Fuel — OMV', 12000),
    (23, ExpenseCategory.food, 'Weekly groceries — Lidl', 7400),
    (22, ExpenseCategory.appearance, 'Haircut', 2500),
    (20, ExpenseCategory.car, 'Oil change — service', 14500),
    (18, ExpenseCategory.clothing, 'Running shoes', 13900),
    (16, ExpenseCategory.food, 'Weekly groceries — Kaufland', 8900),
    (15, ExpenseCategory.education, 'Book — Atomic Habits', 2900),
    (13, ExpenseCategory.entertainment, 'Cinema — IMAX', 2600),
    (12, ExpenseCategory.social, "Colleague's birthday gift", 4000),
    (11, ExpenseCategory.healthSupplements, 'Whey protein — 2 kg', 7900),
    (9, ExpenseCategory.food, 'Weekly groceries — Kaufland', 8600),
    (9, ExpenseCategory.education, 'Online course — Flutter', 4900),
    (8, ExpenseCategory.healthSupplements, 'Pharmacy — supplements', 1850),
    (6, ExpenseCategory.clothing, 'T-shirts — 2 pcs', 4800),
    (4, ExpenseCategory.entertainment, 'New video game', 5900),
    (2, ExpenseCategory.food, 'Weekly groceries — Kaufland', 9200),
    (1, ExpenseCategory.healthSupplements, 'Creatine + vitamin D3', 5400),
  ];
  for (final p in periodic) {
    await db.financeDao.saveExpense(ExpensesCompanion.insert(
      id: 'ex${expId++}', date: _ymd(day(p.$1)), amountCents: p.$4,
      category: p.$2, description: p.$3,
      paymentMethod: Value(rnd.nextBool() ? PaymentMethod.card : PaymentMethod.cash),
      createdAt: now, updatedAt: now,
    ));
  }

  // ── Income ─────────────────────────────────────────────────────────
  final incomes = <(int, int, String, IncomeCategory)>[
    (28, 250000, 'Monthly salary', IncomeCategory.salary),
    (12, 48000, 'Freelance — logo design', IncomeCategory.freelance),
    (7, 9000, 'Sold an old monitor', IncomeCategory.sale),
    (3, 5000, 'Gift from parents', IncomeCategory.gift),
  ];
  for (var k = 0; k < incomes.length; k++) {
    final inc = incomes[k];
    await db.financeDao.saveIncome(IncomeCompanion.insert(
      id: 'in$k', date: _ymd(day(inc.$1)), amountCents: inc.$2,
      source: inc.$3, category: inc.$4, createdAt: now, updatedAt: now,
    ));
  }

  // ── Health events & lab tests ──────────────────────────────────────
  await db.healthDao.saveEvent(HealthEventsCompanion.insert(
    id: 'he0', date: _ymd(day(13)), type: HealthEventType.dentist,
    subtype: const Value(DentalSubtype.cleaning),
    clinic: const Value('Dr. Ivanova'),
    whatWasDone: 'Routine cleaning and check-up',
    priceCents: const Value(8000),
    nextRecommendedDate: Value(_ymd(DateTime(t0.year, t0.month + 6, t0.day))),
    createdAt: now, updatedAt: now,
  ));
  await db.healthDao.saveEvent(HealthEventsCompanion.insert(
    id: 'he1', date: _ymd(day(27)), type: HealthEventType.doctor,
    clinic: const Value('Dr. Petrov — cardiologist'),
    whatWasDone: 'Routine check-up, ECG — normal',
    priceCents: const Value(12000), createdAt: now, updatedAt: now,
  ));
  await db.healthDao.saveEvent(HealthEventsCompanion.insert(
    id: 'he2', date: _ymd(day(8)), type: HealthEventType.physiotherapy,
    clinic: const Value('Kinesis studio'), reason: const Value('Shoulder pain'),
    whatWasDone: 'Shoulder rehab after training — 3rd session',
    priceCents: const Value(6000),
    nextRecommendedDate: Value(_ymd(day(1))), createdAt: now, updatedAt: now,
  ));
  await db.healthDao.saveEvent(HealthEventsCompanion.insert(
    id: 'he3', date: _ymd(day(20)), type: HealthEventType.checkup,
    clinic: const Value('Derma Clinic'),
    whatWasDone: 'Mole dermatoscopy — all clear',
    priceCents: const Value(5000), createdAt: now, updatedAt: now,
  ));
  await db.healthDao.saveLab(LabTestsCompanion.insert(
    id: 'lb0', date: _ymd(day(19)), lab: 'Cibalab', reason: 'Hormones',
    resultsText: const Value('Testosterone: 24.1 nmol/L\nTSH: 1.8 mIU/L\n'
        'Vitamin D: 32 ng/ml\nGlucose: 5.1 mmol/L'),
    createdAt: now, updatedAt: now,
  ));
  await db.healthDao.saveLab(LabTestsCompanion.insert(
    id: 'lb1', date: _ymd(day(5)), lab: 'Ramus', reason: 'Complete blood count',
    resultsText: const Value('Hemoglobin: 152 g/L\nWBC: 6.2 x10⁹/L\n'
        'Cholesterol: 4.6 mmol/L\nCreatinine: 92 µmol/L'),
    note: const Value('Routine, all within range.'),
    createdAt: now, updatedAt: now,
  ));

  // ── Bucket list ────────────────────────────────────────────────────
  const bucket = <(String, String, BucketPriority, BucketStatus)>[
    ('Skydiving', 'To beat my fear of heights', BucketPriority.high, BucketStatus.planned),
    ('Northern lights in Iceland', "I've wanted to see them forever", BucketPriority.high, BucketStatus.idea),
    ('Marathon under 4 hours', 'Discipline and proof to myself', BucketPriority.medium, BucketStatus.planned),
    ('Learn Italian', 'For trips around Italy', BucketPriority.medium, BucketStatus.idea),
    ('Learn snowboarding', '', BucketPriority.low, BucketStatus.completed),
    ('Weekend in Rome', 'Architecture and food', BucketPriority.medium, BucketStatus.completed),
    ('Tattoo', '', BucketPriority.low, BucketStatus.abandoned),
  ];
  for (var k = 0; k < bucket.length; k++) {
    final it = bucket[k];
    await db.bucketDao.saveItem(BucketItemsCompanion.insert(
      id: 'bk$k', title: it.$1, whyWantIt: Value(it.$2),
      priority: it.$3, status: it.$4, createdAt: now, updatedAt: now,
    ));
    if (it.$4 == BucketStatus.completed) {
      await db.bucketDao.saveExperience(BucketExperiencesCompanion.insert(
        id: 'bx$k', bucketItemId: 'bk$k', completedDate: _ymd(day(60 + k * 30)),
        feelingRating: 8 + (k % 2), worthIt: true,
        reflection: const Value('Totally worth it. I would do it again.'),
        createdAt: now, updatedAt: now,
      ));
    }
  }

  // ── Trips ──────────────────────────────────────────────────────────
  const trips = <(String, String, int, int, int, int, int)>[
    ('Weekend in Rome', 'Rome, Italy', 9, 9, 10, 9, 7),
    ('Skiing in Bansko', 'Bansko, Bulgaria', 8, 9, 7, 8, 8),
    ('Greek summer', 'Thassos, Greece', 9, 8, 8, 10, 9),
    ('City break in Budapest', 'Budapest, Hungary', 8, 8, 8, 9, 8),
  ];
  for (var k = 0; k < trips.length; k++) {
    final tr = trips[k];
    final start = DateTime(t0.year, t0.month - 2 - k, 10);
    await db.tripsDao.save(TripsCompanion.insert(
      id: 'tr$k', title: tr.$1, destination: tr.$2,
      fromDate: _ymd(start), toDate: _ymd(DateTime(start.year, start.month, 14)),
      overall: tr.$3, fun: Value(tr.$4), food: Value(tr.$5),
      sights: Value(tr.$6), value: Value(tr.$7), wouldRepeat: const Value(true),
      comment: const Value('Incredible experience, every step was worth it.'),
      createdAt: now, updatedAt: now,
    ));
  }

  // ── Photos: trip covers + visual-diary daily-log photos ────────────
  // Dev-only sample images (assets/seed_photos) run through the real
  // AttachmentService pipeline so Memories + Trips look lived-in.
  if (!withPhotos) return;
  const tripCovers = [
    'cover_rome.jpg', 'cover_bansko.jpg', 'cover_thassos.jpg', 'cover_budapest.jpg',
  ];
  for (var k = 0; k < trips.length && k < tripCovers.length; k++) {
    await att.addFromFile(
      entity: AttachmentEntity.trip,
      entityId: 'tr$k',
      role: AttachmentRole.cover,
      sourcePath: await _assetToTemp(tripCovers[k]),
      originalFileName: tripCovers[k],
    );
  }

  const diaryPhotos = [
    'diary_gym.jpg', 'diary_bjj.jpg', 'diary_coffee.jpg', 'diary_hike.jpg',
    'diary_food.jpg', 'diary_city.jpg', 'diary_run.jpg', 'diary_book.jpg',
  ];
  if (dailyLogIds.isNotEmpty) {
    // dailyLogIds run oldest→newest; spread photos across the recent days.
    final step =
        (dailyLogIds.length / diaryPhotos.length).floor().clamp(1, dailyLogIds.length).toInt();
    for (var k = 0; k < diaryPhotos.length; k++) {
      final idx = dailyLogIds.length - 1 - k * step;
      if (idx < 0) break;
      await att.addFromFile(
        entity: AttachmentEntity.dailyLog,
        entityId: dailyLogIds[idx],
        role: AttachmentRole.main,
        sourcePath: await _assetToTemp(diaryPhotos[k]),
        originalFileName: diaryPhotos[k],
      );
    }
  }
}
