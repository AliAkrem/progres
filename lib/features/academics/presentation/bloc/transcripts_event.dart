part of 'transcripts_bloc.dart';

abstract class TranscriptsEvent extends Equatable {
  const TranscriptsEvent();

  @override
  List<Object?> get props => [];
}

class LoadEnrollments extends TranscriptsEvent {
  final bool forceRefresh;
  
  const LoadEnrollments({this.forceRefresh = false});
  
  @override
  List<Object?> get props => [forceRefresh];
}

class LoadTranscripts extends TranscriptsEvent {
  final int enrollmentId;
  final Enrollment enrollment;
  final bool forceRefresh;

  const LoadTranscripts({
    required this.enrollmentId,
    required this.enrollment,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [enrollmentId, enrollment, forceRefresh];
}

class LoadAnnualSummary extends TranscriptsEvent {
  final int enrollmentId;
  final bool forceRefresh;

  const LoadAnnualSummary({
    required this.enrollmentId,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [enrollmentId, forceRefresh];
}

class ClearTranscriptCache extends TranscriptsEvent {
  const ClearTranscriptCache();
} 