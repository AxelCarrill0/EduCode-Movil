import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  StorageService._(this._secureStorage, this._prefs);

  static Future<StorageService> create() async {
    const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
    );
    final prefs = await SharedPreferences.getInstance();
    return StorageService._(secureStorage, prefs);
  }

  // Token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return _secureStorage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  // User
  Future<void> saveUser(Map<String, dynamic> user) async {
    await _secureStorage.write(key: 'auth_user', value: jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final userStr = await _secureStorage.read(key: 'auth_user');
    if (userStr == null) return null;
    try {
      return jsonDecode(userStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteUser() async {
    await _secureStorage.delete(key: 'auth_user');
  }

  // Theme preference
  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool('is_dark_mode', isDark);
  }

  Future<bool> getDarkMode() async {
    return _prefs.getBool('is_dark_mode') ?? false;
  }

  // Generic preferences
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    return _prefs.getBool(key) ?? true;
  }

  // Session check
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAuth() async {
    await deleteToken();
    await deleteUser();
  }
}