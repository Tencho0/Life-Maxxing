// A unified search result across modules (spec §24.2). Pure Dart.

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
    required this.title,
    required this.subtitle,
    this.date = '',
  });

  final SearchKind kind;

  /// Primary key of the matched record (for the [bucketItem] kind this is the
  /// bucket item's id even when the match came from its experience reflection).
  final String id;
  final String title;
  final String subtitle;

  /// yyyy-MM-dd when the record has one; empty otherwise.
  final String date;
}
