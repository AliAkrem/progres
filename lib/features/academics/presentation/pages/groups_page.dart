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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Groups'),
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
                                  LoadStudentGroups(
                                    cardId: profileState.detailedInfo.id,
                                  ),
                                );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is AcademicsLoaded && state.studentGroups != null) {
                // Build the groups page with periods and groups
                return _buildGroupsContent(context, state.studentGroups!);
              } else {
                return Center(
                  child: Text(
                    'No group data available',
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

  Widget _buildGroupsContent(BuildContext context, List<StudentGroup> groups) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;
    
    if (groups.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_off_outlined, 
              size: isSmallScreen ? 56 : 64,
              color: theme.disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              'No groups assigned',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: isSmallScreen ? 18 : 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You are not assigned to any pedagogical groups yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                fontSize: isSmallScreen ? 14 : 16,
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
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        children: [
     
          
          // Periods and groups
          for (var period in sortedPeriods) ...[
            // Period header
            Container(
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
            
            SizedBox(height: isSmallScreen ? 12 : 16),
            
            // Groups for this period
            ...groupsByPeriod[period]!.map((group) => 
              Card(
                elevation: 0,
                margin: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.brightness == Brightness.light 
                        ? AppTheme.AppBorder 
                        : Colors.grey.shade800,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: isSmallScreen ? 36 : 40,
                            height: isSmallScreen ? 36 : 40,
                            decoration: BoxDecoration(
                              color:   AppTheme.AppPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.group_rounded,
                              color: AppTheme.AppPrimary,
                              size: isSmallScreen ? 20 : 24,
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 12 : 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  group.nomGroupePedagogique,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isSmallScreen ? 14 : 16,
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 3 : 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.view_module_outlined,
                                      size: isSmallScreen ? 12 : 14,
                                      color: theme.brightness == Brightness.light 
                                          ? Colors.grey.shade600
                                          : Colors.grey.shade400,
                                    ),
                                    SizedBox(width: isSmallScreen ? 3 : 4),
                                    Text(
                                      'Section: ${group.nomSection}',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
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
            
            SizedBox(height: isSmallScreen ? 12 : 16),
          ],
        ],
      ),
    );
  }
} 