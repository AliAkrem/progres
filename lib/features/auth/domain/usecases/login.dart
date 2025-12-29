import 'package:progres/features/auth/data/models/auth_response.dart';
import 'package:progres/features/auth/domain/repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<AuthResponse> call(String username, String password) {
    return repository.login(username, password);
  }
}
