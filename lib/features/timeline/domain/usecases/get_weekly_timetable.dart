import 'package:progres/features/timeline/data/models/course_session.dart';
import 'package:progres/features/timeline/domain/repositories/timeline_repository.dart';

class GetWeeklyTimetable {
  final TimeLineRepository repository;

  GetWeeklyTimetable(this.repository);

  Future<List<CourseSession>> call(int enrollmentId) {
    return repository.getWeeklyTimetable(enrollmentId);
  }
}
