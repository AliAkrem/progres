import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:progres/config/routes/app_router.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/dashboard/presentation/widgets/card.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';

Widget buildDashboard(ProfileLoaded state, BuildContext context) {
  final theme = Theme.of(context);
  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 360;
  final horizontalPadding = isSmallScreen ? 16.0 : 24.0;
  final studentName =
      Localizations.localeOf(context).languageCode == 'ar'
          ? state.basicInfo.prenomArabe
          : state.basicInfo.prenomLatin;

  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Padding(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: isSmallScreen ? 26 : 30,
                backgroundColor: AppTheme.AppSecondary,
                child:
                    state.profileImage != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 26 : 30,
                          ),
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
                          color: AppTheme.AppPrimary,
                        ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      GalleryLocalizations.of(context)!.hello(studentName),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 20 : 24,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      GalleryLocalizations.of(
                        context,
                      )!.academicYearWrapper(state.academicYear.code),
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

          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: isSmallScreen ? 10 : 16,
              mainAxisSpacing: isSmallScreen ? 10 : 16,
              childAspectRatio: isSmallScreen ? 0.9 : 1.0,
            ),
            children: [
              buildGridCard(
                context,
                title:
                    GalleryLocalizations.of(
                      context,
                    )!.academicPerformancePageTitle,
                icon: Icons.assignment_rounded,
                color: AppTheme.AppPrimary,
                onTap: () => context.goNamed(AppRouter.academicPerformancePath),
              ),
              buildGridCard(
                context,
                title:
                    GalleryLocalizations.of(context)!.subjectsAndCoefficients,
                icon: Icons.school_rounded,
                color: AppTheme.AppPrimary,
                onTap: () => context.goNamed(AppRouter.subjects),
              ),
              buildGridCard(
                context,
                title: GalleryLocalizations.of(context)!.myGroups,
                icon: Icons.group_rounded,
                color: AppTheme.AppPrimary,
                onTap: () => context.goNamed(AppRouter.groups),
              ),
              buildGridCard(
                context,
                title: GalleryLocalizations.of(context)!.academicHistory,
                icon: Icons.history_edu_rounded,
                color: AppTheme.AppPrimary,
                onTap: () => context.goNamed(AppRouter.enrollments),
              ),
              buildGridCard(
                context,
                title: GalleryLocalizations.of(context)!.weeklySchedule,
                icon: Icons.calendar_today_rounded,
                color: AppTheme.AppPrimary,
                onTap: () => context.goNamed(AppRouter.timeline),
              ),
              buildGridCard(
                context,
                title: GalleryLocalizations.of(context)!.academicTranscripts,
                icon: Icons.menu_book_rounded,
                color: AppTheme.AppPrimary,
                onTap: () => context.goNamed(AppRouter.transcripts),
              ),
            ],
          ),

          SizedBox(height: isSmallScreen ? 24 : 32),
        ],
      ),
    ),
  );
}

Uint8List _decodeBase64Image(String base64String) {
  return base64Decode(base64String);
}
