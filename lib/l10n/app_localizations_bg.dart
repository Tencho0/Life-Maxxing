// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appTitle => 'LifeMaxxing';

  @override
  String get actionSave => 'Запази';

  @override
  String get actionCancel => 'Отказ';

  @override
  String get actionDelete => 'Изтрий';

  @override
  String get actionAdd => 'Добави';

  @override
  String get actionBack => 'Назад';

  @override
  String get actionClose => 'Затвори';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguage => 'Език';

  @override
  String get languageSystem => 'Системен';

  @override
  String get languageBulgarian => 'Български';

  @override
  String get languageEnglish => 'English';

  @override
  String mealTypeLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'breakfast': 'Закуска',
      'lunch': 'Обяд',
      'dinner': 'Вечеря',
      'snack': 'Snack',
      'other': 'Друго',
    });
    return '$_temp0';
  }

  @override
  String activityTypeLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'gym': 'Фитнес',
      'bjj': 'BJJ',
      'boxing': 'Бокс',
      'kickboxing': 'Кикбокс',
      'mma': 'ММА',
      'tennis': 'Тенис',
      'hiking': 'Разходка в планината',
      'folk_dance': 'Народни танци',
      'cycling': 'Колоездене',
      'swimming': 'Плуване',
      'ski': 'Ски',
      'other': 'Друго',
    });
    return '$_temp0';
  }

  @override
  String activityGroupLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'strength': 'Силови тренировки',
      'combat': 'Бойни спортове',
      'cardio': 'Кардио / движение',
      'dance': 'Танци',
      'other': 'Друго',
    });
    return '$_temp0';
  }

  @override
  String intensityLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'low': 'Ниска',
      'medium': 'Средна',
      'high': 'Висока',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String expenseCategoryLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'food': 'Храна',
      'entertainment': 'Забавления',
      'social': 'Социални',
      'transport': 'Транспорт',
      'education': 'Образование',
      'subscriptions': 'Абонаменти',
      'car': 'Автомобил',
      'clothing': 'Дрехи и обувки',
      'health_supplements': 'Здраве и добавки',
      'sport': 'Спорт',
      'appearance': 'Външен вид',
      'vape': 'Вейп',
      'other': 'Друго',
    });
    return '$_temp0';
  }

  @override
  String incomeCategoryLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'salary': 'Заплата',
      'freelance': 'Freelance',
      'bonus': 'Бонус',
      'sale': 'Продажба',
      'gift': 'Подарък',
      'business': 'Бизнес',
      'other': 'Друго',
    });
    return '$_temp0';
  }

  @override
  String paymentMethodLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'card': 'Карта',
      'cash': 'В брой',
      'other': 'Друго',
    });
    return '$_temp0';
  }

  @override
  String healthEventTypeLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'dentist': 'Зъболекар',
      'doctor': 'Лекар',
      'procedure': 'Процедура',
      'checkup': 'Профилактичен преглед',
      'physiotherapy': 'Физиотерапия',
      'other': 'Друго',
    });
    return '$_temp0';
  }

  @override
  String dentalSubtypeLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'prophylaxis': 'Профилактика',
      'cleaning': 'Почистване',
      'filling': 'Пломба',
      'root_canal': 'Кореново лечение',
      'whitening': 'Избелване',
      'bonding': 'Бондинг/фасети',
      'orthodontics': 'Ортодонт',
      'extraction': 'Вадене',
      'other': 'Друго',
    });
    return '$_temp0';
  }

  @override
  String medTypeLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'medication': 'Медикамент',
      'supplement': 'Добавка',
      'vitamin': 'Витамин',
      'mineral': 'Минерал',
      'sports_supplement': 'Спортна добавка',
      'other': 'Друго',
    });
    return '$_temp0';
  }

  @override
  String medStatusLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'taken': 'Прието',
      'missed': 'Пропуснато',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String bucketPriorityLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'low': 'Low',
      'medium': 'Medium',
      'high': 'High',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String bucketStatusLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'idea': 'Идея',
      'planned': 'Планирано',
      'completed': 'Завършено',
      'abandoned': 'Изоставено',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String periodLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'today': 'Днес',
      'last7': 'Последните 7 дни',
      'last30': 'Последните 30 дни',
      'this_month': 'Текущ месец',
      'prev_month': 'Предишен месец',
      'custom': 'Custom период',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String periodChipLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'today': 'Днес',
      'last7': '7 дни',
      'last30': '30 дни',
      'this_month': 'Месец',
      'prev_month': 'Предишен',
      'custom': 'Custom',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get financeTitle => 'Финанси';

  @override
  String get financeRecords => 'Записи';

  @override
  String get financeBalance => 'Баланс за периода';

  @override
  String get financeIncomeStat => 'приходи';

  @override
  String get financeExpenseStat => 'разходи';

  @override
  String get financeAvgPerDay => 'ср. на ден';

  @override
  String get financeIncomeVsExpense => 'Приходи срещу разходи';

  @override
  String get financeIncomeLegend => 'Приход';

  @override
  String get financeExpenseLegend => 'Разход';

  @override
  String get financeExpensesByCategory => 'Разходи по категории';

  @override
  String get financeTabExpenses => 'Разходи';

  @override
  String get financeTabIncome => 'Приходи';

  @override
  String get financeNoExpenses => 'Няма разходи за периода';

  @override
  String get financeAddExpense => 'Добави разход';

  @override
  String get financeNoIncome => 'Няма приходи за периода';

  @override
  String get financeAddIncome => 'Добави приход';

  @override
  String get financeNewExpense => 'Нов разход';

  @override
  String get financeEditExpense => 'Редакция на разход';

  @override
  String get financeExpenseSubtitle => 'сума, категория, описание';

  @override
  String get financeNewIncome => 'Нов приход';

  @override
  String get financeEditIncome => 'Редакция на приход';

  @override
  String get financeIncomeSubtitle => 'сума и източник са задължителни';

  @override
  String get financeNewRecord => 'Нов запис';

  @override
  String get financeChooserSubtitle => 'разход или приход?';

  @override
  String get financeExpense => 'Разход';

  @override
  String get financeChooserExpenseSub => 'пари навън';

  @override
  String get financeIncome => 'Приход';

  @override
  String get financeChooserIncomeSub => 'пари навътре';

  @override
  String get financeInvalidAmount => 'Въведи валидна сума (> 0)';

  @override
  String get financeDescriptionRequired => 'Описанието е задължително';

  @override
  String get financeSourceRequired => 'Източникът е задължителен';

  @override
  String get financeSaved => 'Записано успешно';

  @override
  String get financeDeleted => 'Изтрито';

  @override
  String get financeAmount => 'Сума';

  @override
  String get financeCategory => 'Категория';

  @override
  String get financeDescription => 'Описание';

  @override
  String get financeDescriptionHint => 'напр. Зареждане OMV';

  @override
  String get financePaymentMethod => 'Начин на плащане';

  @override
  String get financeNote => 'Бележка';

  @override
  String get financeOptional => 'незадължително';

  @override
  String get financeSource => 'Източник';

  @override
  String get financeSourceHint => 'напр. Заплата — Klevret';

  @override
  String get financeDate => 'Дата';

  @override
  String get foodTitle => 'Храна';

  @override
  String get foodEntries => 'Записи';

  @override
  String get foodEmpty => 'Няма хранения за периода';

  @override
  String get foodAddMeal => 'Добави хранене';

  @override
  String get foodCalories => 'Калории';

  @override
  String get foodProtein => 'Протеин';

  @override
  String get foodCarbs => 'Въглехидрати';

  @override
  String get foodFat => 'Мазнини';

  @override
  String get foodKcalPerDay => 'kcal/ден';

  @override
  String get foodTotalKcal => 'общо kcal';

  @override
  String get foodMealCount => 'хранения';

  @override
  String get foodAvgProtein => 'ср. протеин';

  @override
  String get foodCaloriesByDay => 'Калории по дни';

  @override
  String get foodNewMeal => 'Ново хранене';

  @override
  String get foodEditMeal => 'Редакция на хранене';

  @override
  String get foodSheetSubtitle => 'дата и име са задължителни';

  @override
  String get foodNameRequired => 'Името е задължително';

  @override
  String get foodSavedToast => 'Записано успешно';

  @override
  String get foodDeletedToast => 'Изтрито';

  @override
  String get foodMealType => 'Тип хранене';

  @override
  String get foodNameLabel => 'Име / описание';

  @override
  String get foodNameHint => 'напр. Пилешко с ориз';

  @override
  String get foodTime => 'Час';

  @override
  String get foodCarbsShort => 'Въглехид.';

  @override
  String get foodGramsHint => 'г';

  @override
  String get foodQuantity => 'Количество';

  @override
  String get foodQuantityHint => 'напр. 1 купа';

  @override
  String get foodNote => 'Бележка';

  @override
  String get foodNoteHint => 'незадължително';

  @override
  String get foodPhoto => 'Снимка';

  @override
  String get foodDate => 'Дата';

  @override
  String get activityTitle => 'Активности';

  @override
  String get activityRecords => 'Записи';

  @override
  String get activityEmpty => 'Няма активности за периода';

  @override
  String get activityAddAction => 'Добави активност';

  @override
  String get activityAll => 'Всички';

  @override
  String get activitySummary => 'Обобщение';

  @override
  String get activityWorkouts => 'тренировки';

  @override
  String get activityTotal => 'общо';

  @override
  String get activityAvgTime => 'ср. време';

  @override
  String get activityMostFrequent => 'Най-често:';

  @override
  String get activityByGroup => 'По групи';

  @override
  String get activityNewTitle => 'Нова активност';

  @override
  String get activityEditTitle => 'Редакция на активност';

  @override
  String get activitySheetSubtitle => 'дата и тип са задължителни';

  @override
  String get activityDurationPositive => 'Времетраенето трябва да е > 0';

  @override
  String get activitySaved => 'Записано успешно';

  @override
  String get activityDeleted => 'Изтрито';

  @override
  String get activityFieldType => 'Тип активност';

  @override
  String get activityFieldName => 'Име / описание';

  @override
  String get activityNameHint => 'напр. Гръб и бицепс';

  @override
  String get activityFieldStart => 'Начало';

  @override
  String get activityFieldEnd => 'Край';

  @override
  String get activityFieldMinutes => 'Мин.';

  @override
  String get activityFieldIntensity => 'Интензивност';

  @override
  String get activityFieldQuality => 'Продуктивност / качество';

  @override
  String get activityFieldMoodAfter => 'Настроение след';

  @override
  String get activityFieldNote => 'Бележка';

  @override
  String get activityNoteHint => 'незадължително';

  @override
  String get activityFieldPhoto => 'Снимка';

  @override
  String get activityFieldDate => 'Дата';

  @override
  String get stepsTitle => 'Крачки';

  @override
  String get stepsToday => 'Днес';

  @override
  String stepsOfGoal(String goal) {
    return 'от $goal';
  }

  @override
  String get stepsStats => 'Статистика';

  @override
  String get stepsStatTotal => 'общо';

  @override
  String get stepsStatAvg => 'средно';

  @override
  String get stepsStatMax => 'макс.';

  @override
  String get stepsStatDays => 'дни';

  @override
  String get stepsByDay => 'Крачки по дни';

  @override
  String get stepsDaysSection => 'Дни';

  @override
  String stepsCountLabel(String count) {
    return '$count крачки';
  }

  @override
  String get stepsEmpty => 'Няма крачки за периода';

  @override
  String get stepsAddAction => 'Добави крачки';

  @override
  String get stepsSheetSubtitle => 'една стойност на ден';

  @override
  String get stepsDateField => 'Дата';

  @override
  String get stepsCountField => 'Брой крачки';

  @override
  String get stepsNoteField => 'Бележка';

  @override
  String get stepsNoteHint => 'незадължително';

  @override
  String get stepsCountRequired => 'Въведи валиден брой крачки';

  @override
  String get stepsSavedToast => 'Записано успешно';

  @override
  String get stepsDeletedToast => 'Изтрито';

  @override
  String get stepsProvFromDaily => 'въведено от Дневен отчет';

  @override
  String get stepsProvFromSteps => 'въведено от Крачки';
}
