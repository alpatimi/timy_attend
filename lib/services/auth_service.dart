import 'api_service.dart';

class AuthService {
  // Menggunakan ApiService
  final ApiService apiService;

  AuthService(this.apiService);

  // Method login akan kita isi setelah
  // endpoint backend sudah tersedia.
  Future<void> login({
    required String email,
    required String password,
  }) async {
    // TODO:
    // Hubungkan ke endpoint login backend.
  }

  // Method register juga akan dihubungkan
  // setelah API backend tersedia.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // TODO:
    // Hubungkan ke endpoint register backend.
  }
}