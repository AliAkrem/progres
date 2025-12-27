import 'package:get_it/get_it.dart';
import 'package:progres/core/network/api_client.dart';
import 'package:progres/core/theme/theme_bloc.dart';
import 'package:progres/features/academics/data/repository/academics_repository_impl.dart';
import 'package:progres/features/academics/domain/repositories/academics_repository.dart';
import 'package:progres/features/academics/domain/usecases/get_continuous_assessments.dart';
import 'package:progres/features/academics/domain/usecases/get_exam_results.dart';
import 'package:progres/features/academics/presentation/bloc/academics_bloc.dart';
import 'package:progres/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:progres/features/auth/domain/repositories/auth_repository.dart';
import 'package:progres/features/auth/domain/usecases/is_logged_in.dart';
import 'package:progres/features/auth/domain/usecases/login.dart';
import 'package:progres/features/auth/domain/usecases/logout.dart';
import 'package:progres/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:progres/features/auth/domain/usecases/get_establishment_id.dart';
import 'package:progres/features/debts/data/repositories/debts_repository_impl.dart';
import 'package:progres/features/debts/data/services/debts_cache_service.dart';
import 'package:progres/features/debts/domain/repositories/debts_repository.dart';
import 'package:progres/features/debts/domain/usecases/get_student_debts.dart';
import 'package:progres/features/debts/presentation/bloc/debts_bloc.dart';
import 'package:progres/features/discharge/data/repository/discharge_repository_impl.dart';
import 'package:progres/features/discharge/domain/repositories/discharge_repository.dart';
import 'package:progres/features/discharge/domain/usecases/get_student_discharge.dart';
import 'package:progres/features/discharge/presentation/bloc/discharge_bloc.dart';
import 'package:progres/features/enrollment/data/repositories/enrollment_repository_impl.dart';
import 'package:progres/features/enrollment/data/services/enrollment_cache_service.dart';
import 'package:progres/features/enrollment/domain/repositories/enrollment_repository.dart';
import 'package:progres/features/enrollment/domain/usecases/get_student_enrollments.dart';
import 'package:progres/features/enrollment/presentation/bloc/enrollment_bloc.dart';
import 'package:progres/features/groups/data/repository/group_repository_impl.dart';
import 'package:progres/features/groups/data/services/groups_cache_service.dart';
import 'package:progres/features/groups/domain/repositories/group_repository.dart';
import 'package:progres/features/groups/domain/usecases/get_student_groups.dart';
import 'package:progres/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:progres/features/profile/data/repositories/student_repository_impl.dart';
import 'package:progres/features/profile/data/services/profile_cache_service.dart';
import 'package:progres/features/profile/domain/repositories/student_repository.dart';
import 'package:progres/features/profile/domain/usecases/get_academic_periods.dart';
import 'package:progres/features/profile/domain/usecases/get_current_academic_year.dart';
import 'package:progres/features/profile/domain/usecases/get_institution_logo.dart';
import 'package:progres/features/profile/domain/usecases/get_student_basic_info.dart';
import 'package:progres/features/profile/domain/usecases/get_student_detailed_info.dart';
import 'package:progres/features/profile/domain/usecases/get_student_profile_image.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/features/subject/data/repositories/subject_repository_impl.dart';
import 'package:progres/features/subject/data/services/subject_cache_service.dart';
import 'package:progres/features/subject/domain/repositories/subject_repository.dart';
import 'package:progres/features/subject/domain/usecases/get_course_coefficients.dart';
import 'package:progres/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:progres/features/timeline/data/repositories/timeline_repository_impl.dart';
import 'package:progres/features/timeline/data/services/timeline_cache_service.dart';
import 'package:progres/features/timeline/domain/repositories/timeline_repository.dart';
import 'package:progres/features/timeline/domain/usecases/get_weekly_timetable.dart';
import 'package:progres/features/timeline/presentation/blocs/timeline_bloc.dart';
import 'package:progres/features/transcript/data/repositories/transcript_repository_impl.dart';
import 'package:progres/features/transcript/data/services/transcript_cache_service.dart';
import 'package:progres/features/transcript/domain/repositories/transcript_repository.dart';
import 'package:progres/features/transcript/domain/usecases/get_academic_transcripts.dart';
import 'package:progres/features/transcript/domain/usecases/get_annual_transcript_summary.dart';
import 'package:progres/features/transcript/presentation/bloc/transcript_bloc.dart';

final injector = GetIt.instance;

