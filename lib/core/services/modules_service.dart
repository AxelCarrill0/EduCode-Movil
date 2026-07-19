import 'dart:convert';

import 'package:educode_mobile/core/network/api_client.dart';
import 'package:educode_mobile/models/module.dart';

class ModulesService {
  final ApiClient _api;

  ModulesService({required this._api});

  Future<List<Module>> getModules() async {
    final response = await _api.get('/modules');

    if (response.statusCode >= 400) {
      throw handleApiError(response);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final modulesList = data['modules'] as List<dynamic>? ?? [];
    return modulesList
        .map((m) => Module.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  Future<Module> getModule(int id) async {
    final response = await _api.get('/modules/$id');

    if (response.statusCode >= 400) {
      throw handleApiError(response);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Module.fromJson(data['module'] as Map<String, dynamic>? ?? data);
  }
}