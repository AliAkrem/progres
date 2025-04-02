import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'dart:convert';
import 'dart:typed_data';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load profile data if not already loaded
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is! ProfileLoaded) {
      context.read<ProfileBloc>().add(LoadProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return _buildLoadingState();
          } else if (state is ProfileError) {
            return _buildErrorState(state);
          } else if (state is ProfileLoaded) {
            return _buildDashboard(state);
          } else {
            return _buildInitialState();
          }
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(ProfileError state) {
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
              'Error: ${state.message}',
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
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
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
              color: AppTheme.claudeSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.dashboard_rounded,
              color: AppTheme.claudePrimary,
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

  Widget _buildDashboard(ProfileLoaded state) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final horizontalPadding = isSmallScreen ? 16.0 : 24.0;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with greeting
            Row(
              children: [
                CircleAvatar(
                  radius: isSmallScreen ? 26 : 30,
                  backgroundColor: AppTheme.claudeSecondary,
                  child: state.profileImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(isSmallScreen ? 26 : 30),
                          child: Image.memory(
                            _decodeBase64Image(state.profileImage!),
                            width: isSmallScreen ? 52 : 60,
                            height: isSmallScreen ? 52 : 60,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: isSmallScreen ? 26 : 30,
                          color: AppTheme.claudePrimary,
                        ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${state.basicInfo.prenomLatin}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 20 : 24,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Academic Year: ${state.academicYear.code}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: isSmallScreen ? 13 : 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: isSmallScreen ? 24 : 32),
            
            // Exams Card
            _buildPerformanceCard(
              context,
              title: 'Academic Performance',
              description: 'View your exam results from all semesters',
              icon: Icons.assignment_rounded,
              color: AppTheme.claudePrimary,
              onTap: () => context.goNamed(AppRouter.academicPerformancePath),
            ),
            
            SizedBox(height: isSmallScreen ? 12 : 16),
            
            // Subjects Card
            _buildPerformanceCard(
              context,
              title: 'Subjects & Coefficients',
              description: 'View your course subjects and their assessment weights',
              icon: Icons.school_rounded,
              color: AppTheme.claudePrimary,
              onTap: () => context.goNamed(AppRouter.subjects),
            ),
            
            SizedBox(height: isSmallScreen ? 12 : 16),
            
            // Groups Card
            _buildPerformanceCard(
              context,
              title: 'My Groups',
              description: 'View your pedagogical groups for each semester',
              icon: Icons.group_rounded,
              color: AppTheme.claudePrimary,
              onTap: () => context.goNamed(AppRouter.groups),
            ),
            
            SizedBox(height: isSmallScreen ? 12 : 16),
            
            // Enrollments Card
            _buildPerformanceCard(
              context,
              title: 'Academic History',
              description: 'View your complete academic enrollment history',
              icon: Icons.history_edu_rounded,
              color: AppTheme.claudePrimary,
              onTap: () => context.goNamed(AppRouter.enrollments),
            ),
            
            SizedBox(height: isSmallScreen ? 12 : 16),
            
            // Timeline Card
            _buildPerformanceCard(
              context,
              title: 'Weekly Schedule',
              description: 'View your weekly course timetable',
              icon: Icons.calendar_today_rounded,
              color: AppTheme.claudePrimary,
              onTap: () => context.goNamed(AppRouter.timeline),
            ),

            SizedBox(height: isSmallScreen ? 24 : 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String title, String value, IconData icon) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.brightness == Brightness.light ? AppTheme.claudeBorder.withOpacity(0.5) : const Color(0xFF3F3C34),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: isSmallScreen ? 18 : 20,
                color: theme.textTheme.bodyMedium?.color,
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Text(
                title,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontWeight: FontWeight.w500,
                  fontSize: isSmallScreen ? 13 : 14,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.brightness == Brightness.light ? AppTheme.claudeBorder : const Color(0xFF3F3C34),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Row(
          children: [
            Container(
              width: isSmallScreen ? 50 : 60,
              height: isSmallScreen ? 50 : 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: isSmallScreen ? 26 : 30,
              ),
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 16 : 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isSmallScreen ? 2 : 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: isSmallScreen ? 13 : 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: theme.textTheme.bodyMedium?.color,
              size: isSmallScreen ? 16 : 18,
            ),
          ],
        ),
      ),
    );
  }

  Uint8List _decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
} 