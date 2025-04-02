import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/academics/data/models/student_group.dart';
import 'package:progres/features/academics/presentation/bloc/academics_bloc.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  @override
  void initState() {
    super.initState();
    
    // Load student groups if profile is loaded
    final profileState = context.read<ProfileBloc>().state;
    
    if (profileState is ProfileLoaded) {
      context.read<AcademicsBloc>().add(
            LoadStudentGroups(
              cardId: profileState.detailedInfo.id,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Groups'),
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
                                LoadStudentGroups(
                                  cardId: profileState.detailedInfo.id,
                                ),
                              );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is AcademicsLoaded && state.studentGroups != null) {
                // Build the groups page with periods and groups
                return _buildGroupsContent(context, state.studentGroups!);
              } else {
                return const Center(
                  child: Text('No group data available'),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildGroupsContent(BuildContext context, List<StudentGroup> groups) {
    final theme = Theme.of(context);
    
    if (groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_off_outlined, 
              size: 64,
              color: theme.disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No groups assigned',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'You are not assigned to any pedagogical groups yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }
    
    // Group by period
    final Map<String, List<StudentGroup>> groupsByPeriod = {};
    for (var group in groups) {
      if (!groupsByPeriod.containsKey(group.periodeLibelleLongLt)) {
        groupsByPeriod[group.periodeLibelleLongLt] = [];
      }
      groupsByPeriod[group.periodeLibelleLongLt]!.add(group);
    }
    
    // Sort periods
    final sortedPeriods = groupsByPeriod.keys.toList()..sort();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedagogical Groups',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'These are the groups you belong to for each semester. Groups are used for scheduling and pedagogical organization.',
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Periods and groups
          for (var period in sortedPeriods) ...[
            // Period header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.claudePrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                period,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.claudePrimary,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Groups for this period
            ...groupsByPeriod[period]!.map((group) => 
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.brightness == Brightness.light 
                        ? AppTheme.claudeBorder 
                        : Colors.grey.shade800,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.claudeSecondary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.group_rounded,
                              color: AppTheme.claudePrimary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  group.nomGroupePedagogique,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.view_module_outlined,
                                      size: 14,
                                      color: theme.brightness == Brightness.light 
                                          ? Colors.grey.shade600
                                          : Colors.grey.shade400,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Section: ${group.nomSection}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: theme.brightness == Brightness.light 
                                            ? Colors.grey.shade600 
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ).toList(),
            
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
} 