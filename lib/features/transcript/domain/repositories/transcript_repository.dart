import 'package:progres/features/transcript/data/models/academic_transcript.dart';
import 'package:progres/features/transcript/data/models/annual_transcript_summary.dart';

abstract class TranscriptRepository {
  Future<List<AcademicTranscript>> getAcademicTranscripts(
    int enrollmentId,
  );
  Future<AnnualTranscriptSummary> getAnnualTranscriptSummary(
    int enrollmentId,
  );
}
