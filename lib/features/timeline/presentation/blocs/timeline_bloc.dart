import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:progres/features/timeline/data/models/course_session.dart';
import 'package:progres/features/timeline/data/repositories/timeline_repository_impl.dart';

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
  final TimeLineRepositoryImpl timeLineRepositoryImpl;
  List<CourseSession>? _cachedSessions;
  DateTime? _lastLoaded;

  TimelineBloc({required this.timeLineRepositoryImpl}) : super(TimelineInitial()) {
    on<LoadWeeklyTimetable>(_onLoadWeeklyTimetable);
  }

  Future<void> _onLoadWeeklyTimetable(
    LoadWeeklyTimetable event,
    Emitter<TimelineState> emit,
  ) async {
    try {
      final now = DateTime.now();
      final cacheStillValid = _lastLoaded != null && 
          _cachedSessions != null && 
          now.difference(_lastLoaded!).inMinutes < 30 &&
          !event.forceReload;

      if (!cacheStillValid) {
        emit(TimelineLoading());
      }

      if (cacheStillValid) {
        emit(TimelineLoaded(sessions: _cachedSessions!));
        return;
      }

      final sessions = await timeLineRepositoryImpl.getWeeklyTimetable(event.enrollmentId);
      
      _cachedSessions = sessions;
      _lastLoaded = now;
      
      emit(TimelineLoaded(sessions: sessions, loadedAt: now));
    } catch (e) {
      emit(TimelineError(e.toString()));
    }
  }
} 