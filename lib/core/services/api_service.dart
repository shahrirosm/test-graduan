import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$path');
    try {
      final response = await http.get(url, headers: headers);
      log(response.body.toString());
      return _handleHttpResponse(response);
    } catch (e) {
      log('GET request error: $e');
      throw ApiException('Network error: $e');
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$path');
    log(body.toString());
    try {
      final response = await http.post(url, headers: headers, body: body);
      log(response.body.toString());
      return _handleHttpResponse(response);
    } catch (e) {
      log('POST request error: $e');
      throw ApiException('Network error: $e');
    }
  }

  Future<dynamic> put(String path, Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$path');
    try {
      final response = await http.put(url, headers: headers, body: body);
      log(response.body.toString());

      return _handleHttpResponse(response);
    } catch (e) {
      log('PUT request error: $e');
      throw ApiException('Network error: $e');
    }
  }

  dynamic _handleHttpResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        if (response.body.isEmpty) {
          return null;
        }
        return jsonDecode(response.body);
      } catch (e) {
        log('Error parsing response: $e');
        throw ApiException('Error Parsing Response: Invalid JSON format');
      }
    } else {
      log('HTTP error ${response.statusCode}: ${response.body}');
      switch (response.statusCode) {
        case 400:
          throw ApiException('Bad Request: ${response.body}');
        case 401:
          throw ApiException('Unauthorized: ${response.body}');
        case 403:
          throw ApiException('Forbidden: ${response.body}');
        case 404:
          throw ApiException('Not Found: ${response.body}');
        case 422:
          final errorResponse = jsonDecode(response.body);
          final errorMessage = errorResponse['message'] ?? 'Unknown error';
          throw ApiException('$errorMessage');
        case 500:
          throw ApiException('Internal Server Error: ${response.body}');
        default:
          throw ApiException('HTTP Error ${response.statusCode}: ${response.body}');
      }
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
