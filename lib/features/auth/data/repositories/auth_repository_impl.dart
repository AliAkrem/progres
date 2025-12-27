import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/auth/data/models/auth_response.dart';
import 'package:progres/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;

  AuthRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  @override
  Future<AuthResponse> login(String username, String password) async {
    try {
      final response = await _apiClient.post(
        '/authentication/v1/',
        data: {'username': username, 'password': password},
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Save token and UUID for future API calls
      await _apiClient.saveToken(authResponse.token);
      await _apiClient.saveUuid(authResponse.uuid);
      await _apiClient.saveEstablishmentId(
        authResponse.establishmentId.toString(),
      );

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _apiClient.logout();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _apiClient.isLoggedIn();
  }

  @override
  Future<String?> getEstablishmentId() async {
    return await _apiClient.getEstablishmentId();
  }
}
