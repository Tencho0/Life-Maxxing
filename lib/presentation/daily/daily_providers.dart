// Daily Quick Log providers: the viewed date, its log + steps (reactive), and
// the trailing-30-day window (mood trend + §17.6 summary) ending at that date.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../data/summaries.dart' show computeDailyLogs;
import '../../domain/enums.dart';
import '../../domain/summaries.dart';
import '../steps/steps_providers.dart' show stepsDaoProvider;

String _ymd(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

final dailyLogsDaoProvider =
    Provider((ref) => ref.watch(databaseProvider).dailyLogsDao);

/// The date currently shown by the Daily screen (default: today).
final dailyDateProvider = StateProvider<String>((_) => _ymd(DateTime.now()));

/// The daily log for the viewed date (null if none yet).
final dailyLogProvider = StreamProvider.autoDispose<DailyLog?>((ref) =>
    ref.watch(dailyLogsDaoProvider).watchByDate(ref.watch(dailyDateProvider)));

/// The steps entry for the viewed date (null if none) — drives the read-only
/// "заключено" display.
final dailyStepsProvider = StreamProvider.autoDispose<StepEntry?>((ref) {
  final d = ref.watch(dailyDateProvider);
  return ref
      .watch(stepsDaoProvider)
      .watchInRange(d, d)
      .map((l) => l.isEmpty ? null : l.first);
});

/// Logs in the trailing 30-day window ending at the viewed date.
final dailyMonthLogsProvider =
    StreamProvider.autoDispose<List<DailyLog>>((ref) {
  final d = DateTime.parse(ref.watch(dailyDateProvider));
  final from = _ymd(DateTime(d.year, d.month, d.day - 29));
  final to = _ymd(d);
  return ref.watch(dailyLogsDaoProvider).watchInRange(from, to);
});

final dailySummaryProvider =
    Provider.autoDispose<AsyncValue<DailyLogSummary>>((ref) =>
        ref.watch(dailyMonthLogsProvider).whenData(computeDailyLogs));

/// The daily photo (role=main) for the viewed date, or null.
final dailyPhotoProvider = StreamProvider.autoDispose<Attachment?>((ref) {
  final log = ref.watch(dailyLogProvider).asData?.value;
  if (log == null) return Stream<Attachment?>.value(null);
  return ref
      .watch(databaseProvider)
      .attachmentsDao
      .watchForEntity(AttachmentEntity.dailyLog, log.id)
      .map((l) => l.isEmpty ? null : l.first);
});
