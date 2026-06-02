// Memories providers: the visual-diary days (only daily logs that have a photo)
// and the trips rail (spec §19).

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../domain/enums.dart';

/// A day with a logged daily photo.
class MemoryDay {
  MemoryDay({required this.date, required this.logId, required this.photo});
  final String date;
  final String logId;
  final Attachment photo;
}

final memoryDailyPhotosProvider =
    StreamProvider.autoDispose<List<Attachment>>((ref) => ref
        .watch(databaseProvider)
        .attachmentsDao
        .watchByType(AttachmentEntity.dailyLog));

final memoryAllLogsProvider = StreamProvider.autoDispose<List<DailyLog>>(
    (ref) => ref.watch(databaseProvider).dailyLogsDao.watchAll());

/// Days that have a daily photo, newest first.
final memoryDaysProvider = Provider.autoDispose<AsyncValue<List<MemoryDay>>>(
    (ref) {
  final photos = ref.watch(memoryDailyPhotosProvider);
  final logs = ref.watch(memoryAllLogsProvider);
  if (photos.isLoading || logs.isLoading) return const AsyncValue.loading();
  final err = photos.asError ?? logs.asError;
  if (err != null) return AsyncValue.error(err.error, err.stackTrace);

  final dateById = {for (final l in logs.requireValue) l.id: l.date};
  final days = <MemoryDay>[];
  for (final a in photos.requireValue) {
    final date = dateById[a.entityId];
    if (date != null) {
      days.add(MemoryDay(date: date, logId: a.entityId, photo: a));
    }
  }
  days.sort((a, b) => b.date.compareTo(a.date));
  return AsyncValue.data(days);
});
