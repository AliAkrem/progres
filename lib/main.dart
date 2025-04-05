import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/core/theme/theme_bloc.dart';
import 'package:progres/features/academics/presentation/bloc/academics_bloc.dart';
import 'package:progres/features/groups/data/repository/student_group_repository_impl.dart';
import 'package:progres/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:progres/features/timeline/data/repositories/timeline_repository_impl.dart';
import 'package:progres/features/timeline/presentation/blocs/timeline_bloc.dart';
import 'package:progres/features/academics/presentation/bloc/transcripts_bloc.dart';
import 'package:progres/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:progres/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:progres/features/profile/data/repositories/student_repository_impl.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/features/academics/data/services/transcript_cache_service.dart';

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
          create: (context) => TimeLineRepositoryImpl(),
        ),
        RepositoryProvider(
          create: (context) => StudentGroupsRepositoryImpl(),
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
            create: (context) => TranscriptsBloc(
              studentRepository: context.read<StudentRepositoryImpl>(),
              cacheService: context.read<TranscriptCacheService>(),
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
