import 'package:shared_preferences/shared_preferences.dart';
import 'api_services.dart';

class AuthService {
  final ApiService apiService = ApiService();

  Future<bool> login(String email, String password) async {
    try {
      final response = await apiService.dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final token = response.data['data']['token'];

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', token);

      return true;
    } catch (e) {
      return false;
    }
  }
}