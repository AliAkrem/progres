import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:progres/features/groups/presentation/widgets/error.dart';
import 'package:progres/features/groups/presentation/widgets/groups.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/l10n/app_localizations.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  late final int studentId;

  @override
  void initState() {
    super.initState();

    // Load student groups if profile is loaded
    final profileState = context.read<ProfileBloc>().state;

    if (profileState is ProfileLoaded) {
      studentId = profileState.detailedInfo.id;
      _loadGroups();
    }
  }

  void _loadGroups() {
    context.read<StudentGroupsBloc>().add(LoadStudentGroups(cardId: studentId));
  }

  Future<void> _refreshGroups() async {
    if (context.read<ProfileBloc>().state is ProfileLoaded) {
      // Clear cache and reload from API
      context.read<StudentGroupsBloc>().add(ClearGroupsCache());
      context.read<StudentGroupsBloc>().add(
        LoadStudentGroups(cardId: studentId),
      );
    }
    // Simulating network delay for better UX
    return Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myGroups),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshGroups,
            tooltip: AppLocalizations.of(context)!.refreshGroups,
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState is! ProfileLoaded) {
            return _buildErrorLoadingProfile();
          }

          return BlocBuilder<StudentGroupsBloc, StudentGroupsState>(
            builder: (context, state) {
              if (state is StudentGroupsLoading) {
                return _buildLoadingState();
              } else if (state is StudentGroupsError) {
                return ErrorState(profileState: profileState, state: state);
              } else if (state is StudentGroupsLoaded) {
                return RefreshIndicator(
                  onRefresh: _refreshGroups,
                  child: GroupsContent(groups: state.studentGroups),
                );
              } else {
                return _buildIinitialState();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildErrorLoadingProfile() {
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

  Widget _buildIinitialState() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.noGroupData,
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadGroups,
            child: Text(AppLocalizations.of(context)!.loadGroups),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }
}
