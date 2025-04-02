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
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.language, color: theme.iconTheme.color),
            title: Text('Language', style: theme.textTheme.titleMedium),
            subtitle: Text('English', style: theme.textTheme.bodyMedium),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.iconTheme.color),
            onTap: () {
              // Language settings could be implemented here
            },
          ),
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return ListTile(
                leading: Icon(Icons.dark_mode, color: theme.iconTheme.color),
                title: Text('Theme', style: theme.textTheme.titleMedium),
                subtitle: Text(_getThemeText(state.themeMode), style: theme.textTheme.bodyMedium),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.iconTheme.color),
                onTap: () {
                  _showThemeSelectionDialog(context, state.themeMode);
                },
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: theme.iconTheme.color),
            title: Text('Notifications', style: theme.textTheme.titleMedium),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.iconTheme.color),
            onTap: () {
              // Notification settings could be implemented here
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.info, color: theme.iconTheme.color),
            title: Text('About', style: theme.textTheme.titleMedium),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.iconTheme.color),
            onTap: () {
              // About page could be implemented here
            },
          ),
          const Divider(),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedOut) {
                context.goNamed(AppRouter.login);
              }
            },
            child: ListTile(
              leading: const Icon(Icons.exit_to_app, color: AppTheme.accentRed),
              title: const Text('Logout', style: TextStyle(color: AppTheme.accentRed)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout', style: theme.textTheme.titleLarge),
                    content: Text('Are you sure you want to logout?', style: theme.textTheme.bodyMedium),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<AuthBloc>().add(LogoutEvent());
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

  void _showThemeSelectionDialog(BuildContext context, ThemeMode currentThemeMode) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Theme', style: theme.textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(context, ThemeMode.light, currentThemeMode, 'Light',
                Icons.light_mode),
            _buildThemeOption(context, ThemeMode.dark, currentThemeMode, 'Dark',
                Icons.dark_mode),
            _buildThemeOption(context, ThemeMode.system, currentThemeMode,
                'System default', Icons.settings_suggest),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
    
    // Use a more neutral color for icons in dark mode that contrasts well
    final iconColor = isSelected 
        ? (theme.brightness == Brightness.dark ? Colors.white : AppTheme.claudePrimary)
        : theme.iconTheme.color;

    return ListTile(
      leading: Icon(
        icon, 
        color: iconColor,
      ),
      title: Text(
        title, 
        style: TextStyle(
          color: isSelected 
              ? (theme.brightness == Brightness.dark ? Colors.white : AppTheme.claudePrimary)
              : theme.textTheme.titleMedium?.color,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      trailing: isSelected 
          ? Icon(Icons.check, color: theme.brightness == Brightness.dark ? Colors.white : AppTheme.claudePrimary) 
          : null,
      onTap: () {
        context.read<ThemeBloc>().add(ThemeChanged(themeMode));
        // Navigator.pop(context);
      },
    );
  }
} 