// StepsService — owns the one-value-per-date steps rule shared between the
// Daily Quick Log and the Steps module (spec §17.4 / §18 / §29.3):
//  • the Daily Log may CREATE a day's steps only if none exist yet
//    (source = dailyQuickLog); once a value exists it is read-only there;
//  • the Steps module may create or edit freely (source = stepsModule on
//    create); editing preserves the original `source` (provenance = where the
//    value was first entered) and the createdAt, bumping updatedAt;
//  • deletion happens only through the Steps module.

import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../data/daos.dart';
import '../data/database.dart';
import '../domain/enums.dart';

class StepsService {
  StepsService(this._dao, {String Function()? idGen, DateTime Function()? clock})
      : _idGen = idGen ?? (() => const Uuid().v4()),
        _clock = clock ?? DateTime.now;

  final StepsDao _dao;
  final String Function() _idGen;
  final DateTime Function() _clock;

  /// The steps row for [date], or null.
  Future<StepEntry?> forDate(String date) => _dao.getByDate(date);

  /// Whether the Daily Quick Log must show steps as read-only for [date]
  /// (true when a value already exists).
  Future<bool> isLockedForDaily(String date) async =>
      (await _dao.getByDate(date)) != null;

  /// Called from the Daily Quick Log. Creates the day's steps only if none
  /// exist; otherwise leaves the existing value untouched. Returns the
  /// effective row.
  Future<StepEntry> setFromDaily(String date, int count) async {
    final existing = await _dao.getByDate(date);
    if (existing != null) return existing; // locked — daily can't change it
    final ts = _clock().toUtc();
    await _dao.save(StepsCompanion.insert(
      id: _idGen(),
      date: date,
      count: count,
      source: StepsSource.dailyQuickLog,
      createdAt: ts,
      updatedAt: ts,
    ));
    return (await _dao.getByDate(date))!;
  }

  /// Called from the Steps module. Creates (source = stepsModule) or edits the
  /// day's value. Editing keeps the original source + createdAt, bumps updatedAt.
  Future<void> setFromStepsModule(String date, int count, {String? note}) async {
    final existing = await _dao.getByDate(date);
    final ts = _clock().toUtc();
    if (existing == null) {
      await _dao.save(StepsCompanion.insert(
        id: _idGen(),
        date: date,
        count: count,
        note: Value(note),
        source: StepsSource.stepsModule,
        createdAt: ts,
        updatedAt: ts,
      ));
    } else {
      await _dao.save(StepsCompanion(
        id: Value(existing.id),
        date: Value(date),
        count: Value(count),
        note: Value(note ?? existing.note),
        source: Value(existing.source), // preserve provenance
        createdAt: Value(existing.createdAt),
        updatedAt: Value(ts),
      ));
    }
  }

  /// Steps-module-only deletion.
  Future<void> deleteForDate(String date) async {
    final e = await _dao.getByDate(date);
    if (e != null) await _dao.deleteById(e.id);
  }
}
