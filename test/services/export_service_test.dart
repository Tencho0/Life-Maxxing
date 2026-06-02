// ExportService — gathers records (Full / Period / Module), applies the §25.5
// period-inclusion rules, and renders JSON (§25.8) + Markdown (§25.9). Pure-ish:
// reads an in-memory drift db, no filesystem/share, so the gather + render logic
// is unit-testable on the VM.

import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/data/database.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/domain/period.dart';
import 'package:lifemaxxing/services/export_service.dart';

void main() {
  late AppDatabase db;
  late ExportService svc;

  DateTime clock() => DateTime.utc(2026, 6, 1, 12);

  setUp(() {
    db = AppDatabase.memory();
    svc = ExportService(db, clock: clock);
  });
  tearDown(() => db.close());

  // Mid-day timestamps keep the local "created date" stable across timezones.
  DateTime ts(int y, int m, int d) => DateTime.utc(y, m, d, 12);
  final now = ts(2026, 6, 1);

  Future<void> seedMixed() async {
    // Meals: one inside May, one before.
    await db.mealsDao.save(MealsCompanion.insert(
        id: 'm_in', date: '2026-05-15', name: 'Салата', type: MealType.lunch,
        calories: const Value(420), createdAt: now, updatedAt: now));
    await db.mealsDao.save(MealsCompanion.insert(
        id: 'm_out', date: '2026-04-30', name: 'Тост', type: MealType.breakfast,
        createdAt: now, updatedAt: now));
    // Finance.
    await db.financeDao.saveExpense(ExpensesCompanion.insert(
        id: 'e_in', date: '2026-05-10', amountCents: 3250,
        category: ExpenseCategory.food, description: 'Обяд',
        createdAt: now, updatedAt: now));
    await db.financeDao.saveExpense(ExpensesCompanion.insert(
        id: 'e_out', date: '2026-06-01', amountCents: 999,
        category: ExpenseCategory.other, description: 'Друго',
        createdAt: now, updatedAt: now));
    await db.financeDao.saveIncome(IncomeCompanion.insert(
        id: 'i_in', date: '2026-05-05', amountCents: 250000,
        source: 'Заплата', category: IncomeCategory.salary,
        createdAt: now, updatedAt: now));
    // Blood pressure.
    await db.healthDao.saveBp(BloodPressureLogsCompanion.insert(
        id: 'bp_in', date: '2026-05-20', time: '08:00',
        systolic: 126, diastolic: 79, pulse: 73, createdAt: now, updatedAt: now));
    // Bucket items: created-in-range, completed-in-range (created earlier), out.
    await db.bucketDao.saveItem(BucketItemsCompanion.insert(
        id: 'bi_created', title: 'Скок с парашут',
        priority: BucketPriority.high, status: BucketStatus.idea,
        createdAt: ts(2026, 5, 12), updatedAt: now));
    await db.bucketDao.saveItem(BucketItemsCompanion.insert(
        id: 'bi_done', title: 'Маратон', priority: BucketPriority.medium,
        status: BucketStatus.completed,
        createdAt: ts(2026, 3, 1), updatedAt: now));
    await db.bucketDao.saveExperience(BucketExperiencesCompanion.insert(
        id: 'be_done', bucketItemId: 'bi_done', completedDate: '2026-05-25',
        feelingRating: 9, worthIt: true, createdAt: now, updatedAt: now));
    await db.bucketDao.saveItem(BucketItemsCompanion.insert(
        id: 'bi_out', title: 'Друго', priority: BucketPriority.low,
        status: BucketStatus.idea,
        createdAt: ts(2026, 1, 1), updatedAt: now));
    // Trips: from-in-range, to-in-range, fully out.
    await db.tripsDao.save(TripsCompanion.insert(
        id: 't_from', title: 'Рим', destination: 'Италия',
        fromDate: '2026-05-28', toDate: '2026-06-05', overall: 9,
        createdAt: now, updatedAt: now));
    await db.tripsDao.save(TripsCompanion.insert(
        id: 't_to', title: 'Виена', destination: 'Австрия',
        fromDate: '2026-04-25', toDate: '2026-05-02', overall: 8,
        createdAt: now, updatedAt: now));
    await db.tripsDao.save(TripsCompanion.insert(
        id: 't_out', title: 'Бургас', destination: 'България',
        fromDate: '2026-07-01', toDate: '2026-07-10', overall: 7,
        createdAt: now, updatedAt: now));
  }

  const mayRange = DateRange('2026-05-01', '2026-05-31');

  group('full export', () {
    test('JSON has all §25.8 top-level keys', () async {
      await seedMixed();
      final data = await svc.gather(const ExportRequest(scope: ExportScopeType.full));
      final json = jsonDecode(svc.toJson(data)) as Map<String, dynamic>;
      for (final key in const [
        'exportDate', 'period', 'summary', 'meals', 'activities', 'expenses',
        'income', 'healthEvents', 'labTests', 'bloodPressurePulseLogs',
        'medicationSupplementLogs', 'dailyQuickLogs', 'steps', 'bucketList',
        'bucketListExperiences', 'trips', 'attachments',
      ]) {
        expect(json.containsKey(key), isTrue, reason: 'missing key "$key"');
      }
      expect(json['exportDate'], '2026-06-01');
      expect(json['period'], isNull); // full export has no period window
    });

    test('serializes a meal with enum code and the right fields', () async {
      await seedMixed();
      final data = await svc.gather(const ExportRequest(scope: ExportScopeType.full));
      final json = jsonDecode(svc.toJson(data)) as Map<String, dynamic>;
      final meals = (json['meals'] as List).cast<Map<String, dynamic>>();
      final m = meals.firstWhere((x) => x['id'] == 'm_in');
      expect(m['type'], 'lunch'); // stable code, not the Bulgarian label
      expect(m['date'], '2026-05-15');
      expect(m['calories'], 420);
      expect(m.containsKey('nameLower'), isFalse); // shadow column excluded
    });

    test('money is exported in euros (cents/100)', () async {
      await seedMixed();
      final data = await svc.gather(const ExportRequest(scope: ExportScopeType.full));
      final json = jsonDecode(svc.toJson(data)) as Map<String, dynamic>;
      final e = (json['expenses'] as List).cast<Map<String, dynamic>>()
          .firstWhere((x) => x['id'] == 'e_in');
      expect(e['amount'], 32.5);
      final summary = json['summary'] as Map<String, dynamic>;
      expect((summary['finance'] as Map)['totalIncome'], 2500);
    });
  });

  group('period inclusion (§25.5)', () {
    test('records included only when their date is in range', () async {
      await seedMixed();
      final data = await svc.gather(
          const ExportRequest(scope: ExportScopeType.period, range: mayRange));
      expect(data.meals.map((m) => m.id), ['m_in']);
      expect(data.expenses.map((e) => e.id), ['e_in']);
    });

    test('bucket item included if created OR completed in range', () async {
      await seedMixed();
      final data = await svc.gather(
          const ExportRequest(scope: ExportScopeType.period, range: mayRange));
      final ids = data.bucketItems.map((b) => b.id).toSet();
      expect(ids, containsAll(['bi_created', 'bi_done']));
      expect(ids, isNot(contains('bi_out')));
      expect(data.bucketExperiences.map((e) => e.id), ['be_done']);
    });

    test('trip included if fromDate OR toDate falls in range', () async {
      await seedMixed();
      final data = await svc.gather(
          const ExportRequest(scope: ExportScopeType.period, range: mayRange));
      final ids = data.trips.map((t) => t.id).toSet();
      expect(ids, {'t_from', 't_to'});
      expect(ids, isNot(contains('t_out')));
    });

    test('JSON period reflects the selected range', () async {
      await seedMixed();
      final data = await svc.gather(
          const ExportRequest(scope: ExportScopeType.period, range: mayRange));
      final json = jsonDecode(svc.toJson(data)) as Map<String, dynamic>;
      expect(json['period'], {'from': '2026-05-01', 'to': '2026-05-31'});
    });
  });

  group('module export (§25.6)', () {
    test('only the chosen module has records', () async {
      await seedMixed();
      final data = await svc.gather(const ExportRequest(
          scope: ExportScopeType.module, module: ExportModule.expenses));
      expect(data.expenses, isNotEmpty);
      expect(data.meals, isEmpty);
      expect(data.trips, isEmpty);
      // Module export ignores period: both expenses present.
      expect(data.expenses.map((e) => e.id).toSet(), {'e_in', 'e_out'});
    });
  });

  group('markdown', () {
    test('always ends with the Questions for AI Analysis block', () async {
      await seedMixed();
      final data = await svc.gather(const ExportRequest(scope: ExportScopeType.full));
      final md = svc.toMarkdown(data);
      expect(md.contains('## Questions for AI Analysis'), isTrue);
      expect(md.trimRight().endsWith('Suggest concrete changes for next month.'),
          isTrue);
    });

    test('includes a section for present data and omits empty ones', () async {
      await seedMixed();
      final data = await svc.gather(const ExportRequest(
          scope: ExportScopeType.module, module: ExportModule.expenses));
      final md = svc.toMarkdown(data);
      expect(md.contains('## Пари'), isTrue);
      expect(md.contains('## Храна'), isFalse); // no meals in this export
    });
  });

  test('record/photo counts reflect gathered data', () async {
    await seedMixed();
    final data = await svc.gather(
        const ExportRequest(scope: ExportScopeType.period, range: mayRange));
    // m_in, e_in, i_in, bp_in, bi_created, bi_done, be_done, t_from, t_to = 9
    expect(data.recordCount, 9);
    expect(data.photoCount, 0);
  });
}
