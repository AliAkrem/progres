import '../../data/models/course_coefficient.dart';

abstract class SubjectRepository {
  Future<List<CourseCoefficient>> getCourseCoefficients(
    int ouvertureOffreFormationId,
    int niveauId,
  );
}
