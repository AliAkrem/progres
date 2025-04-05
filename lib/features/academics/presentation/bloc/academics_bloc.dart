import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:progres/features/academics/data/models/continuous_assessment.dart';
import 'package:progres/features/academics/data/models/exam_result.dart';
import 'package:progres/features/profile/data/repositories/student_repository_impl.dart';

// Events
abstract class AcademicsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAcademicPerformance extends AcademicsEvent {
  final int cardId;

  LoadAcademicPerformance({required this.cardId});

  @override
  List<Object?> get props => [cardId];
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

  AcademicsLoaded({
    required this.examResults,
    required this.continuousAssessments,
  });

  AcademicsLoaded copyWith({
    List<ExamResult>? examResults,
    List<ContinuousAssessment>? continuousAssessments,
  }) {
    return AcademicsLoaded(
      examResults: examResults ?? this.examResults,
      continuousAssessments:
          continuousAssessments ?? this.continuousAssessments,
    );
  }

  @override
  List<Object?> get props =>
      [examResults, continuousAssessments];
}

class AcademicsError extends AcademicsState {
  final String message;

  AcademicsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AcademicsBloc extends Bloc<AcademicsEvent, AcademicsState> {
  final StudentRepositoryImpl studentRepository;
  AcademicsBloc({required this.studentRepository}) : super(AcademicsInitial()) {
    on<LoadAcademicPerformance>(_onLoadAcademicPerformance);
  }

  Future<void> _onLoadAcademicPerformance(
    LoadAcademicPerformance event,
    Emitter<AcademicsState> emit,
  ) async {
    try {
      emit(AcademicsLoading());

      // Fetch exam results and continuous assessments in parallel
      final examResults = await studentRepository.getExamResults(event.cardId);
      final continuousAssessments =
          await studentRepository.getContinuousAssessments(event.cardId);

      emit(AcademicsLoaded(
        examResults: examResults,
        continuousAssessments: continuousAssessments,
      ));
    } catch (e) {
      emit(AcademicsError(e.toString()));
    }
  }
}
