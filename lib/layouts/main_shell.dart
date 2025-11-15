import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/l10n/gallery_localizations.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow:
              theme.brightness == Brightness.dark
                  ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            elevation: 0,
            backgroundColor: theme.colorScheme.surface,
            height: 70,
            indicatorColor: AppTheme.AppPrimary.withValues(alpha: 0.15),
            destinations: [
              _buildNavDestination(
                context,
                icon: Icons.dashboard_rounded,
                selectedIcon: Icons.dashboard_rounded,
                label: AppLocalizations.of(context)!.tabTitleDashboard,
              ),
              _buildNavDestination(
                context,
                icon: Icons.person_outline_rounded,
                selectedIcon: Icons.person_rounded,
                label: AppLocalizations.of(context)!.tabTitleProfile,
              ),
            ],
            onDestinationSelected: (index) {
              _onItemTapped(index, context);
            },
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
    final theme = Theme.of(context);

    return NavigationDestination(
      icon: Icon(
        icon,
        color:
            theme.brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[600],
      ),
      selectedIcon: Icon(selectedIcon, color: AppTheme.AppPrimary),
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
