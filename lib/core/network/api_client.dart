import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static const String baseUrl = 'https://progres.mesrs.dz/api';
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await _secureStorage.read(key: 'auth_token');
          if (token != null) {
            options.headers['authorization'] = token;
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          // Handle errors
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<void> saveUuid(String uuid) async {
    await _secureStorage.write(key: 'uuid', value: uuid);
  }
  
  Future<void> saveEtablissementId(String etablissementId) async {
    await _secureStorage.write(key: 'etablissement_id', value: etablissementId);
  }

  Future<String?> getUuid() async {
    return await _secureStorage.read(key: 'uuid');
  }
  
  Future<String?> getEtablissementId() async {
    return await _secureStorage.read(key: 'etablissement_id');
  }

  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'auth_token');
    return token != null;
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'uuid');
    await _secureStorage.delete(key: 'etablissement_id');
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
} 