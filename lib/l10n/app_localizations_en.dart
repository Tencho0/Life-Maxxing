// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LifeMaxxing';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionBack => 'Back';

  @override
  String get actionClose => 'Close';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageBulgarian => 'Български';

  @override
  String get languageEnglish => 'English';

  @override
  String mealTypeLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'breakfast': 'Breakfast',
      'lunch': 'Lunch',
      'dinner': 'Dinner',
      'snack': 'Snack',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String activityTypeLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'gym': 'Gym',
      'bjj': 'BJJ',
      'boxing': 'Boxing',
      'kickboxing': 'Kickboxing',
      'mma': 'MMA',
      'tennis': 'Tennis',
      'hiking': 'Hiking',
      'folk_dance': 'Folk dancing',
      'cycling': 'Cycling',
      'swimming': 'Swimming',
      'ski': 'Skiing',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String activityGroupLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'strength': 'Strength training',
      'combat': 'Combat sports',
      'cardio': 'Cardio / movement',
      'dance': 'Dance',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String intensityLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'low': 'Low',
      'medium': 'Medium',
      'high': 'High',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String expenseCategoryLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'food': 'Food',
      'entertainment': 'Entertainment',
      'social': 'Social',
      'transport': 'Transport',
      'education': 'Education',
      'subscriptions': 'Subscriptions',
      'car': 'Car',
      'clothing': 'Clothing & shoes',
      'health_supplements': 'Health & supplements',
      'sport': 'Sport',
      'appearance': 'Appearance',
      'vape': 'Vape',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String incomeCategoryLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'salary': 'Salary',
      'freelance': 'Freelance',
      'bonus': 'Bonus',
      'sale': 'Sale',
      'gift': 'Gift',
      'business': 'Business',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String paymentMethodLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'card': 'Card',
      'cash': 'Cash',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String healthEventTypeLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'dentist': 'Dentist',
      'doctor': 'Doctor',
      'procedure': 'Procedure',
      'checkup': 'Check-up',
      'physiotherapy': 'Physiotherapy',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String dentalSubtypeLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'prophylaxis': 'Prophylaxis',
      'cleaning': 'Cleaning',
      'filling': 'Filling',
      'root_canal': 'Root canal',
      'whitening': 'Whitening',
      'bonding': 'Bonding/veneers',
      'orthodontics': 'Orthodontics',
      'extraction': 'Extraction',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String medTypeLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'medication': 'Medication',
      'supplement': 'Supplement',
      'vitamin': 'Vitamin',
      'mineral': 'Mineral',
      'sports_supplement': 'Sports supplement',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String medStatusLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'taken': 'Taken',
      'missed': 'Missed',
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
      'idea': 'Idea',
      'planned': 'Planned',
      'completed': 'Completed',
      'abandoned': 'Abandoned',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String periodLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'today': 'Today',
      'last7': 'Last 7 days',
      'last30': 'Last 30 days',
      'this_month': 'This month',
      'prev_month': 'Previous month',
      'custom': 'Custom period',
      'other': '$code',
    });
    return '$_temp0';
  }

  @override
  String periodChipLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'today': 'Today',
      'last7': '7 days',
      'last30': '30 days',
      'this_month': 'Month',
      'prev_month': 'Previous',
      'custom': 'Custom',
      'other': '$code',
    });
    return '$_temp0';
  }
}
