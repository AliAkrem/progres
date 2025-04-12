import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:progres/features/timeline/data/models/course_session.dart';
import 'package:progres/features/timeline/data/repositories/timeline_repository_impl.dart';
import 'package:progres/features/timeline/data/services/timeline_cache_service.dart';

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

class ClearTimelineCache extends TimelineEvent {
  ClearTimelineCache();

  @override
  List<Object?> get props => [];
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
  final TimelineCacheService timelineCacheService;

  TimelineBloc({
    required this.timeLineRepositoryImpl,
    required this.timelineCacheService,
  }) : super(TimelineInitial()) {
    on<LoadWeeklyTimetable>(_onLoadWeeklyTimetable);
    on<ClearTimelineCache>(_onClearTimelineCache);
  }

  Future<void> _onLoadWeeklyTimetable(
    LoadWeeklyTimetable event,
    Emitter<TimelineState> emit,
  ) async {
    try {
      final String cacheKey = 'weekly_${event.enrollmentId}';

      if (!event.forceReload) {
        final cachedEvents =
            await timelineCacheService.getCachedTimelineEvents(cacheKey);
        if (cachedEvents != null && cachedEvents.isNotEmpty) {
          // Convert cached data back to CourseSession objects
          final List<CourseSession> sessions =
              List<Map<String, dynamic>>.from(cachedEvents)
                  .map((json) => CourseSession.fromJson(json))
                  .toList();

          emit(TimelineLoaded(
            sessions: sessions,
            loadedAt: await timelineCacheService.getLastUpdated(cacheKey),
          ));
          return;
        }
      }

      emit(TimelineLoading());

      // Load from network
      final sessions =
          await timeLineRepositoryImpl.getWeeklyTimetable(event.enrollmentId);

      // Cache the results - convert CourseSession objects to JSON for caching
      final List<Map<String, dynamic>> sessionsJson =
          sessions.map((session) => session.toJson()).toList();
      await timelineCacheService.cacheTimelineEvents(cacheKey, sessionsJson);

      final now = DateTime.now();
      emit(TimelineLoaded(sessions: sessions, loadedAt: now));
    } catch (e) {
      emit(TimelineError(e.toString()));
    }
  }

  Future<void> _onClearTimelineCache(
    ClearTimelineCache event,
    Emitter<TimelineState> emit,
  ) async {
    await timelineCacheService.clearCache();
  }
}
