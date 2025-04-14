import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/core/theme/theme_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.language,
              color: theme.iconTheme.color,
              size: isSmallScreen ? 22 : 24,
            ),
            title: Text(
              'Language',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            subtitle: Text(
              'English',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: isSmallScreen ? 14 : 16,
              color: theme.iconTheme.color,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 24,
              vertical: isSmallScreen ? 8 : 12,
            ),
            onTap: () {
              // Language settings could be implemented here
            },
          ),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return ListTile(
                leading: Icon(
                  Icons.dark_mode,
                  color: theme.iconTheme.color,
                  size: isSmallScreen ? 22 : 24,
                ),
                title: Text(
                  'Theme',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
                subtitle: Text(
                  _getThemeText(state.themeMode),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: isSmallScreen ? 14 : 16,
                  color: theme.iconTheme.color,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 24,
                  vertical: isSmallScreen ? 8 : 12,
                ),
                onTap: () {
                  _showThemeSelectionDialog(context, state.themeMode);
                },
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: theme.iconTheme.color,
              size: isSmallScreen ? 22 : 24,
            ),
            title: Text(
              'Notifications',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: isSmallScreen ? 14 : 16,
              color: theme.iconTheme.color,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 24,
              vertical: isSmallScreen ? 8 : 12,
            ),
            onTap: () {
              // Notification settings could be implemented here
            },
          ),
          Divider(height: isSmallScreen ? 8 : 16),
          ListTile(
            leading: Icon(
              Icons.info,
              color: theme.iconTheme.color,
              size: isSmallScreen ? 22 : 24,
            ),
            title: Text(
              'About',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: isSmallScreen ? 14 : 16,
              color: theme.iconTheme.color,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 24,
              vertical: isSmallScreen ? 8 : 12,
            ),
            onTap: () {
              // About page could be implemented here
            },
          ),
          Divider(height: isSmallScreen ? 8 : 16),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedOut) {
                context.goNamed(AppRouter.login);
              }
            },
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: AppTheme.accentRed,
                size: isSmallScreen ? 22 : 24,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: AppTheme.accentRed,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
                vertical: isSmallScreen ? 8 : 12,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text(
                          'Logout',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: isSmallScreen ? 18 : 20,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to logout?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<AuthBloc>().add(
                                LogoutEvent(context: context),
                              );
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System default';
    }
  }

  void _showThemeSelectionDialog(
    BuildContext context,
    ThemeMode currentThemeMode,
  ) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Select Theme',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: isSmallScreen ? 18 : 20,
              ),
            ),
            contentPadding: EdgeInsets.fromLTRB(
              24,
              isSmallScreen ? 16 : 20,
              24,
              isSmallScreen ? 16 : 20,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeOption(
                  context,
                  ThemeMode.light,
                  currentThemeMode,
                  'Light',
                  Icons.light_mode,
                ),
                _buildThemeOption(
                  context,
                  ThemeMode.dark,
                  currentThemeMode,
                  'Dark',
                  Icons.dark_mode,
                ),
                _buildThemeOption(
                  context,
                  ThemeMode.system,
                  currentThemeMode,
                  'System default',
                  Icons.settings_suggest,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeMode themeMode,
    ThemeMode currentThemeMode,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = themeMode == currentThemeMode;
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    // Use a more neutral color for icons in dark mode that contrasts well
    final iconColor =
        isSelected
            ? (theme.brightness == Brightness.dark
                ? Colors.white
                : AppTheme.AppPrimary)
            : theme.iconTheme.color;

    return ListTile(
      leading: Icon(icon, color: iconColor, size: isSmallScreen ? 22 : 24),
      title: Text(
        title,
        style: TextStyle(
          color:
              isSelected
                  ? (theme.brightness == Brightness.dark
                      ? Colors.white
                      : AppTheme.AppPrimary)
                  : theme.textTheme.titleMedium?.color,
          fontWeight: isSelected ? FontWeight.bold : null,
          fontSize: isSmallScreen ? 14 : 16,
        ),
      ),
      trailing:
          isSelected
              ? Icon(
                Icons.check,
                color:
                    theme.brightness == Brightness.dark
                        ? Colors.white
                        : AppTheme.AppPrimary,
                size: isSmallScreen ? 20 : 22,
              )
              : null,
      contentPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 6 : 8,
      ),
      onTap: () {
        context.read<ThemeBloc>().add(ThemeChanged(themeMode));
        // Navigator.pop(context);
      },
    );
  }
}
