import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/enrollment/data/repositories/enrollment_repository.dart';
import 'package:progres/features/enrollment/data/services/enrollment_cache_service.dart';
import 'package:progres/features/enrollment/presentation/bloc/enrollment_event.dart';
import 'package:progres/features/enrollment/presentation/bloc/enrollment_state.dart';

class EnrollmentBloc extends Bloc<EnrollmentEvent, EnrollmentState> {
  final EnrollmentRepository enrollmentRepository;
  final EnrollmentCacheService cacheService;

  EnrollmentBloc({
    required this.enrollmentRepository,
    required this.cacheService,
  }) : super(EnrollmentInitial()) {
    on<LoadEnrollmentsEvent>(_onLoadEnrollments);
    on<ClearEnrollmentsCache>(_onClearCache);
  }

  Future<void> _onLoadEnrollments(
    LoadEnrollmentsEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    try {
      emit(EnrollmentLoading());

      // If not forcing refresh, try to get from cache first
      if (!event.forceRefresh) {
        final isStale = await cacheService.isDataStale();
        if (!isStale) {
          final cachedEnrollments = await cacheService.getCachedEnrollments();
          if (cachedEnrollments != null && cachedEnrollments.isNotEmpty) {
            print('Using cached enrollments');
            emit(EnrollmentsLoaded(
              enrollments: cachedEnrollments,
              fromCache: true,
            ));
            return;
          }
        }
      }

      final enrollments = await enrollmentRepository.getStudentEnrollments();

      // Cache the results
      await cacheService.cacheEnrollments(enrollments);

      emit(EnrollmentsLoaded(
        enrollments: enrollments,
        fromCache: false,
      ));
    } catch (e) {
      print('Error loading enrollments: $e');

      final cachedEnrollments = await cacheService.getCachedEnrollments();
      if (cachedEnrollments != null && cachedEnrollments.isNotEmpty) {
        emit(EnrollmentsLoaded(
          enrollments: cachedEnrollments,
          fromCache: true,
        ));
      } else {
        emit(EnrollmentError(message: e.toString()));
      }
    }
  }

  Future<void> _onClearCache(
    ClearEnrollmentsCache event,
    Emitter<EnrollmentState> emit,
  ) async {
    await cacheService.clearCache();
  }
}
