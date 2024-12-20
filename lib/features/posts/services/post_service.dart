import 'package:graduan_test/core/services/api_service.dart';
import 'package:graduan_test/core/services/shared_pref_services.dart';
import 'package:graduan_test/features/posts/models/post.dart';

class PostService {
  final ApiService apiService;
  final token = SharedPreferencesService().getString('auth_token');
  PostService({String baseUrl = 'https://flutter-api-demo.graduan.xyz/api'})
      : apiService = ApiService(
          baseUrl: baseUrl,
        );

  Future<List<Post>> fetchPosts() async {
    final response = await apiService.get(
      '/post',
      headers: {'Accept': 'application/json'},
    );
    if (response != null) {
      final data = (response as List).map((e) => Post.fromJson(e)).toList();
      data.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      return data;
    }

    return [];
  }

  Future<Post?> createPost({required String title}) async {
    final body = {
      'title': title,
    };
    if (token != null) {
      final response = await apiService.post(
        ('/dashboard/post'),
        body,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return Post.fromJson(response);
    }
    return null;
  }
}
