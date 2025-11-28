import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';
import 'package:progres/features/enrollment/presentation/bloc/enrollment_bloc.dart';
import 'package:progres/features/enrollment/presentation/bloc/enrollment_event.dart';
import 'package:progres/features/enrollment/presentation/bloc/enrollment_state.dart';
import 'package:progres/l10n/app_localizations.dart';

class EnrollmentsPage extends StatefulWidget {
  const EnrollmentsPage({super.key});

  @override
  State<EnrollmentsPage> createState() => _EnrollmentsPageState();
}

class _EnrollmentsPageState extends State<EnrollmentsPage> {
  @override
  void initState() {
    super.initState();

    // Load enrollments when page is opened
    context.read<EnrollmentBloc>().add(const LoadEnrollmentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.academicHistory),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppLocalizations.of(context)!.refreshData,
            onPressed: () {
              context.read<EnrollmentBloc>().add(
                const LoadEnrollmentsEvent(forceRefresh: true),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.refreshingData),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<EnrollmentBloc, EnrollmentState>(
        builder: (context, state) {
          if (state is EnrollmentLoading || state is EnrollmentInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EnrollmentError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppLocalizations.of(context)!.somthingWentWrong),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<EnrollmentBloc>().add(
                        const LoadEnrollmentsEvent(),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
                ],
              ),
            );
          } else if (state is EnrollmentsLoaded) {
            if (state.enrollments.isEmpty) {
              return Center(
                child: Text(AppLocalizations.of(context)!.errorNoEnrollments),
              );
            }

            return _buildEnrollmentsList(context, state.enrollments);
          } else {
            return Center(
              child: Text(AppLocalizations.of(context)!.somthingWentWrong),
            );
          }
        },
      ),
    );
  }

  Widget _buildEnrollmentsList(
    BuildContext context,
    List<Enrollment> enrollments,
  ) {
    // Sort enrollments by academic year (newest first)
    final sortedEnrollments = List<Enrollment>.from(enrollments)
      ..sort((a, b) => b.anneeAcademiqueId.compareTo(a.anneeAcademiqueId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline of enrollments
          for (var enrollment in sortedEnrollments) ...[
            _buildEnrollmentCard(context, enrollment),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildEnrollmentCard(BuildContext context, Enrollment enrollment) {
    final theme = Theme.of(context);

    final localizedEnrollment = LocalizedEnrollment(
      enrollment: enrollment,
      deviceLocale: Localizations.localeOf(context),
    );

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.brightness == Brightness.light
              ? AppTheme.AppBorder
              : Colors.grey.shade800,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Academic year header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.AppPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                enrollment.anneeAcademiqueCode,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Institution
            Row(
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 18,
                  color: theme.brightness == Brightness.light
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    localizedEnrollment.llEtablissement,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 18,
                  color: theme.brightness == Brightness.light
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${localizedEnrollment.refLibelleCycle.toUpperCase()} - ${localizedEnrollment.niveauLibelleLong}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),

                      Text(
                        localizedEnrollment.ofLlDomaine,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),

                      Text(
                        '${localizedEnrollment.ofLlFiliere}: ${localizedEnrollment.ofLlSpecialite}',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Registration number
            if (enrollment.numeroInscription != null)
              Row(
                children: [
                  Icon(
                    Icons.credit_card_outlined,
                    size: 18,
                    color: theme.brightness == Brightness.light
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.registrationNumber,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        Text(
                          enrollment.numeroInscription!,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
