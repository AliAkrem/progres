part of 'transcripts_bloc.dart';

abstract class TranscriptsState extends Equatable {
  const TranscriptsState();

  @override
  List<Object?> get props => [];
}

class TranscriptsInitial extends TranscriptsState {}

class TranscriptsLoading extends TranscriptsState {}

class EnrollmentsLoaded extends TranscriptsState {
  final List<Enrollment> enrollments;
  final bool fromCache;

  const EnrollmentsLoaded({
    required this.enrollments,
    this.fromCache = false,
  });

  @override
  List<Object?> get props => [enrollments, fromCache];
}

class TranscriptsLoaded extends TranscriptsState {
  final List<AcademicTranscript> transcripts;
  final Enrollment selectedEnrollment;
  final AnnualTranscriptSummary? annualSummary;
  final bool fromCache;

  const TranscriptsLoaded({
    required this.transcripts,
    required this.selectedEnrollment,
    this.annualSummary,
    this.fromCache = false,
  });

  @override
  List<Object?> get props => [transcripts, selectedEnrollment, annualSummary, fromCache];
}

class TranscriptsError extends TranscriptsState {
  final String message;

  const TranscriptsError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
} 