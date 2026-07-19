import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:educode_mobile/core/network/api_client.dart';
import 'package:educode_mobile/core/storage/storage_service.dart';
import 'package:educode_mobile/models/auth_user.dart';

class AuthService {
  final ApiClient _api;
  final StorageService _storage;

  AuthService({required this._api, required this._storage});

  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      '/auth/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
      auth: false,
    );

    if (response.statusCode >= 400) {
      throw handleApiError(response);
    }

    final data = _parseResponse(response);
    final user = _mapUser(data['user'] as Map<String, dynamic>);
    final token = data['session']?['access_token'] as String? ?? data['access_token'] as String?;
    if (token == null) throw Exception('No se recibió token de autenticación');
    await _saveSession(token, user);
    return user;
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post(
      '/auth/login',
      body: {'email': email, 'password': password},
      auth: false,
    );

    if (response.statusCode >= 400) {
      throw handleApiError(response);
    }

    final data = _parseResponse(response);
    final user = _mapUser(data['user'] as Map<String, dynamic>);
    final token = data['session']?['access_token'] as String? ?? data['access_token'] as String?;
    if (token == null) throw Exception('No se recibió token de autenticación');
    await _saveSession(token, user);
    return user;
  }

  Future<AuthUser?> getMe() async {
    try {
      final response = await _api.get('/auth/me');
      if (response.statusCode == 200) {
        final data = _parseResponse(response);
        return _mapUser(data['user'] as Map<String, dynamic>);
      }
    } catch (_) {}
    return null;
  }

  Future<AuthUser> updateProfile({
    String? name,
    String? bio,
  }) async {
    final response = await _api.put(
      '/auth/profile',
      body: {'name': name, 'bio': bio},
    );

    if (response.statusCode >= 400) {
      throw handleApiError(response);
    }

    final data = _parseResponse(response);
    final user = _mapUser(data['user'] as Map<String, dynamic>);
    await _storage.saveUser(user.toJson());
    return user;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirm,
  }) async {
    final response = await _api.put(
      '/auth/change-password',
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirm': newPasswordConfirm,
      },
    );

    if (response.statusCode >= 400) {
      throw handleApiError(response);
    }
  }

  Future<void> deleteAccount() async {
    final response = await _api.delete('/auth/account');

    if (response.statusCode >= 400) {
      throw handleApiError(response);
    }

    await logout();
  }

  Future<void> logout() async {
    await _storage.clearAuth();
  }

  Future<bool> hasValidSession() async {
    return await _storage.hasToken();
  }

  Future<AuthUser?> restoreSession() async {
    if (await hasValidSession()) {
      return await getMe();
    }
    return null;
  }

  Future<void> _saveSession(String token, AuthUser user) async {
    await _storage.saveToken(token);
    await _storage.saveUser(user.toJson());
  }

  AuthUser _mapUser(Map<String, dynamic> json) {
    return AuthUser.fromJson(json);
  }

  Map<String, dynamic> _parseResponse(http.Response response) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw handleApiError(response);
    }
  }
}