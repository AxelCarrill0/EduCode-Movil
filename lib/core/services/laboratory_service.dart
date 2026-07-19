import 'dart:convert';

import 'package:educode_mobile/core/network/api_client.dart';
import 'package:educode_mobile/models/execute_result.dart';

class LaboratoryService {
  final ApiClient _api;

  LaboratoryService({required this._api});

  Future<ExecuteResult> execute(String code) async {
    final response = await _api.post('/execute', body: {'code': code});

    if (response.statusCode >= 400) {
      throw handleApiError(response);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return ExecuteResult.fromJson(data);
  }
}
