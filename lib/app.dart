import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:progres/config/options.dart';
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
import 'package:progres/features/discharge/presentation/bloc/discharge_bloc.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';

class ProgresApp extends StatelessWidget {
  const ProgresApp({super.key});

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
        BlocProvider(create: (context) => injector<StudentDischargeBloc>()),
      ],
      child: CalendarControllerProvider(
        controller: EventController(),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            final appRouter = AppRouter(context: context);
            return MaterialApp.router(
              title: "Student Portal",
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.themeMode,
              localizationsDelegates:
                  GalleryLocalizations.localizationsDelegates,
              supportedLocales: GalleryLocalizations.supportedLocales,
              localeResolutionCallback: (locale, supportedLocales) {
                return locale != null && supportedLocales.contains(locale)
                    ? locale
                    : supportedLocales.first;
              },
              locale: AppOptions.of(context).locale,
              routerConfig: appRouter.router,
            );
          },
        ),
      ),
    );
  }
}
