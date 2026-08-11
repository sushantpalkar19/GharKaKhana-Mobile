import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/app_version.dart';
import 'app_version_service.dart';

/// Abstract base class for update strategies
/// This allows easy migration to Play Store In-App Updates in the future
abstract class UpdateService {
  /// Check for available update
  Future<AppVersion?> checkUpdate();
  
  /// Download the update
  Future<String> downloadUpdate(String url, {Function(double progress)? onProgress});
  
  /// Install the update
  Future<void> installUpdate(String apkPath);
  
  /// Cancel ongoing download
  Future<void> cancelDownload();
}

/// Custom APK-based update service
/// Used for APK distribution (current implementation)
class CustomUpdateService implements UpdateService {
  final AppVersionService _versionService;
  final Dio _dio = Dio();
  CancelToken? _cancelToken;

  CustomUpdateService(this._versionService);

  @override
  Future<AppVersion?> checkUpdate() async {
    try {
      return await _versionService.checkVersion();
    } catch (e) {
      debugPrint('[CustomUpdateService] Check update failed: $e');
      return null;
    }
  }

  @override
  Future<String> downloadUpdate(String url, {Function(double progress)? onProgress}) async {
    debugPrint('[CustomUpdateService] Downloading from: $url');

    try {
      // Request storage permission for Android 10 and below
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          debugPrint('[CustomUpdateService] Storage permission denied');
          throw Exception('Storage permission is required to download updates');
        }
      }

      // Use external storage directory for better installer access
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        debugPrint('[CustomUpdateService] Failed to get external storage directory');
        throw Exception('Failed to access external storage');
      }
      
      final apkPath = '${directory.path}/GharKaKhana-v1.1.0.apk';
      debugPrint('[CustomUpdateService] Download path: $apkPath');

      // Delete existing file if present
      final file = File(apkPath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('[CustomUpdateService] Deleted existing file');
      }

      _cancelToken = CancelToken();

      debugPrint('[CustomUpdateService] Starting download...');
      final response = await _dio.download(
        url,
        apkPath,
        cancelToken: _cancelToken,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          maxRedirects: 5,
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            debugPrint('[CustomUpdateService] Download progress: ${(progress * 100).toStringAsFixed(1)}% ($received/$total bytes)');
            onProgress?.call(progress);
          } else {
            debugPrint('[CustomUpdateService] Downloaded: $received bytes (total unknown)');
          }
        },
      );

      debugPrint('[CustomUpdateService] Download complete. HTTP status: ${response.statusCode}');

      // Verify file exists
      if (!await file.exists()) {
        debugPrint('[CustomUpdateService] ERROR: File does not exist after download');
        throw Exception('Download failed - file not created');
      }

      // Verify file size
      final fileSize = await file.length();
      debugPrint('[CustomUpdateService] Downloaded file size: $fileSize bytes (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)');

      if (fileSize < 1000000) { // Less than 1MB is likely an error page
        debugPrint('[CustomUpdateService] ERROR: File too small, likely not an APK');
        // Read first few bytes to check if it's HTML
        final bytes = await file.openRead(0, 100).toList();
        final header = String.fromCharCodes(bytes[0].toList());
        debugPrint('[CustomUpdateService] File header: $header');
        throw Exception('Downloaded file is too small ($fileSize bytes). May be an error page instead of APK.');
      }

      // Verify APK signature
      final bytes = await file.readAsBytes();
      final isApk = bytes.length >= 4 && 
                   bytes[0] == 0x50 && // P
                   bytes[1] == 0x4B && // K
                   bytes[2] == 0x03 && 
                   bytes[3] == 0x04;
      
      if (!isApk) {
        debugPrint('[CustomUpdateService] ERROR: File is not a valid APK (invalid signature)');
        final header = String.fromCharCodes(bytes.sublist(0, 100).toList());
        debugPrint('[CustomUpdateService] File header: $header');
        throw Exception('Downloaded file is not a valid APK. May be an HTML error page.');
      }

      debugPrint('[CustomUpdateService] APK signature verified successfully');
      return apkPath;
    } catch (e) {
      debugPrint('[CustomUpdateService] Download failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> installUpdate(String apkPath) async {
    debugPrint('[CustomUpdateService] Installing: $apkPath');

    try {
      // Request install permission for Android 13+
      if (Platform.isAndroid) {
        final status = await Permission.requestInstallPackages.request();
        debugPrint('[CustomUpdateService] Install permission status: $status');
        if (!status.isGranted) {
          debugPrint('[CustomUpdateService] Install permission denied');
          // Guide user to enable install permission
          await openAppSettings();
          throw Exception('Install permission is required. Please enable it in settings.');
        }
      }

      // Verify file exists
      final file = File(apkPath);
      if (!await file.exists()) {
        debugPrint('[CustomUpdateService] ERROR: APK file not found at $apkPath');
        throw Exception('APK file not found at $apkPath');
      }

      final fileSize = await file.length();
      debugPrint('[CustomUpdateService] APK file size before install: $fileSize bytes');

      // Open APK with Android installer
      debugPrint('[CustomUpdateService] Opening APK with installer...');
      final result = await OpenFilex.open(apkPath);
      debugPrint('[CustomUpdateService] Install result type: ${result.type}');
      debugPrint('[CustomUpdateService] Install result message: ${result.message}');
      
      if (result.type == ResultType.done) {
        debugPrint('[CustomUpdateService] APK installer opened successfully');
      } else if (result.type == ResultType.noAppToOpen) {
        debugPrint('[CustomUpdateService] ERROR: No app available to open APK');
        throw Exception('No app available to install APK. Please check your device settings.');
      } else if (result.type == ResultType.permissionDenied) {
        debugPrint('[CustomUpdateService] ERROR: Permission denied to open APK');
        throw Exception('Permission denied. Please enable install packages permission.');
      } else {
        debugPrint('[CustomUpdateService] ERROR: Failed to open APK installer');
        throw Exception('Failed to open APK installer: ${result.message}');
      }
    } catch (e) {
      debugPrint('[CustomUpdateService] Installation failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> cancelDownload() async {
    debugPrint('[CustomUpdateService] Download cancelled');
    _cancelToken?.cancel();
  }
}

/// Future: Play Store In-App Updates service
/// To be implemented when migrating to Google Play Store
class PlayStoreUpdateService implements UpdateService {
  @override
  Future<AppVersion?> checkUpdate() async {
    // TODO: Implement Play Core In-App Updates check
    throw UnimplementedError('Play Store updates not yet implemented');
  }
  
  @override
  Future<String> downloadUpdate(String url, {Function(double progress)? onProgress}) async {
    // Play Store handles download automatically
    throw UnimplementedError('Play Store updates not yet implemented');
  }
  
  @override
  Future<void> installUpdate(String apkPath) async {
    // Play Store handles installation automatically
    throw UnimplementedError('Play Store updates not yet implemented');
  }
  
  @override
  Future<void> cancelDownload() async {
    // Play Store handles cancellation automatically
    throw UnimplementedError('Play Store updates not yet implemented');
  }
}
