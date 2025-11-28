import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/debts/data/models/academic_year_debt.dart';
import 'package:progres/features/debts/presentation/bloc/debts_bloc.dart';
import 'package:progres/features/debts/presentation/bloc/debts_event.dart';
import 'package:progres/features/debts/presentation/bloc/debts_state.dart';
import 'package:progres/features/debts/presentation/widgets/debt_course_card.dart';
import 'package:progres/features/debts/presentation/widgets/year_summary_card.dart';
import 'package:progres/l10n/app_localizations.dart';

class DebtsPage extends StatefulWidget {
  const DebtsPage({super.key});

  @override
  State<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  @override
  void initState() {
    super.initState();
    // Load debts when page is opened
    BlocProvider.of<DebtsBloc>(context).add(const LoadDebts());
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
        title: Text(AppLocalizations.of(context)!.academicDebts),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.refreshData,
            onPressed: () {
              context.read<DebtsBloc>().add(
                const LoadDebts(forceRefresh: true),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.refreshingData),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<DebtsBloc, DebtsState>(
        builder: (context, state) {
          if (state is DebtsInitial || state is DebtsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.AppPrimary),
            );
          } else if (state is DebtsEmpty) {
            return _buildEmptyState(theme);
          } else if (state is DebtsError) {
            return _buildErrorState(theme, state.message);
          } else if (state is DebtsLoaded) {
            return _buildDebtsView(state, theme);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: AppTheme.accentGreen,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noDebts,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppTheme.accentGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.noDebtsDescription,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: AppTheme.accentRed),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.somthingWentWrong,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebtsView(DebtsLoaded state, ThemeData theme) {
    // Calculate total debts
    final totalDebts = state.debts.fold<int>(
      0,
      (sum, year) => sum + year.dette.length,
    );

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

          // Summary card
          Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: theme.brightness == Brightness.light
                    ? AppTheme.AppBorder
                    : const Color(0xFF3F3C34),
              ),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.accentRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          size: 24,
                          color: AppTheme.accentRed,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.debtsSummary,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppTheme.accentRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSummaryItem(
                          context,
                          AppLocalizations.of(context)!.totalDebts,
                          totalDebts.toString(),
                          Icons.school_outlined,
                        ),
                        _buildSummaryItem(
                          context,
                          AppLocalizations.of(context)!.academicYears,
                          state.debts.length.toString(),
                          Icons.calendar_today,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Debts by year
          ...state.debts.map((yearDebt) => _buildYearSection(yearDebt, theme)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: AppTheme.accentRed),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.accentRed,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildYearSection(AcademicYearDebt yearDebt, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Year header
        YearSummaryCard(year: yearDebt.annee, debtCount: yearDebt.dette.length),

        const SizedBox(height: 12),

        // Debt courses
        ...yearDebt.dette.map((course) => DebtCourseCard(course: course)),

        const SizedBox(height: 16),
      ],
    );
  }
}
