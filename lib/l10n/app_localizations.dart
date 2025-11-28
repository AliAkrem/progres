import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart' deferred as app_localizations_ar;
import 'app_localizations_en.dart' deferred as app_localizations_en;

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('ar'),
  ];

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Title for settings page and settings-related items
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Arabic language option
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// Label for theme selection
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Title for theme selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// System default theme option
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Label for notification settings
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Label for about section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Confirmation message for logout
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmation;

  ///
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabTitleProfile;

  ///
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get tabTitleDashboard;

  /// Section title for current status
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get currentStatus;

  /// Student's academic level
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// Transport status
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// Status when something is paid
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// Status when something is not paid
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// Section title for personal information
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Label for name in Latin script
  ///
  /// In en, this message translates to:
  /// **'Full Name (Latin)'**
  String get fullNameLatin;

  /// Label for name in Arabic script
  ///
  /// In en, this message translates to:
  /// **'Full Name (Arabic)'**
  String get fullNameArabic;

  /// Label for date of birth
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// Label for place of birth
  ///
  /// In en, this message translates to:
  /// **'Birth Place'**
  String get birthPlace;

  /// Section title for academic status
  ///
  /// In en, this message translates to:
  /// **'Current Academic Status'**
  String get currentAcademicStatus;

  /// Label for academic program
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get program;

  /// Label for academic cycle
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get cycle;

  /// Label for student registration number
  ///
  /// In en, this message translates to:
  /// **'Registration Number'**
  String get registrationNumber;

  ///
  ///
  /// In en, this message translates to:
  /// **'Academic Performance'**
  String get academicPerformancePageTitle;

  /// Label for assessment sections and tabs
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get assessment;

  /// Tooltip for refresh button
  ///
  /// In en, this message translates to:
  /// **'Refresh data'**
  String get refreshData;

  /// Error message when profile fails to load
  ///
  /// In en, this message translates to:
  /// **'Profile data not loaded. Please go back and try again.'**
  String get errorLoadingProfile;

  /// Shown while profile data is being loaded
  ///
  /// In en, this message translates to:
  /// **'Loading profile data...'**
  String get loadingProfileData;

  /// Button text to retry loading data
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Tab title for exam results
  ///
  /// In en, this message translates to:
  /// **'Exam Results'**
  String get examResults;

  /// Label showing that data is from cache
  ///
  /// In en, this message translates to:
  /// **'Cached data'**
  String get cachedData;

  /// Message shown when no period is selected
  ///
  /// In en, this message translates to:
  /// **'Select an academic period to view results'**
  String get selectPeriodForResults;

  /// Message shown when there are no exam results
  ///
  /// In en, this message translates to:
  /// **'No exam results available'**
  String get noExamResults;

  /// Message shown when there are no continuous assessment results
  ///
  /// In en, this message translates to:
  /// **'No continuous assessment results available'**
  String get noContinuousAssessment;

  /// Message shown when no continuous assessments are available for a course
  ///
  /// In en, this message translates to:
  /// **'No continuous assessments available yet'**
  String get noAssessmentsYet;

  /// Project assessment type label
  ///
  /// In en, this message translates to:
  /// **'PROJECT'**
  String get project;

  /// Tutorial work assessment type label
  ///
  /// In en, this message translates to:
  /// **'TUTORIAL WORK'**
  String get tutorialWork;

  /// Practical work assessment type label
  ///
  /// In en, this message translates to:
  /// **'PRACTICAL WORK'**
  String get practicalWork;

  /// Default period name when actual name is not found
  ///
  /// In en, this message translates to:
  /// **'Period {id}'**
  String defaultPeriodName(int id);

  /// Main title on login page
  ///
  /// In en, this message translates to:
  /// **'Student Portal'**
  String get studentPortal;

  /// Subtitle on login page
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get signInToAccount;

  /// Label for student code input field
  ///
  /// In en, this message translates to:
  /// **'Student Code'**
  String get studentCode;

  /// Placeholder for student code input
  ///
  /// In en, this message translates to:
  /// **'Enter your student code'**
  String get enterStudentCode;

  /// Label for password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Placeholder for password input
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// Text for sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Text for switch language button
  ///
  /// In en, this message translates to:
  /// **'Switch Language'**
  String get switchLanguage;

  /// Label for selected language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get selectedLanguage;

  /// Validation message for empty student code
  ///
  /// In en, this message translates to:
  /// **'Please enter your student code'**
  String get pleaseEnterStudentCode;

  /// Validation message for empty enrollment history
  ///
  /// In en, this message translates to:
  /// **'No enrollment history available'**
  String get errorNoEnrollments;

  /// No subject data available error message
  ///
  /// In en, this message translates to:
  /// **'No subject data available'**
  String get errorNoSubjects;

  /// Load Subjects button text
  ///
  /// In en, this message translates to:
  /// **'Load Subjects'**
  String get loadSubjects;

  /// Something went wrong
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somthingWentWrong;

  /// Validation message for empty password
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// Generic error message for failed login
  ///
  /// In en, this message translates to:
  /// **'Unable to sign in. Please check your student code and password.'**
  String get unableToSignIn;

  /// Error message for incorrect credentials
  ///
  /// In en, this message translates to:
  /// **'Incorrect student code or password. Please try again.'**
  String get incorrectCredentials;

  /// Error message for network connection issues
  ///
  /// In en, this message translates to:
  /// **'Network connection error. Please check your internet connection and try again.'**
  String get networkError;

  /// Message shown when no exam results are available for a course
  ///
  /// In en, this message translates to:
  /// **'No exam results available yet'**
  String get noExamResultsYet;

  /// Label for exam type
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get exam;

  /// Coefficient value display
  ///
  /// In en, this message translates to:
  /// **'Coef: {value}'**
  String coefficient(String value);

  /// Shown when a grade is not available
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// Status when an appeal has been requested
  ///
  /// In en, this message translates to:
  /// **'Appeal Requested'**
  String get appealRequested;

  /// Status when an appeal can be requested
  ///
  /// In en, this message translates to:
  /// **'Appeal Available'**
  String get appealAvailable;

  /// Label for timeline section
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// Label for home navigation item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Label for schedule section
  ///
  /// In en, this message translates to:
  /// **'Weekly Schedule'**
  String get weeklyschedule;

  /// Label for transcript section
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get transcript;

  /// Label for academic history section
  ///
  /// In en, this message translates to:
  /// **'Academic History'**
  String get academicHistory;

  /// Label for menu button
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorGeneric;

  /// Error message with details
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// Generic loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Section title for appearance settings
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Section title for user preferences
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// Title for groups page and related items
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get myGroups;

  /// Tooltip for refresh groups button
  ///
  /// In en, this message translates to:
  /// **'Refresh groups'**
  String get refreshGroups;

  /// Button text to load groups
  ///
  /// In en, this message translates to:
  /// **'Load Groups'**
  String get loadGroups;

  /// Message shown when no group data is available
  ///
  /// In en, this message translates to:
  /// **'No group data available'**
  String get noGroupData;

  /// Title for the weekly schedule view
  ///
  /// In en, this message translates to:
  /// **'Weekly Schedule'**
  String get weeklySchedule;

  /// Message shown when there are no classes scheduled
  ///
  /// In en, this message translates to:
  /// **'No classes scheduled for this week'**
  String get noClassesThisWeek;

  /// Label for privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Label for terms of service link
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Label for lecture session type
  ///
  /// In en, this message translates to:
  /// **'Lecture'**
  String get lecture;

  /// Label for tutorial session type
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorial;

  /// Label for practical session type
  ///
  /// In en, this message translates to:
  /// **'Practical'**
  String get practical;

  /// Message shown when there are no classes in the schedule
  ///
  /// In en, this message translates to:
  /// **'No classes scheduled for this week'**
  String get noClassesScheduled;

  /// Description shown when user has no pedagogical groups
  ///
  /// In en, this message translates to:
  /// **'You are not assigned to any pedagogical groups yet.'**
  String get notAssignedToGroups;

  /// Label for section name
  ///
  /// In en, this message translates to:
  /// **'Section: {name}'**
  String section(String name);

  /// Title for academic transcripts page
  ///
  /// In en, this message translates to:
  /// **'Academic Transcripts'**
  String get academicTranscripts;

  /// Message shown when refreshing data
  ///
  /// In en, this message translates to:
  /// **'Refreshing data...'**
  String get refreshingData;

  /// Prompt to select an academic year
  ///
  /// In en, this message translates to:
  /// **'Select an academic year'**
  String get selectAcademicYear;

  /// Title for annual results section
  ///
  /// In en, this message translates to:
  /// **'ANNUAL RESULTS'**
  String get annualResults;

  /// Label for average score
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// Label for credits
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// Shown when level is not available
  ///
  /// In en, this message translates to:
  /// **'Unknown Level'**
  String get unknownLevel;

  /// Academic year with value
  ///
  /// In en, this message translates to:
  /// **'Academic Year'**
  String get academicYear;

  /// Academic year with value
  ///
  /// In en, this message translates to:
  /// **'Academic Year: {year}'**
  String academicYearWrapper(String year);

  /// Status for passing a course or year
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// Status for failing a course or year
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// Status for passing the year with debts
  ///
  /// In en, this message translates to:
  /// **'With Debts'**
  String get withDebts;

  /// Status for passing the year with resit session
  ///
  /// In en, this message translates to:
  /// **'With Resit Session'**
  String get withResitSession;

  /// Status for passing year normal session
  ///
  /// In en, this message translates to:
  /// **'normal session'**
  String get normalSession;

  /// greating message
  ///
  /// In en, this message translates to:
  /// **'Hello, {value} '**
  String hello(String value);

  /// Title for subjects and coefficients section
  ///
  /// In en, this message translates to:
  /// **'Subjects & Coefficients'**
  String get subjectsAndCoefficients;

  /// Title for about page
  ///
  /// In en, this message translates to:
  /// **'About Progres'**
  String get aboutPage;

  /// Version number of the app
  ///
  /// In en, this message translates to:
  /// **'Version {value}'**
  String version(String value);

  /// Description of the app
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Description text of the app
  ///
  /// In en, this message translates to:
  /// **'Progres is a modern, independently developed mobile application that reimagines the Progres/Webetu platform. Designed with a focus on enhanced user experience, it leverages Material Design principles to provide university students with seamless access to their academic information, both online and offline.'**
  String get descriptionText;

  /// Purpose of the app
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// Purpose text of the app
  ///
  /// In en, this message translates to:
  /// **'The primary goal of Progres is to offer a more intuitive and responsive alternative to the traditional Progres/Webetu system. By addressing usability challenges and incorporating offline capabilities, Progres ensures that students can reliably access their academic data anytime, anywhere.'**
  String get purposeText;

  /// License information
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// License text of the app
  ///
  /// In en, this message translates to:
  /// **'Progres is released under the MIT License, allowing for open collaboration and distribution.'**
  String get licenseText;

  /// Current status of the project
  ///
  /// In en, this message translates to:
  /// **'Project Status'**
  String get projectStatus;

  /// Project status text of the app
  ///
  /// In en, this message translates to:
  /// **'The project is actively maintained, with ongoing efforts to enhance functionality, address user feedback, and ensure compatibility with the latest platform updates.'**
  String get projectStatusText;

  /// Contributions to the project
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get contribution;

  /// Contribution text of the app
  ///
  /// In en, this message translates to:
  /// **'Contributions are welcome! If you\'re interested in improving this project, feel free to fork the repository, make your changes, and submit a pull request.'**
  String get contributionText;

  /// View License button
  ///
  /// In en, this message translates to:
  /// **'View License'**
  String get viewLicense;

  /// link to github
  ///
  /// In en, this message translates to:
  /// **'View on GitHub'**
  String get viewonGitHub;

  /// Title for discharge page
  ///
  /// In en, this message translates to:
  /// **'My Discharge'**
  String get myDischarge;

  /// Tooltip for refresh discharge button
  ///
  /// In en, this message translates to:
  /// **'Refresh discharge'**
  String get refreshDischarge;

  /// Button text to load discharge
  ///
  /// In en, this message translates to:
  /// **'Load Discharge'**
  String get loadDischarge;

  /// Message shown when no discharge data is available
  ///
  /// In en, this message translates to:
  /// **'No discharge data available'**
  String get noDischargeData;

  /// Description shown when discharge data is not available
  ///
  /// In en, this message translates to:
  /// **'Discharge information is not available at this time.'**
  String get dischargeNotAvailable;

  /// Title for discharge status section
  ///
  /// In en, this message translates to:
  /// **'Discharge Status'**
  String get dischargeStatus;

  /// Description for discharge status section
  ///
  /// In en, this message translates to:
  /// **'Your current discharge status across all university services'**
  String get dischargeStatusDescription;

  /// Title for department level discharge
  ///
  /// In en, this message translates to:
  /// **'Department Level'**
  String get departmentLevel;

  /// Description for department level discharge
  ///
  /// In en, this message translates to:
  /// **'Academic department clearance'**
  String get departmentDescription;

  /// Title for faculty library level discharge
  ///
  /// In en, this message translates to:
  /// **'Faculty Library Level'**
  String get facultyLibraryLevel;

  /// Description for faculty library level discharge
  ///
  /// In en, this message translates to:
  /// **'Faculty library books and materials clearance'**
  String get facultyLibraryDescription;

  /// Title for central library level discharge
  ///
  /// In en, this message translates to:
  /// **'Central Library Level'**
  String get centralLibraryLevel;

  /// Description for central library level discharge
  ///
  /// In en, this message translates to:
  /// **'Central library books and materials clearance'**
  String get centralLibraryDescription;

  /// Title for residence level discharge
  ///
  /// In en, this message translates to:
  /// **'Residence Level'**
  String get residenceLevel;

  /// Description for residence level discharge
  ///
  /// In en, this message translates to:
  /// **'University residence accommodation clearance'**
  String get residenceDescription;

  /// Title for scholarship service level discharge
  ///
  /// In en, this message translates to:
  /// **'Scholarship Service Level'**
  String get scholarshipServiceLevel;

  /// Description for scholarship service level discharge
  ///
  /// In en, this message translates to:
  /// **'Scholarship and financial aid clearance'**
  String get scholarshipServiceDescription;

  /// Status when discharge is cleared
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get cleared;

  /// Status when discharge is pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Title when discharge is not required for the student
  ///
  /// In en, this message translates to:
  /// **'No Discharge Required'**
  String get dischargeNotRequiredTitle;

  /// Description when discharge is not required for the student
  ///
  /// In en, this message translates to:
  /// **'You are not required to complete any discharge procedures at this time. Your academic status does not require clearance from university services.'**
  String get dischargeNotRequiredDescription;

  /// Tooltip for help icon button
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpIcon;

  /// Title for student code information dialog
  ///
  /// In en, this message translates to:
  /// **'Student Code Information'**
  String get codeInformationTitle;

  /// Text explaining where to find student code
  ///
  /// In en, this message translates to:
  /// **'Your student code can be found on your transcript, as shown in the image above. You must add the year you passed your baccalaureate exam along with your student code when logging in. For example, if your baccalaureate year is 2023 and your code is 12345, enter: 202312345.'**
  String get codeInformationText;

  /// Title for password information dialog
  ///
  /// In en, this message translates to:
  /// **'Password Information'**
  String get passwordInformationTitle;

  /// Text explaining where to find password
  ///
  /// In en, this message translates to:
  /// **'Your password can be found on your transcript as shown in the image above.'**
  String get passwordInformationText;

  /// Close button text for dialogs
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Next button text for multi-step dialogs
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Institution
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get institution;

  /// Specialization
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return lookupAppLocalizations(locale);
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

Future<AppLocalizations> lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return app_localizations_ar.loadLibrary().then(
        (dynamic _) => app_localizations_ar.AppLocalizationsAr(),
      );
    case 'en':
      return app_localizations_en.loadLibrary().then(
        (dynamic _) => app_localizations_en.AppLocalizationsEn(),
      );
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
