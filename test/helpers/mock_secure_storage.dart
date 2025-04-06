import 'package:flutter/src/foundation/basic_types.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MockSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage[key] = value ?? '';
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage.remove(key);
  }

  @override
  Future<bool> containsKey({
    required String key,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _storage.containsKey(key);
  }

  @override
  Future<void> deleteAll({
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage.clear();
  }

  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return Map<String, String>.from(_storage);
  }

  @override
  AndroidOptions get aOptions => throw UnimplementedError();

  @override
  IOSOptions get iOptions => throw UnimplementedError();

  @override
  Future<bool?> isCupertinoProtectedDataAvailable() {
    throw UnimplementedError();
  }

  @override
  LinuxOptions get lOptions => throw UnimplementedError();

  @override
  MacOsOptions get mOptions => throw UnimplementedError();

  @override
  Stream<bool>? get onCupertinoProtectedDataAvailabilityChanged => throw UnimplementedError();

  @override
  void registerListener({required String key, required ValueChanged<String?> listener}) {
  }

  @override
  void unregisterAllListeners() {
  }

  @override
  void unregisterAllListenersForKey({required String key}) {
  }

  @override
  void unregisterListener({required String key, required ValueChanged<String?> listener}) {
  }

  @override
  WindowsOptions get wOptions => throw UnimplementedError();

  @override
  WebOptions get webOptions => throw UnimplementedError();
}
