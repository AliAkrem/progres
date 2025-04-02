import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/features/academics/presentation/pages/academic_performance_page.dart';
import 'dart:convert';
import 'dart:typed_data';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: AppTheme.claudeTextSecondary),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ProfileBloc>().add(LoadProfileEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ProfileLoaded) {
            return _buildDashboard(state);
          } else {
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
                      Icons.school_rounded,
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
                  const Text(
                    'Loading your profile data...',
                    style: TextStyle(color: AppTheme.claudeTextSecondary),
                  ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Institution Logo if available
          if (state.institutionLogo != null)
            Padding(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.memory(
                    _decodeBase64Image(state.institutionLogo!),
                    height: isSmallScreen ? 50 : 60,
                  ),
                ],
              ),
            ),
          
          // Welcome Card
          Padding(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 20, horizontalPadding, 0),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.claudeBorder),
              ),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                child: Row(
                  children: [
                    state.profileImage != null
                        ? Container(
                            width: isSmallScreen ? 56 : 64,
                            height: isSmallScreen ? 56 : 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: MemoryImage(
                                  _decodeBase64Image(state.profileImage!),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            width: isSmallScreen ? 56 : 64,
                            height: isSmallScreen ? 56 : 64,
                            decoration: const BoxDecoration(
                              color: AppTheme.claudeSecondary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              color: AppTheme.claudePrimary,
                              size: isSmallScreen ? 28 : 32,
                            ),
                          ),
                    SizedBox(width: isSmallScreen ? 12 : 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${state.basicInfo.prenomLatin}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 18 : 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Current Academic Year: ${state.academicYear.code}',
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Section header
          Padding(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 12),
            child: Text(
              'Student Information',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 15 : 16,
              ),
            ),
          ),
          
          // Academic Info Card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.claudeBorder),
              ),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: isSmallScreen ? 36 : 40,
                          height: isSmallScreen ? 36 : 40,
                          decoration: BoxDecoration(
                            color: AppTheme.claudeSecondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.school,
                            color: AppTheme.claudePrimary,
                            size: isSmallScreen ? 20 : 24,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 12 : 16),
                        Text(
                          'Academic Status',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 15 : 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 24),
                    _buildInfoRow('Level', state.detailedInfo.niveauLibelleLongLt),
                    _buildInfoRow('Cycle', state.detailedInfo.refLibelleCycle),
                    _buildInfoRow('Registration', state.detailedInfo.numeroInscription),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Academic Performance Section
          Padding(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 12),
            child: Text(
              'Academic Performance',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 15 : 16,
              ),
            ),
          ),
          
          // Exam Results Card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: InkWell(
              onTap: () {
                // Navigate to exams tab of academic performance
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AcademicPerformancePage(initialTab: 0),
                  ),
                );
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppTheme.claudeBorder),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: isSmallScreen ? 36 : 40,
                            height: isSmallScreen ? 36 : 40,
                            decoration: BoxDecoration(
                              color: AppTheme.claudeSecondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.sticky_note_2_outlined,
                              color: AppTheme.claudePrimary,
                              size: isSmallScreen ? 20 : 24,
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 12 : 16),
                          Expanded(
                            child: Text(
                              'Exam Results',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 15 : 16,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: isSmallScreen ? 14 : 16),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),
                      Text(
                        'View all your exam results across different academic periods',
                        style: TextStyle(
                          color: AppTheme.claudeTextSecondary,
                          fontSize: isSmallScreen ? 13 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: isSmallScreen ? 12 : 16),
          
          // Continuous Assessment Card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: InkWell(
              onTap: () {
                // Navigate to continuous assessment tab of academic performance
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AcademicPerformancePage(initialTab: 1),
                  ),
                );
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppTheme.claudeBorder),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: isSmallScreen ? 36 : 40,
                            height: isSmallScreen ? 36 : 40,
                            decoration: BoxDecoration(
                              color: AppTheme.claudeSecondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.assessment_outlined,
                              color: AppTheme.claudePrimary,
                              size: isSmallScreen ? 20 : 24,
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 12 : 16),
                          Expanded(
                            child: Text(
                              'Continuous Assessment',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 15 : 16,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: isSmallScreen ? 14 : 16),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),
                      Text(
                        'View your continuous assessment marks and assignments',
                        style: TextStyle(
                          color: AppTheme.claudeTextSecondary,
                          fontSize: isSmallScreen ? 13 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Transport Status Card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Card(
              margin: EdgeInsets.only(top: isSmallScreen ? 12 : 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.claudeBorder),
              ),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: isSmallScreen ? 36 : 40,
                          height: isSmallScreen ? 36 : 40,
                          decoration: BoxDecoration(
                            color: AppTheme.claudeSecondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.directions_bus,
                            color: AppTheme.claudePrimary,
                            size: isSmallScreen ? 20 : 24,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 12 : 16),
                        Text(
                          'Transport Status',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 15 : 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 24),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 10 : 12, 
                            vertical: isSmallScreen ? 6 : 8
                          ),
                          decoration: BoxDecoration(
                            color: state.detailedInfo.transportPaye
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                state.detailedInfo.transportPaye
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: state.detailedInfo.transportPaye
                                    ? Colors.green
                                    : Colors.red,
                                size: isSmallScreen ? 18 : 20,
                              ),
                              SizedBox(width: isSmallScreen ? 6 : 8),
                              Text(
                                state.detailedInfo.transportPaye
                                    ? 'Transport Fees Paid'
                                    : 'Transport Fees Not Paid',
                                style: TextStyle(
                                  color: state.detailedInfo.transportPaye
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: isSmallScreen ? 13 : 14,
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
            ),
          ),
          
          // Academic Periods Section
          if (state.academicPeriods.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 12),
              child: Text(
                'Current Periods',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 15 : 16,
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppTheme.claudeBorder),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: isSmallScreen ? 8 : 12,
                        runSpacing: isSmallScreen ? 8 : 12,
                        children: state.academicPeriods.map((period) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 12 : 16, 
                              vertical: isSmallScreen ? 8 : 10
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.claudeSecondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: isSmallScreen ? 22 : 24,
                                  height: isSmallScreen ? 22 : 24,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.claudePrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${period.rang}',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 11 : 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 6 : 8),
                                Text(
                                  period.code,
                                  style: TextStyle(
                                    color: AppTheme.claudePrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: isSmallScreen ? 13 : 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          
          // Bottom padding
          SizedBox(height: isSmallScreen ? 24 : 32),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.claudeTextSecondary,
                fontWeight: FontWeight.w500,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to decode base64 image
  Uint8List _decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
} 