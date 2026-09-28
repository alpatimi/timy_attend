import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_services.dart';

class ProfileService {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) return null;

      final response = await apiService.dio.get(
        '/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      return response.data['data'] ?? response.data;
    } on DioException catch (e) {
      debugPrint('GET Profile Error: ${e.response?.statusCode} - ${e.response?.data}');
      return null;
    } catch (e) {
      debugPrint('GET Profile Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateProfile({
  required String name,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    if (token == null) {
      return null;
    }

    final response = await apiService.dio.put(
      '/profile',
      data: {
        'name': name,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return response.data['data'];
  } catch (e) {
    print('UPDATE PROFILE ERROR: $e');
    return null;
  }
}
}