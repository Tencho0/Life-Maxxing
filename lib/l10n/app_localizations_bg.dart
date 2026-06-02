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

  @override
  String get healthTitle => 'Здраве';

  @override
  String get healthTabBp => 'Кръвно';

  @override
  String get healthTabMeds => 'Добавки';

  @override
  String get healthTabEvents => 'Събития';

  @override
  String get healthTabLabs => 'Изследвания';

  @override
  String get healthVitals => 'Витални';

  @override
  String get healthLastBp => 'последно кръвно';

  @override
  String get healthPulse => 'Пулс';

  @override
  String get healthAvgBp => 'ср. кръвно';

  @override
  String get healthAvgPulse => 'ср. пулс';

  @override
  String get healthPulseShort => 'пулс';

  @override
  String healthNextDental(String date) {
    return 'Следващ зъболекар: $date';
  }

  @override
  String get healthBpOverTime => 'Кръвно над времето';

  @override
  String get healthChartTooFewData => 'Малко данни за графика';

  @override
  String get healthSystolic => 'Систолно';

  @override
  String get healthDiastolic => 'Диастолно';

  @override
  String get healthBpEmpty => 'Няма измервания за периода';

  @override
  String get healthBpAdd => 'Добави измерване';

  @override
  String get healthMedsEmpty => 'Няма добавки за периода';

  @override
  String get healthMedsAdd => 'Добави добавка';

  @override
  String get healthEventsEmpty => 'Няма събития';

  @override
  String get healthEventsAdd => 'Добави събитие';

  @override
  String get healthLabsEmpty => 'Няма изследвания';

  @override
  String get healthLabsAdd => 'Добави изследване';

  @override
  String get healthBpSheetTitle => 'Кръвно и пулс';

  @override
  String get healthBpSheetEditTitle => 'Редакция — кръвно';

  @override
  String get healthBpSheetSubtitle =>
      'дата, час и трите стойности са задължителни';

  @override
  String get healthMedSheetTitle => 'Медикамент / добавка';

  @override
  String get healthMedSheetEditTitle => 'Редакция — добавка';

  @override
  String get healthMedSheetSubtitle => 'име, тип и статус са задължителни';

  @override
  String get healthEventSheetTitle => 'Здравно събитие';

  @override
  String get healthEventSheetEditTitle => 'Редакция — събитие';

  @override
  String get healthEventSheetSubtitle => 'какво е направено е задължително';

  @override
  String get healthLabSheetTitle => 'Изследване';

  @override
  String get healthLabSheetEditTitle => 'Редакция — изследване';

  @override
  String get healthLabSheetSubtitle => 'лаборатория и причина са задължителни';

  @override
  String get healthSysGtDia =>
      'Систоличното трябва да е по-голямо от диастоличното';

  @override
  String get healthInvalidValues => 'Въведи валидни стойности';

  @override
  String get healthTimeRequired => 'Часът е задължителен';

  @override
  String get healthNameRequired => 'Името е задължително';

  @override
  String get healthWhatDoneRequired =>
      'Полето „какво е направено“ е задължително';

  @override
  String get healthLabRequired => 'Лаборатория и причина са задължителни';

  @override
  String get healthSaved => 'Записано успешно';

  @override
  String get healthDeleted => 'Изтрито';

  @override
  String get healthTime => 'Час';

  @override
  String get healthName => 'Име';

  @override
  String get healthType => 'Тип';

  @override
  String get healthDose => 'Доза';

  @override
  String get healthStatus => 'Статус';

  @override
  String get healthNote => 'Бележка';

  @override
  String get healthOptional => 'незадължително';

  @override
  String get healthBpNoteHint => 'напр. сутрин, в покой';

  @override
  String get healthMedNameHint => 'напр. Витамин D3';

  @override
  String get healthDentalSubtype => 'Вид (зъболекар)';

  @override
  String get healthClinic => 'Клиника / лекар';

  @override
  String get healthClinicHint => 'напр. Д-р Иванова';

  @override
  String get healthReason => 'Причина';

  @override
  String get healthWhatDone => 'Какво е направено';

  @override
  String get healthWhatDoneHint => 'напр. Профилактично почистване';

  @override
  String get healthPrice => 'Цена';

  @override
  String get healthNextRecommendedDate => 'Следваща препоръчана дата';

  @override
  String get healthPhotos => 'Снимки';

  @override
  String get healthLab => 'Лаборатория';

  @override
  String get healthLabHint => 'напр. Цибалаб';

  @override
  String get healthLabReasonHint => 'напр. Хормони';

  @override
  String get healthResults => 'Резултати';

  @override
  String get healthResultsHint => 'свободен текст';

  @override
  String get healthDate => 'Дата';

  @override
  String get dailyTitle => 'Дневен отчет';

  @override
  String get dailyEmpty => 'Няма отчет за този ден';

  @override
  String get dailyFill => 'Попълни отчета';

  @override
  String get dailyMood => 'Настроение';

  @override
  String get dailyProud => 'Горд ли си от себе си?';

  @override
  String get dailyProudShort => 'Горд';

  @override
  String get dailyUncomfortable => 'Направи ли 1 неудобно нещо?';

  @override
  String get dailyUncomfortableShort => 'Неудобно нещо';

  @override
  String get dailyUncomfortableWhat => 'Какво неудобно нещо?';

  @override
  String dailyUncomfortableNote(String what) {
    return 'Неудобно: $what';
  }

  @override
  String get dailyWorkout => 'Тренировка?';

  @override
  String get dailyWorkoutShort => 'Тренировка';

  @override
  String get dailyAlcohol => 'Пил ли си алкохол?';

  @override
  String get dailyAlcoholShort => 'Алкохол';

  @override
  String get dailyAlcoholWhat => 'Какво пи?';

  @override
  String get dailyAlcoholHint => 'напр. 2 бири';

  @override
  String dailyAlcoholNote(String what) {
    return 'Алкохол: $what';
  }

  @override
  String get dailyOptional => 'незадължително';

  @override
  String get dailyScreenTime => 'Screen time';

  @override
  String get dailyMinutesUnit => 'мин';

  @override
  String dailyMinutes(int count) {
    return '$count мин';
  }

  @override
  String get dailySteps => 'Крачки';

  @override
  String dailyStepsLocked(int count) {
    return '$count · заключено';
  }

  @override
  String get dailyLocked => 'заключено';

  @override
  String get dailyNotes => 'Бележки';

  @override
  String get dailyNotesHint => 'как мина денят?';

  @override
  String get dailyPhoto => 'Снимка на деня';

  @override
  String get dailySaveReport => 'Запази отчета';

  @override
  String get dailySaved => 'Записано успешно';

  @override
  String get dailyMoodTrend => 'Тренд (30 дни)';

  @override
  String get dailyYes => 'Да';

  @override
  String get dailyNo => 'Не';

  @override
  String get bucketTitle => 'Bucket List';

  @override
  String get bucketAll => 'Всички';

  @override
  String bucketError(Object error) {
    return 'Грешка: $error';
  }

  @override
  String get bucketEmpty => 'Няма желания в списъка';

  @override
  String get bucketAddItem => 'Добави желание';

  @override
  String get bucketOverview => 'Преглед';

  @override
  String get bucketStatTotal => 'общо';

  @override
  String get bucketStatCompleted => 'завършени';

  @override
  String get bucketStatPlanned => 'планирани';

  @override
  String get bucketStatHigh => 'висок приор.';

  @override
  String get bucketItemTitle => 'Желание';

  @override
  String get bucketWhy => 'Защо го искам';

  @override
  String get bucketComplete => 'Завърши го';

  @override
  String get bucketEditExperience => 'Редактирай преживяването';

  @override
  String get bucketDeleteItem => 'Изтрий желанието';

  @override
  String get bucketDeleteTitle => 'Изтриване';

  @override
  String get bucketDeleteConfirm => 'Да изтрия желанието и преживяването му?';

  @override
  String get bucketExperience => 'Преживяване';

  @override
  String get bucketFeeling => 'усещане';

  @override
  String get bucketWorthIt => 'струваше ли си';

  @override
  String get bucketYes => 'Да';

  @override
  String get bucketNo => 'Не';

  @override
  String get bucketDate => 'дата';

  @override
  String get bucketNewItem => 'Ново желание';

  @override
  String get bucketEditItem => 'Редакция на желание';

  @override
  String get bucketItemSubtitle => 'заглавие, приоритет и статус';

  @override
  String get bucketCompleteTitle => 'Завърши желанието';

  @override
  String get bucketCompleteSubtitle => 'запиши преживяването си';

  @override
  String get bucketSaved => 'Записано успешно';

  @override
  String get bucketTitleRequired => 'Заглавието е задължително';

  @override
  String get bucketFieldTitle => 'Заглавие';

  @override
  String get bucketTitleHint => 'напр. Северно сияние в Исландия';

  @override
  String get bucketWhyHint => 'мотивацията зад желанието';

  @override
  String get bucketPriority => 'Приоритет';

  @override
  String get bucketStatus => 'Статус';

  @override
  String get bucketPhotos => 'Снимки';

  @override
  String get bucketFeelingPrompt => 'Как се чувстваш?';

  @override
  String get bucketCompletedDate => 'Дата на изпълнение';

  @override
  String get bucketWorthItPrompt => 'Струваше ли си?';

  @override
  String get bucketReflection => 'Бележка / рефлексия';

  @override
  String get bucketReflectionHint => 'Как се почувства? Би ли го направил пак?';

  @override
  String get bucketMarkCompleted => 'Маркирай като завършено';

  @override
  String get tripTitle => 'Пътувания';

  @override
  String get tripDetailTitle => 'Пътуване';

  @override
  String get tripOverview => 'Преглед';

  @override
  String get tripStatCount => 'пътувания';

  @override
  String get tripStatAvg => 'ср. оценка';

  @override
  String get tripStatRepeat => 'бих повторил';

  @override
  String tripError(String error) {
    return 'Грешка: $error';
  }

  @override
  String get tripFilterAll => 'Всички';

  @override
  String get tripFilterWouldRepeat => 'Бих повторил';

  @override
  String get tripEmpty => 'Няма записани пътувания';

  @override
  String get tripEmptyRepeat => 'Няма пътувания, които би повторил';

  @override
  String get tripAddAction => 'Добави пътуване';

  @override
  String get tripRatings => 'Оценки';

  @override
  String get tripOverall => 'Обща';

  @override
  String get tripFun => 'Забавление';

  @override
  String get tripFood => 'Храна';

  @override
  String get tripSights => 'Забележителности';

  @override
  String get tripValue => 'Стойност';

  @override
  String get tripWouldRepeat => 'Бих повторил';

  @override
  String get tripWouldNotRepeat => 'Не бих повторил';

  @override
  String get tripGallery => 'Галерия';

  @override
  String get tripDelete => 'Изтрий пътуването';

  @override
  String get tripDeleteTitle => 'Изтриване';

  @override
  String get tripDeleteConfirm => 'Да изтрия пътуването и снимките му?';

  @override
  String get tripSheetNew => 'Ново пътуване';

  @override
  String get tripSheetEdit => 'Редакция на пътуване';

  @override
  String get tripSheetSubtitle => 'заглавие, дестинация, период, оценка';

  @override
  String get tripFieldTitle => 'Заглавие';

  @override
  String get tripTitleHint => 'напр. Уикенд в Рим';

  @override
  String get tripDestination => 'Дестинация';

  @override
  String get tripDestinationHint => 'напр. Рим, Италия';

  @override
  String get tripFromDate => 'От дата';

  @override
  String get tripToDate => 'До дата';

  @override
  String get tripOverallRating => 'Обща оценка';

  @override
  String get tripWouldRepeatLabel => 'Би ли повторил?';

  @override
  String get tripComment => 'Коментар';

  @override
  String get tripCommentHint => 'как беше?';

  @override
  String get tripCover => 'Cover снимка';

  @override
  String get tripAddCover => 'Добави корица';

  @override
  String get tripRequiredError => 'Заглавие и дестинация са задължителни';

  @override
  String get tripDateOrderError => 'Крайната дата трябва да е след началната';

  @override
  String get tripSavedToast => 'Записано успешно';

  @override
  String get tripDeletedToast => 'Изтрито';

  @override
  String get statsTitle => 'Графики';

  @override
  String get statsMood => 'Настроение';

  @override
  String get statsIncomeVsExpense => 'Приходи срещу разходи';

  @override
  String get statsSteps => 'Крачки';

  @override
  String get statsBloodPressure => 'Кръвно';

  @override
  String get statsNotEnoughData => 'Малко данни за графика';

  @override
  String get memoryTitle => 'Спомени';

  @override
  String get memoryTrips => 'Пътувания';

  @override
  String get memoryNoTrips => 'Няма пътувания';

  @override
  String get memoryVisualDiary => 'Визуален дневник';

  @override
  String get memoryEmptyDiary =>
      'Все още няма снимки в дневника.\nДобави снимка към дневен отчет, за да се появи тук.';

  @override
  String get moreTitle => 'Всички модули';

  @override
  String get moreGroupLogging => 'Логване';

  @override
  String get moreGroupMoney => 'Пари';

  @override
  String get moreGroupHealth => 'Здраве';

  @override
  String get moreGroupLife => 'Живот';

  @override
  String get moreGroupData => 'Данни';

  @override
  String get moreGroupDev => 'Dev';

  @override
  String get moreModuleFood => 'Храна';

  @override
  String get moreModuleActivities => 'Активности';

  @override
  String get moreModuleSteps => 'Крачки';

  @override
  String get moreModuleDaily => 'Дневен отчет';

  @override
  String get moreModuleFinance => 'Финанси';

  @override
  String get moreModuleHealth => 'Здраве';

  @override
  String get moreModuleBucket => 'Bucket List';

  @override
  String get moreModuleTrips => 'Пътувания';

  @override
  String get moreModuleSearch => 'Търсене';

  @override
  String get moreModuleExport => 'Експорт за AI';

  @override
  String get moreModuleBackup => 'Backup & Restore';

  @override
  String get moreDevDesignSystem => 'Dev: дизайн система';

  @override
  String get backupTitle => 'Backup & Restore';

  @override
  String get backupSubtitle => 'Пълно архивиране (ZIP)';

  @override
  String get backupIncludesEyebrow => 'Какво се включва';

  @override
  String get backupIncludeLogs => 'Храна, активности, крачки';

  @override
  String get backupIncludeMoney => 'Разходи и приходи';

  @override
  String get backupIncludeHealth =>
      'Кръвно, пулс, медикаменти, събития, изследвания';

  @override
  String get backupIncludeDaily => 'Daily Quick Logs';

  @override
  String get backupIncludeBucket => 'Bucket List + преживявания';

  @override
  String get backupIncludeTrips => 'Пътувания';

  @override
  String get backupIncludeAttachments => 'Всички снимки и прикачени файлове';

  @override
  String get backupNoneThisSession =>
      'Все още няма създаден backup в тази сесия.';

  @override
  String backupLast(String time) {
    return 'Последен backup: $time';
  }

  @override
  String get backupPleaseWait => 'Моля изчакайте…';

  @override
  String get backupCreate => 'Създай backup';

  @override
  String get backupRestoreEyebrow => 'Възстановяване';

  @override
  String get backupRestoreHint =>
      'Избери ZIP backup файл. Restore заменя всички текущи данни — операцията е „всичко или нищо“.';

  @override
  String get backupPickFile => 'Избери backup файл';

  @override
  String get backupRestoreAction => 'Възстанови от backup';

  @override
  String backupFailed(String error) {
    return 'Backup-ът пропадна: $error';
  }

  @override
  String get backupCannotRead => 'Не може да се прочете файлът';

  @override
  String backupPickError(String error) {
    return 'Грешка при избор: $error';
  }

  @override
  String get backupRestored => 'Данните са възстановени';

  @override
  String get backupRestoreFailed => 'Restore пропадна — данните са непокътнати';

  @override
  String get backupReplaceTitle => 'Замяна на данните';

  @override
  String get backupReplaceBody =>
      'В приложението вече има данни. Restore ще замени текущите данни с тези от backup файла.';

  @override
  String get backupReplaceConfirm => 'Замени и възстанови';

  @override
  String get backupValid => 'Валиден backup';

  @override
  String get backupInvalid => 'Невалиден backup';

  @override
  String backupSummary(int records, int attachments) {
    return '$records записа · $attachments снимки';
  }

  @override
  String get searchTitle => 'Търсене';

  @override
  String get searchHint => 'Търси във всички модули…';

  @override
  String get searchEmptyPrompt => 'Въведи дума за търсене из всички модули';

  @override
  String get searchNoResults => 'Няма резултати';

  @override
  String get quickSheetTitle => 'Бързо логване';

  @override
  String get quickSheetSubtitle => 'избери какво да добавиш';

  @override
  String get quickActionFood => 'Храна';

  @override
  String get quickActionExpense => 'Разход';

  @override
  String get quickActionBloodPressure => 'Кръвно';

  @override
  String get quickActionDaily => 'Дневник';

  @override
  String get quickActionActivity => 'Активност';

  @override
  String get quickActionSteps => 'Крачки';

  @override
  String get quickActionMedication => 'Добавка';

  @override
  String get sheetTitleFood => 'Ново хранене';

  @override
  String get sheetTitleExpense => 'Нов разход';

  @override
  String get sheetTitleIncome => 'Нов приход';

  @override
  String get sheetTitleBloodPressure => 'Кръвно и пулс';

  @override
  String get sheetTitleDaily => 'Дневен отчет';

  @override
  String get sheetTitleActivity => 'Нова активност';

  @override
  String get sheetTitleSteps => 'Крачки';

  @override
  String get sheetTitleMedication => 'Медикамент / добавка';

  @override
  String get sheetTitleBucket => 'Ново желание';

  @override
  String get sheetTitleTrip => 'Ново пътуване';

  @override
  String get sheetTitleDefault => 'Нов запис';

  @override
  String sheetFormPlaceholder(String type) {
    return 'Формата „$type“ предстои (Phase 7).';
  }

  @override
  String get exportTitle => 'Експорт за AI';

  @override
  String get exportSubtitle => 'JSON / Markdown за анализ';

  @override
  String get exportScope => 'Обхват';

  @override
  String get exportScopeFull => 'Всичко';

  @override
  String get exportScopePeriod => 'Период';

  @override
  String get exportScopeModule => 'Модул';

  @override
  String get exportFormat => 'Формат';

  @override
  String get exportPeriodLabel => 'Период';

  @override
  String get exportModule => 'Модул';

  @override
  String get exportCountRecords => 'Записи';

  @override
  String get exportCountPhotos => 'Снимки';

  @override
  String get exportCountSize => 'Размер';

  @override
  String get exportShare => 'Сподели';

  @override
  String get exportCopy => 'Копирай';

  @override
  String get exportShareUnavailable => 'Споделянето не е налично';

  @override
  String get exportCopied => 'Копирано в клипборда';

  @override
  String get exportPreparing => 'Подготвяне…';

  @override
  String get exportNoData => 'Няма данни за този обхват';

  @override
  String exportError(String error) {
    return 'Грешка: $error';
  }

  @override
  String exportModuleLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'food': 'Храна',
      'activities': 'Активности',
      'expenses': 'Разходи',
      'income': 'Приходи',
      'health_events': 'Здравни събития',
      'lab_tests': 'Изследвания',
      'blood_pressure': 'Кръвно и пулс',
      'medications': 'Медикаменти и добавки',
      'daily_logs': 'Daily Quick Logs',
      'steps': 'Крачки',
      'bucket_list': 'Bucket List',
      'trips': 'Пътувания',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String exportFormatLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'json': 'JSON',
      'markdown': 'Markdown',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String get navHome => 'Начало';

  @override
  String get navStats => 'Графики';

  @override
  String get navMemories => 'Спомени';

  @override
  String get navMore => 'Още';

  @override
  String get navQuickLog => 'Бързо логване';

  @override
  String get commonAddPhoto => 'Добави снимка';

  @override
  String get commonPhotoMultiHint => 'може няколко';

  @override
  String get commonLoadError => 'Нещо се обърка при зареждането';

  @override
  String get homeGreetMorning => 'Добро утро';

  @override
  String get homeGreetDay => 'Добър ден';

  @override
  String get homeGreetEvening => 'Добър вечер';

  @override
  String get homeQuickEyebrow => 'Логни за 2 докосвания';

  @override
  String get homeAddPlus => 'добави +';

  @override
  String get homeThisWeek => 'Тази седмица';

  @override
  String get homeRailMood => 'Настроение';

  @override
  String get homeRailSteps => 'Крачки';

  @override
  String get homeRailExpense => 'Разход';

  @override
  String get homeRailPulse => 'Пулс';

  @override
  String get homeAvgUnit => 'ср.';

  @override
  String get homeTimelineSection => 'Дневен поток · днес';

  @override
  String get homeTimelineEmpty => 'Все още няма записи днес';

  @override
  String get homeFinishTitle => 'Завърши дневния отчет';

  @override
  String get homeFinishSub => 'Настроение, тренировка, screen time…';

  @override
  String get homeBpFallback => 'Кръвно';

  @override
  String homePulse(int n) {
    return 'пулс $n';
  }

  @override
  String homeMedsTaken(int count) {
    return 'Добавки · $count приети';
  }

  @override
  String get exportMdTitle => 'LifeMaxxing — Експорт за AI';

  @override
  String get exportMdPeriodLabel => 'Период:';

  @override
  String get exportMdSummary => 'Общо резюме';

  @override
  String get exportMdPeriodAll => 'Всички данни';

  @override
  String exportMdPeriodModule(String module) {
    return 'Модул: $module';
  }

  @override
  String get exportMdSectionDaily => 'Дневни отчети';

  @override
  String get exportMdSectionFood => 'Храна';

  @override
  String get exportMdSectionActivities => 'Активности';

  @override
  String get exportMdSectionSteps => 'Крачки';

  @override
  String get exportMdSectionMoney => 'Пари';

  @override
  String get exportMdSectionHealthEvents => 'Здравни събития';

  @override
  String get exportMdSectionLabTests => 'Изследвания';

  @override
  String get exportMdSectionBloodPressure => 'Кръвно и пулс';

  @override
  String get exportMdSectionMedications => 'Медикаменти и добавки';

  @override
  String get exportMdSectionBucketList => 'Bucket List';

  @override
  String get exportMdSectionBucketExperiences =>
      'Bucket List completed experiences';

  @override
  String get exportMdSectionTrips => 'Пътувания';

  @override
  String exportMdStepsLine(String date, int count) {
    return '$date: $count крачки';
  }

  @override
  String exportMdIncomeLine(
    String date,
    num amount,
    String category,
    String source,
  ) {
    return '$date: +$amount € ($category) — $source';
  }

  @override
  String exportMdExpenseLine(
    String date,
    num amount,
    String category,
    String description,
  ) {
    return '$date: −$amount € ($category) — $description';
  }

  @override
  String exportMdLabLine(String date, String lab, String reason) {
    return '$date: $lab — $reason';
  }

  @override
  String exportMdBloodPressureLine(
    String date,
    String time,
    int systolic,
    int diastolic,
    int pulse,
  ) {
    return '$date $time: $systolic/$diastolic, пулс $pulse';
  }

  @override
  String exportMdMedicationLine(
    String date,
    String time,
    String name,
    String type,
    String status,
  ) {
    return '$date $time: $name ($type) — $status';
  }

  @override
  String exportMdBucketExperienceLine(String date, int rating, String worth) {
    return '$date: оценка $rating/10, $worth';
  }

  @override
  String get exportMdWorthIt => 'струваше си';

  @override
  String get exportMdNotWorthIt => 'не си струваше';

  @override
  String exportMdTripLine(
    String fromDate,
    String toDate,
    String title,
    String destination,
    int overall,
  ) {
    return '$fromDate–$toDate: $title, $destination (обща оценка $overall/10)';
  }

  @override
  String exportMdSummaryFinance(
    Object income,
    Object expenses,
    Object balance,
  ) {
    return 'Приходи: $income €, разходи: $expenses €, баланс: $balance €';
  }

  @override
  String exportMdSummaryHealth(
    Object systolic,
    Object diastolic,
    Object pulse,
    Object count,
  ) {
    return 'Кръвно (средно): $systolic/$diastolic, пулс $pulse ($count измервания)';
  }

  @override
  String exportMdSummaryBucket(Object completed, Object rating) {
    return 'Bucket List: $completed завършени, средно усещане $rating/10';
  }

  @override
  String exportMdDailyMood(int mood) {
    return 'настроение $mood/10';
  }

  @override
  String get exportMdDailyWorkout => 'тренировка';

  @override
  String get exportMdDailyAlcohol => 'алкохол';

  @override
  String exportMdMealCalories(int calories) {
    return ' — $calories kcal';
  }

  @override
  String exportMdActivityDuration(int minutes) {
    return ' — $minutes мин';
  }

  @override
  String exportMdEventNext(String date) {
    return ' (следващ: $date)';
  }

  @override
  String exportMdBucketLine(String title, String status, String priority) {
    return '$title ($status, приоритет $priority)';
  }

  @override
  String get commonYes => 'Да';

  @override
  String get commonNo => 'Не';

  @override
  String get commonRemove => 'Премахни';

  @override
  String get commonAddPhotos => 'Добави снимки';

  @override
  String get moodPickerPrompt => 'как се чувстваш днес?';

  @override
  String get moodPickerLow => '1 · много лошо';

  @override
  String get moodPickerHigh => '10 · страхотно';

  @override
  String get moodVeryBad => 'много лошо';

  @override
  String get moodBad => 'лошо';

  @override
  String get moodMid => 'средно';

  @override
  String get moodGood => 'добре';

  @override
  String get moodVeryGood => 'много добре';

  @override
  String get moodGreat => 'страхотно';

  @override
  String get unitGrams => 'г';

  @override
  String get unitMin => 'м';

  @override
  String get unitHour => 'ч';

  @override
  String get unitThousands => 'к';
}
