// Search providers: the live query and the Cyrillic-safe results across modules
// (delegates to SearchDao; spec §24.2).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../../app/providers.dart';
import '../../domain/search_hit.dart';

final searchQueryProvider = StateProvider<String>((_) => '');

final searchResultsProvider =
    FutureProvider.autoDispose<List<SearchHit>>((ref) {
  final q = ref.watch(searchQueryProvider);
  if (q.trim().isEmpty) return Future.value(const []);
  return ref.watch(databaseProvider).searchDao.search(q);
});
