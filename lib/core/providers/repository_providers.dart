import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/academics/data/repository/academics_repository_impl.dart';
import 'package:progres/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:progres/features/enrollment/data/repositories/enrollment_repository_impl.dart';
import 'package:progres/features/enrollment/data/services/enrollment_cache_service.dart';
import 'package:progres/features/groups/data/repository/group_repository_impl.dart';
import 'package:progres/features/profile/data/repositories/student_repository_impl.dart';
import 'package:progres/features/subject/data/repositories/subject_repository_impl.dart';
import 'package:progres/features/timeline/data/repositories/timeline_repository_impl.dart';
import 'package:progres/features/timeline/data/services/timeline_cache_service.dart';
import 'package:progres/features/transcript/data/repositories/transcript_repository_impl.dart';
import 'package:progres/features/transcript/data/services/transcript_cache_service.dart';

final class RepositoryProviders {
  static final _apiClient = ApiClient();

  static List<RepositoryProvider> providers() {
    return [
      RepositoryProvider(
        create: (context) => AuthRepositoryImpl(apiClient: _apiClient),
      ),
      RepositoryProvider(
        create: (context) => StudentRepositoryImpl(apiClient: _apiClient),
      ),
      RepositoryProvider(
        create: (context) => TimeLineRepositoryImpl(apiClient: _apiClient),
      ),
      RepositoryProvider(
        create: (context) => StudentGroupsRepositoryImpl(apiClient: _apiClient),
      ),
      RepositoryProvider(
        create: (context) => SubjectRepositoryImpl(apiClient: _apiClient),
      ),
      RepositoryProvider(
        create: (context) => TranscriptRepositoryImpl(apiClient: _apiClient),
      ),
      RepositoryProvider(
        create: (context) => EnrollmentRepositoryImpl(apiClient: _apiClient),
      ),
      RepositoryProvider(
        create: (context) =>
            AcademicPerformencetRepositoryImpl(apiClient: _apiClient),
      ),
      RepositoryProvider(
        create: (context) => TranscriptCacheService(),
      ),
      RepositoryProvider(
        create: (context) => EnrollmentCacheService(),
      ),
      RepositoryProvider(
        create: (context) => TimelineCacheService(),
      ),
    ];
  }
}
