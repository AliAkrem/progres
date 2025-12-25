import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/config/options.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/subject/data/models/course_coefficient.dart';
import 'package:progres/features/subject/presentation/bloc/subject_bloc.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/features/subject/presentation/widgets/assessment_type_row.dart';
import 'package:progres/features/subject/presentation/widgets/error_loading_subject.dart';
import 'package:progres/l10n/app_localizations.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  late final int ouvertureOffreFormationId;
  late final int niveauId;

  @override
  void initState() {
    super.initState();

    final profileState = context.read<ProfileBloc>().state;

    if (profileState is ProfileLoaded) {
      ouvertureOffreFormationId = profileState.detailedInfo.trainingOfferId;
      niveauId = profileState.detailedInfo.levelId;
      _loadSubjects();
    }
  }

  void _loadSubjects() {
    context.read<SubjectBloc>().add(
      LoadSubjectCoefficients(
        ouvertureOffreFormationId: ouvertureOffreFormationId,
        niveauId: niveauId,
      ),
    );
  }

  Future<void> _refreshSubjects() async {
    if (context.read<ProfileBloc>().state is ProfileLoaded) {
      // Clear cache and reload from API
      context.read<SubjectBloc>().add(
        ClearSubjectCache(
          ouvertureOffreFormationId: ouvertureOffreFormationId,
          niveauId: niveauId,
        ),
      );
      context.read<SubjectBloc>().add(
        LoadSubjectCoefficients(
          ouvertureOffreFormationId: ouvertureOffreFormationId,
          niveauId: niveauId,
        ),
      );
    }
    // Simulating network delay for better UX
    return Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.subjectsAndCoefficients),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshSubjects,
            tooltip: 'Refresh subjects',
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState is! ProfileLoaded) {
            return const ErroLoadProfileData();
          }

          return BlocBuilder<SubjectBloc, SubjectState>(
            builder: (context, state) {
              if (state is SubjectLoading) {
                return const LoadingState();
              } else if (state is SubjectError) {
                return ErrorLoadingSubjectState(
                  message: state.message,
                  ouvertureOffreFormationId: ouvertureOffreFormationId,
                  niveauId: niveauId,
                );
              } else if (state is SubjectLoaded) {
                return RefreshIndicator(
                  onRefresh: _refreshSubjects,
                  child: SubjectsContent(
                    coefficients: state.courseCoefficients,
                  ),
                );
              } else {
                return InitialState(onReload: _loadSubjects);
              }
            },
          );
        },
      ),
    );
  }
}

class SubjectsContent extends StatelessWidget {
  final List<CourseCoefficient> coefficients;

  const SubjectsContent({super.key, required this.coefficients});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    Map<String, List<CourseCoefficient>> coursesByPeriod = getCoursesbyPeriod();

    // Sort periods
    final sortedPeriods = coursesByPeriod.keys.toList()..sort();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      child: Column(
        children: [
          // Periods and courses
          for (var period in sortedPeriods) ...[
            // Period header
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 16,
                  vertical: isSmallScreen ? 10 : 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.AppPrimary.withValues(alpha: 0.1),
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

            Card(
              elevation: 1,
              margin: EdgeInsets.only(bottom: isSmallScreen ? 20 : 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: theme.brightness == Brightness.light
                      ? AppTheme.AppBorder
                      : const Color(0xFF3F3C34),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: coursesByPeriod[period]!.length,
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 0,
                    color: Colors.transparent,
                    height: 24,
                  ),
                  itemBuilder: (context, index) {
                    final coefficient = coursesByPeriod[period]![index];
                    final localizedCourseCoefficient =
                        LocalizedCourseCoefficient(
                          courseCoefficient: coursesByPeriod[period]![index],
                          deviceLocal: deviceLocale!,
                        );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            localizedCourseCoefficient.subjectLabel,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: theme.textTheme.titleMedium?.color,
                            ),
                          ),
                        ),
                        AssessmentTypeRow(
                          type: 'Continuous Assessment',
                          coefficient:
                              coefficient.continuousAssessmentCoefficient,
                          typeColor: AppTheme.AppSecondary,
                          theme: theme,
                        ),
                        AssessmentTypeRow(
                          type: 'Intermediate Assessment',
                          coefficient:
                              coefficient.intermediaryAssessmentCoefficient,
                          typeColor: AppTheme.accentBlue,
                          theme: theme,
                        ),
                        AssessmentTypeRow(
                          type: 'Final Examination',
                          coefficient: coefficient.examCoefficient,
                          typeColor: AppTheme.accentGreen,
                          theme: theme,
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

  Map<String, List<CourseCoefficient>> getCoursesbyPeriod() {
    final Map<String, List<CourseCoefficient>> coursesByPeriod = {};

    for (var coefficient in coefficients) {
      final localizedCourseCoefficient = LocalizedCourseCoefficient(
        courseCoefficient: coefficient,
        deviceLocal: deviceLocale!,
      );

      if (!coursesByPeriod.containsKey(
        localizedCourseCoefficient.periodLabel,
      )) {
        coursesByPeriod[localizedCourseCoefficient.periodLabel] = [];
      }
      coursesByPeriod[localizedCourseCoefficient.periodLabel]!.add(coefficient);
    }
    return coursesByPeriod;
  }
}

class InitialState extends StatelessWidget {
  final VoidCallback onReload;

  const InitialState({super.key, required this.onReload});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.errorNoSubjects,
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onReload,
            child: Text(AppLocalizations.of(context)!.loadSubjects),
          ),
        ],
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class ErroLoadProfileData extends StatelessWidget {
  const ErroLoadProfileData({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    return Center(
      child: Text(
        AppLocalizations.of(context)!.errorLoadingProfile,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
      ),
    );
  }
}
