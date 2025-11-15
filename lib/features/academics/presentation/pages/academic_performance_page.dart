import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/academics/data/models/exam_result.dart';
import 'package:progres/features/academics/data/models/continuous_assessment.dart';
import 'package:progres/features/academics/presentation/bloc/academics_bloc.dart';
import 'package:progres/features/academics/presentation/widgets/continuous_assessment_card.dart';
import 'package:progres/features/academics/presentation/widgets/exam_results_card.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/l10n/gallery_localizations.dart';

class AcademicPerformancePage extends StatefulWidget {
  final int initialTab;

  const AcademicPerformancePage({super.key, this.initialTab = 0});

  @override
  State<AcademicPerformancePage> createState() =>
      _AcademicPerformancePageState();
}

class _AcademicPerformancePageState extends State<AcademicPerformancePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );

    _loadAcademicData(forceRefresh: false);
  }

  void _loadAcademicData({bool forceRefresh = false}) {
    // Load academic performance data if profile is loaded
    final profileState = context.read<ProfileBloc>().state;

    if (profileState is ProfileLoaded) {
      context.read<AcademicsBloc>().add(
        LoadAcademicPerformance(
          cardId: profileState.detailedInfo.id,
          forceRefresh: forceRefresh,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.academicPerformancePageTitle,
        ),
        actions: [
          BlocBuilder<AcademicsBloc, AcademicsState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: AppLocalizations.of(context)!.refreshData,
                onPressed:
                    state is AcademicsLoading
                        ? null
                        : () => _loadAcademicData(forceRefresh: true),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: AppLocalizations.of(context)!.examResults,
              height: isSmallScreen ? 40 : 46,
            ),
            Tab(
              text: AppLocalizations.of(context)!.assessment,
              height: isSmallScreen ? 40 : 46,
            ),
          ],
          labelStyle: TextStyle(
            fontSize: isSmallScreen ? 13 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState is! ProfileLoaded) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.errorLoadingProfile,
              ),
            );
          }

          return BlocBuilder<AcademicsBloc, AcademicsState>(
            builder: (context, state) {
              if (state is AcademicsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AcademicsError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16.0 : 24.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.somthingWentWrong,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed:
                              () => _loadAcademicData(forceRefresh: true),
                          child: Text(AppLocalizations.of(context)!.retry),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is AcademicsLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    _loadAcademicData(forceRefresh: true);
                  },
                  child: Column(
                    children: [
                      if (state.fromCache)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: theme.colorScheme.secondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                AppLocalizations.of(context)!.cachedData,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.secondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Exam Results Tab - Now grouped by period
                            _buildExamsTab(context, profileState, state),

                            // Continuous Assessment Tab
                            _buildAssessmentsTab(context, profileState, state),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.selectPeriodForResults,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildExamsTab(
    BuildContext context,
    ProfileLoaded profileState,
    AcademicsLoaded state,
  ) {
    // Group exams by period
    final examsByPeriod = _groupExamsByPeriod(state.examResults);
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: isSmallScreen ? 16 : 24),
          if (examsByPeriod.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 24.0 : 32.0),
                child: Text(
                  AppLocalizations.of(context)!.noExamResults,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: theme.textTheme.bodyMedium?.color,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
            )
          else
            ...examsByPeriod.entries.map((entry) {
              // Find period name from the profile state
              final periodId = entry.key;
              String periodName =
                  '${AppLocalizations.of(context)!.defaultPeriodName} $periodId';

              try {
                final period = profileState.academicPeriods.firstWhere(
                  (p) => p.id == periodId,
                );
                periodName = period.libelleLongLt;
              } catch (e) {
                // Not found, use default name
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                      periodName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.AppPrimary,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  ExamResultsCard(examResults: entry.value),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                ],
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildAssessmentsTab(
    BuildContext context,
    ProfileLoaded profileState,
    AcademicsLoaded state,
  ) {
    final assessmentsByPeriod = _groupAssessmentsByPeriod(
      state.continuousAssessments,
    );
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: isSmallScreen ? 16 : 24),
          if (assessmentsByPeriod.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 24.0 : 32.0),
                child: Text(
                  AppLocalizations.of(context)!.noContinuousAssessment,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: theme.textTheme.bodyMedium?.color,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
            )
          else
            ...assessmentsByPeriod.entries.map((entry) {
              String periodName = entry.key;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                      periodName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.AppPrimary,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  ContinuousAssessmentCard(assessments: entry.value),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                ],
              );
            }).toList(),
        ],
      ),
    );
  }

  // Helper method to group exams by period
  Map<int, List<ExamResult>> _groupExamsByPeriod(List<ExamResult> exams) {
    final result = <int, List<ExamResult>>{};

    for (final exam in exams) {
      if (!result.containsKey(exam.idPeriode)) {
        result[exam.idPeriode] = [];
      }
      result[exam.idPeriode]!.add(exam);
    }

    return result;
  }

  // Helper method to group assessments by period
  Map<String, List<ContinuousAssessment>> _groupAssessmentsByPeriod(
    List<ContinuousAssessment> assessments,
  ) {
    final result = <String, List<ContinuousAssessment>>{};

    for (final assessment in assessments) {
      if (!result.containsKey(assessment.llPeriode)) {
        result[assessment.llPeriode] = [];
      }
      result[assessment.llPeriode]!.add(assessment);
    }

    return result;
  }
}
