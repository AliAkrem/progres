import 'package:equatable/equatable.dart';
import 'package:progres/features/transcript/data/models/academic_transcript.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';
import 'package:progres/features/transcript/data/models/annual_transcript_summary.dart';

abstract class TranscriptState extends Equatable {
  const TranscriptState();

  @override
  List<Object?> get props => [];
}

class TranscriptInitial extends TranscriptState {}

class TranscriptLoading extends TranscriptState {}

class EnrollmentsLoaded extends TranscriptState {
  final List<Enrollment> enrollments;
  final bool fromCache;

  const EnrollmentsLoaded({
    required this.enrollments,
    this.fromCache = false,
  });

  @override
  List<Object?> get props => [enrollments, fromCache];
}

class TranscriptsLoaded extends TranscriptState {
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
  List<Object?> get props =>
      [transcripts, selectedEnrollment, annualSummary, fromCache];
}

class TranscriptError extends TranscriptState {
  final String message;

  const TranscriptError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
