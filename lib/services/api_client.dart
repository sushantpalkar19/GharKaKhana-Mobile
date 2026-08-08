import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/config/api_config.dart';

class ApiClient {
  static final http.Client _client = http.Client();

  static String get baseUrl => ApiConfig.baseUrl;

  static Map<String, String> _headers([String? token]) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final body = utf8.decode(response.bodyBytes);
    debugPrint('[ApiClient] Response status: ${response.statusCode}');
    debugPrint('[ApiClient] Response body: $body');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(body) as Map<String, dynamic>;
    } else {
      try {
        final decoded = jsonDecode(body) as Map<String, dynamic>;
        throw Exception(decoded['message'] ?? 'Request failed');
      } catch (_) {
        throw Exception('Request failed with status ${response.statusCode}');
      }
    }
  }

  static Future<Map<String, dynamic>> get(String path, {String? token}) async {
    final uri = Uri.parse('$baseUrl$path');
    debugPrint('[ApiClient] GET $uri');
    try {
      final response = await _client.get(uri, headers: _headers(token));
      return _handleResponse(response);
    } catch (e) {
      debugPrint('[ApiClient] GET exception: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body, {String? token}) async {
    final uri = Uri.parse('$baseUrl$path');
    debugPrint('[ApiClient] POST $uri');
    debugPrint('[ApiClient] Request body: ${jsonEncode(body)}');
    try {
      final response = await _client.post(uri, headers: _headers(token), body: jsonEncode(body));
      return _handleResponse(response);
    } catch (e) {
      debugPrint('[ApiClient] POST exception: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body, {String? token}) async {
    final uri = Uri.parse('$baseUrl$path');
    debugPrint('[ApiClient] PUT $uri');
    debugPrint('[ApiClient] Request body: ${jsonEncode(body)}');
    try {
      final response = await _client.put(uri, headers: _headers(token), body: jsonEncode(body));
      return _handleResponse(response);
    } catch (e) {
      debugPrint('[ApiClient] PUT exception: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> body, {String? token}) async {
    final uri = Uri.parse('$baseUrl$path');
    debugPrint('[ApiClient] PATCH $uri');
    debugPrint('[ApiClient] Request body: ${jsonEncode(body)}');
    try {
      final response = await _client.patch(uri, headers: _headers(token), body: jsonEncode(body));
      return _handleResponse(response);
    } catch (e) {
      debugPrint('[ApiClient] PATCH exception: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> delete(String path, {String? token}) async {
    final uri = Uri.parse('$baseUrl$path');
    debugPrint('[ApiClient] DELETE $uri');
    try {
      final response = await _client.delete(uri, headers: _headers(token));
      return _handleResponse(response);
    } catch (e) {
      debugPrint('[ApiClient] DELETE exception: $e');
      rethrow;
    }
  }
}
