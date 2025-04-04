import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:progres/features/timeline/data/blocs/timeline_bloc.dart';

Widget buildErrorState(TimelineError state, BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          size: 48,
          color: Colors.red,
        ),
        const SizedBox(height: 16),
        Text('Error: ${state.message}'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final profileState = context.read<ProfileBloc>().state;
            if (profileState is ProfileLoaded) {
              context.read<TimelineBloc>().add(
                    LoadWeeklyTimetable(
                      enrollmentId: profileState.detailedInfo.id,
                      forceReload: true,
                    ),
                  );
            }
          },
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}
