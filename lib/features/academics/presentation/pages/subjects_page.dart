import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/academics/data/models/course_coefficient.dart';
import 'package:progres/features/academics/presentation/bloc/academics_bloc.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  @override
  void initState() {
    super.initState();
    
    // Load course coefficients if profile is loaded
    final profileState = context.read<ProfileBloc>().state;
    
    if (profileState is ProfileLoaded) {
      context.read<AcademicsBloc>().add(
            LoadCourseCoefficients(
              ouvertureOffreFormationId: profileState.detailedInfo.ouvertureOffreFormationId,
              niveauId: profileState.detailedInfo.niveauId,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subjects & Coefficients'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState is! ProfileLoaded) {
            return Center(
              child: Text(
                'Profile data not loaded. Please go back and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              ),
            );
          }
          
          return BlocBuilder<AcademicsBloc, AcademicsState>(
            builder: (context, state) {
              if (state is AcademicsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AcademicsError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16.0 : 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${state.message}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AcademicsBloc>().add(
                                  LoadCourseCoefficients(
                                    ouvertureOffreFormationId: profileState.detailedInfo.ouvertureOffreFormationId,
                                    niveauId: profileState.detailedInfo.niveauId,
                                  ),
                                );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is AcademicsLoaded && state.courseCoefficients != null) {
                // Build the subjects page with periods and courses
                return _buildSubjectsContent(context, state.courseCoefficients!);
              } else {
                return Center(
                  child: Text(
                    'No subject data available',
                    style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildSubjectsContent(BuildContext context, List<CourseCoefficient> coefficients) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    // Group courses by period
    final Map<String, List<CourseCoefficient>> coursesByPeriod = {};
    for (var coefficient in coefficients) {
      if (!coursesByPeriod.containsKey(coefficient.periodeLibelleFr)) {
        coursesByPeriod[coefficient.periodeLibelleFr] = [];
      }
      coursesByPeriod[coefficient.periodeLibelleFr]!.add(coefficient);
    }
    
    // Sort periods
    final sortedPeriods = coursesByPeriod.keys.toList()..sort();
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      child: Column(
        children: [
          // Program information
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: theme.brightness == Brightness.light 
                  ? AppTheme.AppBorder 
                  : const Color(0xFF3F3C34)
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coefficients by Subject',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 18 : 20,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Text(
                    'These coefficients define how each assessment type contributes to your final grade for each subject.',
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                      fontSize: isSmallScreen ? 13 : 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: isSmallScreen ? 20 : 24),
          
          // Periods and courses
          for (var period in sortedPeriods) ...[
            // Period header
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16, 
                  vertical: isSmallScreen ? 10 : 12
                ),
                decoration: BoxDecoration(
                  color: AppTheme.AppPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.AppPrimary,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
            ),
            
            // Card for subjects in this period
            Card(
              elevation: 1,
              margin: EdgeInsets.only(bottom: isSmallScreen ? 20 : 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: theme.brightness == Brightness.light 
                    ? AppTheme.AppBorder 
                    : const Color(0xFF3F3C34)
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: coursesByPeriod[period]!.length,
                  separatorBuilder: (context, index) => const Divider(thickness: 0, color: Colors.transparent, height: 24),
                  itemBuilder: (context, index) {
                    final coefficient = coursesByPeriod[period]![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subject name
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            coefficient.mcLibelleFr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: theme.textTheme.titleMedium?.color,
                            ),
                          ),
                        ),
                        
                        // Assessment types
                        _buildAssessmentTypeRow(
                          'Continuous Assessment',
                          coefficient.coefficientControleContinu,
                          AppTheme.accentGreen,
                          theme
                        ),
                        
                        _buildAssessmentTypeRow(
                          'Intermediate Assessment',
                          coefficient.coefficientControleIntermediaire,
                          AppTheme.AppSecondary, 
                          theme
                        ),
                        
                        _buildAssessmentTypeRow(
                          'Final Examination',
                          coefficient.coefficientExamen,
                          AppTheme.accentBlue,
                          theme
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildAssessmentTypeRow(String type, double coefficient, Color typeColor, ThemeData theme) {
    final percentage = (coefficient * 100).toInt();
    
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: typeColor),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: typeColor,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              indent: 8,
              color: theme.brightness == Brightness.light 
                  ? null 
                  : const Color(0xFF3F3C34),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: coefficient > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: typeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$percentage%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  )
                : Text(
                    'N/A',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
} 