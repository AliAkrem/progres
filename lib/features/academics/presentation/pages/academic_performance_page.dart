import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:progres/features/academics/data/models/exam_result.dart';
import 'package:progres/features/academics/data/models/continuous_assessment.dart';
import 'package:progres/features/academics/presentation/bloc/academics_bloc.dart';
import 'package:progres/features/academics/presentation/widgets/continuous_assessment_card.dart';
import 'package:progres/features/academics/presentation/widgets/exam_results_card.dart';
import 'package:progres/features/profile/data/models/academic_period.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';

class AcademicPerformancePage extends StatefulWidget {
  final int initialTab;
  
  const AcademicPerformancePage({super.key, this.initialTab = 0});

  @override
  State<AcademicPerformancePage> createState() => _AcademicPerformancePageState();
}

class _AcademicPerformancePageState extends State<AcademicPerformancePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);
    
    // Load academic performance data if profile is loaded
    final profileState = context.read<ProfileBloc>().state;
    
    if (profileState is ProfileLoaded) {
      context.read<AcademicsBloc>().add(
            LoadAcademicPerformance(cardId: profileState.detailedInfo.id),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Performance'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Exam Results'),
            Tab(text: 'Continuous Assessment'),
          ],
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState is! ProfileLoaded) {
            return const Center(
              child: Text('Profile data not loaded. Please go back and try again.'),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.message}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AcademicsBloc>().add(
                                LoadAcademicPerformance(
                                  cardId: profileState.detailedInfo.id,
                                ),
                              );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is AcademicsLoaded) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    // Exam Results Tab - Now grouped by period
                    _buildExamsTab(context, profileState, state),
                    
                    // Continuous Assessment Tab
                    _buildAssessmentsTab(context, profileState, state),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Select an academic period to view results'),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildExamsTab(BuildContext context, ProfileLoaded profileState, AcademicsLoaded state) {
    // Group exams by period
    final examsByPeriod = _groupExamsByPeriod(state.examResults);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const SizedBox(height: 24),
          
          if (examsByPeriod.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'No exam results available',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            ...examsByPeriod.entries.map((entry) {
              // Find period name from the profile state
              final periodId = entry.key;
              String periodName = 'Period $periodId';
              
              try {
                final period = profileState.academicPeriods
                    .firstWhere((p) => p.id == periodId);
                periodName = period.libelleLongLt;
              } catch (e) {
                // Not found, use default name
              }
                  
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, 
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      periodName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ExamResultsCard(examResults: entry.value),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildAssessmentsTab(BuildContext context, ProfileLoaded profileState, AcademicsLoaded state) {
    final assessmentsByPeriod = _groupAssessmentsByPeriod(state.continuousAssessments);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const SizedBox(height: 24),
          
          if (assessmentsByPeriod.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'No continuous assessment results available',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            ...assessmentsByPeriod.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, 
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ContinuousAssessmentCard(assessments: entry.value),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
        ],
      ),
    );
  }

  // Helper method to decode base64 image
  Uint8List _decodeBase64Image(String base64String) {
    return base64Decode(base64String);
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
      List<ContinuousAssessment> assessments) {
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