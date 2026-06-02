// A unified search result across modules (spec §24.2). Pure Dart.

import 'enums.dart';

/// Which module a [SearchHit] points at (drives navigation + icon).
enum SearchKind {
  meal,
  activity,
  expense,
  income,
  healthEvent,
  labTest,
  bloodPressure,
  medication,
  dailyLog,
  bucketItem,
  trip,
}

/// One row in a global search result list.
class SearchHit {
  SearchHit({
    required this.kind,
    required this.id,
    this.title = '',
    this.subtitle = '',
    this.titleEnum,
    this.subtitleEnum,
    this.date = '',
  });

  final SearchKind kind;

  /// Primary key of the matched record (for the [bucketItem] kind this is the
  /// bucket item's id even when the match came from its experience reflection).
  final String id;

  /// Plain (data) title/subtitle text. When a `*Enum` is set, the presentation
  /// layer shows its localized label instead (the DAO has no BuildContext, so
  /// enum labels are resolved at display time — see search_screen.dart).
  final String title;
  final String subtitle;
  final Coded? titleEnum;
  final Coded? subtitleEnum;

  /// yyyy-MM-dd when the record has one; empty otherwise.
  final String date;
}
