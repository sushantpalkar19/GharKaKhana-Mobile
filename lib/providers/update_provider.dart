import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  int? _currentVersionCode;
  String? _currentVersionName;
  String? _downloadedApkPath;
  
  UpdateProvider(this._updateService);
  
  AppVersion? get appVersion => _appVersion;
  UpdateState get state => _state;
  String? get errorMessage => _errorMessage;
  double get downloadProgress => _downloadProgress;
  String? get ignoredVersion => _ignoredVersion;
  int? get currentVersionCode => _currentVersionCode;
  String? get currentVersionName => _currentVersionName;
  String? get downloadedApkPath => _downloadedApkPath;
  
  bool get isChecking => _state == UpdateState.checking;
  bool get isUpdateAvailable => _state == UpdateState.updateAvailable;
  bool get isDownloading => _state == UpdateState.downloading;
  bool get isInstalling => _state == UpdateState.installing;
  bool get hasError => _state == UpdateState.error;
  bool get isUpToDate => _state == UpdateState.upToDate;
  
  /// Check if mandatory update is required
  bool get isMandatoryUpdate {
    if (_appVersion == null || _currentVersionCode == null) return false;
    return _currentVersionCode! < _appVersion!.minimumVersionCode;
  }
  
  /// Initialize provider
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ignoredVersion = _prefs?.getString('ignored_version');
    await UpdateLogger.init();
    
    // Load current app version
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;
      _currentVersionName = packageInfo.version;
      debugPrint('[UpdateProvider] Current version: $_currentVersionName (code: $_currentVersionCode)');
    } catch (e) {
      debugPrint('[UpdateProvider] Failed to get package info: $e');
    }
    
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
      
      // Check if update is available using versionCode comparison
      final needsUpdate = _needsUpdate(_currentVersionCode ?? 0, version.minimumVersionCode, version.forceUpdate);
      
      if (needsUpdate) {
        // Check if user ignored this version (only for optional updates)
        if (!forceCheck && _ignoredVersion == version.latestVersion && !version.forceUpdate && !isMandatoryUpdate) {
          _state = UpdateState.upToDate;
          notifyListeners();
          return;
        }
        
        _state = UpdateState.updateAvailable;
        await UpdateLogger.logEvent(UpdateEvent(
          type: UpdateEventType.updateAvailable,
          version: version.latestVersion,
          message: 'Force: ${version.forceUpdate}, Mandatory: $isMandatoryUpdate',
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
      _downloadedApkPath = await _updateService.downloadUpdate(apkUrl, onProgress: (progress) {
        _downloadProgress = progress;
        notifyListeners();
      });
      
      _state = UpdateState.installing;
      notifyListeners();
      
      await _updateService.installUpdate(_downloadedApkPath!);
      
      _state = UpdateState.idle;
      notifyListeners();
    } catch (e) {
      debugPrint('[UpdateProvider] Download failed: $e');
      _state = UpdateState.error;
      _errorMessage = e.toString();
      _downloadedApkPath = null;
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
  
  /// Compare versionCodes to check if update is needed
  bool _needsUpdate(int currentVersionCode, int minimumVersionCode, bool forceUpdate) {
    // Update is needed if current version is below minimum supported
    if (currentVersionCode < minimumVersionCode) {
      return true;
    }
    // Update is also needed if forceUpdate is true AND current version is below latest
    // This allows server to force updates for versions that are still technically supported
    if (forceUpdate && _appVersion != null) {
      // Parse latest version to compare (simplified - assumes semantic versioning)
      // For now, we rely on versionCode comparison which is more reliable
      // forceUpdate with same versionCode means server wants to force update for some reason
      return currentVersionCode < minimumVersionCode;
    }
    return false;
  }
}
