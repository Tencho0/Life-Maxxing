// Bucket providers: the filtered list (by status), an all-items + experiences
// pair for reactive stats, and per-item detail + experience streams (spec §20).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../../app/providers.dart';
import '../../data/database.dart';
import '../../data/summaries.dart' show computeBucket;
import '../../domain/enums.dart';
import '../../domain/summaries.dart';

final bucketDaoProvider =
    Provider((ref) => ref.watch(databaseProvider).bucketDao);

/// Optional status filter for the list (null = all).
final bucketStatusFilterProvider = StateProvider<BucketStatus?>((_) => null);

/// The list, narrowed by the active status filter.
final bucketItemsProvider = StreamProvider.autoDispose<List<BucketItem>>((ref) =>
    ref.watch(bucketDaoProvider).watchItems(status: ref.watch(bucketStatusFilterProvider)));

/// All items (unfiltered) — feeds the stats.
final bucketAllItemsProvider = StreamProvider.autoDispose<List<BucketItem>>(
    (ref) => ref.watch(bucketDaoProvider).watchItems());

final bucketExperiencesProvider =
    StreamProvider.autoDispose<List<BucketExperience>>(
        (ref) => ref.watch(bucketDaoProvider).watchAllExperiences());

final bucketStatsProvider = Provider.autoDispose<AsyncValue<BucketStats>>((ref) {
  final items = ref.watch(bucketAllItemsProvider);
  final exps = ref.watch(bucketExperiencesProvider);
  if (items.isLoading || exps.isLoading) return const AsyncValue.loading();
  final err = items.asError ?? exps.asError;
  if (err != null) return AsyncValue.error(err.error, err.stackTrace);
  return AsyncValue.data(computeBucket(items.requireValue, exps.requireValue));
});

final bucketItemProvider =
    StreamProvider.autoDispose.family<BucketItem?, String>(
        (ref, id) => ref.watch(bucketDaoProvider).watchItem(id));

final bucketExperienceProvider =
    StreamProvider.autoDispose.family<BucketExperience?, String>(
        (ref, itemId) => ref.watch(bucketDaoProvider).watchExperienceForItem(itemId));

final bucketItemPhotosProvider =
    StreamProvider.autoDispose.family<List<Attachment>, String>((ref, itemId) =>
        ref
            .watch(databaseProvider)
            .attachmentsDao
            .watchForEntity(AttachmentEntity.bucketItem, itemId));

final bucketExperiencePhotosProvider =
    StreamProvider.autoDispose.family<List<Attachment>, String>((ref, expId) =>
        ref
            .watch(databaseProvider)
            .attachmentsDao
            .watchForEntity(AttachmentEntity.bucketExperience, expId));
