import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/l10n/app_localizations.dart';

Widget buildErrorState(ProfileError state, BuildContext context) {
  final theme = Theme.of(context);
  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 360;

  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16.0 : 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: isSmallScreen ? 40 : 48,
            color: AppTheme.accentRed,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.somthingWentWrong,
            style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProfileBloc>().add(LoadProfileEvent());
            },
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    ),
  );
}
