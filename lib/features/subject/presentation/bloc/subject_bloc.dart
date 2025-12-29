import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:progres/features/subject/data/services/subject_cache_service.dart';
import 'package:progres/features/subject/domain/usecases/get_course_coefficients.dart';
import '../../data/models/course_coefficient.dart';

abstract class SubjectEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSubjectCoefficients extends SubjectEvent {
  final int ouvertureOffreFormationId;
  final int niveauId;

  LoadSubjectCoefficients({
    required this.ouvertureOffreFormationId,
    required this.niveauId,
  });

  @override
  List<Object?> get props => [ouvertureOffreFormationId, niveauId];
}

class ClearSubjectCache extends SubjectEvent {
  final int? ouvertureOffreFormationId;
  final int? niveauId;

  ClearSubjectCache({this.ouvertureOffreFormationId, this.niveauId});

  @override
  List<Object?> get props => [ouvertureOffreFormationId, niveauId];
}

abstract class SubjectState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectLoaded extends SubjectState {
  final List<CourseCoefficient> courseCoefficients;

  SubjectLoaded({required this.courseCoefficients});

  @override
  List<Object?> get props => [courseCoefficients];
}

class SubjectError extends SubjectState {
  final String message;

  SubjectError(this.message);

  @override
  List<Object?> get props => [message];
}

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final GetCourseCoefficients getCourseCoefficients;
  final SubjectCacheService cacheService;

  SubjectBloc(
      {required this.getCourseCoefficients, required this.cacheService})
      : super(SubjectInitial()) {
    on<LoadSubjectCoefficients>(_onLoadSubjectCoefficients);
    on<ClearSubjectCache>(_onClearSubjectCache);
  }

  Future<void> _onLoadSubjectCoefficients(
    LoadSubjectCoefficients event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      emit(SubjectLoading());
      final cachedCoefficients =
          await cacheService.getCachedSubjectCoefficients(
        event.ouvertureOffreFormationId,
        event.niveauId,
      );

      if (cachedCoefficients != null) {
        emit(SubjectLoaded(courseCoefficients: cachedCoefficients));
        return;
      }

      // If cache is stale or empty, fetch from API
      final coefficients = await getCourseCoefficients(
        event.ouvertureOffreFormationId,
        event.niveauId,
      );

      // Cache the results
      await cacheService.cacheSubjectCoefficients(
        coefficients,
        event.ouvertureOffreFormationId,
        event.niveauId,
      );

      emit(SubjectLoaded(courseCoefficients: coefficients));
    } catch (e) {
      emit(SubjectError(e.toString()));
    }
  }

  Future<void> _onClearSubjectCache(
    ClearSubjectCache event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      if (event.ouvertureOffreFormationId != null && event.niveauId != null) {
        // Clear specific cache
        await cacheService.clearSpecificCache(
          event.ouvertureOffreFormationId!,
          event.niveauId!,
        );
      } else {
        // Clear all caches
        await cacheService.clearAllCache();
      }
    } catch (e) {
      debugPrint('Error clearing subject cache: $e');
    }
  }
}
