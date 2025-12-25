import 'package:progres/features/timeline/data/models/course_session.dart';

abstract class TimeLineRepository {
  Future<List<CourseSession>> getWeeklyTimetable(int enrollmentId);
}
