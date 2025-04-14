import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/transcript/data/models/academic_transcript.dart';
import 'package:progres/features/transcript/presentation/bloc/transcript_bloc.dart';
import 'package:progres/features/transcript/presentation/bloc/transcript_event.dart';
import 'package:progres/features/transcript/presentation/bloc/transcript_state.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';
import 'package:progres/features/transcript/presentation/widgets/result_item.dart';
import 'package:progres/features/transcript/presentation/widgets/status_badge.dart';
import 'package:progres/features/transcript/presentation/widgets/semester_info_chip.dart';

class TranscriptPage extends StatefulWidget {
  const TranscriptPage({super.key});

  @override
  State<TranscriptPage> createState() => _TranscriptPageState();
}

class _TranscriptPageState extends State<TranscriptPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<Enrollment> _enrollments = [];
  int _currentIndex = 0;
  bool _isTabControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    // Load enrollments when page is opened
    BlocProvider.of<TranscriptBloc>(context).add(const LoadEnrollments());
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Academic Transcripts'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
            onPressed: () {
              if (_enrollments.isNotEmpty) {
                // Force refresh current data
                context.read<TranscriptBloc>().add(
                  LoadTranscripts(
                    enrollmentId: _enrollments[_currentIndex].id,
                    enrollment: _enrollments[_currentIndex],
                    forceRefresh: true,
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Refreshing data...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<TranscriptBloc, TranscriptState>(
        listener: (context, state) {
          if (state is EnrollmentsLoaded && !_isTabControllerInitialized) {
            setState(() {
              _enrollments = state.enrollments;
              if (_enrollments.isNotEmpty) {
                _tabController = TabController(
                  length: _enrollments.length,
                  vsync: this,
                );
                _isTabControllerInitialized = true;

                _tabController!.addListener(() {
                  if (!_tabController!.indexIsChanging) {
                    setState(() {
                      _currentIndex = _tabController!.index;
                    });
                    _loadTranscriptsForCurrentEnrollment();
                  }
                });

                // Load first enrollment data
                _loadTranscriptsForCurrentEnrollment();
              }
            });
          }
        },
        builder: (context, state) {
          if (state is TranscriptInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.AppPrimary),
            );
          } else if (state is TranscriptError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: theme.textTheme.bodyLarge,
              ),
            );
          } else if (_enrollments.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.AppPrimary),
            );
          } else {
            return _buildContent(state, theme);
          }
        },
      ),
    );
  }

  void _loadTranscriptsForCurrentEnrollment() {
    if (_enrollments.isNotEmpty) {
      final enrollment = _enrollments[_currentIndex];

      // Load both transcripts and annual summary in a single request
      context.read<TranscriptBloc>().add(
        LoadTranscripts(enrollmentId: enrollment.id, enrollment: enrollment),
      );
    }
  }

  Widget _buildContent(TranscriptState state, ThemeData theme) {
    return Column(
      children: [
        // Year tabs
        if (_tabController != null)
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppTheme.AppSecondary,
            tabs:
                _enrollments.map((enrollment) {
                  return Tab(text: enrollment.anneeAcademiqueCode);
                }).toList(),
          ),

        // Main content
        Expanded(
          child:
              state is TranscriptLoading
                  ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.AppPrimary,
                    ),
                  )
                  : state is TranscriptsLoaded
                  ? _buildTranscriptsView(state, theme)
                  : Center(
                    child: Text(
                      'Select an academic year',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ),
        ),
      ],
    );
  }

  Widget _buildTranscriptsView(TranscriptsLoaded state, ThemeData theme) {
    // Extract annual summary if available
    final annualSummary = state.annualSummary;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cached data indicator
          if (state.fromCache)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
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
                    'Cached data',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Combined card with Annual Results and Level & Year info
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color:
                    theme.brightness == Brightness.light
                        ? AppTheme.AppBorder
                        : const Color(0xFF3F3C34),
              ),
            ),
            child: Column(
              children: [
                // Annual Results section
                if (annualSummary != null)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.AppPrimary.withValues(alpha: 0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      border: const Border(
                        bottom: BorderSide(color: AppTheme.AppBorder, width: 1),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.stars_rounded,
                                size: 24,
                                color: AppTheme.AppPrimary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'ANNUAL RESULTS',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppTheme.AppPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ResultItem(
                                label: 'Average',
                                value: annualSummary.moyenne.toStringAsFixed(2),
                                color: AppTheme.AppPrimary,
                                icon: Icons.bar_chart_rounded,
                                compact: true,
                              ),
                              ResultItem(
                                label: 'Credits',
                                value: annualSummary.creditAcquis.toString(),
                                color: AppTheme.accentBlue,
                                icon: Icons.school_rounded,
                                compact: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          StatusBadge(
                            status: annualSummary.typeDecisionLibelleFr,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Level & Year info section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.school,
                            size: 18,
                            color: AppTheme.AppPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.selectedEnrollment.niveauLibelleLongLt ??
                                'Unknown Level',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: theme.textTheme.titleMedium?.color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Academic Year: ${state.selectedEnrollment.anneeAcademiqueCode}',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Transcripts Content
          ...state.transcripts
              .map((transcript) => _buildSemesterCard(transcript, theme))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildSemesterCard(AcademicTranscript transcript, ThemeData theme) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color:
              theme.brightness == Brightness.light
                  ? AppTheme.AppBorder
                  : const Color(0xFF3F3C34),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Semester header with title and stats
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 18,
                  color: AppTheme.AppPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  transcript.periodeLibelleFr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                const Spacer(),
                SemesterInfoChip(
                  label: 'Avg: ${transcript.moyenne.toStringAsFixed(2)}',
                  color: AppTheme.AppPrimary,
                ),
                const SizedBox(width: 6),
                SemesterInfoChip(
                  label: 'CR: ${transcript.creditAcquis}',
                  color: AppTheme.accentBlue,
                ),
              ],
            ),

            const SizedBox(height: 21),

            // Teaching Units
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transcript.bilanUes.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder:
                  (context, index) =>
                      _buildTeachingUnit(transcript.bilanUes[index], theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeachingUnit(TranscriptUnit unit, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Unit header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getUeColor(unit.ueNatureLcFr),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                unit.ueNatureLcFr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getUeColor(unit.ueNatureLcFr).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: _getUeColor(unit.ueNatureLcFr)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Avg: ${unit.moyenne.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getUeColor(unit.ueNatureLcFr),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'CR: ${unit.creditAcquis}/${unit.credit}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: _getUeColor(unit.ueNatureLcFr),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Modules
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: unit.bilanMcs.length,
          itemBuilder:
              (context, index) => _buildModuleRow(unit.bilanMcs[index], theme),
        ),
      ],
    );
  }

  Widget _buildModuleRow(TranscriptModuleComponent module, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module name
          Text(
            module.mcLibelleFr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 16),

          // Coef info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.AppBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Coef: ${module.coefficient}',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'CR: ${module.creditObtenu}',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Divider(
                  indent: 8,
                  endIndent: 8,
                  color:
                      theme.brightness == Brightness.light
                          ? null
                          : const Color(0xFF3F3C34),
                ),
              ),

              // Grade
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getGradeColor(module.moyenneGenerale),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  module.moyenneGenerale.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getUeColor(String ueType) {
    switch (ueType) {
      case 'U.E.F':
        return AppTheme.accentBlue;
      case 'U.E.M':
        return AppTheme.accentGreen;
      case 'U.E.D':
        return AppTheme.accentYellow;
      case 'U.E.T':
        return AppTheme.AppSecondary;
      default:
        return AppTheme.AppTextSecondary;
    }
  }

  Color _getGradeColor(double grade) {
    if (grade < 10) {
      return AppTheme.accentRed;
    } else if (grade >= 10) {
      return AppTheme.accentGreen;
    } else {
      return AppTheme.accentRed;
    }
  }
}
