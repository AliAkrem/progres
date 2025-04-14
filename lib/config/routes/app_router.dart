import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/features/academics/presentation/pages/academic_performance_page.dart';
import 'package:progres/features/groups/presentation/pages/groups_page.dart';
import 'package:progres/features/subject/presentation/pages/subject_page.dart';
import 'package:progres/features/timeline/presentation/pages/timeline_page.dart';
import 'package:progres/features/transcript/presentation/pages/transcript_page.dart';
import 'package:progres/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:progres/features/auth/presentation/pages/login_page.dart';
import 'package:progres/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:progres/features/enrollment/presentation/pages/enrollments_page.dart';
import 'package:progres/features/profile/presentation/pages/profile_page.dart';
import 'package:progres/features/settings/presentation/pages/settings_page.dart';
import 'package:progres/layouts/main_shell.dart';

class AppRouter {
  // Route names as static constants
  static const String login = 'login';
  static const String dashboard = 'dashboard';
  static const String profile = 'profile';
  static const String settings = 'settings';
  static const String academicPerformance = 'academic_performance';
  static const String assessments = 'assessments';
  static const String subjects = 'subjects';
  static const String groups = 'groups';
  static const String enrollments = 'enrollments';
  static const String timeline = 'timeline';
  static const String transcripts = 'transcripts';

  // Route paths
  static const String loginPath = '/login';
  static const String dashboardPath = '/dashboard';
  static const String profilePath = '/profile';
  static const String settingsPath = '/settings';
  static const String academicPerformancePath = 'academic_performance';
  static const String assessmentsPath = '/assessments';
  static const String subjectsPath = 'subjects';
  static const String groupsPath = 'groups';
  static const String enrollmentsPath = 'enrollments';
  static const String timelinePath = 'timeline';
  static const String transcriptsPath = 'transcripts';

  late final GoRouter router;

  AppRouter({required BuildContext context}) {
    router = GoRouter(
      initialLocation: loginPath,
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state;
        final isLoginRoute = state.matchedLocation == loginPath;

        // If the user is not logged in and is not on the login page, redirect to login
        if (authState is! AuthSuccess && !isLoginRoute) {
          return loginPath;
        }

        // If the user is logged in and is on the login page, redirect to dashboard
        if (authState is AuthSuccess && isLoginRoute) {
          return dashboardPath;
        }

        // Otherwise, no redirection needed
        return null;
      },
      routes: [
        GoRoute(
          path: loginPath,
          name: login,
          builder: (context, state) => const LoginPage(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return MainShell(child: child);
          },
          routes: [
            GoRoute(
              path: dashboardPath,
              name: dashboard,
              builder: (context, state) => const DashboardPage(),
              routes: [
                GoRoute(
                  path: academicPerformancePath,
                  name: academicPerformance,
                  builder: (context, state) => const AcademicPerformancePage(),
                ),
                GoRoute(
                  path: subjectsPath,
                  name: subjects,
                  builder: (context, state) => const SubjectPage(),
                ),
                GoRoute(
                  path: groupsPath,
                  name: groups,
                  builder: (context, state) => const GroupsPage(),
                ),
                GoRoute(
                  path: enrollmentsPath,
                  name: enrollments,
                  builder: (context, state) => const EnrollmentsPage(),
                ),
                GoRoute(
                  path: timelinePath,
                  name: timeline,
                  builder: (context, state) => const TimelinePage(),
                ),
                GoRoute(
                  path: transcriptsPath,
                  name: transcripts,
                  builder: (context, state) => const TranscriptPage(),
                ),
              ],
            ),
            GoRoute(
              path: profilePath,
              name: profile,
              builder: (context, state) => const ProfilePage(),
            ),
            GoRoute(
              path: settingsPath,
              name: settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    );
  }
}
