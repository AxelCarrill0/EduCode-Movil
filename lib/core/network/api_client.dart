import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:educode_mobile/core/storage/storage_service.dart';

class ApiClient {
  final String baseUrl;
  final StorageService _storage;

  ApiClient({required this.baseUrl, required this._storage});

  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParams,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: queryParams);
    final headers = await _buildHeaders(auth);
    return http.get(uri, headers: headers);
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _buildHeaders(auth);
    return http.post(uri, headers: headers, body: jsonEncode(body));
  }

  Future<http.Response> put(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _buildHeaders(auth);
    return http.put(uri, headers: headers, body: jsonEncode(body));
  }

  Future<http.Response> delete(String path, {bool auth = true}) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _buildHeaders(auth);
    return http.delete(uri, headers: headers);
  }

  Future<Map<String, String>> _buildHeaders(bool auth) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (auth) {
      final token = await _storage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? details;

  ApiException({required this.message, this.statusCode, this.details});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

VoidCallback? _onUnauthorized;

void setUnauthorizedHandler(VoidCallback handler) {
  _onUnauthorized = handler;
}

ApiException handleApiError(http.Response response) {
  String message;
  Map<String, dynamic>? details;

  try {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    message = (data['message'] ?? data['error'] ?? 'Error del servidor') as String;
    details = data;
  } catch (_) {
    switch (response.statusCode) {
      case 400:
        message = 'Datos inválidos';
        break;
      case 401:
        message = 'Tu sesión expiró. Inicia sesión nuevamente.';
        break;
      case 403:
        message = 'No tienes permiso para esta acción';
        break;
      case 404:
        message = 'Recurso no encontrado';
        break;
      case 500:
        message = 'Error del servidor. Intenta más tarde.';
        break;
      default:
        message = 'Error de conexión. Verifica tu internet.';
    }
  }

  if (response.statusCode == 401 && _onUnauthorized != null) {
    _onUnauthorized!();
  }

  return ApiException(message: message, statusCode: response.statusCode, details: details);
}