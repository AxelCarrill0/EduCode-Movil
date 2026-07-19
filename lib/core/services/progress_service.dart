import 'dart:convert';

import 'package:educode_mobile/core/network/api_client.dart';
import 'package:educode_mobile/models/progress.dart';

class ProgressService {
  final ApiClient _api;

  ProgressService({required this._api});

  Future<Progress> getProgress() async {
    final response = await _api.get('/progress');

    if (response.statusCode >= 400) {
      throw handleApiError(response);
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Progress.fromJson(data);
  }

  Future<void> completeLesson(int moduleId, int lessonId) async {
    final response = await _api.post(
      '/progress/lessons/complete',
      body: {'moduleId': moduleId, 'lessonId': lessonId},
    );

    if (response.statusCode >= 400) {
      throw handleApiError(response);
    }
  }

  Future<void> resetProgress() async {
    final response = await _api.delete('/progress');

    if (response.statusCode >= 400) {
      throw handleApiError(response);
    }
  }
}