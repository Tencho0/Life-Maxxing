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

  /// Label for the editable user-name row in Settings (used in the home greeting).
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get settingsName;

  /// Settings section eyebrow above the clear-all-data row.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsDataSection;

  /// Settings row that wipes all logged data (name + language are kept).
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get settingsClearData;

  /// Title of the destructive clear-all-data confirm dialog.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get settingsClearDataTitle;

  /// Body of the clear-all-data confirm dialog.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes all records and photos. Your name and language are kept.'**
  String get settingsClearDataBody;

  /// Red confirm button in the clear-all-data dialog.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get settingsClearDataConfirm;

  /// Toast shown after all data has been cleared.
  ///
  /// In en, this message translates to:
  /// **'Data cleared'**
  String get settingsClearDataDone;

  /// First-launch welcome screen heading.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcomeTitle;

  /// First-launch prompt asking for the user's name.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get welcomePrompt;

  /// Placeholder text in the first-launch name input.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get welcomeNameHint;

  /// Button that confirms the entered name and enters the app.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get welcomeContinue;

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
  /// **'e.g. Salary'**
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

  /// No description provided for @healthTitle.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get healthTitle;

  /// No description provided for @healthTabBp.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure'**
  String get healthTabBp;

  /// No description provided for @healthTabMeds.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get healthTabMeds;

  /// No description provided for @healthTabEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get healthTabEvents;

  /// No description provided for @healthTabLabs.
  ///
  /// In en, this message translates to:
  /// **'Lab tests'**
  String get healthTabLabs;

  /// No description provided for @healthVitals.
  ///
  /// In en, this message translates to:
  /// **'Vitals'**
  String get healthVitals;

  /// No description provided for @healthLastBp.
  ///
  /// In en, this message translates to:
  /// **'last blood pressure'**
  String get healthLastBp;

  /// No description provided for @healthPulse.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get healthPulse;

  /// No description provided for @healthAvgBp.
  ///
  /// In en, this message translates to:
  /// **'avg. blood pressure'**
  String get healthAvgBp;

  /// No description provided for @healthAvgPulse.
  ///
  /// In en, this message translates to:
  /// **'avg. pulse'**
  String get healthAvgPulse;

  /// No description provided for @healthPulseShort.
  ///
  /// In en, this message translates to:
  /// **'pulse'**
  String get healthPulseShort;

  /// No description provided for @healthNextDental.
  ///
  /// In en, this message translates to:
  /// **'Next dentist: {date}'**
  String healthNextDental(String date);

  /// No description provided for @healthBpOverTime.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure over time'**
  String get healthBpOverTime;

  /// No description provided for @healthChartTooFewData.
  ///
  /// In en, this message translates to:
  /// **'Too little data for a chart'**
  String get healthChartTooFewData;

  /// No description provided for @healthSystolic.
  ///
  /// In en, this message translates to:
  /// **'Systolic'**
  String get healthSystolic;

  /// No description provided for @healthDiastolic.
  ///
  /// In en, this message translates to:
  /// **'Diastolic'**
  String get healthDiastolic;

  /// No description provided for @healthBpEmpty.
  ///
  /// In en, this message translates to:
  /// **'No measurements for the period'**
  String get healthBpEmpty;

  /// No description provided for @healthBpAdd.
  ///
  /// In en, this message translates to:
  /// **'Add measurement'**
  String get healthBpAdd;

  /// No description provided for @healthMedsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No supplements for the period'**
  String get healthMedsEmpty;

  /// No description provided for @healthMedsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add supplement'**
  String get healthMedsAdd;

  /// No description provided for @healthEventsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events'**
  String get healthEventsEmpty;

  /// No description provided for @healthEventsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add event'**
  String get healthEventsAdd;

  /// No description provided for @healthLabsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No lab tests'**
  String get healthLabsEmpty;

  /// No description provided for @healthLabsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add lab test'**
  String get healthLabsAdd;

  /// No description provided for @healthBpSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure & pulse'**
  String get healthBpSheetTitle;

  /// No description provided for @healthBpSheetEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit — blood pressure'**
  String get healthBpSheetEditTitle;

  /// No description provided for @healthBpSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'date, time and all three values are required'**
  String get healthBpSheetSubtitle;

  /// No description provided for @healthMedSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Medication / supplement'**
  String get healthMedSheetTitle;

  /// No description provided for @healthMedSheetEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit — supplement'**
  String get healthMedSheetEditTitle;

  /// No description provided for @healthMedSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'name, type and status are required'**
  String get healthMedSheetSubtitle;

  /// No description provided for @healthEventSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Health event'**
  String get healthEventSheetTitle;

  /// No description provided for @healthEventSheetEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit — event'**
  String get healthEventSheetEditTitle;

  /// No description provided for @healthEventSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'what was done is required'**
  String get healthEventSheetSubtitle;

  /// No description provided for @healthLabSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Lab test'**
  String get healthLabSheetTitle;

  /// No description provided for @healthLabSheetEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit — lab test'**
  String get healthLabSheetEditTitle;

  /// No description provided for @healthLabSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'lab and reason are required'**
  String get healthLabSheetSubtitle;

  /// No description provided for @healthSysGtDia.
  ///
  /// In en, this message translates to:
  /// **'Systolic must be greater than diastolic'**
  String get healthSysGtDia;

  /// No description provided for @healthInvalidValues.
  ///
  /// In en, this message translates to:
  /// **'Enter valid values'**
  String get healthInvalidValues;

  /// No description provided for @healthTimeRequired.
  ///
  /// In en, this message translates to:
  /// **'Time is required'**
  String get healthTimeRequired;

  /// No description provided for @healthNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get healthNameRequired;

  /// No description provided for @healthWhatDoneRequired.
  ///
  /// In en, this message translates to:
  /// **'The \"what was done\" field is required'**
  String get healthWhatDoneRequired;

  /// No description provided for @healthLabRequired.
  ///
  /// In en, this message translates to:
  /// **'Lab and reason are required'**
  String get healthLabRequired;

  /// No description provided for @healthSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get healthSaved;

  /// No description provided for @healthDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get healthDeleted;

  /// No description provided for @healthTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get healthTime;

  /// No description provided for @healthName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get healthName;

  /// No description provided for @healthType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get healthType;

  /// No description provided for @healthDose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get healthDose;

  /// No description provided for @healthStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get healthStatus;

  /// No description provided for @healthNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get healthNote;

  /// No description provided for @healthOptional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get healthOptional;

  /// No description provided for @healthBpNoteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. morning, at rest'**
  String get healthBpNoteHint;

  /// No description provided for @healthMedNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Vitamin D3'**
  String get healthMedNameHint;

  /// No description provided for @healthDentalSubtype.
  ///
  /// In en, this message translates to:
  /// **'Kind (dentist)'**
  String get healthDentalSubtype;

  /// No description provided for @healthClinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic / doctor'**
  String get healthClinic;

  /// No description provided for @healthClinicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Dr. Ivanova'**
  String get healthClinicHint;

  /// No description provided for @healthReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get healthReason;

  /// No description provided for @healthWhatDone.
  ///
  /// In en, this message translates to:
  /// **'What was done'**
  String get healthWhatDone;

  /// No description provided for @healthWhatDoneHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Prophylactic cleaning'**
  String get healthWhatDoneHint;

  /// No description provided for @healthPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get healthPrice;

  /// No description provided for @healthNextRecommendedDate.
  ///
  /// In en, this message translates to:
  /// **'Next recommended date'**
  String get healthNextRecommendedDate;

  /// No description provided for @healthPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get healthPhotos;

  /// No description provided for @healthLab.
  ///
  /// In en, this message translates to:
  /// **'Lab'**
  String get healthLab;

  /// No description provided for @healthLabHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cibalab'**
  String get healthLabHint;

  /// No description provided for @healthLabReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hormones'**
  String get healthLabReasonHint;

  /// No description provided for @healthResults.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get healthResults;

  /// No description provided for @healthResultsHint.
  ///
  /// In en, this message translates to:
  /// **'free text'**
  String get healthResultsHint;

  /// No description provided for @healthDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get healthDate;

  /// No description provided for @dailyTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily report'**
  String get dailyTitle;

  /// No description provided for @dailyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No report for this day'**
  String get dailyEmpty;

  /// No description provided for @dailyFill.
  ///
  /// In en, this message translates to:
  /// **'Fill in the report'**
  String get dailyFill;

  /// No description provided for @dailyMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get dailyMood;

  /// No description provided for @dailyProud.
  ///
  /// In en, this message translates to:
  /// **'Are you proud of yourself?'**
  String get dailyProud;

  /// No description provided for @dailyProudShort.
  ///
  /// In en, this message translates to:
  /// **'Proud'**
  String get dailyProudShort;

  /// No description provided for @dailyUncomfortable.
  ///
  /// In en, this message translates to:
  /// **'Did you do 1 uncomfortable thing?'**
  String get dailyUncomfortable;

  /// No description provided for @dailyUncomfortableShort.
  ///
  /// In en, this message translates to:
  /// **'Uncomfortable thing'**
  String get dailyUncomfortableShort;

  /// No description provided for @dailyUncomfortableWhat.
  ///
  /// In en, this message translates to:
  /// **'What uncomfortable thing?'**
  String get dailyUncomfortableWhat;

  /// No description provided for @dailyUncomfortableNote.
  ///
  /// In en, this message translates to:
  /// **'Uncomfortable: {what}'**
  String dailyUncomfortableNote(String what);

  /// No description provided for @dailyWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout?'**
  String get dailyWorkout;

  /// No description provided for @dailyWorkoutShort.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get dailyWorkoutShort;

  /// No description provided for @dailyAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Did you drink alcohol?'**
  String get dailyAlcohol;

  /// No description provided for @dailyAlcoholShort.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get dailyAlcoholShort;

  /// No description provided for @dailyAlcoholWhat.
  ///
  /// In en, this message translates to:
  /// **'What did you drink?'**
  String get dailyAlcoholWhat;

  /// No description provided for @dailyAlcoholHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 2 beers'**
  String get dailyAlcoholHint;

  /// No description provided for @dailyAlcoholNote.
  ///
  /// In en, this message translates to:
  /// **'Alcohol: {what}'**
  String dailyAlcoholNote(String what);

  /// No description provided for @dailyOptional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get dailyOptional;

  /// No description provided for @dailyScreenTime.
  ///
  /// In en, this message translates to:
  /// **'Screen time'**
  String get dailyScreenTime;

  /// No description provided for @dailyMinutesUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get dailyMinutesUnit;

  /// No description provided for @dailyMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String dailyMinutes(int count);

  /// No description provided for @dailySteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get dailySteps;

  /// No description provided for @dailyStepsLocked.
  ///
  /// In en, this message translates to:
  /// **'{count} · locked'**
  String dailyStepsLocked(int count);

  /// No description provided for @dailyLocked.
  ///
  /// In en, this message translates to:
  /// **'locked'**
  String get dailyLocked;

  /// No description provided for @dailyNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get dailyNotes;

  /// No description provided for @dailyNotesHint.
  ///
  /// In en, this message translates to:
  /// **'how was the day?'**
  String get dailyNotesHint;

  /// No description provided for @dailyPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo of the day'**
  String get dailyPhoto;

  /// No description provided for @dailySaveReport.
  ///
  /// In en, this message translates to:
  /// **'Save the report'**
  String get dailySaveReport;

  /// No description provided for @dailySaved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get dailySaved;

  /// No description provided for @dailyMoodTrend.
  ///
  /// In en, this message translates to:
  /// **'Trend (30 days)'**
  String get dailyMoodTrend;

  /// No description provided for @dailyYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get dailyYes;

  /// No description provided for @dailyNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get dailyNo;

  /// No description provided for @bucketTitle.
  ///
  /// In en, this message translates to:
  /// **'Bucket List'**
  String get bucketTitle;

  /// No description provided for @bucketAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bucketAll;

  /// No description provided for @bucketError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String bucketError(Object error);

  /// No description provided for @bucketEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items in the list'**
  String get bucketEmpty;

  /// No description provided for @bucketAddItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get bucketAddItem;

  /// No description provided for @bucketOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get bucketOverview;

  /// No description provided for @bucketStatTotal.
  ///
  /// In en, this message translates to:
  /// **'total'**
  String get bucketStatTotal;

  /// No description provided for @bucketStatCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get bucketStatCompleted;

  /// No description provided for @bucketStatPlanned.
  ///
  /// In en, this message translates to:
  /// **'planned'**
  String get bucketStatPlanned;

  /// No description provided for @bucketStatHigh.
  ///
  /// In en, this message translates to:
  /// **'high prio.'**
  String get bucketStatHigh;

  /// No description provided for @bucketItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get bucketItemTitle;

  /// No description provided for @bucketWhy.
  ///
  /// In en, this message translates to:
  /// **'Why I want it'**
  String get bucketWhy;

  /// No description provided for @bucketComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete it'**
  String get bucketComplete;

  /// No description provided for @bucketEditExperience.
  ///
  /// In en, this message translates to:
  /// **'Edit the experience'**
  String get bucketEditExperience;

  /// No description provided for @bucketDeleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete item'**
  String get bucketDeleteItem;

  /// No description provided for @bucketDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get bucketDeleteTitle;

  /// No description provided for @bucketDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete the item and its experience?'**
  String get bucketDeleteConfirm;

  /// No description provided for @bucketExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get bucketExperience;

  /// No description provided for @bucketFeeling.
  ///
  /// In en, this message translates to:
  /// **'feeling'**
  String get bucketFeeling;

  /// No description provided for @bucketWorthIt.
  ///
  /// In en, this message translates to:
  /// **'worth it'**
  String get bucketWorthIt;

  /// No description provided for @bucketYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get bucketYes;

  /// No description provided for @bucketNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get bucketNo;

  /// No description provided for @bucketDate.
  ///
  /// In en, this message translates to:
  /// **'date'**
  String get bucketDate;

  /// No description provided for @bucketNewItem.
  ///
  /// In en, this message translates to:
  /// **'New item'**
  String get bucketNewItem;

  /// No description provided for @bucketEditItem.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get bucketEditItem;

  /// No description provided for @bucketItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'title, priority and status'**
  String get bucketItemSubtitle;

  /// No description provided for @bucketCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete the item'**
  String get bucketCompleteTitle;

  /// No description provided for @bucketCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'log your experience'**
  String get bucketCompleteSubtitle;

  /// No description provided for @bucketSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get bucketSaved;

  /// No description provided for @bucketTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get bucketTitleRequired;

  /// No description provided for @bucketFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get bucketFieldTitle;

  /// No description provided for @bucketTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Northern lights in Iceland'**
  String get bucketTitleHint;

  /// No description provided for @bucketWhyHint.
  ///
  /// In en, this message translates to:
  /// **'the motivation behind the wish'**
  String get bucketWhyHint;

  /// No description provided for @bucketPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get bucketPriority;

  /// No description provided for @bucketStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get bucketStatus;

  /// No description provided for @bucketPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get bucketPhotos;

  /// No description provided for @bucketFeelingPrompt.
  ///
  /// In en, this message translates to:
  /// **'How do you feel?'**
  String get bucketFeelingPrompt;

  /// No description provided for @bucketCompletedDate.
  ///
  /// In en, this message translates to:
  /// **'Date of completion'**
  String get bucketCompletedDate;

  /// No description provided for @bucketWorthItPrompt.
  ///
  /// In en, this message translates to:
  /// **'Was it worth it?'**
  String get bucketWorthItPrompt;

  /// No description provided for @bucketReflection.
  ///
  /// In en, this message translates to:
  /// **'Note / reflection'**
  String get bucketReflection;

  /// No description provided for @bucketReflectionHint.
  ///
  /// In en, this message translates to:
  /// **'How did you feel? Would you do it again?'**
  String get bucketReflectionHint;

  /// No description provided for @bucketMarkCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get bucketMarkCompleted;

  /// No description provided for @tripTitle.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get tripTitle;

  /// No description provided for @tripDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get tripDetailTitle;

  /// No description provided for @tripOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get tripOverview;

  /// No description provided for @tripStatCount.
  ///
  /// In en, this message translates to:
  /// **'trips'**
  String get tripStatCount;

  /// No description provided for @tripStatAvg.
  ///
  /// In en, this message translates to:
  /// **'avg. rating'**
  String get tripStatAvg;

  /// No description provided for @tripStatRepeat.
  ///
  /// In en, this message translates to:
  /// **'would repeat'**
  String get tripStatRepeat;

  /// No description provided for @tripError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String tripError(String error);

  /// No description provided for @tripFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tripFilterAll;

  /// No description provided for @tripFilterWouldRepeat.
  ///
  /// In en, this message translates to:
  /// **'Would repeat'**
  String get tripFilterWouldRepeat;

  /// No description provided for @tripEmpty.
  ///
  /// In en, this message translates to:
  /// **'No trips recorded'**
  String get tripEmpty;

  /// No description provided for @tripEmptyRepeat.
  ///
  /// In en, this message translates to:
  /// **'No trips you would repeat'**
  String get tripEmptyRepeat;

  /// No description provided for @tripAddAction.
  ///
  /// In en, this message translates to:
  /// **'Add trip'**
  String get tripAddAction;

  /// No description provided for @tripRatings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get tripRatings;

  /// No description provided for @tripOverall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get tripOverall;

  /// No description provided for @tripFun.
  ///
  /// In en, this message translates to:
  /// **'Fun'**
  String get tripFun;

  /// No description provided for @tripFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get tripFood;

  /// No description provided for @tripSights.
  ///
  /// In en, this message translates to:
  /// **'Sights'**
  String get tripSights;

  /// No description provided for @tripValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get tripValue;

  /// No description provided for @tripWouldRepeat.
  ///
  /// In en, this message translates to:
  /// **'Would repeat'**
  String get tripWouldRepeat;

  /// No description provided for @tripWouldNotRepeat.
  ///
  /// In en, this message translates to:
  /// **'Would not repeat'**
  String get tripWouldNotRepeat;

  /// No description provided for @tripGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get tripGallery;

  /// No description provided for @tripDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete trip'**
  String get tripDelete;

  /// No description provided for @tripDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get tripDeleteTitle;

  /// No description provided for @tripDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete the trip and its photos?'**
  String get tripDeleteConfirm;

  /// No description provided for @tripSheetNew.
  ///
  /// In en, this message translates to:
  /// **'New trip'**
  String get tripSheetNew;

  /// No description provided for @tripSheetEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit trip'**
  String get tripSheetEdit;

  /// No description provided for @tripSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'title, destination, period, rating'**
  String get tripSheetSubtitle;

  /// No description provided for @tripFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tripFieldTitle;

  /// No description provided for @tripTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Weekend in Rome'**
  String get tripTitleHint;

  /// No description provided for @tripDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get tripDestination;

  /// No description provided for @tripDestinationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Rome, Italy'**
  String get tripDestinationHint;

  /// No description provided for @tripFromDate.
  ///
  /// In en, this message translates to:
  /// **'From date'**
  String get tripFromDate;

  /// No description provided for @tripToDate.
  ///
  /// In en, this message translates to:
  /// **'To date'**
  String get tripToDate;

  /// No description provided for @tripOverallRating.
  ///
  /// In en, this message translates to:
  /// **'Overall rating'**
  String get tripOverallRating;

  /// No description provided for @tripWouldRepeatLabel.
  ///
  /// In en, this message translates to:
  /// **'Would you repeat?'**
  String get tripWouldRepeatLabel;

  /// No description provided for @tripComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get tripComment;

  /// No description provided for @tripCommentHint.
  ///
  /// In en, this message translates to:
  /// **'how was it?'**
  String get tripCommentHint;

  /// No description provided for @tripCover.
  ///
  /// In en, this message translates to:
  /// **'Cover photo'**
  String get tripCover;

  /// No description provided for @tripAddCover.
  ///
  /// In en, this message translates to:
  /// **'Add cover'**
  String get tripAddCover;

  /// No description provided for @tripRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Title and destination are required'**
  String get tripRequiredError;

  /// No description provided for @tripDateOrderError.
  ///
  /// In en, this message translates to:
  /// **'The end date must be after the start date'**
  String get tripDateOrderError;

  /// No description provided for @tripSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get tripSavedToast;

  /// No description provided for @tripDeletedToast.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get tripDeletedToast;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Graphs'**
  String get statsTitle;

  /// No description provided for @statsMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get statsMood;

  /// No description provided for @statsIncomeVsExpense.
  ///
  /// In en, this message translates to:
  /// **'Income vs expenses'**
  String get statsIncomeVsExpense;

  /// No description provided for @statsSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get statsSteps;

  /// No description provided for @statsBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure'**
  String get statsBloodPressure;

  /// No description provided for @statsNotEnoughData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data for the chart'**
  String get statsNotEnoughData;

  /// No description provided for @memoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get memoryTitle;

  /// No description provided for @memoryTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get memoryTrips;

  /// No description provided for @memoryNoTrips.
  ///
  /// In en, this message translates to:
  /// **'No trips'**
  String get memoryNoTrips;

  /// No description provided for @memoryVisualDiary.
  ///
  /// In en, this message translates to:
  /// **'Visual diary'**
  String get memoryVisualDiary;

  /// No description provided for @memoryEmptyDiary.
  ///
  /// In en, this message translates to:
  /// **'No photos in the diary yet.\nAdd a photo to a daily log for it to appear here.'**
  String get memoryEmptyDiary;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'All modules'**
  String get moreTitle;

  /// No description provided for @moreGroupLogging.
  ///
  /// In en, this message translates to:
  /// **'Logging'**
  String get moreGroupLogging;

  /// No description provided for @moreGroupMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get moreGroupMoney;

  /// No description provided for @moreGroupHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get moreGroupHealth;

  /// No description provided for @moreGroupLife.
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get moreGroupLife;

  /// No description provided for @moreGroupData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get moreGroupData;

  /// No description provided for @moreGroupDev.
  ///
  /// In en, this message translates to:
  /// **'Dev'**
  String get moreGroupDev;

  /// No description provided for @moreModuleFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get moreModuleFood;

  /// No description provided for @moreModuleActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get moreModuleActivities;

  /// No description provided for @moreModuleSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get moreModuleSteps;

  /// No description provided for @moreModuleDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily log'**
  String get moreModuleDaily;

  /// No description provided for @moreModuleFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get moreModuleFinance;

  /// No description provided for @moreModuleHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get moreModuleHealth;

  /// No description provided for @moreModuleBucket.
  ///
  /// In en, this message translates to:
  /// **'Bucket List'**
  String get moreModuleBucket;

  /// No description provided for @moreModuleTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get moreModuleTrips;

  /// No description provided for @moreModuleSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get moreModuleSearch;

  /// No description provided for @moreModuleExport.
  ///
  /// In en, this message translates to:
  /// **'Export for AI'**
  String get moreModuleExport;

  /// No description provided for @moreModuleBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get moreModuleBackup;

  /// No description provided for @moreDevDesignSystem.
  ///
  /// In en, this message translates to:
  /// **'Dev: design system'**
  String get moreDevDesignSystem;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupTitle;

  /// No description provided for @backupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Full backup (ZIP)'**
  String get backupSubtitle;

  /// No description provided for @backupIncludesEyebrow.
  ///
  /// In en, this message translates to:
  /// **'What\'s included'**
  String get backupIncludesEyebrow;

  /// No description provided for @backupIncludeLogs.
  ///
  /// In en, this message translates to:
  /// **'Food, activities, steps'**
  String get backupIncludeLogs;

  /// No description provided for @backupIncludeMoney.
  ///
  /// In en, this message translates to:
  /// **'Expenses and income'**
  String get backupIncludeMoney;

  /// No description provided for @backupIncludeHealth.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure, pulse, medications, events, lab tests'**
  String get backupIncludeHealth;

  /// No description provided for @backupIncludeDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily Quick Logs'**
  String get backupIncludeDaily;

  /// No description provided for @backupIncludeBucket.
  ///
  /// In en, this message translates to:
  /// **'Bucket List + experiences'**
  String get backupIncludeBucket;

  /// No description provided for @backupIncludeTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get backupIncludeTrips;

  /// No description provided for @backupIncludeAttachments.
  ///
  /// In en, this message translates to:
  /// **'All photos and attachments'**
  String get backupIncludeAttachments;

  /// No description provided for @backupNoneThisSession.
  ///
  /// In en, this message translates to:
  /// **'No backup has been created in this session yet.'**
  String get backupNoneThisSession;

  /// No description provided for @backupLast.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {time}'**
  String backupLast(String time);

  /// No description provided for @backupPleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait…'**
  String get backupPleaseWait;

  /// No description provided for @backupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get backupCreate;

  /// No description provided for @backupRestoreEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get backupRestoreEyebrow;

  /// No description provided for @backupRestoreHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a ZIP backup file. Restore replaces all current data — the operation is \"all or nothing\".'**
  String get backupRestoreHint;

  /// No description provided for @backupPickFile.
  ///
  /// In en, this message translates to:
  /// **'Pick backup file'**
  String get backupPickFile;

  /// No description provided for @backupRestoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get backupRestoreAction;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String backupFailed(String error);

  /// No description provided for @backupCannotRead.
  ///
  /// In en, this message translates to:
  /// **'The file cannot be read'**
  String get backupCannotRead;

  /// No description provided for @backupPickError.
  ///
  /// In en, this message translates to:
  /// **'Error while picking: {error}'**
  String backupPickError(String error);

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Data has been restored'**
  String get backupRestored;

  /// No description provided for @backupRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed — your data is intact'**
  String get backupRestoreFailed;

  /// No description provided for @backupReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace data'**
  String get backupReplaceTitle;

  /// No description provided for @backupReplaceBody.
  ///
  /// In en, this message translates to:
  /// **'The app already has data. Restore will replace the current data with the data from the backup file.'**
  String get backupReplaceBody;

  /// No description provided for @backupReplaceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Replace and restore'**
  String get backupReplaceConfirm;

  /// No description provided for @backupValid.
  ///
  /// In en, this message translates to:
  /// **'Valid backup'**
  String get backupValid;

  /// No description provided for @backupInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup'**
  String get backupInvalid;

  /// No description provided for @backupSummary.
  ///
  /// In en, this message translates to:
  /// **'{records} records · {attachments} photos'**
  String backupSummary(int records, int attachments);

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search across all modules…'**
  String get searchHint;

  /// No description provided for @searchEmptyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter a word to search across all modules'**
  String get searchEmptyPrompt;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get searchNoResults;

  /// No description provided for @quickSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick log'**
  String get quickSheetTitle;

  /// No description provided for @quickSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'choose what to add'**
  String get quickSheetSubtitle;

  /// No description provided for @quickActionFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get quickActionFood;

  /// No description provided for @quickActionExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get quickActionExpense;

  /// No description provided for @quickActionBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure'**
  String get quickActionBloodPressure;

  /// No description provided for @quickActionDaily.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get quickActionDaily;

  /// No description provided for @quickActionActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get quickActionActivity;

  /// No description provided for @quickActionSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get quickActionSteps;

  /// No description provided for @quickActionMedication.
  ///
  /// In en, this message translates to:
  /// **'Supplement'**
  String get quickActionMedication;

  /// No description provided for @sheetTitleFood.
  ///
  /// In en, this message translates to:
  /// **'New meal'**
  String get sheetTitleFood;

  /// No description provided for @sheetTitleExpense.
  ///
  /// In en, this message translates to:
  /// **'New expense'**
  String get sheetTitleExpense;

  /// No description provided for @sheetTitleIncome.
  ///
  /// In en, this message translates to:
  /// **'New income'**
  String get sheetTitleIncome;

  /// No description provided for @sheetTitleBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure & pulse'**
  String get sheetTitleBloodPressure;

  /// No description provided for @sheetTitleDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily log'**
  String get sheetTitleDaily;

  /// No description provided for @sheetTitleActivity.
  ///
  /// In en, this message translates to:
  /// **'New activity'**
  String get sheetTitleActivity;

  /// No description provided for @sheetTitleSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get sheetTitleSteps;

  /// No description provided for @sheetTitleMedication.
  ///
  /// In en, this message translates to:
  /// **'Medication / supplement'**
  String get sheetTitleMedication;

  /// No description provided for @sheetTitleBucket.
  ///
  /// In en, this message translates to:
  /// **'New wish'**
  String get sheetTitleBucket;

  /// No description provided for @sheetTitleTrip.
  ///
  /// In en, this message translates to:
  /// **'New trip'**
  String get sheetTitleTrip;

  /// No description provided for @sheetTitleDefault.
  ///
  /// In en, this message translates to:
  /// **'New record'**
  String get sheetTitleDefault;

  /// No description provided for @sheetFormPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The “{type}” form is coming (Phase 7).'**
  String sheetFormPlaceholder(String type);

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export for AI'**
  String get exportTitle;

  /// No description provided for @exportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'JSON / Markdown for analysis'**
  String get exportSubtitle;

  /// No description provided for @exportScope.
  ///
  /// In en, this message translates to:
  /// **'Scope'**
  String get exportScope;

  /// No description provided for @exportScopeFull.
  ///
  /// In en, this message translates to:
  /// **'Everything'**
  String get exportScopeFull;

  /// No description provided for @exportScopePeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get exportScopePeriod;

  /// No description provided for @exportScopeModule.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get exportScopeModule;

  /// No description provided for @exportFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get exportFormat;

  /// No description provided for @exportPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get exportPeriodLabel;

  /// No description provided for @exportModule.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get exportModule;

  /// No description provided for @exportCountRecords.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get exportCountRecords;

  /// No description provided for @exportCountPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get exportCountPhotos;

  /// No description provided for @exportCountSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get exportCountSize;

  /// No description provided for @exportShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get exportShare;

  /// No description provided for @exportCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get exportCopy;

  /// No description provided for @exportShareUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sharing is not available'**
  String get exportShareUnavailable;

  /// No description provided for @exportCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get exportCopied;

  /// No description provided for @exportPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing…'**
  String get exportPreparing;

  /// No description provided for @exportNoData.
  ///
  /// In en, this message translates to:
  /// **'No data for this scope'**
  String get exportNoData;

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String exportError(String error);

  /// No description provided for @exportModuleLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, food{Food} activities{Activities} expenses{Expenses} income{Income} health_events{Health events} lab_tests{Lab tests} blood_pressure{Blood pressure & pulse} medications{Medications & supplements} daily_logs{Daily Quick Logs} steps{Steps} weight{Weight} bucket_list{Bucket List} trips{Trips} other{{code}}}'**
  String exportModuleLabel(String code);

  /// No description provided for @exportFormatLabel.
  ///
  /// In en, this message translates to:
  /// **'{code, select, json{JSON} markdown{Markdown} other{{code}}}'**
  String exportFormatLabel(String code);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get navStats;

  /// No description provided for @navMemories.
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get navMemories;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @navQuickLog.
  ///
  /// In en, this message translates to:
  /// **'Quick log'**
  String get navQuickLog;

  /// No description provided for @commonAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get commonAddPhoto;

  /// No description provided for @commonPhotoMultiHint.
  ///
  /// In en, this message translates to:
  /// **'you can add several'**
  String get commonPhotoMultiHint;

  /// No description provided for @commonLoadError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading'**
  String get commonLoadError;

  /// No description provided for @homeGreetMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGreetMorning;

  /// No description provided for @homeGreetDay.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGreetDay;

  /// No description provided for @homeGreetEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGreetEvening;

  /// No description provided for @homeQuickEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Log in 2 taps'**
  String get homeQuickEyebrow;

  /// No description provided for @homeAddPlus.
  ///
  /// In en, this message translates to:
  /// **'add +'**
  String get homeAddPlus;

  /// No description provided for @homeThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get homeThisWeek;

  /// No description provided for @homeRailMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get homeRailMood;

  /// No description provided for @homeRailSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get homeRailSteps;

  /// No description provided for @homeRailExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get homeRailExpense;

  /// No description provided for @homeRailPulse.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get homeRailPulse;

  /// No description provided for @homeAvgUnit.
  ///
  /// In en, this message translates to:
  /// **'avg.'**
  String get homeAvgUnit;

  /// No description provided for @homeTimelineSection.
  ///
  /// In en, this message translates to:
  /// **'Daily flow · today'**
  String get homeTimelineSection;

  /// No description provided for @homeTimelineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No entries yet today'**
  String get homeTimelineEmpty;

  /// No description provided for @homeFinishTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish the daily report'**
  String get homeFinishTitle;

  /// No description provided for @homeFinishSub.
  ///
  /// In en, this message translates to:
  /// **'Mood, workout, screen time…'**
  String get homeFinishSub;

  /// No description provided for @homeBpFallback.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure'**
  String get homeBpFallback;

  /// No description provided for @homePulse.
  ///
  /// In en, this message translates to:
  /// **'pulse {n}'**
  String homePulse(int n);

  /// No description provided for @homeMedsTaken.
  ///
  /// In en, this message translates to:
  /// **'Supplements · {count} taken'**
  String homeMedsTaken(int count);

  /// No description provided for @exportMdTitle.
  ///
  /// In en, this message translates to:
  /// **'LifeMaxxing — AI Export'**
  String get exportMdTitle;

  /// No description provided for @exportMdPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period:'**
  String get exportMdPeriodLabel;

  /// No description provided for @exportMdSummary.
  ///
  /// In en, this message translates to:
  /// **'Overall summary'**
  String get exportMdSummary;

  /// No description provided for @exportMdPeriodAll.
  ///
  /// In en, this message translates to:
  /// **'All data'**
  String get exportMdPeriodAll;

  /// No description provided for @exportMdPeriodModule.
  ///
  /// In en, this message translates to:
  /// **'Module: {module}'**
  String exportMdPeriodModule(String module);

  /// No description provided for @exportMdSectionDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily logs'**
  String get exportMdSectionDaily;

  /// No description provided for @exportMdSectionFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get exportMdSectionFood;

  /// No description provided for @exportMdSectionActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get exportMdSectionActivities;

  /// No description provided for @exportMdSectionSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get exportMdSectionSteps;

  /// No description provided for @exportMdSectionWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get exportMdSectionWeight;

  /// No description provided for @exportMdSectionMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get exportMdSectionMoney;

  /// No description provided for @exportMdSectionHealthEvents.
  ///
  /// In en, this message translates to:
  /// **'Health events'**
  String get exportMdSectionHealthEvents;

  /// No description provided for @exportMdSectionLabTests.
  ///
  /// In en, this message translates to:
  /// **'Lab tests'**
  String get exportMdSectionLabTests;

  /// No description provided for @exportMdSectionBloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure & pulse'**
  String get exportMdSectionBloodPressure;

  /// No description provided for @exportMdSectionMedications.
  ///
  /// In en, this message translates to:
  /// **'Medications & supplements'**
  String get exportMdSectionMedications;

  /// No description provided for @exportMdSectionBucketList.
  ///
  /// In en, this message translates to:
  /// **'Bucket List'**
  String get exportMdSectionBucketList;

  /// No description provided for @exportMdSectionBucketExperiences.
  ///
  /// In en, this message translates to:
  /// **'Bucket List completed experiences'**
  String get exportMdSectionBucketExperiences;

  /// No description provided for @exportMdSectionTrips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get exportMdSectionTrips;

  /// No description provided for @exportMdStepsLine.
  ///
  /// In en, this message translates to:
  /// **'{date}: {count} steps'**
  String exportMdStepsLine(String date, int count);

  /// No description provided for @exportMdWeightLine.
  ///
  /// In en, this message translates to:
  /// **'{date}: {kg} kg{note}'**
  String exportMdWeightLine(String date, String kg, String note);

  /// No description provided for @exportMdIncomeLine.
  ///
  /// In en, this message translates to:
  /// **'{date}: +{amount} € ({category}) — {source}'**
  String exportMdIncomeLine(
    String date,
    num amount,
    String category,
    String source,
  );

  /// No description provided for @exportMdExpenseLine.
  ///
  /// In en, this message translates to:
  /// **'{date}: −{amount} € ({category}) — {description}'**
  String exportMdExpenseLine(
    String date,
    num amount,
    String category,
    String description,
  );

  /// No description provided for @exportMdLabLine.
  ///
  /// In en, this message translates to:
  /// **'{date}: {lab} — {reason}'**
  String exportMdLabLine(String date, String lab, String reason);

  /// No description provided for @exportMdBloodPressureLine.
  ///
  /// In en, this message translates to:
  /// **'{date} {time}: {systolic}/{diastolic}, pulse {pulse}'**
  String exportMdBloodPressureLine(
    String date,
    String time,
    int systolic,
    int diastolic,
    int pulse,
  );

  /// No description provided for @exportMdMedicationLine.
  ///
  /// In en, this message translates to:
  /// **'{date} {time}: {name} ({type}) — {status}'**
  String exportMdMedicationLine(
    String date,
    String time,
    String name,
    String type,
    String status,
  );

  /// No description provided for @exportMdBucketExperienceLine.
  ///
  /// In en, this message translates to:
  /// **'{date}: rating {rating}/10, {worth}'**
  String exportMdBucketExperienceLine(String date, int rating, String worth);

  /// No description provided for @exportMdWorthIt.
  ///
  /// In en, this message translates to:
  /// **'worth it'**
  String get exportMdWorthIt;

  /// No description provided for @exportMdNotWorthIt.
  ///
  /// In en, this message translates to:
  /// **'not worth it'**
  String get exportMdNotWorthIt;

  /// No description provided for @exportMdTripLine.
  ///
  /// In en, this message translates to:
  /// **'{fromDate}–{toDate}: {title}, {destination} (overall rating {overall}/10)'**
  String exportMdTripLine(
    String fromDate,
    String toDate,
    String title,
    String destination,
    int overall,
  );

  /// No description provided for @exportMdSummaryFinance.
  ///
  /// In en, this message translates to:
  /// **'Income: {income} €, expenses: {expenses} €, balance: {balance} €'**
  String exportMdSummaryFinance(Object income, Object expenses, Object balance);

  /// No description provided for @exportMdSummaryHealth.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure (avg): {systolic}/{diastolic}, pulse {pulse} ({count} measurements)'**
  String exportMdSummaryHealth(
    Object systolic,
    Object diastolic,
    Object pulse,
    Object count,
  );

  /// No description provided for @exportMdSummaryBucket.
  ///
  /// In en, this message translates to:
  /// **'Bucket List: {completed} completed, average feeling {rating}/10'**
  String exportMdSummaryBucket(Object completed, Object rating);

  /// No description provided for @exportMdDailyMood.
  ///
  /// In en, this message translates to:
  /// **'mood {mood}/10'**
  String exportMdDailyMood(int mood);

  /// No description provided for @exportMdDailyWorkout.
  ///
  /// In en, this message translates to:
  /// **'workout'**
  String get exportMdDailyWorkout;

  /// No description provided for @exportMdDailyAlcohol.
  ///
  /// In en, this message translates to:
  /// **'alcohol'**
  String get exportMdDailyAlcohol;

  /// No description provided for @exportMdMealCalories.
  ///
  /// In en, this message translates to:
  /// **' — {calories} kcal'**
  String exportMdMealCalories(int calories);

  /// No description provided for @exportMdActivityDuration.
  ///
  /// In en, this message translates to:
  /// **' — {minutes} min'**
  String exportMdActivityDuration(int minutes);

  /// No description provided for @exportMdEventNext.
  ///
  /// In en, this message translates to:
  /// **' (next: {date})'**
  String exportMdEventNext(String date);

  /// No description provided for @exportMdBucketLine.
  ///
  /// In en, this message translates to:
  /// **'{title} ({status}, priority {priority})'**
  String exportMdBucketLine(String title, String status, String priority);

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonAddPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get commonAddPhotos;

  /// No description provided for @moodPickerPrompt.
  ///
  /// In en, this message translates to:
  /// **'how do you feel today?'**
  String get moodPickerPrompt;

  /// No description provided for @moodPickerLow.
  ///
  /// In en, this message translates to:
  /// **'1 · very bad'**
  String get moodPickerLow;

  /// No description provided for @moodPickerHigh.
  ///
  /// In en, this message translates to:
  /// **'10 · great'**
  String get moodPickerHigh;

  /// No description provided for @moodVeryBad.
  ///
  /// In en, this message translates to:
  /// **'very bad'**
  String get moodVeryBad;

  /// No description provided for @moodBad.
  ///
  /// In en, this message translates to:
  /// **'bad'**
  String get moodBad;

  /// No description provided for @moodMid.
  ///
  /// In en, this message translates to:
  /// **'average'**
  String get moodMid;

  /// No description provided for @moodGood.
  ///
  /// In en, this message translates to:
  /// **'good'**
  String get moodGood;

  /// No description provided for @moodVeryGood.
  ///
  /// In en, this message translates to:
  /// **'very good'**
  String get moodVeryGood;

  /// No description provided for @moodGreat.
  ///
  /// In en, this message translates to:
  /// **'great'**
  String get moodGreat;

  /// No description provided for @unitGrams.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get unitGrams;

  /// No description provided for @unitMin.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get unitMin;

  /// No description provided for @unitHour.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get unitHour;

  /// No description provided for @unitThousands.
  ///
  /// In en, this message translates to:
  /// **'k'**
  String get unitThousands;
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
