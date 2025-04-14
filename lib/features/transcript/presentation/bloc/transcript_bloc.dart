import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progres/features/transcript/data/models/annual_transcript_summary.dart';
import 'package:progres/features/transcript/data/repositories/transcript_repository_impl.dart';
import 'package:progres/features/transcript/data/services/transcript_cache_service.dart';
import 'package:progres/features/enrollment/data/services/enrollment_cache_service.dart';
import 'package:progres/features/transcript/presentation/bloc/transcript_event.dart';
import 'package:progres/features/transcript/presentation/bloc/transcript_state.dart';

class TranscriptBloc extends Bloc<TranscriptEvent, TranscriptState> {
  final TranscriptRepositoryImpl transcriptRepository;
  final TranscriptCacheService transcriptCacheService;
  final EnrollmentCacheService enrollmentCacheService;

  TranscriptBloc({
    required this.transcriptRepository,
    required this.transcriptCacheService,
    required this.enrollmentCacheService,
  }) : super(TranscriptInitial()) {
    on<LoadEnrollments>(_onLoadEnrollments);
    on<LoadTranscripts>(_onLoadTranscripts);
    on<LoadAnnualSummary>(_onLoadAnnualSummary);
    on<ClearTranscriptCache>(_onClearCache);
  }

  Future<void> _onLoadEnrollments(
    LoadEnrollments event,
    Emitter<TranscriptState> emit,
  ) async {
    try {
      emit(TranscriptLoading());

      // If not forcing refresh, try to get from cache first
      if (!event.forceRefresh) {
        final isStale = await enrollmentCacheService.isDataStale();
        if (!isStale) {
          final cachedEnrollments =
              await enrollmentCacheService.getCachedEnrollments();
          if (cachedEnrollments != null && cachedEnrollments.isNotEmpty) {
            print('Using cached enrollments');
            emit(
              EnrollmentsLoaded(
                enrollments: cachedEnrollments,
                fromCache: true,
              ),
            );
            return;
          }
        }
      }

      final enrollments = await transcriptRepository.getStudentEnrollments();

      // Cache the results
      await enrollmentCacheService.cacheEnrollments(enrollments);

      emit(EnrollmentsLoaded(enrollments: enrollments, fromCache: false));
    } catch (e) {
      print('Error loading enrollments: $e');

      final cachedEnrollments =
          await enrollmentCacheService.getCachedEnrollments();
      if (cachedEnrollments != null && cachedEnrollments.isNotEmpty) {
        emit(
          EnrollmentsLoaded(enrollments: cachedEnrollments, fromCache: true),
        );
      } else {
        emit(TranscriptError(message: e.toString()));
      }
    }
  }

  Future<void> _onLoadTranscripts(
    LoadTranscripts event,
    Emitter<TranscriptState> emit,
  ) async {
    try {
      // If not forcing refresh, try to get from cache first
      if (!event.forceRefresh) {
        final isTranscriptsStale = await transcriptCacheService.isDataStale(
          'transcript',
          event.enrollmentId,
        );
        final isSummaryStale = await transcriptCacheService.isDataStale(
          'summary',
          event.enrollmentId,
        );

        if (!isTranscriptsStale && !isSummaryStale) {
          final cachedTranscripts = await transcriptCacheService
              .getCachedTranscripts(event.enrollmentId);
          final cachedSummary = await transcriptCacheService
              .getCachedAnnualSummary(event.enrollmentId);

          if (cachedTranscripts != null && cachedTranscripts.isNotEmpty) {
            print(
              'Using cached transcripts and summary for enrollment ID: ${event.enrollmentId}',
            );
            emit(
              TranscriptsLoaded(
                transcripts: cachedTranscripts,
                selectedEnrollment: event.enrollment,
                annualSummary: cachedSummary,
                fromCache: true,
              ),
            );
            return;
          }
        }
      }

      emit(TranscriptLoading());

      // Load transcripts from network
      final transcripts = await transcriptRepository.getAcademicTranscripts(
        event.enrollmentId,
      );

      // Cache the transcripts
      await transcriptCacheService.cacheTranscripts(
        event.enrollmentId,
        transcripts,
      );

      // Load annual summary
      AnnualTranscriptSummary? annualSummary;
      try {
        annualSummary = await transcriptRepository.getAnnualTranscriptSummary(
          event.enrollmentId,
        );
        // Cache the annual summary
        await transcriptCacheService.cacheAnnualSummary(
          event.enrollmentId,
          annualSummary,
        );
      } catch (e) {
        print('Error loading annual summary: $e');
        // Try to get from cache if network request fails
        annualSummary = await transcriptCacheService.getCachedAnnualSummary(
          event.enrollmentId,
        );
      }

      emit(
        TranscriptsLoaded(
          transcripts: transcripts,
          selectedEnrollment: event.enrollment,
          annualSummary: annualSummary,
          fromCache: false,
        ),
      );
    } catch (e) {
      print('Error loading transcripts: $e');

      // Try to load from cache if network request fails
      final cachedTranscripts = await transcriptCacheService
          .getCachedTranscripts(event.enrollmentId);
      final cachedSummary = await transcriptCacheService.getCachedAnnualSummary(
        event.enrollmentId,
      );

      if (cachedTranscripts != null && cachedTranscripts.isNotEmpty) {
        emit(
          TranscriptsLoaded(
            transcripts: cachedTranscripts,
            selectedEnrollment: event.enrollment,
            annualSummary: cachedSummary,
            fromCache: true,
          ),
        );
      } else {
        emit(TranscriptError(message: e.toString()));
      }
    }
  }

  Future<void> _onLoadAnnualSummary(
    LoadAnnualSummary event,
    Emitter<TranscriptState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is TranscriptsLoaded) {
        // If not forcing refresh and we have data in cache, use it
        if (!event.forceRefresh) {
          final isStale = await transcriptCacheService.isDataStale(
            'summary',
            event.enrollmentId,
          );
          if (!isStale) {
            final cachedSummary = await transcriptCacheService
                .getCachedAnnualSummary(event.enrollmentId);
            if (cachedSummary != null) {
              emit(
                TranscriptsLoaded(
                  transcripts: currentState.transcripts,
                  selectedEnrollment: currentState.selectedEnrollment,
                  annualSummary: cachedSummary,
                  fromCache: true,
                ),
              );
              return;
            }
          }
        }

        // Load from network
        final annualSummary = await transcriptRepository
            .getAnnualTranscriptSummary(event.enrollmentId);

        // Cache the result
        await transcriptCacheService.cacheAnnualSummary(
          event.enrollmentId,
          annualSummary,
        );

        emit(
          TranscriptsLoaded(
            transcripts: currentState.transcripts,
            selectedEnrollment: currentState.selectedEnrollment,
            annualSummary: annualSummary,
            fromCache: false,
          ),
        );
      }
    } catch (e) {
      print('Error loading annual summary: $e');
      // Don't change state on error, just log
    }
  }

  Future<void> _onClearCache(
    ClearTranscriptCache event,
    Emitter<TranscriptState> emit,
  ) async {
    await transcriptCacheService.clearAllCache();
    await enrollmentCacheService.clearCache();
  }
}
