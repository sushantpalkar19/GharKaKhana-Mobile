import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  AuthService();

  Future<User> register(
    String fullName,
    String email,
    String phone,
    String password, {
    String role = 'customer',
    String? businessName,
    String? businessAddress,
    String? businessCity,
    String? businessPincode,
  }) async {
    debugPrint('[AuthService] Calling register — email=$email, role=$role');
    final body = {
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'password': password,
      'role': role,
    };
    
    // Add owner-specific fields if registering as owner
    if (role == 'owner') {
      if (businessName != null) body['businessName'] = businessName;
      if (businessAddress != null) body['businessAddress'] = businessAddress;
      if (businessCity != null) body['businessCity'] = businessCity;
      if (businessPincode != null) body['businessPincode'] = businessPincode;
    }
    
    final result = await ApiClient.post('/auth/register', body);
    final data = result['data'] as Map<String, dynamic>? ?? result['user'] as Map<String, dynamic>? ?? result;
    return User.fromJson(data);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    debugPrint('[AuthService] Calling login — email=$email');
    final result = await ApiClient.post('/auth/login', {
      'email': email,
      'password': password,
    });
    debugPrint('[AuthService] login raw result keys: ${result.keys.toList()}');
    final data = result['data'] as Map<String, dynamic>? ?? result;
    final userJson = data['user'] as Map<String, dynamic>? ?? data;
    final token = data['token'] as String? ?? data['accessToken'] as String? ?? '';
    final requiresPasswordChange = data['requiresPasswordChange'] as bool? ?? false;
    debugPrint('[AuthService] login extracted token length: ${token.length}');
    debugPrint('[AuthService] login extracted user keys: ${userJson.keys.toList()}');
    return {
      'user': User.fromJson(userJson),
      'token': token,
      'requiresPasswordChange': requiresPasswordChange,
    };
  }

  Future<User> getMe(String token) async {
    debugPrint('[AuthService] Calling getMe');
    final result = await ApiClient.get('/auth/me', token: token);
    final data = result['data'] as Map<String, dynamic>? ?? result['user'] as Map<String, dynamic>? ?? result;
    return User.fromJson(data);
  }

  Future<User> changePassword(String token, String oldPassword, String newPassword) async {
    debugPrint('[AuthService] Calling changePassword');
    final result = await ApiClient.post('/auth/change-password', {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    }, token: token);
    final data = result['data'] as Map<String, dynamic>? ?? result['user'] as Map<String, dynamic>? ?? result;
    return User.fromJson(data);
  }
}