Future<void> initDependencies() async {
  // Blocs
  injector.registerFactory(
    () => AuthBloc(
      loginUseCase: injector(),
      logoutUseCase: injector(),
      isLoggedInUseCase: injector(),
    )..add(CheckAuthStatusEvent()),
  );
  injector.registerFactory(
    () => ProfileBloc(
      getStudentBasicInfo: injector(),
      getCurrentAcademicYear: injector(),
      getStudentDetailedInfo: injector(),
      getStudentProfileImage: injector(),
      getInstitutionLogo: injector(),
      getAcademicPeriods: injector(),
      getEstablishmentId: injector(),
      cacheService: injector(),
    ),
  );
  injector.registerFactory(
    () => AcademicsBloc(
      getExamResults: injector(),
      getContinuousAssessments: injector(),
    ),
  );
  injector.registerFactory(
    () => DebtsBloc(
      getStudentDebts: injector(),
      debtsCacheService: injector(),
    ),
  );
  injector.registerFactory(
    () => StudentDischargeBloc(
      getStudentDischarge: injector(),
    ),
  );
  injector.registerFactory(
    () => EnrollmentBloc(
      getStudentEnrollments: injector(),
      cacheService: injector(),
    ),
  );
  injector.registerFactory(
    () => StudentGroupsBloc(
      getStudentGroups: injector(),
      cacheService: injector(),
    ),
  );
  injector.registerFactory(
    () => SubjectBloc(
      getCourseCoefficients: injector(),
      cacheService: injector(),
    ),
  );
  injector.registerFactory(
    () => TimelineBloc(
      getWeeklyTimetable: injector(),
      timelineCacheService: injector(),
    ),
  );
  injector.registerFactory(
    () => TranscriptBloc(
      getStudentEnrollments: injector(),
      getAcademicTranscripts: injector(),
      getAnnualTranscriptSummary: injector(),
      transcriptCacheService: injector(),
      enrollmentCacheService: injector(),
    ),
  );

  // Use cases
  injector.registerLazySingleton(() => Login(injector()));
  injector.registerLazySingleton(() => Logout(injector()));
  injector.registerLazySingleton(() => IsLoggedIn(injector()));
  injector.registerLazySingleton(() => GetEstablishmentIdUseCase(injector()));
  injector.registerLazySingleton(() => GetStudentBasicInfo(injector()));
  injector.registerLazySingleton(() => GetCurrentAcademicYear(injector()));
  injector.registerLazySingleton(() => GetStudentDetailedInfo(injector()));
  injector.registerLazySingleton(() => GetStudentProfileImage(injector()));
  injector.registerLazySingleton(() => GetInstitutionLogo(injector()));
  injector.registerLazySingleton(() => GetAcademicPeriods(injector()));
  injector.registerLazySingleton(() => GetExamResults(injector()));
  injector.registerLazySingleton(() => GetContinuousAssessments(injector()));
  injector.registerLazySingleton(() => GetStudentDebts(injector()));
  injector.registerLazySingleton(() => GetStudentDischarge(injector()));
  injector.registerLazySingleton(() => GetStudentEnrollments(injector()));
  injector.registerLazySingleton(() => GetStudentGroups(injector()));
  injector.registerLazySingleton(() => GetCourseCoefficients(injector()));
  injector.registerLazySingleton(() => GetWeeklyTimetable(injector()));
  injector.registerLazySingleton(
      () => GetAcademicTranscripts(injector()));
  injector.registerLazySingleton(
      () => GetAnnualTranscriptSummary(injector()));

  // Repositories
  injector.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(apiClient: injector()),
  );
  injector.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(apiClient: injector()),
  );
  injector.registerLazySingleton<AcademicPerformanceRepository>(
    () => AcademicPerformanceRepositoryImpl(apiClient: injector()),
  );
  injector.registerLazySingleton<DebtsRepository>(
    () => DebtsRepositoryImpl(apiClient: injector()),
  );
  injector.registerLazySingleton<StudentDischargeRepository>(
    () => StudentDischargeRepositoryImpl(),
  );
  injector.registerLazySingleton<EnrollmentRepository>(
    () => EnrollmentRepositoryImpl(apiClient: injector()),
  );
  injector.registerLazySingleton<StudentGroupsRepository>(
    () => StudentGroupsRepositoryImpl(apiClient: injector()),
  );
  injector.registerLazySingleton<SubjectRepository>(
    () => SubjectRepositoryImpl(apiClient: injector()),
  );
  injector.registerLazySingleton<TimeLineRepository>(
    () => TimeLineRepositoryImpl(apiClient: injector()),
  );
  injector.registerLazySingleton<TranscriptRepository>(
    () => TranscriptRepositoryImpl(apiClient: injector()),
  );
  injector.registerLazySingleton(() => ApiClient());
  injector.registerLazySingleton(() => TimelineCacheService());
  injector.registerLazySingleton(() => EnrollmentCacheService());
  injector.registerLazySingleton(() => TranscriptCacheService());
  injector.registerLazySingleton(() => GroupsCacheService());
  injector.registerLazySingleton(() => SubjectCacheService());
  injector.registerLazySingleton(() => DebtsCacheService());

  // Register BLoCs
  injector.registerFactory(() => ThemeBloc()..add(LoadTheme()));

  injector.registerFactory(() => ProfileCacheService());
}
