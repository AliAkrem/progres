import 'package:progres/features/groups/data/models/group.dart';

abstract class StudentGroupsRepository {
  Future<List<StudentGroup>> getStudentGroups(int cardId);
}
