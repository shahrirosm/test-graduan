import 'dart:developer';

import 'package:graduan_test/core/services/api_service.dart';
import 'package:graduan_test/core/services/shared_pref_services.dart';
import 'package:graduan_test/features/profile/models/user.dart';

class ProfileService {
  final ApiService apiService;
  final token = SharedPreferencesService().getString('auth_token');
  ProfileService({String baseUrl = 'https://flutter-api-demo.graduan.xyz/api'}) : apiService = ApiService(baseUrl: baseUrl);

  Future<User> fetchUserInfo() async {
    final response = await apiService.get('/dashboard/profile', headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    log('response: $response');
    final data = User.fromJson(response);
    return data;
  }

  Future<dynamic> updateUserInfo({required String name}) async {
    final body = {
      'name': name,
    };
    if (token != null) {
      final response = await apiService.put(
        ('/dashboard/profile'),
        body,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      log('response: $response');
      return response;
    }
  }

  Future<bool> logout() async {
    if (token != null) {
      log('logout');
      await apiService.post('/dashboard/logout', {}, headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      });
      await SharedPreferencesService().remove('auth_token');
      return true;
    }
    return false;
  }
}
