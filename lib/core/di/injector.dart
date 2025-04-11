import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:progres/core/network/api_client.dart';
import 'package:progres/core/theme/theme_bloc.dart';
import 'package:progres/features/academics/data/repository/academics_repository_impl.dart';
import 'package:progres/features/academics/presentation/bloc/academics_bloc.dart';
import 'package:progres/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:progres/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:progres/features/enrollment/data/repositories/enrollment_repository_impl.dart';
import 'package:progres/features/enrollment/data/services/enrollment_cache_service.dart';
import 'package:progres/features/enrollment/presentation/bloc/enrollment_bloc.dart';
import 'package:progres/features/groups/data/repository/group_repository_impl.dart';
import 'package:progres/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:progres/features/profile/data/repositories/student_repository_impl.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/features/subject/data/repositories/subject_repository_impl.dart';
import 'package:progres/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:progres/features/timeline/data/repositories/timeline_repository_impl.dart';
import 'package:progres/features/timeline/data/services/timeline_cache_service.dart';
import 'package:progres/features/timeline/presentation/blocs/timeline_bloc.dart';
import 'package:progres/features/transcript/data/repositories/transcript_repository_impl.dart';
import 'package:progres/features/transcript/data/services/transcript_cache_service.dart';
import 'package:progres/features/transcript/presentation/bloc/transcript_bloc.dart';

final injector = GetIt.instance;

Future<void> initDependencies() async {
  injector.registerLazySingleton(() => kIsWeb ? WebApiClient() :  ApiClient());
  injector
      .registerLazySingleton(() => AuthRepositoryImpl(apiClient: injector()));
  injector.registerLazySingleton(
      () => StudentRepositoryImpl(apiClient: injector()));
  injector.registerLazySingleton(
      () => TimeLineRepositoryImpl(apiClient: injector()));
  injector.registerLazySingleton(
      () => StudentGroupsRepositoryImpl(apiClient: injector()));
  injector.registerLazySingleton(
      () => SubjectRepositoryImpl(apiClient: injector()));
  injector.registerLazySingleton(
      () => TranscriptRepositoryImpl(apiClient: injector()));
  injector.registerLazySingleton(
      () => EnrollmentRepositoryImpl(apiClient: injector()));
  injector.registerLazySingleton(
      () => AcademicPerformencetRepositoryImpl(apiClient: injector()));
  injector.registerLazySingleton(() => TimelineCacheService());
  injector.registerLazySingleton(() => EnrollmentCacheService());
  injector.registerLazySingleton(() => TranscriptCacheService());

  // Register BLoCs
  injector.registerFactory(() => ThemeBloc()..add(LoadTheme()));
  injector.registerFactory(
      () => AuthBloc(authRepository: injector())..add(CheckAuthStatusEvent()));
  injector.registerFactory(() => ProfileBloc(
        studentRepository: injector(),
        authRepository: injector(),
      ));
  injector.registerFactory(() => AcademicsBloc(
        academicPerformanceRepository: injector(),
      ));
  injector.registerFactory(() => StudentGroupsBloc(
        studentGroupsRepository: injector(),
      ));
  injector.registerFactory(() => TimelineBloc(
        timeLineRepositoryImpl: injector(),
      ));
  injector.registerFactory(() => SubjectBloc(
        subjectRepository: injector(),
      ));
  injector.registerFactory(() => TranscriptBloc(
        transcriptRepository: injector(),
        transcriptCacheService: injector(),
        enrollmentCacheService: injector(),
      ));
  injector.registerFactory(() => EnrollmentBloc(
        enrollmentRepository: injector(),
        cacheService: injector(),
      ));
}
