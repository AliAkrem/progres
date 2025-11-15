import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:progres/core/network/cache_manager.dart';

class DischargeApiClient {
  static const String baseUrl = 'https://quittance.mesrs.dz/api';

  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  late final CacheManager _cacheManager;
  final Duration _shortTimeout = const Duration(seconds: 5);
  final Connectivity _connectivity = Connectivity();

  DischargeApiClient({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
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
    CacheManager.getInstance().then((value) => _cacheManager = value);
  }

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
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

  // Generate a cache key string based on path and query parameters
  String _cacheKey(String path, Map<String, dynamic>? queryParameters) {
    final queryStr = queryParameters != null
        ? Uri(queryParameters: queryParameters).query
        : '';
    return '$path?$queryStr';
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final key = _cacheKey(path, queryParameters);

    if (!await isConnected) {
      // offline - use cached data if available
      final cachedData = _cacheManager.getCache(key);
      if (cachedData != null) {
        return Response(
          requestOptions: RequestOptions(path: path),
          data: cachedData,
          statusCode: 200,
        );
      } else {
        // No cache, throw offline error
        throw DioException(
          requestOptions: RequestOptions(path: path),
          error: 'No internet connection and no cached data',
        );
      }
    }

    try {
      // Try to get fresh data with a short timeout for fast fallback on slow responses
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          sendTimeout: _shortTimeout,
          receiveTimeout: _shortTimeout,
        ),
      );
      await _cacheManager.saveCache(key, response.data);
      return response;
    } catch (e) {
      // On failure, return cached data if available
      final cachedData = _cacheManager.getCache(key);
      if (cachedData != null) {
        return Response(
          requestOptions: RequestOptions(path: path),
          data: cachedData,
          statusCode: 200,
        );
      }
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
