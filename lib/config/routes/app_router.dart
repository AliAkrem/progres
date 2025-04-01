import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:progres/features/auth/presentation/pages/login_page.dart';
import 'package:progres/features/home/presentation/pages/home_page.dart';
import 'package:progres/features/profile/presentation/pages/profile_page.dart';
import 'package:progres/features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  // Route names as static constants
  static const String login = 'login';
  static const String home = 'home';
  static const String profile = 'profile';
  static const String settings = 'settings';
  
  // Route paths
  static const String loginPath = '/login';
  static const String homePath = '/home';
  static const String profilePath = '/profile';
  static const String settingsPath = '/settings';

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

        // If the user is logged in and is on the login page, redirect to home
        if (authState is AuthSuccess && isLoginRoute) {
          return homePath;
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
        // Shell route for the main app with bottom navigation
        ShellRoute(
          builder: (context, state, child) {
            return ScaffoldWithNavBar(child: child);
          },
          routes: [
            GoRoute(
              path: homePath,
              name: home,
              builder: (context, state) => const HomePage(),
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

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Academic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRouter.homePath)) {
      return 0;
    }
    if (location.startsWith(AppRouter.profilePath)) {
      return 2;
    }
    // Default to "Home" tab index
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(AppRouter.home);
        break;
      case 1:
        // Academic page could be added here
        // For now redirect to home
        context.goNamed(AppRouter.home);
        break;
      case 2:
        context.goNamed(AppRouter.profile);
        break;
    }
  }
} 