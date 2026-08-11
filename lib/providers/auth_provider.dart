import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  bool _isInitialized = false;
  bool _requiresPasswordChange = false;
  String? _error;
  Future<void>? _initFuture;

  final AuthService _authService;
  SharedPreferences? _prefs;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get requiresPasswordChange => _requiresPasswordChange;
  String? get error => _error;
  bool get isAuthenticated => _token != null && _user != null;

  Future<void> init() {
    _initFuture ??= _loadPersistedSession();
    return _initFuture!;
  }

  Future<void> _loadPersistedSession() async {
    debugPrint('[AuthProvider] init started');
    try {
      _prefs = await SharedPreferences.getInstance();
      _token = _prefs?.getString(AppConstants.accessTokenKey);
      final userJson = _prefs?.getString(AppConstants.userKey);
      if (userJson != null && userJson.isNotEmpty) {
        try {
          _user = User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
        } catch (_) {
          _user = null;
        }
      }
    } catch (e) {
      debugPrint('[AuthProvider] init exception: $e');
      _token = null;
      _user = null;
      _error = e.toString();
    } finally {
      _isInitialized = true;
      debugPrint(
        '[AuthProvider] auth initialized authenticated=$isAuthenticated',
      );
      notifyListeners();
    }
  }

  Future<bool> register(
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
    debugPrint('[AuthProvider] Calling register — email=$email, role=$role');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.register(
        fullName,
        email,
        phone,
        password,
        role: role,
        businessName: businessName,
        businessAddress: businessAddress,
        businessCity: businessCity,
        businessPincode: businessPincode,
      );
      _user = result;
      debugPrint('[AuthProvider] register succeeded — user=${_user?.fullName}, role=${_user?.role}');
      return true;
    } catch (e) {
      debugPrint('[AuthProvider] register exception: $e');
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    debugPrint('[AuthProvider] Calling login — email=$email');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _authService.login(email, password);
      _user = res['user'] as User;
      _token = res['token'] as String;
      _requiresPasswordChange = res['requiresPasswordChange'] as bool? ?? false;

      debugPrint(
        '[AuthProvider] login succeeded — user=${_user?.fullName}, role=${_user?.role}, status=${_user?.status}, token length=${_token?.length}, requiresPasswordChange=$_requiresPasswordChange',
      );

      _prefs ??= await SharedPreferences.getInstance();
      if (_token != null) {
        await _prefs!.setString(AppConstants.accessTokenKey, _token!);
      }
      if (_user != null) {
        await _prefs!.setString(
          AppConstants.userKey,
          jsonEncode(_user!.toJson()),
        );
      }

      return true;
    } catch (e) {
      debugPrint('[AuthProvider] login exception: $e');
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _error = null;

    if (_prefs != null) {
      await _prefs!.remove(AppConstants.accessTokenKey);
      await _prefs!.remove(AppConstants.userKey);
    }

    notifyListeners();
  }

  Future<bool> fetchMe() async {
    if (_token == null) return false;

    try {
      _user = await _authService.getMe(_token!);

      if (_prefs != null) {
        await _prefs!.setString(
          AppConstants.userKey,
          jsonEncode(_user!.toJson()),
        );
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('[AuthProvider] fetchMe exception: $e');
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (_token == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = await _authService.changePassword(
        _token!,
        oldPassword,
        newPassword,
      );

      _user = updatedUser;
      _requiresPasswordChange = false;

      if (_prefs != null) {
        await _prefs!.setString(
          AppConstants.userKey,
          jsonEncode(_user!.toJson()),
        );
      }

      debugPrint('[AuthProvider] Password changed successfully');
      return true;
    } catch (e) {
      debugPrint('[AuthProvider] changePassword exception: $e');
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get the appropriate dashboard route based on role and status
  String getDashboardRoute() {
    if (_user == null) {
      debugPrint('[AuthProvider] getDashboardRoute: user is null, returning /login');
      return '/login';
    }
    
    debugPrint('[AuthProvider] getDashboardRoute: role=${_user!.role}, status=${_user!.status}, requiresPasswordChange=$_requiresPasswordChange');
    
    switch (_user!.role) {
      case 'owner':
        // Check owner status
        if (_user!.status == 'pending') {
          debugPrint('[AuthProvider] getDashboardRoute: owner pending, returning /owner-verification');
          return '/owner-verification';
        } else if (_user!.status == 'rejected') {
          debugPrint('[AuthProvider] getDashboardRoute: owner rejected, returning /owner-rejected');
          return '/owner-rejected';
        } else if (_user!.status == 'suspended') {
          debugPrint('[AuthProvider] getDashboardRoute: owner suspended, returning /owner-suspended');
          return '/owner-suspended';
        } else if (_user!.status == 'active') {
          debugPrint('[AuthProvider] getDashboardRoute: owner active, returning /owner-app');
          return '/owner-app';
        }
        debugPrint('[AuthProvider] getDashboardRoute: owner unknown status, returning /login');
        return '/login';
      case 'customer':
        debugPrint('[AuthProvider] getDashboardRoute: customer, returning /customer-app');
        return '/customer-app';
      case 'admin':
        // Check if admin needs to change password
        if (_requiresPasswordChange) {
          debugPrint('[AuthProvider] getDashboardRoute: admin requires password change, returning /change-password');
          return '/change-password';
        }
        debugPrint('[AuthProvider] getDashboardRoute: admin, returning /admin-dashboard');
        return '/admin-dashboard';
      default:
        debugPrint('[AuthProvider] getDashboardRoute: unknown role, returning /customer-app');
        return '/customer-app';
    }
  }
}
