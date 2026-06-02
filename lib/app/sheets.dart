// Bottom-sheet infrastructure: showLmSheet wrapper (design Sheet chrome), the
// quick-log chooser, and the form-sheet registry. In Slice 5.1 the per-entity
// forms are placeholders; Phase 7 replaces openFormSheet's bodies with the
// real create/edit forms.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/l10n_ext.dart';
import '../core/theme/tokens.dart';
import '../core/theme/typography.dart';
import '../core/icons/lm_icons.dart';
import '../presentation/activities/activity_forms.dart';
import '../presentation/daily/daily_forms.dart';
import '../presentation/daily/daily_providers.dart';
import '../presentation/finance/finance_forms.dart';
import '../presentation/food/food_forms.dart';
import '../presentation/health/health_forms.dart';
import '../presentation/steps/steps_forms.dart';
import '../presentation/steps/steps_providers.dart' show stepsDaoProvider;

/// One quick-log action (spec §5.2). The first four are the mandatory ones.
/// The label is resolved from localizations at build time via [label].
class QuickAction {
  const QuickAction(this.id, this.icon, this.color);
  final String id;
  final LmIcons icon;
  final Color color;

  /// Localized display label, resolved per [id].
  String label(BuildContext context) {
    final l10n = context.l10n;
    return switch (id) {
      'food' => l10n.quickActionFood,
      'expense' => l10n.quickActionExpense,
      'bp' => l10n.quickActionBloodPressure,
      'daily' => l10n.quickActionDaily,
      'activity' => l10n.quickActionActivity,
      'steps' => l10n.quickActionSteps,
      'med' => l10n.quickActionMedication,
      _ => id,
    };
  }
}

const kQuickActions = [
  QuickAction('food', LmIcons.food, AppColors.amber),
  QuickAction('expense', LmIcons.expense, AppColors.red),
  QuickAction('bp', LmIcons.pulse, AppColors.pink),
  QuickAction('daily', LmIcons.sun, AppColors.accent),
  QuickAction('activity', LmIcons.run, AppColors.green),
  QuickAction('steps', LmIcons.steps, AppColors.purple),
  QuickAction('med', LmIcons.pill, AppColors.accent),
];

/// Shows a styled bottom sheet (rounded top, drag handle, header with close,
/// scrollable body, optional pinned footer).
Future<T?> showLmSheet<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  required Widget child,
  Widget? footer,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bg2,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (ctx) =>
        _SheetShell(title: title, subtitle: subtitle, footer: footer, child: child),
  );
}

/// Opens the quick-log chooser (the center FAB).
void openQuickSheet(BuildContext context) {
  showLmSheet(
    context,
    title: context.l10n.quickSheetTitle,
    subtitle: context.l10n.quickSheetSubtitle,
    child: _QuickGrid(),
  );
}

/// Opens the create form for a given entity [type]. Real forms are wired as
/// their feature slices land; the rest stay placeholders.
void openFormSheet(BuildContext context, String type) {
  switch (type) {
    case 'food':
      showFoodSheet(context);
      return;
    case 'activity':
      showActivitySheet(context);
      return;
    case 'steps':
      showStepsSheet(context);
      return;
    case 'bp':
      showBpSheet(context);
      return;
    case 'med':
      showMedSheet(context);
      return;
    case 'expense':
      showExpenseSheet(context);
      return;
    case 'income':
      showIncomeSheet(context);
      return;
  }
  final l10n = context.l10n;
  final titles = {
    'food': l10n.sheetTitleFood,
    'expense': l10n.sheetTitleExpense,
    'income': l10n.sheetTitleIncome,
    'bp': l10n.sheetTitleBloodPressure,
    'daily': l10n.sheetTitleDaily,
    'activity': l10n.sheetTitleActivity,
    'steps': l10n.sheetTitleSteps,
    'med': l10n.sheetTitleMedication,
    'bucket': l10n.sheetTitleBucket,
    'trip': l10n.sheetTitleTrip,
  };
  showLmSheet(
    context,
    title: titles[type] ?? l10n.sheetTitleDefault,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Text(l10n.sheetFormPlaceholder(type),
          style: AppText.bodyDim, textAlign: TextAlign.center),
    ),
  );
}

class _SheetShell extends StatelessWidget {
  const _SheetShell({
    required this.title,
    this.subtitle,
    required this.child,
    this.footer,
  });
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final maxH = MediaQuery.sizeOf(context).height * 0.9;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // drag handle
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderHi,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppText.sheetTitle),
                        if (subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(subtitle!,
                                style: AppText.monoFaint.copyWith(fontSize: 11.5)),
                          ),
                      ],
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: context.l10n.actionClose,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const LmIcon(LmIcons.close,
                            size: 18, color: AppColors.textDim),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 2, 18, 16),
                child: child,
              ),
            ),
            if (footer != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                    18, 12, 18, 16 + MediaQuery.paddingOf(context).bottom),
                decoration: const BoxDecoration(
                  color: AppColors.bg2,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: footer,
              ),
          ],
        ),
      ),
    );
  }
}

/// Opens today's daily log, resolving the existing log + steps first so the
/// form reuses the right id (no duplicate) and shows steps locked when present.
Future<void> openDailyToday(BuildContext context, WidgetRef ref) async {
  final now = DateTime.now();
  final today = '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}';
  final log = await ref.read(dailyLogsDaoProvider).getByDate(today);
  final steps = await ref.read(stepsDaoProvider).getByDate(today);
  if (context.mounted) {
    showDailySheet(context, date: today, existing: log, existingSteps: steps);
  }
}

class _QuickGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.6,
      children: [
        for (final q in kQuickActions)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context).pop();
              if (q.id == 'daily') {
                openDailyToday(context, ref);
              } else {
                openFormSheet(context, q.id);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.white05,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: LmIcon(q.icon, size: 22, color: q.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(q.label(context),
                        style: AppText.bodyStrong, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
