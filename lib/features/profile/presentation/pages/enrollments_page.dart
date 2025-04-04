import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/profile/data/models/enrollment.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';

class EnrollmentsPage extends StatefulWidget {
  const EnrollmentsPage({super.key});

  @override
  State<EnrollmentsPage> createState() => _EnrollmentsPageState();
}

class _EnrollmentsPageState extends State<EnrollmentsPage> {
  @override
  void initState() {
    super.initState();
    
    // Load enrollments if profile is loaded
    final profileState = context.read<ProfileBloc>().state;
    
    if (profileState is ProfileLoaded && profileState.enrollments == null) {
      context.read<ProfileBloc>().add(LoadEnrollmentsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic History'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(LoadEnrollmentsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ProfileLoaded) {
            if (state.enrollments == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (state.enrollments!.isEmpty) {
              return const Center(
                child: Text('No enrollment history available'),
              );
            }
            
            return _buildEnrollmentsList(context, state.enrollments!);
          } else {
            return const Center(
              child: Text('Please load your profile data first'),
            );
          }
        },
      ),
    );
  }

  Widget _buildEnrollmentsList(BuildContext context, List<Enrollment> enrollments) {

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
            if (enrollment.llEtablissementLatin != null)
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
                      enrollment.llEtablissementLatin!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                  ),
                ],
              ),
            
            if (enrollment.llEtablissementLatin != null)
              const SizedBox(height: 12),
            
            // Program of study
            if (enrollment.niveauLibelleLongLt != null || 
                enrollment.refLibelleCycle != null || 
                enrollment.ofLlDomaine != null || 
                enrollment.ofLlFiliere != null || 
                enrollment.ofLlSpecialite != null)
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
                        if (enrollment.refLibelleCycle != null && enrollment.niveauLibelleLongLt != null)
                          Text(
                            '${enrollment.refLibelleCycle!.toUpperCase()} - ${enrollment.niveauLibelleLongLt}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: theme.textTheme.titleMedium?.color,
                            ),
                          )
                        else if (enrollment.niveauLibelleLongLt != null)
                          Text(
                            enrollment.niveauLibelleLongLt!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: theme.textTheme.titleMedium?.color,
                            ),
                          ),
                        
                        if (enrollment.ofLlDomaine != null)
                          Text(
                            enrollment.ofLlDomaine!,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                            ),
                          ),
                        
                        if (enrollment.ofLlFiliere != null && enrollment.ofLlSpecialite != null)
                          Text(
                            '${enrollment.ofLlFiliere}: ${enrollment.ofLlSpecialite}',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                            ),
                          )
                        else if (enrollment.ofLlFiliere != null)
                          Text(
                            enrollment.ofLlFiliere!,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            
            if (enrollment.niveauLibelleLongLt != null || 
                enrollment.refLibelleCycle != null || 
                enrollment.ofLlDomaine != null || 
                enrollment.ofLlFiliere != null || 
                enrollment.ofLlSpecialite != null)
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
                          'Registration',
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