import 'package:progres/features/transcript/data/models/academic_transcript.dart';
import 'package:progres/features/transcript/domain/repositories/transcript_repository.dart';

class GetAcademicTranscripts {
  final TranscriptRepository repository;

  GetAcademicTranscripts(this.repository);

  Future<List<AcademicTranscript>> call(int enrollmentId) {
    return repository.getAcademicTranscripts(enrollmentId);
  }
}
