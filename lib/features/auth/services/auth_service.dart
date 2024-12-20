import 'package:graduan_test/core/services/api_service.dart';
import 'package:graduan_test/core/services/shared_pref_services.dart';
import 'package:graduan_test/features/auth/models/login_request.dart';
import 'package:graduan_test/features/auth/models/login_response.dart';

class AuthService {
  final ApiService apiService;

  AuthService({String baseUrl = 'https://flutter-api-demo.graduan.xyz/api'}) : apiService = ApiService(baseUrl: baseUrl);

  Future<dynamic> login(String email, String password) async {
    final loginRequest = LoginRequest(email: email, password: password);
    final response = await apiService.post(
      '/login',
      loginRequest.toJson(),
      headers: {"Accept": "application/json"},
    );
    if (response != null) {
      final token = LoginResponse.fromJson(response).token;
      final sharedPreferencesService = SharedPreferencesService();
      if (token != null) {
        await sharedPreferencesService.setString('auth_token', token);
      }
    }
  }
}
