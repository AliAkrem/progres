import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/core/di/injector.dart';
import 'package:progres/core/theme/theme_bloc.dart';
import 'package:progres/features/academics/presentation/bloc/academics_bloc.dart';
import 'package:progres/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:progres/features/enrollment/presentation/bloc/enrollment_bloc.dart';
import 'package:progres/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:progres/features/timeline/presentation/blocs/timeline_bloc.dart';
import 'package:progres/features/transcript/presentation/bloc/transcript_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => injector<ThemeBloc>()),
        BlocProvider(create: (context) => injector<AuthBloc>()),
        BlocProvider(create: (context) => injector<ProfileBloc>()),
        BlocProvider(create: (context) => injector<AcademicsBloc>()),
        BlocProvider(create: (context) => injector<StudentGroupsBloc>()),
        BlocProvider(create: (context) => injector<TimelineBloc>()),
        BlocProvider(create: (context) => injector<SubjectBloc>()),
        BlocProvider(create: (context) => injector<TranscriptBloc>()),
        BlocProvider(create: (context) => injector<EnrollmentBloc>()),
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
    );
  }
}
