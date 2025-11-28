// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcomeBack => 'مرحباً بك';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get theme => 'المظهر';

  @override
  String get selectTheme => 'اختر المظهر';

  @override
  String get light => 'الوضع الفاتح';

  @override
  String get dark => 'الوضع الداكن';

  @override
  String get systemDefault => 'افتراضي النظام';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get about => 'حول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get tabTitleProfile => 'الملف الشخصي';

  @override
  String get tabTitleDashboard => 'لوحة المعلومات';

  @override
  String get currentStatus => 'الوضع الحالي';

  @override
  String get level => 'المستوى';

  @override
  String get transport => 'النقل';

  @override
  String get paid => 'مدفوع';

  @override
  String get unpaid => 'غير مدفوع';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get fullNameLatin => 'الاسم الكامل (باللاتينية)';

  @override
  String get fullNameArabic => 'الاسم الكامل (بالعربية)';

  @override
  String get birthDate => 'تاريخ الميلاد';

  @override
  String get birthPlace => 'مكان الميلاد';

  @override
  String get currentAcademicStatus => 'الحالة الأكاديمية';

  @override
  String get program => 'البرنامج';

  @override
  String get cycle => 'الدورة';

  @override
  String get registrationNumber => 'رقم التسجيل';

  @override
  String get academicPerformancePageTitle => 'الأداء الأكاديمي';

  @override
  String get assessment => 'التقييم';

  @override
  String get refreshData => 'تحديث البيانات';

  @override
  String get errorLoadingProfile =>
      'لم يتم تحميل بيانات الملف الشخصي. يرجى الرجوع والمحاولة مرة أخرى.';

  @override
  String get loadingProfileData => 'جاري تحميل بيانات الملف الشخصي...';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get examResults => 'نتائج الامتحانات';

  @override
  String get cachedData => 'بيانات محفوظة مؤقتًا';

  @override
  String get selectPeriodForResults => 'اختر فترة أكاديمية لعرض النتائج';

  @override
  String get noExamResults => 'لا توجد نتائج امتحانات متاحة';

  @override
  String get noContinuousAssessment => 'لا توجد نتائج تقييم مستمر متاحة';

  @override
  String get noAssessmentsYet => 'لا توجد تقييمات مستمرة متاحة بعد';

  @override
  String get project => 'مشروع';

  @override
  String get tutorialWork => 'أعمال توجيهية';

  @override
  String get practicalWork => 'أعمال تطبيقية';

  @override
  String defaultPeriodName(int id) {
    return 'الفترة $id';
  }

  @override
  String get studentPortal => 'بوابة الطالب';

  @override
  String get signInToAccount => 'تسجيل الدخول إلى حسابك';

  @override
  String get studentCode => 'رمز الطالب';

  @override
  String get enterStudentCode => 'أدخل رمز الطالب الخاص بك';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterPassword => 'أدخل كلمة المرور الخاصة بك';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get switchLanguage => 'تبديل اللغة';

  @override
  String get selectedLanguage => 'العربية';

  @override
  String get pleaseEnterStudentCode => 'يرجى إدخال رمز الطالب الخاص بك';

  @override
  String get errorNoEnrollments => 'لا يوجد سجل تسجيل';

  @override
  String get errorNoSubjects => 'بيانات المقاييس غير متوفرة';

  @override
  String get loadSubjects => 'تحميل المقاييس';

  @override
  String get somthingWentWrong => 'حدث خطأ ما';

  @override
  String get pleaseEnterPassword => 'يرجى إدخال كلمة المرور الخاصة بك';

  @override
  String get unableToSignIn =>
      'تعذر تسجيل الدخول. يرجى التحقق من رمز الطالب وكلمة المرور.';

  @override
  String get incorrectCredentials =>
      'رمز الطالب أو كلمة المرور غير صحيحة. يرجى المحاولة مرة أخرى.';

  @override
  String get networkError =>
      'خطأ في اتصال الشبكة. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.';

  @override
  String get noExamResultsYet => 'لا توجد نتائج امتحانات متاحة بعد';

  @override
  String get exam => 'امتحان';

  @override
  String coefficient(String value) {
    return 'المعامل: $value';
  }

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get appealRequested => 'تم طلب استئناف';

  @override
  String get appealAvailable => 'الاستئناف متاح';

  @override
  String get timeline => 'الجدول الزمني';

  @override
  String get home => 'الرئيسية';

  @override
  String get weeklyschedule => 'الجدول الأسبوعي';

  @override
  String get transcript => 'كشف العلامات';

  @override
  String get academicHistory => 'السجل الأكاديمي';

  @override
  String get menu => 'القائمة';

  @override
  String get errorGeneric => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String error(String message) {
    return 'خطأ: $message';
  }

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get appearance => 'المظهر';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get myGroups => 'مجموعاتي';

  @override
  String get refreshGroups => 'تحديث المجموعات';

  @override
  String get loadGroups => 'تحميل المجموعات';

  @override
  String get noGroupData => 'لا توجد بيانات للمجموعات متاحة';

  @override
  String get weeklySchedule => 'الجدول الأسبوعي';

  @override
  String get noClassesThisWeek => 'لا توجد دروس مقررة لهذا الأسبوع';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get lecture => 'محاضرة';

  @override
  String get tutorial => 'توجيهي';

  @override
  String get practical => 'تطبيقي';

  @override
  String get noClassesScheduled => 'لا توجد دروس مقررة لهذا الأسبوع';

  @override
  String get notAssignedToGroups =>
      'لم يتم تعيينك لأي مجموعات تربوية حتى الآن.';

  @override
  String section(String name) {
    return 'الفوج: $name';
  }

  @override
  String get academicTranscripts => 'كشوف العلامات الأكاديمية';

  @override
  String get refreshingData => 'جاري تحديث البيانات...';

  @override
  String get selectAcademicYear => 'اختر سنة أكاديمية';

  @override
  String get annualResults => 'النتائج السنوية';

  @override
  String get average => 'المعدل';

  @override
  String get credits => 'الوحدات';

  @override
  String get unknownLevel => 'مستوى غير معروف';

  @override
  String get academicYear => 'السنة الأكاديمية';

  @override
  String academicYearWrapper(String year) {
    return 'السنة الأكاديمية: $year';
  }

  @override
  String get passed => 'اجتاز';

  @override
  String get failed => 'فشل';

  @override
  String hello(String value) {
    return 'مرحبًا، $value';
  }

  @override
  String get subjectsAndCoefficients => 'المواد والمعاملات';

  @override
  String get aboutPage => 'حول تطبيق Progres';

  @override
  String version(String value) {
    return 'الإصدار $value';
  }

  @override
  String get description => 'الوصف';

  @override
  String get descriptionText =>
      'تطبيق Progres هو نسخة مطوّرة وحديثة من منصة Progres/Webetu، تم تطويره بشكل مستقل مع التركيز على تجربة المستخدم. يستخدم مبادئ تصميم Material Design لتوفير تجربة سلسة تتيح للطلاب الجامعيين الوصول إلى معلوماتهم الأكاديمية بسهولة،';

  @override
  String get purpose => 'الهدف';

  @override
  String get purposeText =>
      'الهدف الأساسي من تطبيق Progres هو تقديم بديل أكثر سلاسة وتفاعلية لنظام Progres/Webetu التقليدي. ومن خلال معالجة التحديات المتعلقة بسهولة الاستخدام وتوفير دعم للوضع غير المتصل، يضمن التطبيق للطلبة إمكانية الوصول إلى بياناتهم الأكاديمية في أي وقت ومن أي مكان.';

  @override
  String get license => 'الترخيص';

  @override
  String get licenseText =>
      'تطبيق Progres متاح بموجب ترخيص MIT، مما يتيح التعاون المفتوح والتوزيع بحرية.';

  @override
  String get projectStatus => 'حالة المشروع';

  @override
  String get projectStatusText =>
      'المشروع في حالة صيانة نشطة، مع جهود مستمرة لتحسين الوظائف، والاستجابة لملاحظات المستخدمين، وضمان التوافق مع آخر تحديثات المنصات.';

  @override
  String get contribution => 'المساهمات';

  @override
  String get contributionText =>
      'نرحب بالمساهمات! إذا كنت مهتمًا بتطوير هذا المشروع، يمكنك عمل fork للمستودع، وإجراء التعديلات اللازمة، ثم إرسال طلب دمج (pull request).';

  @override
  String get viewLicense => 'عرض الترخيص';

  @override
  String get viewonGitHub => 'عرض على github';

  @override
  String get myDischarge => 'براءة الذمة';

  @override
  String get refreshDischarge => 'تحديث براءة الذمة';

  @override
  String get loadDischarge => 'تحميل براءة الذمة';

  @override
  String get noDischargeData => 'لا توجد بيانات براءة ذمة متاحة';

  @override
  String get dischargeNotAvailable =>
      'معلومات براءة الذمة غير متاحة في الوقت الحالي.';

  @override
  String get dischargeStatus => 'حالة براءة الذمة';

  @override
  String get dischargeStatusDescription =>
      'حالة براءة الذمة الحالية عبر جميع خدمات الجامعة';

  @override
  String get departmentLevel => 'مستوى القسم';

  @override
  String get departmentDescription => 'تسوية القسم الأكاديمي';

  @override
  String get facultyLibraryLevel => 'مستوى مكتبة الكلية';

  @override
  String get facultyLibraryDescription => 'تسوية كتب ومواد مكتبة الكلية';

  @override
  String get centralLibraryLevel => 'مستوى المكتبة المركزية';

  @override
  String get centralLibraryDescription => 'تسوية كتب ومواد المكتبة المركزية';

  @override
  String get residenceLevel => 'مستوى الإقامة';

  @override
  String get residenceDescription => 'تسوية سكن الإقامة الجامعية';

  @override
  String get scholarshipServiceLevel => 'مستوى خدمة المنح الدراسية';

  @override
  String get scholarshipServiceDescription =>
      'تسوية المنح الدراسية والمساعدات المالية';

  @override
  String get cleared => 'مسوى';

  @override
  String get pending => 'في الانتظار';

  @override
  String get dischargeNotRequiredTitle => 'لا تحتاج براءة ذمة';

  @override
  String get dischargeNotRequiredDescription =>
      'لست مطالباً بإكمال أي إجراءات براءة ذمة في الوقت الحالي. وضعك الأكاديمي لا يتطلب تسوية من خدمات الجامعة.';

  @override
  String get helpIcon => 'مساعدة';

  @override
  String get codeInformationTitle => 'معلومات رمز الطالب';

  @override
  String get codeInformationText =>
      'يمكن العثور على رمز الطالب الخاص بك في كشف النقاط كما هو موضح في الصورة أعلاه. يجب عليك إضافة سنة نجاحك في شهادة البكالوريا مع رمز الطالب الخاص بك عند تسجيل الدخول. على سبيل المثال، إذا كانت سنة البكالوريا هي 2023 ورمزك هو 12345، أدخل: 202312345';

  @override
  String get passwordInformationTitle => 'معلومات كلمة المرور';

  @override
  String get passwordInformationText =>
      'يمكن العثور على كلمة المرور الخاصة بك في كشف النقاط كما هو موضح في الصورة أعلاه.';

  @override
  String get close => 'إغلاق';

  @override
  String get next => 'التالي';

  @override
  String get institution => 'الجامعة';

  @override
  String get specialization => 'التخصص';
}
