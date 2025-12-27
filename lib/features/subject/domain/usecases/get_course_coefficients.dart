import 'package:progres/features/subject/data/models/course_coefficient.dart';
import 'package:progres/features/subject/domain/repositories/subject_repository.dart';

class GetCourseCoefficients {
  final SubjectRepository repository;

  GetCourseCoefficients(this.repository);

  Future<List<CourseCoefficient>> call(
    int ouvertureOffreFormationId,
    int niveauId,
  ) {
    return repository.getCourseCoefficients(ouvertureOffreFormationId, niveauId);
  }
}
