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
