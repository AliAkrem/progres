import 'package:progres/features/transcript/data/models/academic_transcript.dart';
import 'package:progres/features/enrollment/data/models/enrollment.dart';
import 'package:progres/features/transcript/data/models/annual_transcript_summary.dart';

abstract class TranscriptRepository {
  Future<List<Enrollment>> getStudentEnrollments();
  
  Future<List<AcademicTranscript>> getAcademicTranscripts(int enrollmentId);
  
  Future<AnnualTranscriptSummary> getAnnualTranscriptSummary(int enrollmentId);
} 