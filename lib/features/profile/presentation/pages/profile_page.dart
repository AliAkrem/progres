import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.goNamed(AppRouter.settings),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return _buildLoadingState();
          } else if (state is ProfileError) {
            return _buildErrorState(state);
          } else if (state is ProfileLoaded) {
            return _buildProfileContent(state);
          } else {
            return _buildLoadingState();
          }
        },
      ),
    );
  }
  
  Widget _buildLoadingState() {
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
  }
  
  Widget _buildErrorState(ProfileError state) {
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
  }
  
  Widget _buildProfileContent(ProfileLoaded state) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          _buildProfileHeader(state, theme),
          const SizedBox(height: 24),

          
          // Status cards
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatusCard(
                    icon: Icons.school_rounded,
                    title: 'Level',
                    value: state.detailedInfo.niveauLibelleLongLt,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatusCard(
                    icon: Icons.calendar_today_rounded,
                    title: 'Academic Year',
                    value: state.academicYear.code,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatusCard(
                    icon: Icons.directions_bus_rounded,
                    title: 'Transport',
                    value: state.detailedInfo.transportPaye ? 'Paid' : 'Unpaid',
                    valueColor: state.detailedInfo.transportPaye ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          
          // Personal Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildInfoSection(
              title: 'Personal Information',
              children: [
                _buildInfoRow('Full Name (Latin)', '${state.basicInfo.prenomLatin} ${state.basicInfo.nomLatin}'),
                _buildInfoRow('Full Name (Arabic)', '${state.basicInfo.prenomArabe} ${state.basicInfo.nomArabe}'),
                _buildInfoRow('Birth Date', state.basicInfo.dateNaissance),
                _buildInfoRow('Birth Place', state.basicInfo.lieuNaissance),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Contact Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildInfoSection(
              title: 'Contact Information',
              children: [
                _buildInfoRow('Email', 'student@university.edu'),
                _buildInfoRow('Phone', 'Not Available'),
                _buildInfoRow('Address', 'Not Available'),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Academic Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildInfoSection(
              title: 'Current Academic Status',
              children: [
                _buildInfoRow('Program', state.detailedInfo.niveauLibelleLongLt),
                _buildInfoRow('Level', state.detailedInfo.niveauLibelleLongLt),
                _buildInfoRow('Cycle', state.detailedInfo.refLibelleCycle),
                _buildInfoRow('Registration Number', state.detailedInfo.numeroInscription),
                _buildInfoRow('Academic Year', state.academicYear.code),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Academic Services
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildInfoSection(
              title: 'Academic Services',
              children: [
                _buildInfoRow('Transport', state.detailedInfo.transportPaye ? 'Paid' : 'Unpaid', 
                  valueColor: state.detailedInfo.transportPaye ? Colors.green : Colors.red,
                ),
                _buildInfoRow('Housing', 'Not Available'),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          

        ],
      ),
    );
  }
  
  Widget _buildProfileHeader(ProfileLoaded state, ThemeData theme) {
    return Container(
      width: double.infinity,
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        children: [
          // Profile image
          Hero(
            tag: 'profile-image',
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: state.profileImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.memory(
                        _decodeBase64Image(state.profileImage!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: AppTheme.claudeSecondary,
                      child: Icon(
                        Icons.person_rounded,
                        size: 60,
                        color: AppTheme.claudePrimary,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          // Student name
          Text(
            '${state.basicInfo.prenomLatin} ${state.basicInfo.nomLatin}',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${state.basicInfo.prenomArabe} ${state.basicInfo.nomArabe}',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.claudeTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.claudeSecondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'ID: ${state.detailedInfo.numeroInscription}',
              style: TextStyle(
                color: AppTheme.claudePrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.claudeBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: AppTheme.claudeTextSecondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.claudeTextSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.claudeBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
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
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppTheme.claudeTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAcademicPeriods(ProfileLoaded state) {
    if (state.academicPeriods.isEmpty) {
      return const SizedBox();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Academic Periods',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.claudeBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.academicPeriods.length,
            separatorBuilder: (context, index) => Divider(
              color: AppTheme.claudeBorder,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final period = state.academicPeriods[index];
              return ListTile(
                title: Text(
                  period.code,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Period ${period.rang}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.claudeTextSecondary,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    period.libelleLongLt,
                    style: TextStyle(
                      color: AppTheme.claudePrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Uint8List _decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
} 