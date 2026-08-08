import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/theme_settings.dart';
import '../services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeSettings _settings = ThemeSettings.defaultSettings;

  ThemeSettings get settings => _settings;

  ThemeData get themeData {
    final pack = ThemePack.packs[_settings.themePack]!;
    
    Brightness brightness;
    bool isAMOLED = false;

    switch (_settings.themeMode) {
      case ThemeModeEnum.light:
        brightness = Brightness.light;
        break;
      case ThemeModeEnum.dark:
        brightness = Brightness.dark;
        break;
      case ThemeModeEnum.amoled:
        brightness = Brightness.dark;
        isAMOLED = true;
        break;
      case ThemeModeEnum.system:
        // For system mode, we'll use light as default and let ThemeMode handle it
        brightness = Brightness.light;
        break;
    }

    return AppTheme.fromThemePack(
      pack,
      brightness: brightness,
      isAMOLED: isAMOLED,
      gradientEnabled: _settings.gradientEnabled,
    );
  }

  ThemeMode get themeMode {
    switch (_settings.themeMode) {
      case ThemeModeEnum.light:
        return ThemeMode.light;
      case ThemeModeEnum.dark:
        return ThemeMode.dark;
      case ThemeModeEnum.amoled:
        return ThemeMode.dark;
      case ThemeModeEnum.system:
        return ThemeMode.system;
    }
  }

  Future<void> init() async {
    _settings = await ThemeService.loadThemeSettings();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeModeEnum mode) async {
    _settings = _settings.copyWith(themeMode: mode);
    await ThemeService.saveThemeSettings(_settings);
    notifyListeners();
  }

  Future<void> setThemePack(ThemePackEnum pack) async {
    _settings = _settings.copyWith(themePack: pack);
    await ThemeService.saveThemeSettings(_settings);
    notifyListeners();
  }

  Future<void> setGradientEnabled(bool enabled) async {
    _settings = _settings.copyWith(gradientEnabled: enabled);
    await ThemeService.saveThemeSettings(_settings);
    notifyListeners();
  }

  Future<void> restoreDefault() async {
    _settings = ThemeSettings.defaultSettings;
    await ThemeService.restoreDefault();
    notifyListeners();
  }
}
