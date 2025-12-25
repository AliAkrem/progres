import 'package:progres/features/groups/data/models/group.dart';
import 'package:progres/features/groups/domain/repositories/group_repository.dart';

class GetStudentGroups {
  final StudentGroupsRepository repository;

  GetStudentGroups(this.repository);

  Future<List<StudentGroup>> call(int cardId) {
    return repository.getStudentGroups(cardId);
  }
}
