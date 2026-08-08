import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_version.dart';
import '../services/update_service.dart';
import '../services/update_logger.dart';

enum UpdateState {
  idle,
  checking,
  updateAvailable,
  downloading,
  installing,
  error,
  upToDate,
}

class UpdateProvider extends ChangeNotifier {
  final UpdateService _updateService;
  SharedPreferences? _prefs;
  
  AppVersion? _appVersion;
  UpdateState _state = UpdateState.idle;
  String? _errorMessage;
  double _downloadProgress = 0.0;
  String? _ignoredVersion;
  
  UpdateProvider(this._updateService);
  
  AppVersion? get appVersion => _appVersion;
  UpdateState get state => _state;
  String? get errorMessage => _errorMessage;
  double get downloadProgress => _downloadProgress;
  String? get ignoredVersion => _ignoredVersion;
  
  bool get isChecking => _state == UpdateState.checking;
  bool get isUpdateAvailable => _state == UpdateState.updateAvailable;
  bool get isDownloading => _state == UpdateState.downloading;
  bool get isInstalling => _state == UpdateState.installing;
  bool get hasError => _state == UpdateState.error;
  bool get isUpToDate => _state == UpdateState.upToDate;
  
  /// Initialize provider
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ignoredVersion = _prefs?.getString('ignored_version');
    await UpdateLogger.init();
    notifyListeners();
  }
  
  /// Check for updates
  Future<void> checkForUpdate({bool forceCheck = false}) async {
    _state = UpdateState.checking;
    _errorMessage = null;
    notifyListeners();
    
    await UpdateLogger.logEvent(UpdateEvent(
      type: UpdateEventType.checkStarted,
      timestamp: DateTime.now(),
      metadata: {'forceCheck': forceCheck},
    ));
    
    try {
      final version = await _updateService.checkUpdate();
      
      if (version == null) {
        _state = UpdateState.error;
        _errorMessage = 'Failed to check for updates';
        await UpdateLogger.logEvent(UpdateEvent(
          type: UpdateEventType.checkFailed,
          message: _errorMessage,
          timestamp: DateTime.now(),
        ));
        notifyListeners();
        return;
      }
      
      _appVersion = version;
      
      await UpdateLogger.logEvent(UpdateEvent(
        type: UpdateEventType.checkSuccess,
        version: version.latestVersion,
        timestamp: DateTime.now(),
      ));
      
      // Check maintenance mode
      if (version.maintenanceMode) {
        _state = UpdateState.updateAvailable;
        await UpdateLogger.logEvent(UpdateEvent(
          type: UpdateEventType.maintenanceMode,
          message: version.maintenanceMessage,
          timestamp: DateTime.now(),
        ));
        notifyListeners();
        return;
      }
      
      // Check if update is available
      final currentVersion = await _getCurrentVersion();
      final needsUpdate = _needsUpdate(currentVersion, version.latestVersion);
      
      if (needsUpdate) {
        // Check if user ignored this version
        if (!forceCheck && _ignoredVersion == version.latestVersion && !version.forceUpdate) {
          _state = UpdateState.upToDate;
          notifyListeners();
          return;
        }
        
        _state = UpdateState.updateAvailable;
        await UpdateLogger.logEvent(UpdateEvent(
          type: UpdateEventType.updateAvailable,
          version: version.latestVersion,
          message: 'Force: ${version.forceUpdate}',
          timestamp: DateTime.now(),
        ));
        notifyListeners();
      } else {
        _state = UpdateState.upToDate;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[UpdateProvider] Check for update failed: $e');
      _state = UpdateState.error;
      _errorMessage = e.toString();
      await UpdateLogger.logEvent(UpdateEvent(
        type: UpdateEventType.checkFailed,
        message: _errorMessage,
        timestamp: DateTime.now(),
      ));
      notifyListeners();
    }
  }
  
  /// Download update
  Future<void> downloadUpdate(String apkUrl) async {
    if (_appVersion == null) return;
    
    _state = UpdateState.downloading;
    _downloadProgress = 0.0;
    _errorMessage = null;
    notifyListeners();
    
    try {
      await _updateService.downloadUpdate(apkUrl, onProgress: (progress) {
        _downloadProgress = progress;
        notifyListeners();
      });
      
      _state = UpdateState.installing;
      notifyListeners();
      
      // TODO: Get actual APK path from download
      const apkPath = '/path/to/downloaded.apk';
      await _updateService.installUpdate(apkPath);
      
      _state = UpdateState.idle;
      notifyListeners();
    } catch (e) {
      debugPrint('[UpdateProvider] Download failed: $e');
      _state = UpdateState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  /// Ignore this version (for soft updates)
  Future<void> ignoreVersion() async {
    if (_appVersion == null) return;
    
    _ignoredVersion = _appVersion!.latestVersion;
    await _prefs?.setString('ignored_version', _ignoredVersion!);
    
    await UpdateLogger.logEvent(UpdateEvent(
      type: UpdateEventType.updateIgnored,
      version: _ignoredVersion,
      timestamp: DateTime.now(),
    ));
    
    _state = UpdateState.upToDate;
    notifyListeners();
  }
  
  /// Cancel download
  Future<void> cancelDownload() async {
    await _updateService.cancelDownload();
    _state = UpdateState.idle;
    _downloadProgress = 0.0;
    notifyListeners();
  }
  
  /// Reset state
  void reset() {
    _state = UpdateState.idle;
    _errorMessage = null;
    _downloadProgress = 0.0;
    notifyListeners();
  }
  
  /// Get current app version from pubspec.yaml
  Future<String> _getCurrentVersion() async {
    // This should be read from package_info_plus in production
    // For now, return a placeholder
    return '1.0.0';
  }
  
  /// Compare versions to check if update is needed
  bool _needsUpdate(String current, String latest) {
    final currentParts = current.split('.').map(int.parse).toList();
    final latestParts = latest.split('.').map(int.parse).toList();
    
    for (int i = 0; i < 3; i++) {
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }
    return false;
  }
}
