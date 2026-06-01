// Bottom-sheet infrastructure: showLmSheet wrapper (design Sheet chrome), the
// quick-log chooser, and the form-sheet registry. In Slice 5.1 the per-entity
// forms are placeholders; Phase 7 replaces openFormSheet's bodies with the
// real create/edit forms.

import 'package:flutter/material.dart';

import '../core/theme/tokens.dart';
import '../core/theme/typography.dart';
import '../core/icons/lm_icons.dart';
import '../presentation/activities/activity_forms.dart';
import '../presentation/finance/finance_forms.dart';
import '../presentation/food/food_forms.dart';
import '../presentation/steps/steps_forms.dart';

/// One quick-log action (spec §5.2). The first four are the mandatory ones.
class QuickAction {
  const QuickAction(this.id, this.label, this.icon, this.color);
  final String id;
  final String label;
  final LmIcons icon;
  final Color color;
}

const kQuickActions = [
  QuickAction('food', 'Храна', LmIcons.food, AppColors.amber),
  QuickAction('expense', 'Разход', LmIcons.expense, AppColors.red),
  QuickAction('bp', 'Кръвно', LmIcons.pulse, AppColors.pink),
  QuickAction('daily', 'Дневник', LmIcons.sun, AppColors.accent),
  QuickAction('activity', 'Активност', LmIcons.run, AppColors.green),
  QuickAction('steps', 'Крачки', LmIcons.steps, AppColors.purple),
  QuickAction('med', 'Добавка', LmIcons.pill, AppColors.accent),
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
    title: 'Бързо логване',
    subtitle: 'избери какво да добавиш',
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
    case 'expense':
      showExpenseSheet(context);
      return;
    case 'income':
      showIncomeSheet(context);
      return;
  }
  const titles = {
    'food': 'Ново хранене',
    'expense': 'Нов разход',
    'income': 'Нов приход',
    'bp': 'Кръвно и пулс',
    'daily': 'Дневен отчет',
    'activity': 'Нова активност',
    'steps': 'Крачки',
    'med': 'Медикамент / добавка',
    'bucket': 'Ново желание',
    'trip': 'Ново пътуване',
  };
  showLmSheet(
    context,
    title: titles[type] ?? 'Нов запис',
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Text('Формата „$type“ предстои (Phase 7).',
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
                  GestureDetector(
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

class _QuickGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              openFormSheet(context, q.id);
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
                    child: Text(q.label,
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
