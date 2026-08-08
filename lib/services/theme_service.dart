import 'package:hive_flutter/hive_flutter.dart';
import '../models/theme_settings.dart';

class ThemeService {
  static const String _themeSettingsBox = 'themeSettings';
  static const String _appStateBox = 'appState';
  static const String _firstLaunchCompletedKey = 'first_launch_completed';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ThemeModeEnumAdapter());
    Hive.registerAdapter(ThemePackEnumAdapter());
    Hive.registerAdapter(ThemeSettingsAdapter());
    await Hive.openBox(_themeSettingsBox);
    await Hive.openBox(_appStateBox);
  }

  static Future<ThemeSettings> loadThemeSettings() async {
    try {
      final box = Hive.box(_themeSettingsBox);
      final settings = box.get('settings') as ThemeSettings?;
      return settings ?? ThemeSettings.defaultSettings;
    } catch (e) {
      return ThemeSettings.defaultSettings;
    }
  }

  static Future<void> saveThemeSettings(ThemeSettings settings) async {
    try {
      final box = Hive.box(_themeSettingsBox);
      await box.put('settings', settings);
    } catch (e) {
      // Silently fail on save error
    }
  }

  static Future<void> restoreDefault() async {
    await saveThemeSettings(ThemeSettings.defaultSettings);
  }

  static Future<bool> isFirstLaunch() async {
    try {
      final box = Hive.box(_appStateBox);
      final firstLaunchCompleted = box.get(_firstLaunchCompletedKey) as bool?;
      return firstLaunchCompleted != true;
    } catch (e) {
      return true; // Default to first launch if error
    }
  }

  static Future<void> setFirstLaunchCompleted() async {
    try {
      final box = Hive.box(_appStateBox);
      await box.put(_firstLaunchCompletedKey, true);
    } catch (e) {
      // Silently fail on save error
    }
  }

  static Future<void> close() async {
    await Hive.close();
  }
}
