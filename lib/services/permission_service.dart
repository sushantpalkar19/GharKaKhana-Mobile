import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

class PermissionService {
  PermissionService._();

  // Permission Rationale Messages
  static const String notificationRationale =
      'GharKaKhana uses notifications to inform you about:\n\n'
      '• Order Status\n'
      '• Delivery Updates\n'
      '• Payment Confirmation\n'
      '• Offers\n'
      '• Important Announcements';

  static const String locationRationale =
      'GharKaKhana uses your location to:\n\n'
      '• Find nearby messes\n'
      '• Show accurate delivery estimates\n'
      '• Auto-select delivery address';

  static const String cameraRationale =
      'GharKaKhana uses camera to:\n\n'
      '• Take profile photos\n'
      '• Upload mess images';

  static const String storageRationale =
      'GharKaKhana needs storage access to:\n\n'
      '• Upload profile pictures\n'
      '• Upload mess banners\n'
      '• Upload meal images\n'
      '• Upload menu images';

  // Check Permission Status
  static Future<bool> isNotificationGranted() async {
    if (kDebugMode) {
      debugPrint('[PermissionService] Checking notification permission');
    }
    return await Permission.notification.isGranted;
  }

  static Future<bool> isLocationGranted() async {
    if (kDebugMode) {
      debugPrint('[PermissionService] Checking location permission');
    }
    return await Permission.location.isGranted;
  }

  static Future<bool> isCameraGranted() async {
    if (kDebugMode) {
      debugPrint('[PermissionService] Checking camera permission');
    }
    return await Permission.camera.isGranted;
  }

  static Future<bool> isStorageGranted() async {
    if (kDebugMode) {
      debugPrint('[PermissionService] Checking storage permission');
    }
    // Try modern permission first (Android 13+)
    final status = await Permission.photos.status;
    if (status.isGranted) return true;
    
    // Fallback to legacy permission (Android 12 and below)
    return await Permission.storage.isGranted;
  }

  // Request Permissions
  static Future<bool> requestNotificationPermission() async {
    if (kDebugMode) {
      debugPrint('[PermissionService] Requesting notification permission');
    }
    final status = await Permission.notification.request();
    if (kDebugMode) {
      debugPrint('[PermissionService] Notification permission status: $status');
    }
    return status.isGranted;
  }

  static Future<bool> requestLocationPermission() async {
    if (kDebugMode) {
      debugPrint('[PermissionService] Requesting location permission');
    }
    final status = await Permission.location.request();
    if (kDebugMode) {
      debugPrint('[PermissionService] Location permission status: $status');
    }
    return status.isGranted;
  }

  static Future<bool> requestCameraPermission() async {
    if (kDebugMode) {
      debugPrint('[PermissionService] Requesting camera permission');
    }
    final status = await Permission.camera.request();
    if (kDebugMode) {
      debugPrint('[PermissionService] Camera permission status: $status');
    }
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    if (kDebugMode) {
      debugPrint('[PermissionService] Requesting storage permission');
    }
    // Try modern permission first (Android 13+)
    var status = await Permission.photos.request();
    if (status.isGranted) {
      if (kDebugMode) {
        debugPrint('[PermissionService] Photos permission granted');
      }
      return true;
    }
    
    // Fallback to legacy permission (Android 12 and below)
    status = await Permission.storage.request();
    if (kDebugMode) {
      debugPrint('[PermissionService] Storage permission status: $status');
    }
    return status.isGranted;
  }

  // Check if Permanently Denied
  static Future<bool> isNotificationPermanentlyDenied() async {
    final status = await Permission.notification.status;
    return status.isPermanentlyDenied;
  }

  static Future<bool> isLocationPermanentlyDenied() async {
    final status = await Permission.location.status;
    return status.isPermanentlyDenied;
  }

  static Future<bool> isCameraPermanentlyDenied() async {
    final status = await Permission.camera.status;
    return status.isPermanentlyDenied;
  }

  static Future<bool> isStoragePermanentlyDenied() async {
    final status = await Permission.photos.status;
    if (status.isPermanentlyDenied) return true;
    
    final legacyStatus = await Permission.storage.status;
    return legacyStatus.isPermanentlyDenied;
  }

  // Open App Settings
  static Future<void> openAppSettings() async {
    if (kDebugMode) {
      debugPrint('[PermissionService] Opening app settings');
    }
    await AppSettings.openAppSettings();
  }

  // Open Notification Settings (Android 13+)
  static Future<void> openNotificationSettings() async {
    if (kDebugMode) {
      debugPrint('[PermissionService] Opening notification settings');
    }
    await AppSettings.openAppSettings(type: AppSettingsType.notification);
  }
}
