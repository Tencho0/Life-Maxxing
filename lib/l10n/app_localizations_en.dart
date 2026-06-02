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

  @override
  String get healthTitle => 'Health';

  @override
  String get healthTabBp => 'Blood pressure';

  @override
  String get healthTabMeds => 'Supplements';

  @override
  String get healthTabEvents => 'Events';

  @override
  String get healthTabLabs => 'Lab tests';

  @override
  String get healthVitals => 'Vitals';

  @override
  String get healthLastBp => 'last blood pressure';

  @override
  String get healthPulse => 'Pulse';

  @override
  String get healthAvgBp => 'avg. blood pressure';

  @override
  String get healthAvgPulse => 'avg. pulse';

  @override
  String get healthPulseShort => 'pulse';

  @override
  String healthNextDental(String date) {
    return 'Next dentist: $date';
  }

  @override
  String get healthBpOverTime => 'Blood pressure over time';

  @override
  String get healthChartTooFewData => 'Too little data for a chart';

  @override
  String get healthSystolic => 'Systolic';

  @override
  String get healthDiastolic => 'Diastolic';

  @override
  String get healthBpEmpty => 'No measurements for the period';

  @override
  String get healthBpAdd => 'Add measurement';

  @override
  String get healthMedsEmpty => 'No supplements for the period';

  @override
  String get healthMedsAdd => 'Add supplement';

  @override
  String get healthEventsEmpty => 'No events';

  @override
  String get healthEventsAdd => 'Add event';

  @override
  String get healthLabsEmpty => 'No lab tests';

  @override
  String get healthLabsAdd => 'Add lab test';

  @override
  String get healthBpSheetTitle => 'Blood pressure & pulse';

  @override
  String get healthBpSheetEditTitle => 'Edit — blood pressure';

  @override
  String get healthBpSheetSubtitle =>
      'date, time and all three values are required';

  @override
  String get healthMedSheetTitle => 'Medication / supplement';

  @override
  String get healthMedSheetEditTitle => 'Edit — supplement';

  @override
  String get healthMedSheetSubtitle => 'name, type and status are required';

  @override
  String get healthEventSheetTitle => 'Health event';

  @override
  String get healthEventSheetEditTitle => 'Edit — event';

  @override
  String get healthEventSheetSubtitle => 'what was done is required';

  @override
  String get healthLabSheetTitle => 'Lab test';

  @override
  String get healthLabSheetEditTitle => 'Edit — lab test';

  @override
  String get healthLabSheetSubtitle => 'lab and reason are required';

  @override
  String get healthSysGtDia => 'Systolic must be greater than diastolic';

  @override
  String get healthInvalidValues => 'Enter valid values';

  @override
  String get healthTimeRequired => 'Time is required';

  @override
  String get healthNameRequired => 'Name is required';

  @override
  String get healthWhatDoneRequired =>
      'The \"what was done\" field is required';

  @override
  String get healthLabRequired => 'Lab and reason are required';

  @override
  String get healthSaved => 'Saved successfully';

  @override
  String get healthDeleted => 'Deleted';

  @override
  String get healthTime => 'Time';

  @override
  String get healthName => 'Name';

  @override
  String get healthType => 'Type';

  @override
  String get healthDose => 'Dose';

  @override
  String get healthStatus => 'Status';

  @override
  String get healthNote => 'Note';

  @override
  String get healthOptional => 'optional';

  @override
  String get healthBpNoteHint => 'e.g. morning, at rest';

  @override
  String get healthMedNameHint => 'e.g. Vitamin D3';

  @override
  String get healthDentalSubtype => 'Kind (dentist)';

  @override
  String get healthClinic => 'Clinic / doctor';

  @override
  String get healthClinicHint => 'e.g. Dr. Ivanova';

  @override
  String get healthReason => 'Reason';

  @override
  String get healthWhatDone => 'What was done';

  @override
  String get healthWhatDoneHint => 'e.g. Prophylactic cleaning';

  @override
  String get healthPrice => 'Price';

  @override
  String get healthNextRecommendedDate => 'Next recommended date';

  @override
  String get healthPhotos => 'Photos';

  @override
  String get healthLab => 'Lab';

  @override
  String get healthLabHint => 'e.g. Cibalab';

  @override
  String get healthLabReasonHint => 'e.g. Hormones';

  @override
  String get healthResults => 'Results';

  @override
  String get healthResultsHint => 'free text';

  @override
  String get healthDate => 'Date';

  @override
  String get dailyTitle => 'Daily report';

  @override
  String get dailyEmpty => 'No report for this day';

  @override
  String get dailyFill => 'Fill in the report';

  @override
  String get dailyMood => 'Mood';

  @override
  String get dailyProud => 'Are you proud of yourself?';

  @override
  String get dailyProudShort => 'Proud';

  @override
  String get dailyUncomfortable => 'Did you do 1 uncomfortable thing?';

  @override
  String get dailyUncomfortableShort => 'Uncomfortable thing';

  @override
  String get dailyUncomfortableWhat => 'What uncomfortable thing?';

  @override
  String dailyUncomfortableNote(String what) {
    return 'Uncomfortable: $what';
  }

  @override
  String get dailyWorkout => 'Workout?';

  @override
  String get dailyWorkoutShort => 'Workout';

  @override
  String get dailyAlcohol => 'Did you drink alcohol?';

  @override
  String get dailyAlcoholShort => 'Alcohol';

  @override
  String get dailyAlcoholWhat => 'What did you drink?';

  @override
  String get dailyAlcoholHint => 'e.g. 2 beers';

  @override
  String dailyAlcoholNote(String what) {
    return 'Alcohol: $what';
  }

  @override
  String get dailyOptional => 'optional';

  @override
  String get dailyScreenTime => 'Screen time';

  @override
  String get dailyMinutesUnit => 'min';

  @override
  String dailyMinutes(int count) {
    return '$count min';
  }

  @override
  String get dailySteps => 'Steps';

  @override
  String dailyStepsLocked(int count) {
    return '$count · locked';
  }

  @override
  String get dailyLocked => 'locked';

  @override
  String get dailyNotes => 'Notes';

  @override
  String get dailyNotesHint => 'how was the day?';

  @override
  String get dailyPhoto => 'Photo of the day';

  @override
  String get dailySaveReport => 'Save the report';

  @override
  String get dailySaved => 'Saved successfully';

  @override
  String get dailyMoodTrend => 'Trend (30 days)';

  @override
  String get dailyYes => 'Yes';

  @override
  String get dailyNo => 'No';

  @override
  String get bucketTitle => 'Bucket List';

  @override
  String get bucketAll => 'All';

  @override
  String bucketError(Object error) {
    return 'Error: $error';
  }

  @override
  String get bucketEmpty => 'No items in the list';

  @override
  String get bucketAddItem => 'Add item';

  @override
  String get bucketOverview => 'Overview';

  @override
  String get bucketStatTotal => 'total';

  @override
  String get bucketStatCompleted => 'completed';

  @override
  String get bucketStatPlanned => 'planned';

  @override
  String get bucketStatHigh => 'high prio.';

  @override
  String get bucketItemTitle => 'Item';

  @override
  String get bucketWhy => 'Why I want it';

  @override
  String get bucketComplete => 'Complete it';

  @override
  String get bucketEditExperience => 'Edit the experience';

  @override
  String get bucketDeleteItem => 'Delete item';

  @override
  String get bucketDeleteTitle => 'Delete';

  @override
  String get bucketDeleteConfirm => 'Delete the item and its experience?';

  @override
  String get bucketExperience => 'Experience';

  @override
  String get bucketFeeling => 'feeling';

  @override
  String get bucketWorthIt => 'worth it';

  @override
  String get bucketYes => 'Yes';

  @override
  String get bucketNo => 'No';

  @override
  String get bucketDate => 'date';

  @override
  String get bucketNewItem => 'New item';

  @override
  String get bucketEditItem => 'Edit item';

  @override
  String get bucketItemSubtitle => 'title, priority and status';

  @override
  String get bucketCompleteTitle => 'Complete the item';

  @override
  String get bucketCompleteSubtitle => 'log your experience';

  @override
  String get bucketSaved => 'Saved successfully';

  @override
  String get bucketTitleRequired => 'Title is required';

  @override
  String get bucketFieldTitle => 'Title';

  @override
  String get bucketTitleHint => 'e.g. Northern lights in Iceland';

  @override
  String get bucketWhyHint => 'the motivation behind the wish';

  @override
  String get bucketPriority => 'Priority';

  @override
  String get bucketStatus => 'Status';

  @override
  String get bucketPhotos => 'Photos';

  @override
  String get bucketFeelingPrompt => 'How do you feel?';

  @override
  String get bucketCompletedDate => 'Date of completion';

  @override
  String get bucketWorthItPrompt => 'Was it worth it?';

  @override
  String get bucketReflection => 'Note / reflection';

  @override
  String get bucketReflectionHint => 'How did you feel? Would you do it again?';

  @override
  String get bucketMarkCompleted => 'Mark as completed';

  @override
  String get tripTitle => 'Trips';

  @override
  String get tripDetailTitle => 'Trip';

  @override
  String get tripOverview => 'Overview';

  @override
  String get tripStatCount => 'trips';

  @override
  String get tripStatAvg => 'avg. rating';

  @override
  String get tripStatRepeat => 'would repeat';

  @override
  String tripError(String error) {
    return 'Error: $error';
  }

  @override
  String get tripFilterAll => 'All';

  @override
  String get tripFilterWouldRepeat => 'Would repeat';

  @override
  String get tripEmpty => 'No trips recorded';

  @override
  String get tripEmptyRepeat => 'No trips you would repeat';

  @override
  String get tripAddAction => 'Add trip';

  @override
  String get tripRatings => 'Ratings';

  @override
  String get tripOverall => 'Overall';

  @override
  String get tripFun => 'Fun';

  @override
  String get tripFood => 'Food';

  @override
  String get tripSights => 'Sights';

  @override
  String get tripValue => 'Value';

  @override
  String get tripWouldRepeat => 'Would repeat';

  @override
  String get tripWouldNotRepeat => 'Would not repeat';

  @override
  String get tripGallery => 'Gallery';

  @override
  String get tripDelete => 'Delete trip';

  @override
  String get tripDeleteTitle => 'Delete';

  @override
  String get tripDeleteConfirm => 'Delete the trip and its photos?';

  @override
  String get tripSheetNew => 'New trip';

  @override
  String get tripSheetEdit => 'Edit trip';

  @override
  String get tripSheetSubtitle => 'title, destination, period, rating';

  @override
  String get tripFieldTitle => 'Title';

  @override
  String get tripTitleHint => 'e.g. Weekend in Rome';

  @override
  String get tripDestination => 'Destination';

  @override
  String get tripDestinationHint => 'e.g. Rome, Italy';

  @override
  String get tripFromDate => 'From date';

  @override
  String get tripToDate => 'To date';

  @override
  String get tripOverallRating => 'Overall rating';

  @override
  String get tripWouldRepeatLabel => 'Would you repeat?';

  @override
  String get tripComment => 'Comment';

  @override
  String get tripCommentHint => 'how was it?';

  @override
  String get tripCover => 'Cover photo';

  @override
  String get tripAddCover => 'Add cover';

  @override
  String get tripRequiredError => 'Title and destination are required';

  @override
  String get tripDateOrderError => 'The end date must be after the start date';

  @override
  String get tripSavedToast => 'Saved successfully';

  @override
  String get tripDeletedToast => 'Deleted';

  @override
  String get statsTitle => 'Graphs';

  @override
  String get statsMood => 'Mood';

  @override
  String get statsIncomeVsExpense => 'Income vs expenses';

  @override
  String get statsSteps => 'Steps';

  @override
  String get statsBloodPressure => 'Blood pressure';

  @override
  String get statsNotEnoughData => 'Not enough data for the chart';

  @override
  String get memoryTitle => 'Memories';

  @override
  String get memoryTrips => 'Trips';

  @override
  String get memoryNoTrips => 'No trips';

  @override
  String get memoryVisualDiary => 'Visual diary';

  @override
  String get memoryEmptyDiary =>
      'No photos in the diary yet.\nAdd a photo to a daily log for it to appear here.';

  @override
  String get moreTitle => 'All modules';

  @override
  String get moreGroupLogging => 'Logging';

  @override
  String get moreGroupMoney => 'Money';

  @override
  String get moreGroupHealth => 'Health';

  @override
  String get moreGroupLife => 'Life';

  @override
  String get moreGroupData => 'Data';

  @override
  String get moreGroupDev => 'Dev';

  @override
  String get moreModuleFood => 'Food';

  @override
  String get moreModuleActivities => 'Activities';

  @override
  String get moreModuleSteps => 'Steps';

  @override
  String get moreModuleDaily => 'Daily log';

  @override
  String get moreModuleFinance => 'Finance';

  @override
  String get moreModuleHealth => 'Health';

  @override
  String get moreModuleBucket => 'Bucket List';

  @override
  String get moreModuleTrips => 'Trips';

  @override
  String get moreModuleSearch => 'Search';

  @override
  String get moreModuleExport => 'Export for AI';

  @override
  String get moreModuleBackup => 'Backup & Restore';

  @override
  String get moreDevDesignSystem => 'Dev: design system';

  @override
  String get backupTitle => 'Backup & Restore';

  @override
  String get backupSubtitle => 'Full backup (ZIP)';

  @override
  String get backupIncludesEyebrow => 'What\'s included';

  @override
  String get backupIncludeLogs => 'Food, activities, steps';

  @override
  String get backupIncludeMoney => 'Expenses and income';

  @override
  String get backupIncludeHealth =>
      'Blood pressure, pulse, medications, events, lab tests';

  @override
  String get backupIncludeDaily => 'Daily Quick Logs';

  @override
  String get backupIncludeBucket => 'Bucket List + experiences';

  @override
  String get backupIncludeTrips => 'Trips';

  @override
  String get backupIncludeAttachments => 'All photos and attachments';

  @override
  String get backupNoneThisSession =>
      'No backup has been created in this session yet.';

  @override
  String backupLast(String time) {
    return 'Last backup: $time';
  }

  @override
  String get backupPleaseWait => 'Please wait…';

  @override
  String get backupCreate => 'Create backup';

  @override
  String get backupRestoreEyebrow => 'Restore';

  @override
  String get backupRestoreHint =>
      'Pick a ZIP backup file. Restore replaces all current data — the operation is \"all or nothing\".';

  @override
  String get backupPickFile => 'Pick backup file';

  @override
  String get backupRestoreAction => 'Restore from backup';

  @override
  String backupFailed(String error) {
    return 'Backup failed: $error';
  }

  @override
  String get backupCannotRead => 'The file cannot be read';

  @override
  String backupPickError(String error) {
    return 'Error while picking: $error';
  }

  @override
  String get backupRestored => 'Data has been restored';

  @override
  String get backupRestoreFailed => 'Restore failed — your data is intact';

  @override
  String get backupReplaceTitle => 'Replace data';

  @override
  String get backupReplaceBody =>
      'The app already has data. Restore will replace the current data with the data from the backup file.';

  @override
  String get backupReplaceConfirm => 'Replace and restore';

  @override
  String get backupValid => 'Valid backup';

  @override
  String get backupInvalid => 'Invalid backup';

  @override
  String backupSummary(int records, int attachments) {
    return '$records records · $attachments photos';
  }

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search across all modules…';

  @override
  String get searchEmptyPrompt => 'Enter a word to search across all modules';

  @override
  String get searchNoResults => 'No results';

  @override
  String get quickSheetTitle => 'Quick log';

  @override
  String get quickSheetSubtitle => 'choose what to add';

  @override
  String get quickActionFood => 'Food';

  @override
  String get quickActionExpense => 'Expense';

  @override
  String get quickActionBloodPressure => 'Blood pressure';

  @override
  String get quickActionDaily => 'Journal';

  @override
  String get quickActionActivity => 'Activity';

  @override
  String get quickActionSteps => 'Steps';

  @override
  String get quickActionMedication => 'Supplement';

  @override
  String get sheetTitleFood => 'New meal';

  @override
  String get sheetTitleExpense => 'New expense';

  @override
  String get sheetTitleIncome => 'New income';

  @override
  String get sheetTitleBloodPressure => 'Blood pressure & pulse';

  @override
  String get sheetTitleDaily => 'Daily log';

  @override
  String get sheetTitleActivity => 'New activity';

  @override
  String get sheetTitleSteps => 'Steps';

  @override
  String get sheetTitleMedication => 'Medication / supplement';

  @override
  String get sheetTitleBucket => 'New wish';

  @override
  String get sheetTitleTrip => 'New trip';

  @override
  String get sheetTitleDefault => 'New record';

  @override
  String sheetFormPlaceholder(String type) {
    return 'The “$type” form is coming (Phase 7).';
  }

  @override
  String get exportTitle => 'Export for AI';

  @override
  String get exportSubtitle => 'JSON / Markdown for analysis';

  @override
  String get exportScope => 'Scope';

  @override
  String get exportScopeFull => 'Everything';

  @override
  String get exportScopePeriod => 'Period';

  @override
  String get exportScopeModule => 'Module';

  @override
  String get exportFormat => 'Format';

  @override
  String get exportPeriodLabel => 'Period';

  @override
  String get exportModule => 'Module';

  @override
  String get exportCountRecords => 'Records';

  @override
  String get exportCountPhotos => 'Photos';

  @override
  String get exportCountSize => 'Size';

  @override
  String get exportShare => 'Share';

  @override
  String get exportCopy => 'Copy';

  @override
  String get exportShareUnavailable => 'Sharing is not available';

  @override
  String get exportCopied => 'Copied to clipboard';

  @override
  String get exportPreparing => 'Preparing…';

  @override
  String get exportNoData => 'No data for this scope';

  @override
  String exportError(String error) {
    return 'Error: $error';
  }

  @override
  String exportModuleLabel(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'food': 'Food',
      'activities': 'Activities',
      'expenses': 'Expenses',
      'income': 'Income',
      'health_events': 'Health events',
      'lab_tests': 'Lab tests',
      'blood_pressure': 'Blood pressure & pulse',
      'medications': 'Medications & supplements',
      'daily_logs': 'Daily Quick Logs',
      'steps': 'Steps',
      'bucket_list': 'Bucket List',
      'trips': 'Trips',
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
  String get navHome => 'Home';

  @override
  String get navStats => 'Charts';

  @override
  String get navMemories => 'Memories';

  @override
  String get navMore => 'More';

  @override
  String get navQuickLog => 'Quick log';

  @override
  String get commonAddPhoto => 'Add photo';

  @override
  String get commonPhotoMultiHint => 'you can add several';

  @override
  String get commonLoadError => 'Something went wrong while loading';
}
