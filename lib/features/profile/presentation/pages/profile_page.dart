import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/features/profile/presentation/widgets/academic_periods_card.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    final theme = Theme.of(context);
    
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.claudePrimary),
                  const SizedBox(height: 24),
                  Text(
                    'Loading profile data...',
                    style: TextStyle(color: AppTheme.claudeTextSecondary),
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: AppTheme.claudeTextSecondary),
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
            );
          } else if (state is ProfileLoaded) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header with image and name
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
                      color: AppTheme.claudeSecondary.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Profile image
                        if (state.profileImage != null)
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              image: DecorationImage(
                                image: MemoryImage(
                                  _decodeBase64Image(state.profileImage!),
                                ),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              size: 60,
                              color: AppTheme.claudePrimary,
                            ),
                          ),
                        const SizedBox(height: 24),
                        Text(
                          '${state.basicInfo.prenomLatin} ${state.basicInfo.nomLatin}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${state.basicInfo.prenomArabe} ${state.basicInfo.nomArabe}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppTheme.claudeTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.claudePrimary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Student ID: ${state.detailedInfo.numeroInscription}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Student Stats Summary
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        _buildStatItem(
                          context, 
                          'Level', 
                          state.detailedInfo.niveauLibelleLongLt, 
                          Icons.school
                        ),
                        _buildStatItem(
                          context, 
                          'Year', 
                          state.academicYear.code, 
                          Icons.calendar_today
                        ),
                        _buildStatItem(
                          context, 
                          'Transport', 
                          state.detailedInfo.transportPaye ? 'Paid' : 'Unpaid', 
                          Icons.directions_bus,
                          color: state.detailedInfo.transportPaye ? Colors.green : Colors.red,
                        ),
                      ],
                    ),
                  ),
                  
                  // Personal Information Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppTheme.claudeBorder),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                              'Full Name (Latin)', 
                              '${state.basicInfo.prenomLatin} ${state.basicInfo.nomLatin}'
                            ),
                            _buildInfoRow(
                              'Full Name (Arabic)', 
                              '${state.basicInfo.prenomArabe} ${state.basicInfo.nomArabe}'
                            ),
                            _buildInfoRow('Birth Date', state.basicInfo.dateNaissance),
                            _buildInfoRow('Birth Place', state.basicInfo.lieuNaissance),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Academic Information Section
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Text(
                      'Academic Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: AppTheme.claudeBorder),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Academic Year', state.academicYear.code),
                            _buildInfoRow('Level', state.detailedInfo.niveauLibelleLongLt),
                            _buildInfoRow('Cycle', state.detailedInfo.refLibelleCycle),
                            _buildInfoRow('Registration', state.detailedInfo.numeroInscription),
                            _buildInfoRow('Transport Paid', state.detailedInfo.transportPaye ? 'Yes' : 'No'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Academic Periods Section
                  if (state.academicPeriods.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                      child: Text(
                        'Academic Periods',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildPeriodsCard(state.academicPeriods),
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 48,
                    color: AppTheme.claudeTextSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No profile data available',
                    style: TextStyle(color: AppTheme.claudeTextSecondary),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<ProfileBloc>().add(LoadProfileEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Load Profile'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
  
  Widget _buildStatItem(
    BuildContext context, 
    String title, 
    String value, 
    IconData icon, 
    {Color? color}
  ) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.claudeSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color ?? AppTheme.claudePrimary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? AppTheme.claudeTextPrimary,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.claudeTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.claudeTextSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPeriodsCard(List periods) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.claudeBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: periods.length,
          separatorBuilder: (context, index) => Divider(color: AppTheme.claudeBorder),
          itemBuilder: (context, index) {
            final period = periods[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.claudePrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${period.rang}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          period.code,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          period.libelleLongLt,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.claudeTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.claudeSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      period.libelleLongFrNiveau,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.claudePrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to decode base64 image
  Uint8List _decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
} 