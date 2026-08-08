import 'package:flutter/foundation.dart';
import '../models/app_version.dart';
import 'api_client.dart';

class AppVersionService {
  AppVersionService();

  Future<AppVersion> checkVersion() async {
    debugPrint('[AppVersionService] Checking for app version update...');
    
    try {
      final result = await ApiClient.get('/app/version');
      final data = result['data'] as Map<String, dynamic>? ?? result;
      
      debugPrint('[AppVersionService] Version check successful');
      debugPrint('[AppVersionService] Latest version: ${data['latestVersion']}');
      debugPrint('[AppVersionService] Force update: ${data['forceUpdate']}');
      debugPrint('[AppVersionService] Maintenance mode: ${data['maintenanceMode']}');
      
      return AppVersion.fromJson(data);
    } catch (e) {
      debugPrint('[AppVersionService] Version check failed: $e');
      rethrow;
    }
  }
}
