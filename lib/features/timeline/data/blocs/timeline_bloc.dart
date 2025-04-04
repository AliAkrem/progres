import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:progres/features/timeline/data/models/course_session.dart';
import 'package:progres/features/profile/data/repositories/student_repository_impl.dart';

// Events
abstract class TimelineEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadWeeklyTimetable extends TimelineEvent {
  final int enrollmentId;
  final bool forceReload;

  LoadWeeklyTimetable({
    required this.enrollmentId,
    this.forceReload = false,
  });

  @override
  List<Object?> get props => [enrollmentId, forceReload];
}

// States
abstract class TimelineState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TimelineInitial extends TimelineState {}

class TimelineLoading extends TimelineState {}

class TimelineLoaded extends TimelineState {
  final List<CourseSession> sessions;
  final DateTime loadedAt;

  TimelineLoaded({
    required this.sessions,
    DateTime? loadedAt,
  }) : loadedAt = loadedAt ?? DateTime.now();

  @override
  List<Object?> get props => [sessions, loadedAt];
}

class TimelineError extends TimelineState {
  final String message;

  TimelineError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final StudentRepositoryImpl studentRepository;
  List<CourseSession>? _cachedSessions;
  DateTime? _lastLoaded;

  TimelineBloc({required this.studentRepository}) : super(TimelineInitial()) {
    on<LoadWeeklyTimetable>(_onLoadWeeklyTimetable);
  }

  Future<void> _onLoadWeeklyTimetable(
    LoadWeeklyTimetable event,
    Emitter<TimelineState> emit,
  ) async {
    try {
      // Check if we have cached data and it's less than 30 minutes old
      final now = DateTime.now();
      final cacheStillValid = _lastLoaded != null && 
          _cachedSessions != null && 
          now.difference(_lastLoaded!).inMinutes < 30 &&
          !event.forceReload;

      // Emit loading state if no cache or forced reload
      if (!cacheStillValid) {
        emit(TimelineLoading());
      }

      // Return cached data if valid
      if (cacheStillValid) {
        emit(TimelineLoaded(sessions: _cachedSessions!));
        return;
      }

      // Otherwise, fetch fresh data
      final sessions = await studentRepository.getWeeklyTimetable(event.enrollmentId);
      
      // Cache the results
      _cachedSessions = sessions;
      _lastLoaded = now;
      
      emit(TimelineLoaded(sessions: sessions, loadedAt: now));
    } catch (e) {
      emit(TimelineError(e.toString()));
    }
  }
} 