import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/groups/data/models/group.dart';
import 'package:progres/features/groups/data/repository/group_repository_impl.dart';

class StudentGroupsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadStudentGroups extends StudentGroupsEvent {
  final int cardId;

  LoadStudentGroups({required this.cardId});

  @override
  List<Object?> get props => [cardId];
}

class StudentGroupsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StudentGroupsInitial extends StudentGroupsState {}

class StudentGroupsLoading extends StudentGroupsState {}

class StudentGroupsLoaded extends StudentGroupsState {
  final List<StudentGroup> studentGroups;

  StudentGroupsLoaded({required this.studentGroups});

  @override
  List<Object?> get props => [studentGroups];
}

class StudentGroupsError extends StudentGroupsState {
  final String message;

  StudentGroupsError(this.message);

  @override
  List<Object?> get props => [message];
}

class StudentGroupsBloc extends Bloc<StudentGroupsEvent, StudentGroupsState> {
  final StudentGroupsRepositoryImpl studentGroupsRepository;

  StudentGroupsBloc({required this.studentGroupsRepository})
      : super(StudentGroupsInitial()) {
    on<LoadStudentGroups>(_onLoadStudentGroups);
  }

  Future<void> _onLoadStudentGroups(
      LoadStudentGroups event, Emitter<StudentGroupsState> emit) async {
    emit(StudentGroupsLoading());
    try {
      final studentGroups =
          await studentGroupsRepository.getStudentGroups(event.cardId);
      emit(StudentGroupsLoaded(studentGroups: studentGroups));
    } catch (e) {
      emit(StudentGroupsError(e.toString()));
    }
  }
}
