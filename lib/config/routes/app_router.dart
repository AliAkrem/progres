import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/features/academics/presentation/pages/academic_performance_page.dart';
import 'package:progres/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:progres/features/auth/presentation/pages/login_page.dart';
import 'package:progres/features/home/presentation/pages/home_page.dart';
import 'package:progres/features/profile/presentation/pages/profile_page.dart';
import 'package:progres/features/settings/presentation/pages/settings_page.dart';
import 'package:progres/config/theme/app_theme.dart';

class AppRouter {
  // Route names as static constants
  static const String login = 'login';
  static const String home = 'home';
  static const String profile = 'profile';
  static const String settings = 'settings';
  static const String academics = 'academics';
  
  // Route paths
  static const String loginPath = '/login';
  static const String homePath = '/home';
  static const String profilePath = '/profile';
  static const String settingsPath = '/settings';
  static const String academicsPath = '/academics';

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
        // Add academics as a standalone route
        GoRoute(
          path: academicsPath,
          name: academics,
          builder: (context, state) => const AcademicPerformancePage(),
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
    final int selectedIndex = _calculateSelectedIndex(context);
    
    return Scaffold(
      body: Column(
        children: [
          // Claude-style app header
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36, 
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.claudeSecondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.school_rounded,
                          color: AppTheme.claudePrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Student Portal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.claudeTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      context.goNamed(AppRouter.settings);
                    },
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context, 
                  0, 
                  selectedIndex, 
                  Icons.home_outlined, 
                  Icons.home,
                  'Home',
                  () => context.goNamed(AppRouter.home),
                ),
                _buildNavItem(
                  context, 
                  1, 
                  selectedIndex, 
                  Icons.person_outline, 
                  Icons.person,
                  'Profile',
                  () => context.goNamed(AppRouter.profile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    int selectedIndex,
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    VoidCallback onTap,
  ) {
    final bool isSelected = index == selectedIndex;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected 
            ? BoxDecoration(
                color: AppTheme.claudeSecondary,
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected ? AppTheme.claudePrimary : AppTheme.claudeTextSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.claudePrimary : AppTheme.claudeTextSecondary,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRouter.homePath)) {
      return 0;
    }
    if (location.startsWith(AppRouter.profilePath)) {
      return 1;
    }
    // Default to "Home" tab index
    return 0;
  }
} 