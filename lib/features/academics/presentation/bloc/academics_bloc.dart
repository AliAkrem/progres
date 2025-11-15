import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:progres/features/academics/data/models/continuous_assessment.dart';
import 'package:progres/features/academics/data/models/exam_result.dart';
import 'package:progres/features/academics/data/services/academics_cache_service.dart';
import 'package:progres/features/academics/data/repository/academics_repository_impl.dart';

// Events
abstract class AcademicsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAcademicPerformance extends AcademicsEvent {
  final int cardId;
  final bool forceRefresh;

  LoadAcademicPerformance({required this.cardId, this.forceRefresh = false});

  @override
  List<Object?> get props => [cardId, forceRefresh];
}

class LoadCourseCoefficients extends AcademicsEvent {
  final int ouvertureOffreFormationId;
  final int niveauId;

  LoadCourseCoefficients({
    required this.ouvertureOffreFormationId,
    required this.niveauId,
  });

  @override
  List<Object?> get props => [ouvertureOffreFormationId, niveauId];
}

class LoadStudentGroups extends AcademicsEvent {
  final int cardId;

  LoadStudentGroups({required this.cardId});

  @override
  List<Object?> get props => [cardId];
}

// States
abstract class AcademicsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AcademicsInitial extends AcademicsState {}

class AcademicsLoading extends AcademicsState {}

class AcademicsLoaded extends AcademicsState {
  final List<ExamResult> examResults;
  final List<ContinuousAssessment> continuousAssessments;
  final bool fromCache;

  AcademicsLoaded({
    required this.examResults,
    required this.continuousAssessments,
    this.fromCache = false,
  });

  AcademicsLoaded copyWith({
    List<ExamResult>? examResults,
    List<ContinuousAssessment>? continuousAssessments,
    bool? fromCache,
  }) {
    return AcademicsLoaded(
      examResults: examResults ?? this.examResults,
      continuousAssessments:
          continuousAssessments ?? this.continuousAssessments,
      fromCache: fromCache ?? this.fromCache,
    );
  }

  @override
  List<Object?> get props => [examResults, continuousAssessments, fromCache];
}

class AcademicsError extends AcademicsState {
  final String message;

  AcademicsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AcademicsBloc extends Bloc<AcademicsEvent, AcademicsState> {
  final AcademicPerformencetRepositoryImpl academicPerformanceRepository;
  final AcademicsCacheService cacheService = AcademicsCacheService();

  AcademicsBloc({required this.academicPerformanceRepository})
    : super(AcademicsInitial()) {
    on<LoadAcademicPerformance>(_onLoadAcademicPerformance);
  }

  Future<void> _onLoadAcademicPerformance(
    LoadAcademicPerformance event,
    Emitter<AcademicsState> emit,
  ) async {
    try {
      emit(AcademicsLoading());

      final String cacheKeyExams = 'exams_${event.cardId}';
      final String cacheKeyAssessments = 'assessments_${event.cardId}';

      // Check if we should use cached data
      if (!event.forceRefresh) {
        // Try to get cached data first
        final bool isExamsStale = await cacheService.isDataStale(cacheKeyExams);
        final bool isAssessmentsStale = await cacheService.isDataStale(
          cacheKeyAssessments,
        );

        if (!isExamsStale && !isAssessmentsStale) {
          final cachedExams = await cacheService.getCachedAcademicsData(
            cacheKeyExams,
          );
          final cachedAssessments = await cacheService.getCachedAcademicsData(
            cacheKeyAssessments,
          );

          if (cachedExams != null && cachedAssessments != null) {
            final examResults = (cachedExams)
                .map((e) => ExamResult.fromJson(e))
                .toList();

            final continuousAssessments = (cachedAssessments)
                .map((e) => ContinuousAssessment.fromJson(e))
                .toList();

            emit(
              AcademicsLoaded(
                examResults: examResults,
                continuousAssessments: continuousAssessments,
                fromCache: true,
              ),
            );
            return;
          }
        }
      }

      // Fetch exam results and continuous assessments in parallel
      final examResults = await academicPerformanceRepository.getExamResults(
        event.cardId,
      );
      final continuousAssessments = await academicPerformanceRepository
          .getContinuousAssessments(event.cardId);

      // Cache the results
      await cacheService.cacheAcademicsData(
        cacheKeyExams,
        examResults.map((e) => e.toJson()).toList(),
      );

      await cacheService.cacheAcademicsData(
        cacheKeyAssessments,
        continuousAssessments.map((e) => e.toJson()).toList(),
      );

      emit(
        AcademicsLoaded(
          examResults: examResults,
          continuousAssessments: continuousAssessments,
          fromCache: false,
        ),
      );
    } catch (e) {
      emit(AcademicsError(e.toString()));
    }
  }
}
