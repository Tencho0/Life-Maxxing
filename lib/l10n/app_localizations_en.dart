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

  @override
  String get financeTitle => 'Finance';

  @override
  String get financeRecords => 'Records';

  @override
  String get financeBalance => 'Balance for the period';

  @override
  String get financeIncomeStat => 'income';

  @override
  String get financeExpenseStat => 'expenses';

  @override
  String get financeAvgPerDay => 'avg. per day';

  @override
  String get financeIncomeVsExpense => 'Income vs expenses';

  @override
  String get financeIncomeLegend => 'Income';

  @override
  String get financeExpenseLegend => 'Expense';

  @override
  String get financeExpensesByCategory => 'Expenses by category';

  @override
  String get financeTabExpenses => 'Expenses';

  @override
  String get financeTabIncome => 'Income';

  @override
  String get financeNoExpenses => 'No expenses for the period';

  @override
  String get financeAddExpense => 'Add expense';

  @override
  String get financeNoIncome => 'No income for the period';

  @override
  String get financeAddIncome => 'Add income';

  @override
  String get financeNewExpense => 'New expense';

  @override
  String get financeEditExpense => 'Edit expense';

  @override
  String get financeExpenseSubtitle => 'amount, category, description';

  @override
  String get financeNewIncome => 'New income';

  @override
  String get financeEditIncome => 'Edit income';

  @override
  String get financeIncomeSubtitle => 'amount and source are required';

  @override
  String get financeNewRecord => 'New record';

  @override
  String get financeChooserSubtitle => 'expense or income?';

  @override
  String get financeExpense => 'Expense';

  @override
  String get financeChooserExpenseSub => 'money out';

  @override
  String get financeIncome => 'Income';

  @override
  String get financeChooserIncomeSub => 'money in';

  @override
  String get financeInvalidAmount => 'Enter a valid amount (> 0)';

  @override
  String get financeDescriptionRequired => 'Description is required';

  @override
  String get financeSourceRequired => 'Source is required';

  @override
  String get financeSaved => 'Saved successfully';

  @override
  String get financeDeleted => 'Deleted';

  @override
  String get financeAmount => 'Amount';

  @override
  String get financeCategory => 'Category';

  @override
  String get financeDescription => 'Description';

  @override
  String get financeDescriptionHint => 'e.g. OMV refuel';

  @override
  String get financePaymentMethod => 'Payment method';

  @override
  String get financeNote => 'Note';

  @override
  String get financeOptional => 'optional';

  @override
  String get financeSource => 'Source';

  @override
  String get financeSourceHint => 'e.g. Salary — Klevret';

  @override
  String get financeDate => 'Date';

  @override
  String get foodTitle => 'Food';

  @override
  String get foodEntries => 'Entries';

  @override
  String get foodEmpty => 'No meals for this period';

  @override
  String get foodAddMeal => 'Add meal';

  @override
  String get foodCalories => 'Calories';

  @override
  String get foodProtein => 'Protein';

  @override
  String get foodCarbs => 'Carbs';

  @override
  String get foodFat => 'Fat';

  @override
  String get foodKcalPerDay => 'kcal/day';

  @override
  String get foodTotalKcal => 'total kcal';

  @override
  String get foodMealCount => 'meals';

  @override
  String get foodAvgProtein => 'avg. protein';

  @override
  String get foodCaloriesByDay => 'Calories by day';

  @override
  String get foodNewMeal => 'New meal';

  @override
  String get foodEditMeal => 'Edit meal';

  @override
  String get foodSheetSubtitle => 'date and name are required';

  @override
  String get foodNameRequired => 'Name is required';

  @override
  String get foodSavedToast => 'Saved successfully';

  @override
  String get foodDeletedToast => 'Deleted';

  @override
  String get foodMealType => 'Meal type';

  @override
  String get foodNameLabel => 'Name / description';

  @override
  String get foodNameHint => 'e.g. Chicken with rice';

  @override
  String get foodTime => 'Time';

  @override
  String get foodCarbsShort => 'Carbs';

  @override
  String get foodGramsHint => 'g';

  @override
  String get foodQuantity => 'Quantity';

  @override
  String get foodQuantityHint => 'e.g. 1 bowl';

  @override
  String get foodNote => 'Note';

  @override
  String get foodNoteHint => 'optional';

  @override
  String get foodPhoto => 'Photo';

  @override
  String get foodDate => 'Date';

  @override
  String get activityTitle => 'Activities';

  @override
  String get activityRecords => 'Records';

  @override
  String get activityEmpty => 'No activities for the period';

  @override
  String get activityAddAction => 'Add activity';

  @override
  String get activityAll => 'All';

  @override
  String get activitySummary => 'Summary';

  @override
  String get activityWorkouts => 'workouts';

  @override
  String get activityTotal => 'total';

  @override
  String get activityAvgTime => 'avg. time';

  @override
  String get activityMostFrequent => 'Most frequent:';

  @override
  String get activityByGroup => 'By group';

  @override
  String get activityNewTitle => 'New activity';

  @override
  String get activityEditTitle => 'Edit activity';

  @override
  String get activitySheetSubtitle => 'date and type are required';

  @override
  String get activityDurationPositive => 'Duration must be > 0';

  @override
  String get activitySaved => 'Saved successfully';

  @override
  String get activityDeleted => 'Deleted';

  @override
  String get activityFieldType => 'Activity type';

  @override
  String get activityFieldName => 'Name / description';

  @override
  String get activityNameHint => 'e.g. Back and biceps';

  @override
  String get activityFieldStart => 'Start';

  @override
  String get activityFieldEnd => 'End';

  @override
  String get activityFieldMinutes => 'Min.';

  @override
  String get activityFieldIntensity => 'Intensity';

  @override
  String get activityFieldQuality => 'Productivity / quality';

  @override
  String get activityFieldMoodAfter => 'Mood after';

  @override
  String get activityFieldNote => 'Note';

  @override
  String get activityNoteHint => 'optional';

  @override
  String get activityFieldPhoto => 'Photo';

  @override
  String get activityFieldDate => 'Date';

  @override
  String get stepsTitle => 'Steps';

  @override
  String get stepsToday => 'Today';

  @override
  String stepsOfGoal(String goal) {
    return 'of $goal';
  }

  @override
  String get stepsStats => 'Statistics';

  @override
  String get stepsStatTotal => 'total';

  @override
  String get stepsStatAvg => 'average';

  @override
  String get stepsStatMax => 'max.';

  @override
  String get stepsStatDays => 'days';

  @override
  String get stepsByDay => 'Steps by day';

  @override
  String get stepsDaysSection => 'Days';

  @override
  String stepsCountLabel(String count) {
    return '$count steps';
  }

  @override
  String get stepsEmpty => 'No steps for the period';

  @override
  String get stepsAddAction => 'Add steps';

  @override
  String get stepsSheetSubtitle => 'one value per day';

  @override
  String get stepsDateField => 'Date';

  @override
  String get stepsCountField => 'Step count';

  @override
  String get stepsNoteField => 'Note';

  @override
  String get stepsNoteHint => 'optional';

  @override
  String get stepsCountRequired => 'Enter a valid step count';

  @override
  String get stepsSavedToast => 'Saved successfully';

  @override
  String get stepsDeletedToast => 'Deleted';

  @override
  String get stepsProvFromDaily => 'entered from Daily log';

  @override
  String get stepsProvFromSteps => 'entered from Steps';
}
