import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bg'),
    Locale('en'),
  ];

  /// Application name shown in the OS task switcher.
  ///
  /// In en, this message translates to:
  /// **'LifeMaxxing'**
  String get appTitle;

  /// Generic save button label.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// Generic cancel button label.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Generic delete button label.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// Generic add button / semantics label.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// Back navigation semantics label.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// Close (e.g. sheet) semantics label.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// Settings section title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Label for the language picker row.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Language option: follow the system locale.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// Language option: Bulgarian (shown in its own name).
  ///
  /// In en, this message translates to:
  /// **'Български'**
  String get languageBulgarian;

  /// Language option: English (shown in its own name).
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Display label for a MealType, by stable code.
  ///
  /// In en, this message translates to:
  /// **'{code, select, breakfast{Breakfast} lunch{Lunch} dinner{Dinner} snack{Snack} other{Other}}'**
  String mealTypeLabel(String code);

  /// No description provided for @activityTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, gym{Gym} bjj{BJJ} boxing{Boxing} kickboxing{Kickboxing} mma{MMA} tennis{Tennis} hiking{Hiking} folk_dance{Folk dancing} cycling{Cycling} swimming{Swimming} ski{Skiing} other{Other}}'**
  String activityTypeLabel(String code);

  /// No description provided for @activityGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, strength{Strength training} combat{Combat sports} cardio{Cardio / movement} dance{Dance} other{Other}}'**
  String activityGroupLabel(String code);

  /// No description provided for @intensityLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, low{Low} medium{Medium} high{High} other{{code}}}'**
  String intensityLabel(String code);

  /// No description provided for @expenseCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, food{Food} entertainment{Entertainment} social{Social} transport{Transport} education{Education} subscriptions{Subscriptions} car{Car} clothing{Clothing & shoes} health_supplements{Health & supplements} sport{Sport} appearance{Appearance} vape{Vape} other{Other}}'**
  String expenseCategoryLabel(String code);

  /// No description provided for @incomeCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, salary{Salary} freelance{Freelance} bonus{Bonus} sale{Sale} gift{Gift} business{Business} other{Other}}'**
  String incomeCategoryLabel(String code);

  /// No description provided for @paymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, card{Card} cash{Cash} other{Other}}'**
  String paymentMethodLabel(String code);

  /// No description provided for @healthEventTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, dentist{Dentist} doctor{Doctor} procedure{Procedure} checkup{Check-up} physiotherapy{Physiotherapy} other{Other}}'**
  String healthEventTypeLabel(String code);

  /// No description provided for @dentalSubtypeLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, prophylaxis{Prophylaxis} cleaning{Cleaning} filling{Filling} root_canal{Root canal} whitening{Whitening} bonding{Bonding/veneers} orthodontics{Orthodontics} extraction{Extraction} other{Other}}'**
  String dentalSubtypeLabel(String code);

  /// No description provided for @medTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, medication{Medication} supplement{Supplement} vitamin{Vitamin} mineral{Mineral} sports_supplement{Sports supplement} other{Other}}'**
  String medTypeLabel(String code);

  /// No description provided for @medStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, taken{Taken} missed{Missed} other{{code}}}'**
  String medStatusLabel(String code);

  /// No description provided for @bucketPriorityLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, low{Low} medium{Medium} high{High} other{{code}}}'**
  String bucketPriorityLabel(String code);

  /// No description provided for @bucketStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, idea{Idea} planned{Planned} completed{Completed} abandoned{Abandoned} other{{code}}}'**
  String bucketStatusLabel(String code);

  /// No description provided for @periodLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, today{Today} last7{Last 7 days} last30{Last 30 days} this_month{This month} prev_month{Previous month} custom{Custom period} other{{code}}}'**
  String periodLabel(String code);

  /// No description provided for @periodChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, today{Today} last7{7 days} last30{30 days} this_month{Month} prev_month{Previous} custom{Custom} other{{code}}}'**
  String periodChipLabel(String code);

  /// No description provided for @financeTitle.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get financeTitle;

  /// No description provided for @financeRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get financeRecords;

  /// No description provided for @financeBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance for the period'**
  String get financeBalance;

  /// No description provided for @financeIncomeStat.
  ///
  /// In en, this message translates to:
  /// **'income'**
  String get financeIncomeStat;

  /// No description provided for @financeExpenseStat.
  ///
  /// In en, this message translates to:
  /// **'expenses'**
  String get financeExpenseStat;

  /// No description provided for @financeAvgPerDay.
  ///
  /// In en, this message translates to:
  /// **'avg. per day'**
  String get financeAvgPerDay;

  /// No description provided for @financeIncomeVsExpense.
  ///
  /// In en, this message translates to:
  /// **'Income vs expenses'**
  String get financeIncomeVsExpense;

  /// No description provided for @financeIncomeLegend.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get financeIncomeLegend;

  /// No description provided for @financeExpenseLegend.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get financeExpenseLegend;

  /// No description provided for @financeExpensesByCategory.
  ///
  /// In en, this message translates to:
  /// **'Expenses by category'**
  String get financeExpensesByCategory;

  /// No description provided for @financeTabExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get financeTabExpenses;

  /// No description provided for @financeTabIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get financeTabIncome;

  /// No description provided for @financeNoExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses for the period'**
  String get financeNoExpenses;

  /// No description provided for @financeAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get financeAddExpense;

  /// No description provided for @financeNoIncome.
  ///
  /// In en, this message translates to:
  /// **'No income for the period'**
  String get financeNoIncome;

  /// No description provided for @financeAddIncome.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get financeAddIncome;

  /// No description provided for @financeNewExpense.
  ///
  /// In en, this message translates to:
  /// **'New expense'**
  String get financeNewExpense;

  /// No description provided for @financeEditExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get financeEditExpense;

  /// No description provided for @financeExpenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'amount, category, description'**
  String get financeExpenseSubtitle;

  /// No description provided for @financeNewIncome.
  ///
  /// In en, this message translates to:
  /// **'New income'**
  String get financeNewIncome;

  /// No description provided for @financeEditIncome.
  ///
  /// In en, this message translates to:
  /// **'Edit income'**
  String get financeEditIncome;

  /// No description provided for @financeIncomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'amount and source are required'**
  String get financeIncomeSubtitle;

  /// No description provided for @financeNewRecord.
  ///
  /// In en, this message translates to:
  /// **'New record'**
  String get financeNewRecord;

  /// No description provided for @financeChooserSubtitle.
  ///
  /// In en, this message translates to:
  /// **'expense or income?'**
  String get financeChooserSubtitle;

  /// No description provided for @financeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get financeExpense;

  /// No description provided for @financeChooserExpenseSub.
  ///
  /// In en, this message translates to:
  /// **'money out'**
  String get financeChooserExpenseSub;

  /// No description provided for @financeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get financeIncome;

  /// No description provided for @financeChooserIncomeSub.
  ///
  /// In en, this message translates to:
  /// **'money in'**
  String get financeChooserIncomeSub;

  /// No description provided for @financeInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount (> 0)'**
  String get financeInvalidAmount;

  /// No description provided for @financeDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get financeDescriptionRequired;

  /// No description provided for @financeSourceRequired.
  ///
  /// In en, this message translates to:
  /// **'Source is required'**
  String get financeSourceRequired;

  /// No description provided for @financeSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get financeSaved;

  /// No description provided for @financeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get financeDeleted;

  /// No description provided for @financeAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get financeAmount;

  /// No description provided for @financeCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get financeCategory;

  /// No description provided for @financeDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get financeDescription;

  /// No description provided for @financeDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. OMV refuel'**
  String get financeDescriptionHint;

  /// No description provided for @financePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get financePaymentMethod;

  /// No description provided for @financeNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get financeNote;

  /// No description provided for @financeOptional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get financeOptional;

  /// No description provided for @financeSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get financeSource;

  /// No description provided for @financeSourceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Salary — Klevret'**
  String get financeSourceHint;

  /// No description provided for @financeDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get financeDate;

  /// No description provided for @foodTitle.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get foodTitle;

  /// No description provided for @foodEntries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get foodEntries;

  /// No description provided for @foodEmpty.
  ///
  /// In en, this message translates to:
  /// **'No meals for this period'**
  String get foodEmpty;

  /// No description provided for @foodAddMeal.
  ///
  /// In en, this message translates to:
  /// **'Add meal'**
  String get foodAddMeal;

  /// No description provided for @foodCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get foodCalories;

  /// No description provided for @foodProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get foodProtein;

  /// No description provided for @foodCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get foodCarbs;

  /// No description provided for @foodFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get foodFat;

  /// No description provided for @foodKcalPerDay.
  ///
  /// In en, this message translates to:
  /// **'kcal/day'**
  String get foodKcalPerDay;

  /// No description provided for @foodTotalKcal.
  ///
  /// In en, this message translates to:
  /// **'total kcal'**
  String get foodTotalKcal;

  /// No description provided for @foodMealCount.
  ///
  /// In en, this message translates to:
  /// **'meals'**
  String get foodMealCount;

  /// No description provided for @foodAvgProtein.
  ///
  /// In en, this message translates to:
  /// **'avg. protein'**
  String get foodAvgProtein;

  /// No description provided for @foodCaloriesByDay.
  ///
  /// In en, this message translates to:
  /// **'Calories by day'**
  String get foodCaloriesByDay;

  /// No description provided for @foodNewMeal.
  ///
  /// In en, this message translates to:
  /// **'New meal'**
  String get foodNewMeal;

  /// No description provided for @foodEditMeal.
  ///
  /// In en, this message translates to:
  /// **'Edit meal'**
  String get foodEditMeal;

  /// No description provided for @foodSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'date and name are required'**
  String get foodSheetSubtitle;

  /// No description provided for @foodNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get foodNameRequired;

  /// No description provided for @foodSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get foodSavedToast;

  /// No description provided for @foodDeletedToast.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get foodDeletedToast;

  /// No description provided for @foodMealType.
  ///
  /// In en, this message translates to:
  /// **'Meal type'**
  String get foodMealType;

  /// No description provided for @foodNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name / description'**
  String get foodNameLabel;

  /// No description provided for @foodNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Chicken with rice'**
  String get foodNameHint;

  /// No description provided for @foodTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get foodTime;

  /// No description provided for @foodCarbsShort.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get foodCarbsShort;

  /// No description provided for @foodGramsHint.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get foodGramsHint;

  /// No description provided for @foodQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get foodQuantity;

  /// No description provided for @foodQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1 bowl'**
  String get foodQuantityHint;

  /// No description provided for @foodNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get foodNote;

  /// No description provided for @foodNoteHint.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get foodNoteHint;

  /// No description provided for @foodPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get foodPhoto;

  /// No description provided for @foodDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get foodDate;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activityTitle;

  /// No description provided for @activityRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get activityRecords;

  /// No description provided for @activityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No activities for the period'**
  String get activityEmpty;

  /// No description provided for @activityAddAction.
  ///
  /// In en, this message translates to:
  /// **'Add activity'**
  String get activityAddAction;

  /// No description provided for @activityAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get activityAll;

  /// No description provided for @activitySummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get activitySummary;

  /// No description provided for @activityWorkouts.
  ///
  /// In en, this message translates to:
  /// **'workouts'**
  String get activityWorkouts;

  /// No description provided for @activityTotal.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get activityTotal;

  /// No description provided for @activityAvgTime.
  ///
  /// In en, this message translates to:
  /// **'avg. time'**
  String get activityAvgTime;

  /// No description provided for @activityMostFrequent.
  ///
  /// In en, this message translates to:
  /// **'Most frequent:'**
  String get activityMostFrequent;

  /// No description provided for @activityByGroup.
  ///
  /// In en, this message translates to:
  /// **'By group'**
  String get activityByGroup;

  /// No description provided for @activityNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New activity'**
  String get activityNewTitle;

  /// No description provided for @activityEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit activity'**
  String get activityEditTitle;

  /// No description provided for @activitySheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'date and type are required'**
  String get activitySheetSubtitle;

  /// No description provided for @activityDurationPositive.
  ///
  /// In en, this message translates to:
  /// **'Duration must be > 0'**
  String get activityDurationPositive;

  /// No description provided for @activitySaved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get activitySaved;

  /// No description provided for @activityDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get activityDeleted;

  /// No description provided for @activityFieldType.
  ///
  /// In en, this message translates to:
  /// **'Activity type'**
  String get activityFieldType;

  /// No description provided for @activityFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name / description'**
  String get activityFieldName;

  /// No description provided for @activityNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Back and biceps'**
  String get activityNameHint;

  /// No description provided for @activityFieldStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get activityFieldStart;

  /// No description provided for @activityFieldEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get activityFieldEnd;

  /// No description provided for @activityFieldMinutes.
  ///
  /// In en, this message translates to:
  /// **'Min.'**
  String get activityFieldMinutes;

  /// No description provided for @activityFieldIntensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get activityFieldIntensity;

  /// No description provided for @activityFieldQuality.
  ///
  /// In en, this message translates to:
  /// **'Productivity / quality'**
  String get activityFieldQuality;

  /// No description provided for @activityFieldMoodAfter.
  ///
  /// In en, this message translates to:
  /// **'Mood after'**
  String get activityFieldMoodAfter;

  /// No description provided for @activityFieldNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get activityFieldNote;

  /// No description provided for @activityNoteHint.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get activityNoteHint;

  /// No description provided for @activityFieldPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get activityFieldPhoto;

  /// No description provided for @activityFieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get activityFieldDate;

  /// No description provided for @stepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get stepsTitle;

  /// No description provided for @stepsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get stepsToday;

  /// No description provided for @stepsOfGoal.
  ///
  /// In en, this message translates to:
  /// **'of {goal}'**
  String stepsOfGoal(String goal);

  /// No description provided for @stepsStats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get stepsStats;

  /// No description provided for @stepsStatTotal.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get stepsStatTotal;

  /// No description provided for @stepsStatAvg.
  ///
  /// In en, this message translates to:
  /// **'average'**
  String get stepsStatAvg;

  /// No description provided for @stepsStatMax.
  ///
  /// In en, this message translates to:
  /// **'max.'**
  String get stepsStatMax;

  /// No description provided for @stepsStatDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get stepsStatDays;

  /// No description provided for @stepsByDay.
  ///
  /// In en, this message translates to:
  /// **'Steps by day'**
  String get stepsByDay;

  /// No description provided for @stepsDaysSection.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get stepsDaysSection;

  /// No description provided for @stepsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} steps'**
  String stepsCountLabel(String count);

  /// No description provided for @stepsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No steps for the period'**
  String get stepsEmpty;

  /// No description provided for @stepsAddAction.
  ///
  /// In en, this message translates to:
  /// **'Add steps'**
  String get stepsAddAction;

  /// No description provided for @stepsSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'one value per day'**
  String get stepsSheetSubtitle;

  /// No description provided for @stepsDateField.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get stepsDateField;

  /// No description provided for @stepsCountField.
  ///
  /// In en, this message translates to:
  /// **'Step count'**
  String get stepsCountField;

  /// No description provided for @stepsNoteField.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get stepsNoteField;

  /// No description provided for @stepsNoteHint.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get stepsNoteHint;

  /// No description provided for @stepsCountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid step count'**
  String get stepsCountRequired;

  /// No description provided for @stepsSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get stepsSavedToast;

  /// No description provided for @stepsDeletedToast.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get stepsDeletedToast;

  /// No description provided for @stepsProvFromDaily.
  ///
  /// In en, this message translates to:
  /// **'entered from Daily log'**
  String get stepsProvFromDaily;

  /// No description provided for @stepsProvFromSteps.
  ///
  /// In en, this message translates to:
  /// **'entered from Steps'**
  String get stepsProvFromSteps;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bg', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg':
      return AppLocalizationsBg();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
