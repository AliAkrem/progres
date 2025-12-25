import 'package:progres/features/auth/domain/repositories/auth_repository.dart';

class IsLoggedIn {
  final AuthRepository repository;

  IsLoggedIn(this.repository);

  Future<bool> call() {
    return repository.isLoggedIn();
  }
}
