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
}
