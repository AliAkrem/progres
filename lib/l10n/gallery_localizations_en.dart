// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'gallery_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get theme => 'Theme';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get systemDefault => 'System Default';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get notifications => 'Notifications';

  @override
  String get about => 'About';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to log out?';

  @override
  String get tabTitleProfile => 'Profile';

  @override
  String get tabTitleDashboard => 'Dashboard';

  @override
  String get currentStatus => 'Current Status';

  @override
  String get level => 'Level';

  @override
  String get transport => 'Transport';

  @override
  String get paid => 'Paid';

  @override
  String get unpaid => 'Unpaid';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get fullNameLatin => 'Full Name (Latin)';

  @override
  String get fullNameArabic => 'Full Name (Arabic)';

  @override
  String get birthDate => 'Birth Date';

  @override
  String get birthPlace => 'Birth Place';

  @override
  String get currentAcademicStatus => 'Current Academic Status';

  @override
  String get program => 'Program';

  @override
  String get cycle => 'Cycle';

  @override
  String get registrationNumber => 'Registration Number';

  @override
  String get academicPerformancePageTitle => 'Academic Performance';

  @override
  String get assessment => 'Assessment';

  @override
  String get refreshData => 'Refresh data';

  @override
  String get errorLoadingProfile =>
      'Profile data not loaded. Please go back and try again.';

  @override
  String get loadingProfileData => 'Loading profile data...';

  @override
  String get retry => 'Retry';

  @override
  String get examResults => 'Exam Results';

  @override
  String get cachedData => 'Cached data';

  @override
  String get selectPeriodForResults =>
      'Select an academic period to view results';

  @override
  String get noExamResults => 'No exam results available';

  @override
  String get noContinuousAssessment =>
      'No continuous assessment results available';

  @override
  String get noAssessmentsYet => 'No continuous assessments available yet';

  @override
  String get project => 'PROJECT';

  @override
  String get tutorialWork => 'TUTORIAL WORK';

  @override
  String get practicalWork => 'PRACTICAL WORK';

  @override
  String defaultPeriodName(int id) {
    return 'Period $id';
  }

  @override
  String get studentPortal => 'Student Portal';

  @override
  String get signInToAccount => 'Sign in to your account';

  @override
  String get studentCode => 'Student Code';

  @override
  String get enterStudentCode => 'Enter your student code';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get signIn => 'Sign In';

  @override
  String get switchLanguage => 'Switch Language';

  @override
  String get selectedLanguage => 'English';

  @override
  String get pleaseEnterStudentCode => 'Please enter your student code';

  @override
  String get errorNoEnrollments => 'No enrollment history available';

  @override
  String get errorNoSubjects => 'No subject data available';

  @override
  String get loadSubjects => 'Load Subjects';

  @override
  String get somthingWentWrong => 'Something went wrong';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get unableToSignIn =>
      'Unable to sign in. Please check your student code and password.';

  @override
  String get incorrectCredentials =>
      'Incorrect student code or password. Please try again.';

  @override
  String get networkError =>
      'Network connection error. Please check your internet connection and try again.';

  @override
  String get noExamResultsYet => 'No exam results available yet';

  @override
  String get exam => 'Exam';

  @override
  String coefficient(String value) {
    return 'Coef: $value';
  }

  @override
  String get notAvailable => 'N/A';

  @override
  String get appealRequested => 'Appeal Requested';

  @override
  String get appealAvailable => 'Appeal Available';

  @override
  String get timeline => 'Timeline';

  @override
  String get home => 'Home';

  @override
  String get weeklyschedule => 'Weekly Schedule';

  @override
  String get transcript => 'Transcript';

  @override
  String get academicHistory => 'Academic History';

  @override
  String get menu => 'Menu';

  @override
  String get errorGeneric => 'An error occurred. Please try again.';

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get loading => 'Loading...';

  @override
  String get appearance => 'Appearance';

  @override
  String get preferences => 'Preferences';

  @override
  String get myGroups => 'My Groups';

  @override
  String get refreshGroups => 'Refresh groups';

  @override
  String get loadGroups => 'Load Groups';

  @override
  String get noGroupData => 'No group data available';

  @override
  String get weeklySchedule => 'Weekly Schedule';

  @override
  String get noClassesThisWeek => 'No classes scheduled for this week';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get lecture => 'Lecture';

  @override
  String get tutorial => 'Tutorial';

  @override
  String get practical => 'Practical';

  @override
  String get noClassesScheduled => 'No classes scheduled for this week';

  @override
  String get notAssignedToGroups =>
      'You are not assigned to any pedagogical groups yet.';

  @override
  String section(String name) {
    return 'Section: $name';
  }

  @override
  String get academicTranscripts => 'Academic Transcripts';

  @override
  String get refreshingData => 'Refreshing data...';

  @override
  String get selectAcademicYear => 'Select an academic year';

  @override
  String get annualResults => 'ANNUAL RESULTS';

  @override
  String get average => 'Average';

  @override
  String get credits => 'Credits';

  @override
  String get unknownLevel => 'Unknown Level';

  @override
  String get academicYear => 'Academic Year';

  @override
  String academicYearWrapper(String year) {
    return 'Academic Year: $year';
  }

  @override
  String get passed => 'Passed';

  @override
  String get failed => 'Failed';

  @override
  String hello(String value) {
    return 'Hello, $value ';
  }

  @override
  String get subjectsAndCoefficients => 'Subjects & Coefficients';

  @override
  String get aboutPage => 'About Progres';

  @override
  String version(String value) {
    return 'Version $value';
  }

  @override
  String get description => 'Description';

  @override
  String get descriptionText =>
      'Progres is a modern, independently developed mobile application that reimagines the Progres/Webetu platform. Designed with a focus on enhanced user experience, it leverages Material Design principles to provide university students with seamless access to their academic information, both online and offline.';

  @override
  String get purpose => 'Purpose';

  @override
  String get purposeText =>
      'The primary goal of Progres is to offer a more intuitive and responsive alternative to the traditional Progres/Webetu system. By addressing usability challenges and incorporating offline capabilities, Progres ensures that students can reliably access their academic data anytime, anywhere.';

  @override
  String get license => 'License';

  @override
  String get licenseText =>
      'Progres is released under the MIT License, allowing for open collaboration and distribution.';

  @override
  String get projectStatus => 'Project Status';

  @override
  String get projectStatusText =>
      'The project is actively maintained, with ongoing efforts to enhance functionality, address user feedback, and ensure compatibility with the latest platform updates.';

  @override
  String get contribution => 'Contributions';

  @override
  String get contributionText =>
      'Contributions are welcome! If you\'re interested in improving this project, feel free to fork the repository, make your changes, and submit a pull request.';

  @override
  String get viewLicense => 'View License';

  @override
  String get viewonGitHub => 'View on GitHub';

  @override
  String get myDischarge => 'My Discharge';

  @override
  String get refreshDischarge => 'Refresh discharge';

  @override
  String get loadDischarge => 'Load Discharge';

  @override
  String get noDischargeData => 'No discharge data available';

  @override
  String get dischargeNotAvailable =>
      'Discharge information is not available at this time.';

  @override
  String get dischargeStatus => 'Discharge Status';

  @override
  String get dischargeStatusDescription =>
      'Your current discharge status across all university services';

  @override
  String get departmentLevel => 'Department Level';

  @override
  String get departmentDescription => 'Academic department clearance';

  @override
  String get facultyLibraryLevel => 'Faculty Library Level';

  @override
  String get facultyLibraryDescription =>
      'Faculty library books and materials clearance';

  @override
  String get centralLibraryLevel => 'Central Library Level';

  @override
  String get centralLibraryDescription =>
      'Central library books and materials clearance';

  @override
  String get residenceLevel => 'Residence Level';

  @override
  String get residenceDescription =>
      'University residence accommodation clearance';

  @override
  String get scholarshipServiceLevel => 'Scholarship Service Level';

  @override
  String get scholarshipServiceDescription =>
      'Scholarship and financial aid clearance';

  @override
  String get cleared => 'Cleared';

  @override
  String get pending => 'Pending';

  @override
  String get dischargeNotRequiredTitle => 'No Discharge Required';

  @override
  String get dischargeNotRequiredDescription =>
      'You are not required to complete any discharge procedures at this time. Your academic status does not require clearance from university services.';

  @override
  String get helpIcon => 'Help';

  @override
  String get codeInformationTitle => 'Student Code Information';

  @override
  String get codeInformationText =>
      'Your student code can be found on your transcript, as shown in the image above. You must add the year you passed your baccalaureate exam along with your student code when logging in. For example, if your baccalaureate year is 2023 and your code is 12345, enter: 202312345.';

  @override
  String get passwordInformationTitle => 'Password Information';

  @override
  String get passwordInformationText =>
      'Your password can be found on your transcript as shown in the image above.';

  @override
  String get close => 'Close';

  @override
  String get next => 'Next';

  @override
  String get institution => 'Institution';

  @override
  String get specialization => 'Specialization';
}
