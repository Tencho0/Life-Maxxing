// Trip providers: the list (optional would-repeat filter), all-trips stats,
// per-trip detail + photos. Period filtering is deferred (stats span all trips,
// per the §3.4 note).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../data/summaries.dart' show computeTrips;
import '../../domain/enums.dart';
import '../../domain/summaries.dart';

final tripsDaoProvider = Provider((ref) => ref.watch(databaseProvider).tripsDao);

/// Show only trips the user would repeat.
final tripRepeatOnlyProvider = StateProvider<bool>((_) => false);

final tripsProvider = StreamProvider.autoDispose<List<Trip>>((ref) {
  final repeatOnly = ref.watch(tripRepeatOnlyProvider);
  return ref
      .watch(tripsDaoProvider)
      .watchAll(wouldRepeat: repeatOnly ? true : null);
});

/// All trips (unfiltered) — feeds the stats.
final tripsAllProvider =
    StreamProvider.autoDispose<List<Trip>>((ref) => ref.watch(tripsDaoProvider).watchAll());

final tripStatsProvider = Provider.autoDispose<AsyncValue<TripStats>>(
    (ref) => ref.watch(tripsAllProvider).whenData(computeTrips));

final tripProvider = StreamProvider.autoDispose
    .family<Trip?, String>((ref, id) => ref.watch(tripsDaoProvider).watchById(id));

final tripPhotosProvider = StreamProvider.autoDispose
    .family<List<Attachment>, String>((ref, id) => ref
        .watch(databaseProvider)
        .attachmentsDao
        .watchForEntity(AttachmentEntity.trip, id));

/// The cover photo for a trip (role=cover), or null — for list cards.
final tripCoverProvider =
    StreamProvider.autoDispose.family<Attachment?, String>((ref, id) => ref
        .watch(databaseProvider)
        .attachmentsDao
        .watchForEntity(AttachmentEntity.trip, id)
        .map((l) {
      final covers = l.where((a) => a.role == AttachmentRole.cover);
      return covers.isEmpty ? null : covers.first;
    }));
