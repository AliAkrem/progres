import 'package:progres/features/transcript/data/models/annual_transcript_summary.dart';
import 'package:progres/features/transcript/domain/repositories/transcript_repository.dart';

class GetAnnualTranscriptSummary {
  final TranscriptRepository repository;

  GetAnnualTranscriptSummary(this.repository);

  Future<AnnualTranscriptSummary> call(int enrollmentId) {
    return repository.getAnnualTranscriptSummary(enrollmentId);
  }
}
