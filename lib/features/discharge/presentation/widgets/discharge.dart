import 'package:flutter/material.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/discharge/data/models/discharge.dart';
import 'package:progres/l10n/app_localizations.dart';

class DischargeContent extends StatelessWidget {
  final StudentDischarge discharge;
  const DischargeContent({super.key, required this.discharge});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(context, isSmallScreen),
          SizedBox(height: isSmallScreen ? 16 : 20),
          _buildDischargeCards(context, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, bool isSmallScreen) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.AppPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isSmallScreen ? 32 : 36,
                height: isSmallScreen ? 32 : 36,
                decoration: BoxDecoration(
                  color: AppTheme.AppPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.assignment_turned_in_outlined,
                  color: AppTheme.AppPrimary,
                  size: isSmallScreen ? 18 : 20,
                ),
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.dischargeStatus,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.AppPrimary,
                    fontSize: isSmallScreen ? 16 : 18,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            AppLocalizations.of(context)!.dischargeStatusDescription,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              color: theme.brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.grey.shade300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDischargeCards(BuildContext context, bool isSmallScreen) {
    return Column(
      children: [
        DischargeCard(
          title: AppLocalizations.of(context)!.departmentLevel,
          description: AppLocalizations.of(context)!.departmentDescription,
          isCleared: discharge.departmentStatus,
          icon: Icons.domain_outlined,
          isSmallScreen: isSmallScreen,
        ),
        SizedBox(height: isSmallScreen ? 10 : 12),
        DischargeCard(
          title: AppLocalizations.of(context)!.facultyLibraryLevel,
          description: AppLocalizations.of(context)!.facultyLibraryDescription,
          isCleared: discharge.facultyLibraryStatus,
          icon: Icons.local_library_outlined,
          isSmallScreen: isSmallScreen,
        ),
        SizedBox(height: isSmallScreen ? 10 : 12),
        DischargeCard(
          title: AppLocalizations.of(context)!.centralLibraryLevel,
          description: AppLocalizations.of(context)!.centralLibraryDescription,
          isCleared: discharge.centralLibraryStatus,
          icon: Icons.library_books_outlined,
          isSmallScreen: isSmallScreen,
        ),
        SizedBox(height: isSmallScreen ? 10 : 12),
        DischargeCard(
          title: AppLocalizations.of(context)!.residenceLevel,
          description: AppLocalizations.of(context)!.residenceDescription,
          isCleared: discharge.residenceStatus,
          icon: Icons.home_outlined,
          isSmallScreen: isSmallScreen,
        ),
        SizedBox(height: isSmallScreen ? 10 : 12),
        DischargeCard(
          title: AppLocalizations.of(context)!.scholarshipServiceLevel,
          description: AppLocalizations.of(
            context,
          )!.scholarshipServiceDescription,
          isCleared: discharge.scholarshipStatus,
          icon: Icons.school_outlined,
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }
}

class DischargeCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isCleared;
  final IconData icon;
  final bool isSmallScreen;

  const DischargeCard({
    super.key,
    required this.title,
    required this.description,
    required this.isCleared,
    required this.icon,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = isCleared ? Colors.green : Colors.orange;
    final statusIcon = isCleared ? Icons.check_circle : Icons.pending;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.brightness == Brightness.light
              ? AppTheme.AppBorder
              : Colors.grey.shade800,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: isSmallScreen ? 36 : 40,
                  height: isSmallScreen ? 36 : 40,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: statusColor,
                    size: isSmallScreen ? 20 : 24,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 2 : 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 11 : 12,
                          color: theme.brightness == Brightness.light
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 10,
                    vertical: isSmallScreen ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: isSmallScreen ? 14 : 16,
                        color: statusColor,
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 6),
                      Text(
                        isCleared
                            ? AppLocalizations.of(context)!.cleared
                            : AppLocalizations.of(context)!.pending,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10 : 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyDischarge extends StatelessWidget {
  const EmptyDischarge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: isSmallScreen ? 56 : 64,
            color: theme.disabledColor,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noDischargeData,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: isSmallScreen ? 18 : 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.dischargeNotAvailable,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ),
        ],
      ),
    );
  }
}

class DischargeNotRequired extends StatelessWidget {
  const DischargeNotRequired({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isSmallScreen ? 80 : 96,
            height: isSmallScreen ? 80 : 96,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: isSmallScreen ? 48 : 56,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.dischargeNotRequiredTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 24 : 32),
            child: Text(
              AppLocalizations.of(context)!.dischargeNotRequiredDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.7,
                ),
                fontSize: isSmallScreen ? 14 : 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
