import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:progres/features/academics/data/models/academic_transcript.dart';
import 'package:progres/features/profile/data/models/annual_transcript_summary.dart';
import 'package:progres/features/profile/data/models/enrollment.dart';
import 'package:progres/features/profile/data/repositories/student_repository_impl.dart';
import 'package:progres/features/academics/data/services/transcript_cache_service.dart';

part 'transcripts_event.dart';
part 'transcripts_state.dart';

class TranscriptsBloc extends Bloc<TranscriptsEvent, TranscriptsState> {
  final StudentRepositoryImpl studentRepository;
  final TranscriptCacheService cacheService;

  TranscriptsBloc({
    required this.studentRepository, 
    required this.cacheService,
  }) : super(TranscriptsInitial()) {
    on<LoadEnrollments>(_onLoadEnrollments);
    on<LoadTranscripts>(_onLoadTranscripts);
    on<LoadAnnualSummary>(_onLoadAnnualSummary);
    on<ClearTranscriptCache>(_onClearCache);
  }

  Future<void> _onLoadEnrollments(
    LoadEnrollments event,
    Emitter<TranscriptsState> emit,
  ) async {
    try {
      emit(TranscriptsLoading());
      
      // If not forcing refresh, try to get from cache first
      if (!event.forceRefresh) {
        final isStale = await cacheService.isDataStale('enrollments');
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
      
      // Load from network
      final enrollments = await studentRepository.getStudentEnrollments();
      
      // Cache the results
      await cacheService.cacheEnrollments(enrollments);
      
      emit(EnrollmentsLoaded(
        enrollments: enrollments,
        fromCache: false,
      ));
    } catch (e) {
      print('Error loading enrollments: $e');
      
      // Try to load from cache even if refresh was requested but failed
      final cachedEnrollments = await cacheService.getCachedEnrollments();
      if (cachedEnrollments != null && cachedEnrollments.isNotEmpty) {
        emit(EnrollmentsLoaded(
          enrollments: cachedEnrollments,
          fromCache: true,
        ));
      } else {
        emit(TranscriptsError(message: e.toString()));
      }
    }
  }

  Future<void> _onLoadTranscripts(
    LoadTranscripts event,
    Emitter<TranscriptsState> emit,
  ) async {
    try {
      // If not forcing refresh, try to get from cache first
      if (!event.forceRefresh) {
        final isTranscriptsStale = await cacheService.isDataStale('transcript', enrollmentId: event.enrollmentId);
        final isSummaryStale = await cacheService.isDataStale('summary', enrollmentId: event.enrollmentId);
        
        if (!isTranscriptsStale && !isSummaryStale) {
          final cachedTranscripts = await cacheService.getCachedTranscripts(event.enrollmentId);
          final cachedSummary = await cacheService.getCachedAnnualSummary(event.enrollmentId);
          
          if (cachedTranscripts != null && cachedTranscripts.isNotEmpty) {
            print('Using cached transcripts and summary for enrollment ID: ${event.enrollmentId}');
            emit(TranscriptsLoaded(
              transcripts: cachedTranscripts,
              selectedEnrollment: event.enrollment,
              annualSummary: cachedSummary,
              fromCache: true,
            ));
            return;
          }
        }
      }
      
      emit(TranscriptsLoading());
      
      // Load transcripts from network
      final transcripts = await studentRepository.getAcademicTranscripts(event.enrollmentId);
      
      // Cache the transcripts
      await cacheService.cacheTranscripts(event.enrollmentId, transcripts);
      
      // Load annual summary
      AnnualTranscriptSummary? annualSummary;
      try {
        annualSummary = await studentRepository.getAnnualTranscriptSummary(event.enrollmentId);
        // Cache the annual summary
        await cacheService.cacheAnnualSummary(event.enrollmentId, annualSummary);
            } catch (e) {
        print('Error loading annual summary: $e');
        // Try to get from cache if network request fails
        annualSummary = await cacheService.getCachedAnnualSummary(event.enrollmentId);
      }
      
      emit(TranscriptsLoaded(
        transcripts: transcripts,
        selectedEnrollment: event.enrollment,
        annualSummary: annualSummary,
        fromCache: false,
      ));
    } catch (e) {
      print('Error loading transcripts: $e');
      
      // Try to load from cache if network request fails
      final cachedTranscripts = await cacheService.getCachedTranscripts(event.enrollmentId);
      final cachedSummary = await cacheService.getCachedAnnualSummary(event.enrollmentId);
      
      if (cachedTranscripts != null && cachedTranscripts.isNotEmpty) {
        emit(TranscriptsLoaded(
          transcripts: cachedTranscripts,
          selectedEnrollment: event.enrollment,
          annualSummary: cachedSummary,
          fromCache: true,
        ));
      } else {
        emit(TranscriptsError(message: e.toString()));
      }
    }
  }

  Future<void> _onLoadAnnualSummary(
    LoadAnnualSummary event,
    Emitter<TranscriptsState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is TranscriptsLoaded) {
        // If not forcing refresh and we have data in cache, use it
        if (!event.forceRefresh) {
          final isStale = await cacheService.isDataStale('summary', enrollmentId: event.enrollmentId);
          if (!isStale) {
            final cachedSummary = await cacheService.getCachedAnnualSummary(event.enrollmentId);
            if (cachedSummary != null) {
              emit(TranscriptsLoaded(
                transcripts: currentState.transcripts,
                selectedEnrollment: currentState.selectedEnrollment,
                annualSummary: cachedSummary,
                fromCache: true,
              ));
              return;
            }
          }
        }
        
        // Load from network
        final annualSummary = await studentRepository.getAnnualTranscriptSummary(event.enrollmentId);
        
        // Cache the result
        await cacheService.cacheAnnualSummary(event.enrollmentId, annualSummary);
        
        emit(TranscriptsLoaded(
          transcripts: currentState.transcripts,
          selectedEnrollment: currentState.selectedEnrollment,
          annualSummary: annualSummary,
          fromCache: false,
        ));
      }
    } catch (e) {
      print('Error loading annual summary: $e');
      // Don't change state on error, just log
    }
  }
  
  Future<void> _onClearCache(
    ClearTranscriptCache event,
    Emitter<TranscriptsState> emit,
  ) async {
    await cacheService.clearAllCache();
    print('Transcript cache cleared');
  }
} 