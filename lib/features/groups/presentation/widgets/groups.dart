import 'package:flutter/material.dart';
import 'package:progres/config/theme/app_theme.dart';
import 'package:progres/features/groups/data/models/group.dart';

class GroupsContent extends StatelessWidget {
  final List<StudentGroup> groups;
  const GroupsContent({super.key, required this.groups});
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    if (groups.isEmpty) {
      return const EmptyGroup();
    }
    Map<String, List<StudentGroup>> groupsByPeriod = _getGroupByPeriod(groups);
    final sortedPeriods = groupsByPeriod.keys.toList()..sort();
    return SingleChildScrollView(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        children: [
          for (var period in sortedPeriods) ...[
            PeriodHeader(period: period),
            SizedBox(height: isSmallScreen ? 12 : 16),
            ...groupsByPeriod[period]!
                .map((group) => GroupCard(group: group))
                .toList(),
            SizedBox(height: isSmallScreen ? 12 : 16),
          ],
        ],
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final StudentGroup group;
  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              theme.brightness == Brightness.light
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
                    color: AppTheme.AppPrimary.withValues(alpha: 0.1),
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
                            color:
                                theme.brightness == Brightness.light
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade400,
                          ),
                          SizedBox(width: isSmallScreen ? 3 : 4),
                          Text(
                            'Section: ${group.nomSection}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color:
                                  theme.brightness == Brightness.light
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
    );
  }
}

class PeriodHeader extends StatelessWidget {
  final String period;
  const PeriodHeader({super.key, required this.period});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Container(
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
    );
  }
}

Map<String, List<StudentGroup>> _getGroupByPeriod(List<StudentGroup> groups) {
  final Map<String, List<StudentGroup>> groupsByPeriod = {};
  for (var group in groups) {
    if (!groupsByPeriod.containsKey(group.periodeLibelleLongLt)) {
      groupsByPeriod[group.periodeLibelleLongLt] = [];
    }
    groupsByPeriod[group.periodeLibelleLongLt]!.add(group);
  }
  return groupsByPeriod;
}

class EmptyGroup extends StatelessWidget {
  const EmptyGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
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
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ),
        ],
      ),
    );
  }
}
