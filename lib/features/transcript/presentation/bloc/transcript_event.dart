import 'package:equatable/equatable.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';

abstract class TranscriptEvent extends Equatable {
  const TranscriptEvent();

  @override
  List<Object?> get props => [];
}

class LoadEnrollments extends TranscriptEvent {
  final bool forceRefresh;

  const LoadEnrollments({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class LoadTranscripts extends TranscriptEvent {
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

class LoadAnnualSummary extends TranscriptEvent {
  final int enrollmentId;
  final bool forceRefresh;

  const LoadAnnualSummary({
    required this.enrollmentId,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [enrollmentId, forceRefresh];
}

class ClearTranscriptCache extends TranscriptEvent {
  const ClearTranscriptCache();
}
