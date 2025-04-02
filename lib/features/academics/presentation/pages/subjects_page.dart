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
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;
    
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
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        children: [
          // Program information
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.dividerColor.withOpacity(0.2),
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16, 
                vertical: isSmallScreen ? 10 : 12
              ),
              decoration: BoxDecoration(
                color: AppTheme.claudePrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                period,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.claudePrimary,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
            ),
            
            SizedBox(height: isSmallScreen ? 12 : 16),
            
            // Table header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Subject',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 12 : 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Continuous',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 12 : 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Intermediate',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 12 : 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Final Exam',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 12 : 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // Course rows
            for (var coefficient in coursesByPeriod[period]!)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 10 : 12, 
                  horizontal: isSmallScreen ? 12 : 16
                ),
                child: Row(
                  children: [
                    // Subject name
                    Expanded(
                      flex: 3,
                      child: Text(
                        coefficient.mcLibelleFr,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.titleMedium?.color,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ),
                    
                    // Continuous coefficient
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: _buildCoefficientChip(
                          coefficient.coefficientControleContinu,
                          Colors.green.shade100,
                          Colors.green.shade800,
                        ),
                      ),
                    ),
                    
                    // Intermediate coefficient
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: _buildCoefficientChip(
                          coefficient.coefficientControleIntermediaire,
                          Colors.orange.shade100,
                          Colors.orange.shade800,
                        ),
                      ),
                    ),
                    
                    // Final exam coefficient
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: _buildCoefficientChip(
                          coefficient.coefficientExamen,
                          Colors.blue.shade100,
                          Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            SizedBox(height: isSmallScreen ? 20 : 24),
          ],
        ],
      ),
    );
  }
  
  Widget _buildCoefficientChip(double coefficient, Color bgColor, Color textColor) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    final percentage = (coefficient * 100).toInt();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 6 : 8, 
        vertical: isSmallScreen ? 3 : 4
      ),
      decoration: BoxDecoration(
        color: coefficient > 0 ? bgColor : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
      ),
      child: Text(
        '$percentage%',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: coefficient > 0 ? textColor : Colors.grey.shade700,
          fontSize: isSmallScreen ? 11 : 13,
        ),
      ),
    );
  }
} 