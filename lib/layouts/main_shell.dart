import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/config/theme/app_theme.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);
    
    return Scaffold(
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.claudeBorder,
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: NavigationBar(
                selectedIndex: selectedIndex,
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.surface,
                height: 70,
                destinations: [
                  _buildNavDestination(
                    context,
                    icon: Icons.dashboard_rounded,
                    selectedIcon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                  ),
                  _buildNavDestination(
                    context,
                    icon: Icons.person_outline_rounded,
                    selectedIcon: Icons.person_rounded,
                    label: 'Profile',
                  ),
                ],
                onDestinationSelected: (index) {
                  _onItemTapped(index, context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  NavigationDestination _buildNavDestination(
    BuildContext context, {
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: Icon(
        selectedIcon,
        color: AppTheme.claudePrimary,
      ),
      label: label,
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(AppRouter.dashboardPath)) {
      return 0;
    }
    if (location.startsWith(AppRouter.profilePath)) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(AppRouter.dashboard);
        break;
      case 1:
        context.goNamed(AppRouter.profile);
        break;
    }
  }
} 