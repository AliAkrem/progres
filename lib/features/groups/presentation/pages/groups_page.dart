import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:progres/features/groups/presentation/widgets/error.dart';
import 'package:progres/features/groups/presentation/widgets/groups.dart';
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
      context.read<StudentGroupsBloc>().add(
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
            return _buildErrorLoadingProfile();
          }

          return BlocBuilder<StudentGroupsBloc, StudentGroupsState>(
            builder: (context, state) {
              if (state is StudentGroupsLoading) {
                return _buildLoadingState();
              } else if (state is StudentGroupsError) {
                return ErrorState(
                  profileState: profileState,
                  state: state,
                );
              } else if (state is StudentGroupsLoaded) {
                return GroupsContent(
                  groups: state.studentGroups,
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
        'Profile data not loaded. Please go back and try again.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
      ),
    );
  }

  Widget _buildIinitialState() {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Center(
      child: Text(
        'No group data available',
        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
