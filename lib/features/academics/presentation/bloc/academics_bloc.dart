import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:progres/features/academics/data/models/continuous_assessment.dart';
import 'package:progres/features/academics/data/models/course_coefficient.dart';
import 'package:progres/features/academics/data/models/exam_result.dart';
import 'package:progres/features/academics/data/models/student_group.dart';
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
  final List<CourseCoefficient>? courseCoefficients;
  final List<StudentGroup>? studentGroups;

  AcademicsLoaded({
    required this.examResults,
    required this.continuousAssessments,
    this.courseCoefficients,
    this.studentGroups,
  });

  AcademicsLoaded copyWith({
    List<ExamResult>? examResults,
    List<ContinuousAssessment>? continuousAssessments,
    List<CourseCoefficient>? courseCoefficients,
    List<StudentGroup>? studentGroups,
  }) {
    return AcademicsLoaded(
      examResults: examResults ?? this.examResults,
      continuousAssessments: continuousAssessments ?? this.continuousAssessments,
      courseCoefficients: courseCoefficients ?? this.courseCoefficients,
      studentGroups: studentGroups ?? this.studentGroups,
    );
  }

  @override
  List<Object?> get props => [examResults, continuousAssessments, courseCoefficients, studentGroups];
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
    on<LoadCourseCoefficients>(_onLoadCourseCoefficients);
    on<LoadStudentGroups>(_onLoadStudentGroups);
  }

  Future<void> _onLoadAcademicPerformance(
    LoadAcademicPerformance event,
    Emitter<AcademicsState> emit,
  ) async {
    try {
      emit(AcademicsLoading());

      // Fetch exam results and continuous assessments in parallel
      final examResults = await studentRepository.getExamResults(event.cardId);
      final continuousAssessments = await studentRepository.getContinuousAssessments(event.cardId);

      emit(AcademicsLoaded(
        examResults: examResults,
        continuousAssessments: continuousAssessments,
      ));
    } catch (e) {
      emit(AcademicsError(e.toString()));
    }
  }
  
  Future<void> _onLoadCourseCoefficients(
    LoadCourseCoefficients event,
    Emitter<AcademicsState> emit,
  ) async {
    try {
      // If we're in initial state, emit loading
      if (state is! AcademicsLoaded) {
        emit(AcademicsLoading());
      }
      
      final coefficients = await studentRepository.getCourseCoefficients(
        event.ouvertureOffreFormationId,
        event.niveauId,
      );
      
      if (state is AcademicsLoaded) {
        // Keep existing data and add coefficients
        final currentState = state as AcademicsLoaded;
        emit(currentState.copyWith(courseCoefficients: coefficients));
      } else {
        // Should not happen, but just in case
        emit(AcademicsLoaded(
          examResults: [],
          continuousAssessments: [],
          courseCoefficients: coefficients,
        ));
      }
    } catch (e) {
      emit(AcademicsError(e.toString()));
    }
  }
  
  Future<void> _onLoadStudentGroups(
    LoadStudentGroups event,
    Emitter<AcademicsState> emit,
  ) async {
    try {
      // If we're in initial state, emit loading
      if (state is! AcademicsLoaded) {
        emit(AcademicsLoading());
      }
      
      final groups = await studentRepository.getStudentGroups(event.cardId);
      
      if (state is AcademicsLoaded) {
        // Keep existing data and add groups
        final currentState = state as AcademicsLoaded;
        emit(currentState.copyWith(studentGroups: groups));
      } else {
        // Should not happen, but just in case
        emit(AcademicsLoaded(
          examResults: [],
          continuousAssessments: [],
          studentGroups: groups,
        ));
      }
    } catch (e) {
      emit(AcademicsError(e.toString()));
    }
  }
} 