import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/discharge/data/models/discharge.dart';
import 'package:progres/features/discharge/data/repository/discharge_repository_impl.dart';
import 'package:progres/features/discharge/domain/usecases/get_student_discharge.dart';

class StudentDischargeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadStudentDischarge extends StudentDischargeEvent {}

class StudentDischargeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StudentDischargeInitial extends StudentDischargeState {}

class StudentDischargeLoading extends StudentDischargeState {}

class StudentDischargeLoaded extends StudentDischargeState {
  final StudentDischarge studentDischarge;

  StudentDischargeLoaded({required this.studentDischarge});

  @override
  List<Object?> get props => [studentDischarge];
}

class StudentDischargeNotRequired extends StudentDischargeState {}

class StudentDischargeError extends StudentDischargeState {
  final String message;

  StudentDischargeError(this.message);

  @override
  List<Object?> get props => [message];
}

class StudentDischargeBloc
    extends Bloc<StudentDischargeEvent, StudentDischargeState> {
  final GetStudentDischarge getStudentDischarge;

  StudentDischargeBloc({required this.getStudentDischarge})
      : super(StudentDischargeInitial()) {
    on<LoadStudentDischarge>(_onLoadStudentDischarge);
  }

  Future<void> _onLoadStudentDischarge(
    LoadStudentDischarge event,
    Emitter<StudentDischargeState> emit,
  ) async {
    emit(StudentDischargeLoading());
    try {
      // Always fetch fresh data from API
      final studentDischarge = await getStudentDischarge();

      emit(StudentDischargeLoaded(studentDischarge: studentDischarge));
    } on DischargeNotRequiredException {
      emit(StudentDischargeNotRequired());
    } catch (e) {
      emit(StudentDischargeError(e.toString()));
    }
  }
}
