import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:progres/core/network/api_client.dart';
import 'package:progres/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:progres/features/auth/data/models/auth_response.dart';
import '../helpers/mock_secure_storage.dart';
import '../helpers/test_http_override.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  late AuthRepositoryImpl authRepository;
  late MockSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockSecureStorage();
    final apiClient = ApiClient(secureStorage: mockStorage);
    authRepository = AuthRepositoryImpl(apiClient: apiClient);
  });

  group('Auth API Tests', () {
    test('Login API should return valid AuthResponse', () async {
      const username = String.fromEnvironment('TEST_USERNAME',
          defaultValue: 'TEST_username_');
      const password = String.fromEnvironment('TEST_PASSWORD',
          defaultValue: 'TEST_password_');

      final authResponse = await authRepository.login(username, password);

      // Verify response structure
      expect(authResponse, isA<AuthResponse>());
      expect(authResponse.token, isNotEmpty);
      expect(authResponse.uuid, isNotEmpty);
      expect(authResponse.etablissementId, isNotNull);

      // Verify data was saved
      final isLoggedIn = await authRepository.isLoggedIn();
      expect(isLoggedIn, true);

      final etablissementId = await authRepository.getEtablissementId();
      expect(etablissementId, isNotNull);

      // Cleanup
      await authRepository.logout();
      final isLoggedOut = await authRepository.isLoggedIn();
      expect(isLoggedOut, false);
    });

    test('Login API should handle invalid credentials', () async {
      final invalidUsername = 'invalid_username';
      final invalidPassword = 'invalid_password';

      try {
        await authRepository.login(invalidUsername, invalidPassword);
        fail('Expected an exception to be thrown');
      } catch (e) {
        expect(e, isA<Exception>());
      }
    });

    test('Logout API should clear stored data', () async {
      const username = String.fromEnvironment('TEST_USERNAME',
          defaultValue: 'TEST_username_');
      const password = String.fromEnvironment('TEST_PASSWORD',
          defaultValue: 'TEST_password_');

      // First login
      await authRepository.login(username, password);

      // Logout
      await authRepository.logout();

      // Verify data was cleared
      final isLoggedIn = await authRepository.isLoggedIn();
      expect(isLoggedIn, false);

      final etablissementId = await authRepository.getEtablissementId();
      expect(etablissementId, isNull);
    });
  });
}
