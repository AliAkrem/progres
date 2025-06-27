import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/discharge/data/models/dischage.dart';
import 'package:progres/features/discharge/data/repository/discharge_repository_impl.dart';
import 'package:progres/features/discharge/data/services/discharge_cache_service.dart';

class StudentDischargeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadStudentDischarge extends StudentDischargeEvent {}

class ClearDischargeCache extends StudentDischargeEvent {}

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
  final StudentDischargeRepositoryImpl studentDischargeRepository;
  final DischargeCacheService cacheService;

  StudentDischargeBloc({
    required this.studentDischargeRepository,
    required this.cacheService,
  }) : super(StudentDischargeInitial()) {
    on<LoadStudentDischarge>(_onLoadStudentDischarge);
    on<ClearDischargeCache>(_onClearCache);
  }

  Future<void> _onLoadStudentDischarge(
    LoadStudentDischarge event,
    Emitter<StudentDischargeState> emit,
  ) async {
    emit(StudentDischargeLoading());
    try {
      final cachedDischarge = await cacheService.getCachedDischarge();

      if (cachedDischarge != null) {
        emit(StudentDischargeLoaded(studentDischarge: cachedDischarge));
        return;
      }

      // If cache is stale or empty, fetch from API
      final studentDischarge =
          await studentDischargeRepository.getStudentDischarge();

      // Cache the results
      await cacheService.cacheDischarge(studentDischarge);

      emit(StudentDischargeLoaded(studentDischarge: studentDischarge));
    } on DischargeNotRequiredException {
      emit(StudentDischargeNotRequired());
    } catch (e) {
      emit(StudentDischargeError(e.toString()));
    }
  }

  Future<void> _onClearCache(
    ClearDischargeCache event,
    Emitter<StudentDischargeState> emit,
  ) async {
    await cacheService.clearCache();
  }
}
