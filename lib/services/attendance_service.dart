import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_services.dart';

class AttendanceService {
  final ApiService apiService = ApiService();

  Future<bool> checkIn({
    required String latitude,
    required String longitude,
    required String address,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token');

      if (token == null) {
        return false;
      }

      final response = await apiService.dio.post(
        '/absen/check-in',
        data: {
          'check_in_lat': latitude,
          'check_in_lng': longitude,
          'check_in_address': address,
          'status': 'masuk',
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('CHECK IN ERROR: $e');

      if (e is DioException) {
        print('STATUS CODE: ${e.response?.statusCode}');
        print('RESPONSE DATA: ${e.response?.data}');
      }

      return false;
    }
  }

  Future<bool> checkOut({
  required String latitude,
  required String longitude,
  required String address,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    if (token == null) {
      return false;
    }

    final response = await apiService.dio.post(
      '/absen/check-out',
      data: {
        'check_out_lat': latitude,
        'check_out_lng': longitude,
        'check_out_location': '$latitude, $longitude',
        'check_out_address': address,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return response.statusCode == 200;
  } catch (e) {
    print('CHECK OUT ERROR: $e');

    if (e is DioException) {
      print('STATUS CODE: ${e.response?.statusCode}');
      print('RESPONSE DATA: ${e.response?.data}');
    }

    return false;
  }
}
}
