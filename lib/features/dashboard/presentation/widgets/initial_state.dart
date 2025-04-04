import 'package:flutter/material.dart';
import 'package:progres/config/theme/app_theme.dart';

Widget buildInitialState(BuildContext context) {
  final theme = Theme.of(context);
  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 360;

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: isSmallScreen ? 50 : 60,
          height: isSmallScreen ? 50 : 60,
          decoration: const BoxDecoration(
            color: AppTheme.AppSecondary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.dashboard_rounded,
            color: AppTheme.AppPrimary,
            size: isSmallScreen ? 26 : 32,
          ),
        ),
        SizedBox(height: isSmallScreen ? 16 : 24),
        Text(
          'Welcome!',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: isSmallScreen ? 26 : 32,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Loading your dashboard...',
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        ),
        const SizedBox(height: 24),
        const CircularProgressIndicator(),
      ],
    ),
  );
}
