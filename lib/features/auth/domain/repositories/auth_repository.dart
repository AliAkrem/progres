import 'package:progres/features/auth/data/models/auth_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(String username, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getEstablishmentId();
}
