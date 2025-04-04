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
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppTheme.AppPrimary),
          const SizedBox(height: 24),
          Text(
            'Loading profile data...',
            style: TextStyle(color: theme.textTheme.bodyMedium?.color),
          ),
        ],
      ),
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
              Icons.error_outline,
              size: isSmallScreen ? 40 : 48,
              color: Colors.red.shade400,
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
  
  Widget _buildProfileContent(ProfileLoaded state) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final horizontalPadding = isSmallScreen ? 16.0 : 24.0;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          _buildProfileHeader(state, theme),
          SizedBox(height: isSmallScreen ? 16 : 24),

          
          // Status cards
          Padding(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, isSmallScreen ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Status',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                _buildUnifiedStatusCard(
                  theme: theme,
                  isSmallScreen: isSmallScreen,
                  levelValue: state.detailedInfo.niveauLibelleLongLt,
                  academicYearValue: state.academicYear.code,
                  transportPaid: state.detailedInfo.transportPaye,
                ),
              ],
            ),
          ),
          
          // Personal Information
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
          
          SizedBox(height: isSmallScreen ? 16 : 24),
          
          
          // Academic Information
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
          
          SizedBox(height: isSmallScreen ? 16 : 24),
 
          

        ],
      ),
    );
  }
  
  Widget _buildProfileHeader(ProfileLoaded state, ThemeData theme) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    return Container(
      width: double.infinity,
      color: theme.colorScheme.surface,
      padding: EdgeInsets.fromLTRB(
        isSmallScreen ? 16 : 24, 
        isSmallScreen ? 12 : 16, 
        isSmallScreen ? 16 : 24, 
        isSmallScreen ? 20 : 24
      ),
      child: Column(
        children: [
          // Profile image
          Hero(
            tag: 'profile-image',
            child: Container(
              width: isSmallScreen ? 100 : 120,
              height: isSmallScreen ? 100 : 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.brightness == Brightness.light ? Colors.white : const Color(0xFF3F3C34), width: 4),
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
                      borderRadius: BorderRadius.circular(isSmallScreen ? 50 : 60),
                      child: Image.memory(
                        _decodeBase64Image(state.profileImage!),
                        fit: BoxFit.cover,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: AppTheme.AppSecondary,
                      child: Icon(
                        Icons.person_rounded,
                        size: isSmallScreen ? 50 : 60,
                        color: AppTheme.AppPrimary,
                      ),
                    ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          // Student name
          Text(
            '${state.basicInfo.prenomLatin} ${state.basicInfo.nomLatin}',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 20 : 24,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${state.basicInfo.prenomArabe} ${state.basicInfo.nomArabe}',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: isSmallScreen ? 14 : 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 10 : 12),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 14 : 16, 
              vertical: isSmallScreen ? 6 : 8
            ),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.light ? AppTheme.AppSecondary.withOpacity(0.1) : AppTheme.AppSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'ID: ${state.detailedInfo.numeroInscription}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isSmallScreen ? 13 : 14,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildUnifiedStatusCard({
    required ThemeData theme,
    required bool isSmallScreen,
    required String levelValue,
    required String academicYearValue,
    required bool transportPaid,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.brightness == Brightness.light ? AppTheme.AppBorder : const Color(0xFF3F3C34)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Column(
          children: [
            _buildStatusRow(
              theme: theme,
              isSmallScreen: isSmallScreen,
              icon: Icons.school_rounded,
              title: 'Level',
              value: levelValue,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
              child: Divider(
                color: theme.brightness == Brightness.light 
                  ? Colors.black.withOpacity(0.1) 
                  : Colors.white.withOpacity(0.1),
                height: 1,
              ),
            ),
            _buildStatusRow(
              theme: theme,
              isSmallScreen: isSmallScreen,
              icon: Icons.calendar_today_rounded,
              title: 'Academic Year',
              value: academicYearValue,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
              child: Divider(
                color: theme.brightness == Brightness.light 
                  ? Colors.black.withOpacity(0.1) 
                  : Colors.white.withOpacity(0.1),
                height: 1,
              ),
            ),
            _buildStatusRow(
              theme: theme,
              isSmallScreen: isSmallScreen,
              icon: Icons.directions_bus_rounded,
              title: 'Transport',
              value: transportPaid ? 'Paid' : 'Unpaid',
              valueColor: transportPaid ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusRow({
    required ThemeData theme,
    required bool isSmallScreen,
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: isSmallScreen ? 18 : 20,
          color: theme.brightness == Brightness.light ? AppTheme.AppPrimary.withOpacity(0.7) : AppTheme.AppPrimary,
        ),
        SizedBox(width: isSmallScreen ? 12 : 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 14,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: valueColor ?? theme.textTheme.titleMedium?.color,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildInfoSection({
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.brightness == Brightness.light ? AppTheme.AppBorder : const Color(0xFF3F3C34)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          SizedBox(height: isSmallScreen ? 3 : 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: valueColor ?? theme.textTheme.titleMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
  
  Uint8List _decodeBase64Image(String base64String) {
    return base64Decode(base64String);
  }
} 