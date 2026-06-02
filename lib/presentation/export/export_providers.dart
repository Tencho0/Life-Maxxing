// Export providers: the scope/format/period/module selectors drive an
// ExportRequest, which the ExportService turns into gathered ExportData and a
// rendered string (JSON or Markdown). Gather + render are async/pure; the share
// and clipboard side effects live in the screen (spec §25).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../../app/providers.dart';
import '../../domain/enums.dart';
import '../../domain/period.dart';
import '../../services/export_service.dart';

final exportScopeProvider =
    StateProvider<ExportScopeType>((_) => ExportScopeType.full);
final exportFormatProvider =
    StateProvider<ExportFormat>((_) => ExportFormat.markdown);
final exportPeriodProvider = StateProvider<Period>((_) => Period.last30);
final exportCustomRangeProvider = StateProvider<DateRange?>((_) => null);
final exportModuleProvider =
    StateProvider<ExportModule>((_) => ExportModule.food);

final exportServiceProvider =
    Provider<ExportService>((ref) => ExportService(ref.watch(databaseProvider)));

/// The request built from the current selectors. Period scope resolves its
/// window (custom falls back to last-30 if no range picked yet).
final exportRequestProvider = Provider<ExportRequest>((ref) {
  switch (ref.watch(exportScopeProvider)) {
    case ExportScopeType.full:
      return const ExportRequest(scope: ExportScopeType.full);
    case ExportScopeType.module:
      return ExportRequest(
          scope: ExportScopeType.module, module: ref.watch(exportModuleProvider));
    case ExportScopeType.period:
      final p = ref.watch(exportPeriodProvider);
      final range = p == Period.custom
          ? (ref.watch(exportCustomRangeProvider) ?? resolveRange(Period.last30))
          : resolveRange(p);
      return ExportRequest(scope: ExportScopeType.period, range: range);
  }
});

final exportDataProvider = FutureProvider.autoDispose<ExportData>((ref) {
  final svc = ref.watch(exportServiceProvider);
  return svc.gather(ref.watch(exportRequestProvider));
});

/// The rendered export string for the chosen format, tracking [exportDataProvider].
final exportTextProvider = Provider.autoDispose<AsyncValue<String>>((ref) {
  final svc = ref.watch(exportServiceProvider);
  final json = ref.watch(exportFormatProvider) == ExportFormat.json;
  return ref
      .watch(exportDataProvider)
      .whenData((d) => json ? svc.toJson(d) : svc.toMarkdown(d));
});
