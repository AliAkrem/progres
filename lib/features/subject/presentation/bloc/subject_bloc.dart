import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:progres/features/subject/data/repositories/subject_repository_impl.dart';
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
  final SubjectRepositoryImpl subjectRepository;

  SubjectBloc({required this.subjectRepository}) : super(SubjectInitial()) {
    on<LoadSubjectCoefficients>(_onLoadSubjectCoefficients);
  }

  Future<void> _onLoadSubjectCoefficients(
    LoadSubjectCoefficients event,
    Emitter<SubjectState> emit,
  ) async {
    try {
      emit(SubjectLoading());

      final coefficients = await subjectRepository.getCourseCoefficients(
        event.ouvertureOffreFormationId,
        event.niveauId,
      );

      emit(SubjectLoaded(courseCoefficients: coefficients));
    } catch (e) {
      emit(SubjectError(e.toString()));
    }
  }
} 