import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/auth/data/models/auth_response.dart';

class AuthRepositoryImpl {
  final ApiClient _apiClient;

  AuthRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<AuthResponse> login(String username, String password) async {
    try {
      final response = await _apiClient.post(
        '/authentication/v1/',
        data: {
          'username': username,
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      // Save token and UUID for future API calls
      await _apiClient.saveToken(authResponse.token);
      await _apiClient.saveUuid(authResponse.uuid);
      
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> logout() async {
    await _apiClient.logout();
  }
  
  Future<bool> isLoggedIn() async {
    return await _apiClient.isLoggedIn();
  }
} 