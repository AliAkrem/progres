import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/core/theme/theme_bloc.dart';
import 'package:progres/features/academics/presentation/bloc/academics_bloc.dart';
import 'package:progres/features/groups/data/repository/group_repository_impl.dart';
import 'package:progres/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:progres/features/timeline/data/repositories/timeline_repository_impl.dart';
import 'package:progres/features/timeline/presentation/blocs/timeline_bloc.dart';
import 'package:progres/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:progres/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:progres/features/profile/data/repositories/student_repository_impl.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/features/subject/data/repositories/subject_repository_impl.dart';
import 'package:progres/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/transcript/data/repositories/transcript_repository_impl.dart';
import 'package:progres/features/transcript/data/services/transcript_cache_service.dart';
import 'package:progres/features/transcript/presentation/bloc/transcript_bloc.dart';
import 'package:progres/features/enrollment/data/services/enrollment_cache_service.dart';
import 'package:progres/features/timeline/data/services/timeline_cache_service.dart';
import 'package:progres/features/enrollment/data/repositories/enrollment_repository_impl.dart';
import 'package:progres/features/enrollment/presentation/bloc/enrollment_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepositoryImpl(),
        ),
        RepositoryProvider(
          create: (context) => StudentRepositoryImpl(),
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
        RepositoryProvider(
          create: (context) => TimeLineRepositoryImpl(),
        ),
        RepositoryProvider(
          create: (context) => StudentGroupsRepositoryImpl(),
        ),
        RepositoryProvider(
          create: (context) => SubjectRepositoryImpl(apiClient: ApiClient()),
        ),
        RepositoryProvider(
          create: (context) => TranscriptRepositoryImpl(apiClient: ApiClient()),
        ),
        RepositoryProvider(
          create: (context) => EnrollmentRepositoryImpl(apiClient: ApiClient()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepositoryImpl>(),
            )..add(CheckAuthStatusEvent()),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(
              studentRepository: context.read<StudentRepositoryImpl>(),
              authRepository: context.read<AuthRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (context) => AcademicsBloc(
              studentRepository: context.read<StudentRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (context) => StudentGroupsBloc(
              studentGroupsRepository: context.read<StudentGroupsRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (context) => TimelineBloc(
              timeLineRepositoryImpl: context.read<TimeLineRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (context) => SubjectBloc(
              subjectRepository: context.read<SubjectRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (context) => TranscriptBloc(
              transcriptRepository: context.read<TranscriptRepositoryImpl>(),
              transcriptCacheService: context.read<TranscriptCacheService>(),
              enrollmentCacheService: context.read<EnrollmentCacheService>(),
            ),
          ),
          BlocProvider(
            create: (context) => EnrollmentBloc(
              enrollmentRepository: context.read<EnrollmentRepositoryImpl>(),
              cacheService: context.read<EnrollmentCacheService>(),
            ),
          ),
          BlocProvider(
            create: (context) => ThemeBloc()..add(LoadTheme()),
          ),
        ],
        child: CalendarControllerProvider(
          controller: EventController(),
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              final appRouter = AppRouter(context: context);
              return MaterialApp.router(
                title: 'Student Portal',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                routerConfig: appRouter.router,
              );
            },
          ),
        ),
      ),
    );
  }
}
