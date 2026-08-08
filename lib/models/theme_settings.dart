import 'package:hive/hive.dart';

part 'theme_settings.g.dart';

@HiveType(typeId: 0)
enum ThemeModeEnum {
  @HiveField(0)
  light,
  @HiveField(1)
  dark,
  @HiveField(2)
  amoled,
  @HiveField(3)
  system,
}

@HiveType(typeId: 1)
enum ThemePackEnum {
  @HiveField(0)
  freshGreen,
  @HiveField(1)
  ocean,
  @HiveField(2)
  sunrise,
  @HiveField(3)
  coffeeHouse,
  @HiveField(4)
  roseKitchen,
  @HiveField(5)
  mangoDelight,
  @HiveField(6)
  indianSpice,
  @HiveField(7)
  organicLeaf,
}

@HiveType(typeId: 2)
class ThemeSettings {
  @HiveField(0)
  final ThemeModeEnum themeMode;

  @HiveField(1)
  final ThemePackEnum themePack;

  @HiveField(2)
  final bool gradientEnabled;

  ThemeSettings({
    required this.themeMode,
    required this.themePack,
    required this.gradientEnabled,
  });

  ThemeSettings copyWith({
    ThemeModeEnum? themeMode,
    ThemePackEnum? themePack,
    bool? gradientEnabled,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      themePack: themePack ?? this.themePack,
      gradientEnabled: gradientEnabled ?? this.gradientEnabled,
    );
  }

  static ThemeSettings get defaultSettings => ThemeSettings(
        themeMode: ThemeModeEnum.system,
        themePack: ThemePackEnum.freshGreen,
        gradientEnabled: true,
      );
}
