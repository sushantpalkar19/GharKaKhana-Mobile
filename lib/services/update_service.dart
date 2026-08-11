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
          throw Exception('Storage permission is required to download updates');
        }
      }

      // Get download directory
      final directory = await getTemporaryDirectory();
      final apkPath = '${directory.path}/gharkakhana_update.apk';

      // Delete existing file if present
      final file = File(apkPath);
      if (await file.exists()) {
        await file.delete();
      }

      _cancelToken = CancelToken();

      await _dio.download(
        url,
        apkPath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            debugPrint('[CustomUpdateService] Download progress: ${(progress * 100).toStringAsFixed(1)}%');
            onProgress?.call(progress);
          }
        },
      );

      debugPrint('[CustomUpdateService] Download complete: $apkPath');
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
        if (!status.isGranted) {
          // Guide user to enable install permission
          await openAppSettings();
          throw Exception('Install permission is required. Please enable it in settings.');
        }
      }

      // Verify file exists
      final file = File(apkPath);
      if (!await file.exists()) {
        throw Exception('APK file not found at $apkPath');
      }

      // Open APK with Android installer
      final result = await OpenFilex.open(apkPath);
      debugPrint('[CustomUpdateService] Install result: ${result.type}');
      
      if (result.type != ResultType.done) {
        throw Exception('Failed to open APK installer');
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
