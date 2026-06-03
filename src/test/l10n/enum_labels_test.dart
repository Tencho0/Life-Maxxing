// Slice 10.3 — localized enum labels resolver. Display labels come from ARB
// (per locale); the stable `code` is unchanged (storage/search/export/backup).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lifemaxxing/core/l10n/enum_labels.dart';
import 'package:lifemaxxing/domain/enums.dart';
import 'package:lifemaxxing/l10n/app_localizations.dart';

void main() {
  Future<BuildContext> contextFor(WidgetTester tester, Locale locale) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (c) {
        ctx = c;
        return const SizedBox.shrink();
      }),
    ));
    return ctx;
  }

  testWidgets('localizedLabel resolves enum labels per locale', (tester) async {
    final bg = await contextFor(tester, const Locale('bg'));
    expect(localizedLabel(bg, MealType.breakfast), 'Закуска');
    expect(localizedLabel(bg, ActivityType.boxing), 'Бокс');
    expect(localizedLabel(bg, ActivityGroup.combat), 'Бойни спортове');
    expect(localizedLabel(bg, Intensity.high), 'Висока');
    expect(localizedLabel(bg, ExpenseCategory.car), 'Автомобил');
    expect(localizedLabel(bg, IncomeCategory.salary), 'Заплата');
    expect(localizedLabel(bg, PaymentMethod.cash), 'В брой');
    expect(localizedLabel(bg, HealthEventType.dentist), 'Зъболекар');
    expect(localizedLabel(bg, DentalSubtype.filling), 'Пломба');
    expect(localizedLabel(bg, MedType.supplement), 'Добавка');
    expect(localizedLabel(bg, MedStatus.taken), 'Прието');
    expect(localizedLabel(bg, BucketStatus.completed), 'Завършено');
    expect(localizedLabel(bg, Period.last30), 'Последните 30 дни');
    expect(periodChipLabel(bg, Period.last30), '30 дни');

    final en = await contextFor(tester, const Locale('en'));
    expect(localizedLabel(en, MealType.breakfast), 'Breakfast');
    expect(localizedLabel(en, ActivityType.boxing), 'Boxing');
    expect(localizedLabel(en, ActivityGroup.combat), 'Combat sports');
    expect(localizedLabel(en, Intensity.high), 'High');
    expect(localizedLabel(en, ExpenseCategory.car), 'Car');
    expect(localizedLabel(en, IncomeCategory.salary), 'Salary');
    expect(localizedLabel(en, PaymentMethod.cash), 'Cash');
    expect(localizedLabel(en, HealthEventType.dentist), 'Dentist');
    expect(localizedLabel(en, DentalSubtype.filling), 'Filling');
    expect(localizedLabel(en, MedType.supplement), 'Supplement');
    expect(localizedLabel(en, MedStatus.taken), 'Taken');
    expect(localizedLabel(en, BucketStatus.completed), 'Completed');
    expect(localizedLabel(en, Period.last30), 'Last 30 days');
    expect(periodChipLabel(en, Period.last30), '30 days');
  });

  test('enum codes are unchanged (storage/search/export stay stable)', () {
    expect(MealType.breakfast.code, 'breakfast');
    expect(ExpenseCategory.car.code, 'car');
    expect(MedStatus.taken.code, 'taken');
    expect(Period.last30.code, 'last30');
  });
}
