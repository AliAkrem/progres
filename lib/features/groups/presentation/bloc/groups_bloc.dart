import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/groups/data/models/group.dart';
import 'package:progres/features/groups/data/services/groups_cache_service.dart';
import 'package:progres/features/groups/domain/usecases/get_student_groups.dart';

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

class ClearGroupsCache extends StudentGroupsEvent {}

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
  final GetStudentGroups getStudentGroups;
  final GroupsCacheService cacheService;

  StudentGroupsBloc({
    required this.getStudentGroups,
    required this.cacheService,
  }) : super(StudentGroupsInitial()) {
    on<LoadStudentGroups>(_onLoadStudentGroups);
    on<ClearGroupsCache>(_onClearCache);
  }

  Future<void> _onLoadStudentGroups(
    LoadStudentGroups event,
    Emitter<StudentGroupsState> emit,
  ) async {
    emit(StudentGroupsLoading());
    try {
      final cachedGroups = await cacheService.getCachedGroups();

      if (cachedGroups != null) {
        emit(StudentGroupsLoaded(studentGroups: cachedGroups));
        return;
      }

      // If cache is stale or empty, fetch from API
      final studentGroups = await getStudentGroups(event.cardId);

      // Cache the results
      await cacheService.cacheGroups(studentGroups);

      emit(StudentGroupsLoaded(studentGroups: studentGroups));
    } catch (e) {
      emit(StudentGroupsError(e.toString()));
    }
  }

  Future<void> _onClearCache(
    ClearGroupsCache event,
    Emitter<StudentGroupsState> emit,
  ) async {
    await cacheService.clearCache();
  }
}
