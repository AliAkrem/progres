import 'package:flutter/material.dart';
import 'package:progres/l10n/gallery_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';
import 'package:progres/features/enrollment/presentation/bloc/enrollment_bloc.dart';
import 'package:progres/features/enrollment/presentation/bloc/enrollment_event.dart';
import 'package:progres/features/enrollment/presentation/bloc/enrollment_state.dart';
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

    // Load enrollment data for latest enrollment
    context.read<EnrollmentBloc>().add(const LoadEnrollmentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.goNamed(AppRouter.settings),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          return BlocBuilder<EnrollmentBloc, EnrollmentState>(
            builder: (context, enrollmentState) {
              // Get latest enrollment if available
              Enrollment? latestEnrollment;
              if (enrollmentState is EnrollmentsLoaded &&
                  enrollmentState.enrollments.isNotEmpty) {
                // Sort enrollments by academic year (newest first)
                final sortedEnrollments =
                    List<Enrollment>.from(enrollmentState.enrollments)..sort(
                      (a, b) =>
                          b.anneeAcademiqueId.compareTo(a.anneeAcademiqueId),
                    );
                latestEnrollment = sortedEnrollments.first;
              }

              if (profileState is ProfileLoading) {
                return _buildLoadingState();
              } else if (profileState is ProfileError) {
                return _buildErrorState(profileState);
              } else if (profileState is ProfileLoaded) {
                return _buildProfileContent(profileState, latestEnrollment);
              } else {
                return _buildLoadingState();
              }
            },
          );
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
            AppLocalizations.of(context)!.loadingProfileData,
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

  Widget _buildProfileContent(
    ProfileLoaded state,
    Enrollment? latestEnrollment,
  ) {
    // Make sure we have the required imports and parameters
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final horizontalPadding = isSmallScreen ? 16.0 : 24.0;
    final deviceLocale = Localizations.localeOf(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          _buildProfileHeader(state, theme),
          SizedBox(height: isSmallScreen ? 16 : 24),

          // Academic Information
          if (latestEnrollment != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: _buildInfoSection(
                title: AppLocalizations.of(context)!.currentAcademicStatus,
                children: [
                  _buildInfoRow(
                    AppLocalizations.of(context)!.academicYear,
                    latestEnrollment.anneeAcademiqueCode,
                  ),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.institution,
                    deviceLocale.languageCode == 'ar'
                        ? latestEnrollment.llEtablissementArabe ?? ''
                        : latestEnrollment.llEtablissementLatin ?? '',
                  ),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.level,
                    deviceLocale.languageCode == 'ar'
                        ? latestEnrollment.niveauLibelleLongAr ?? ''
                        : latestEnrollment.niveauLibelleLongLt ?? '',
                  ),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.program,
                    deviceLocale.languageCode == 'ar'
                        ? latestEnrollment.ofLlDomaineArabe ?? ''
                        : latestEnrollment.ofLlDomaine ?? '',
                  ),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.specialization,
                    deviceLocale.languageCode == 'ar'
                        ? latestEnrollment.ofLlSpecialiteArabe ?? ''
                        : latestEnrollment.ofLlSpecialite ?? '',
                  ),
                  if (latestEnrollment.numeroInscription != null)
                    _buildInfoRow(
                      AppLocalizations.of(context)!.registrationNumber,
                      latestEnrollment.numeroInscription!,
                    ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
          ] else ...[
            // Fallback to existing profile data if enrollment not available
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: _buildInfoSection(
                title: AppLocalizations.of(context)!.currentAcademicStatus,
                children: [
                  _buildInfoRow(
                    AppLocalizations.of(context)!.academicYear,
                    state.academicYear.code,
                  ),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.level,
                    state.detailedInfo.niveauLibelleLongLt,
                  ),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.cycle,
                    state.detailedInfo.refLibelleCycle,
                  ),
                  _buildInfoRow(
                    AppLocalizations.of(context)!.registrationNumber,
                    state.detailedInfo.numeroInscription,
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ProfileLoaded state, ThemeData theme) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final deviceLocale = Localizations.localeOf(context);

    return Container(
      width: double.infinity,
      color: theme.colorScheme.surface,
      padding: EdgeInsets.fromLTRB(
        isSmallScreen ? 16 : 24,
        isSmallScreen ? 12 : 16,
        isSmallScreen ? 16 : 24,
        isSmallScreen ? 20 : 24,
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
                border: Border.all(
                  color: theme.brightness == Brightness.light
                      ? Colors.white
                      : const Color(0xFF3F3C34),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: state.profileImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 50 : 60,
                      ),
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
          // Student name in Latin
          Text(
            '${state.basicInfo.prenomLatin} ${state.basicInfo.nomLatin}',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 20 : 24,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Student name in Arabic
          Text(
            '${state.basicInfo.prenomArabe} ${state.basicInfo.nomArabe}',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          // Birth info
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8,
            runSpacing: 12,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: theme.brightness == Brightness.light
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    state.basicInfo.dateNaissance,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 14,
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: theme.brightness == Brightness.light
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    deviceLocale.languageCode == 'ar'
                        ? state.basicInfo.lieuNaissanceArabe
                        : state.basicInfo.lieuNaissance,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 14,
                      color: theme.textTheme.bodyMedium?.color?.withValues(
                        alpha: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.directions_bus_rounded,
                    size: 16,
                    color: theme.brightness == Brightness.light
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    AppLocalizations.of(context)!.transport + ": ",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 14,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  Text(
                    state.detailedInfo.transportPaye
                        ? AppLocalizations.of(context)!.paid
                        : AppLocalizations.of(context)!.unpaid,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: state.detailedInfo.transportPaye
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
            border: Border.all(
              color: theme.brightness == Brightness.light
                  ? AppTheme.AppBorder
                  : const Color(0xFF3F3C34),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
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
