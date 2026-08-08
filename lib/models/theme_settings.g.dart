// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeSettingsAdapter extends TypeAdapter<ThemeSettings> {
  @override
  final int typeId = 2;

  @override
  ThemeSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeSettings(
      themeMode: fields[0] as ThemeModeEnum,
      themePack: fields[1] as ThemePackEnum,
      gradientEnabled: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeSettings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.themePack)
      ..writeByte(2)
      ..write(obj.gradientEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemeModeEnumAdapter extends TypeAdapter<ThemeModeEnum> {
  @override
  final int typeId = 0;

  @override
  ThemeModeEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeModeEnum.light;
      case 1:
        return ThemeModeEnum.dark;
      case 2:
        return ThemeModeEnum.amoled;
      case 3:
        return ThemeModeEnum.system;
      default:
        return ThemeModeEnum.light;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeModeEnum obj) {
    switch (obj) {
      case ThemeModeEnum.light:
        writer.writeByte(0);
        break;
      case ThemeModeEnum.dark:
        writer.writeByte(1);
        break;
      case ThemeModeEnum.amoled:
        writer.writeByte(2);
        break;
      case ThemeModeEnum.system:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeModeEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThemePackEnumAdapter extends TypeAdapter<ThemePackEnum> {
  @override
  final int typeId = 1;

  @override
  ThemePackEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemePackEnum.freshGreen;
      case 1:
        return ThemePackEnum.ocean;
      case 2:
        return ThemePackEnum.sunrise;
      case 3:
        return ThemePackEnum.coffeeHouse;
      case 4:
        return ThemePackEnum.roseKitchen;
      case 5:
        return ThemePackEnum.mangoDelight;
      case 6:
        return ThemePackEnum.indianSpice;
      case 7:
        return ThemePackEnum.organicLeaf;
      default:
        return ThemePackEnum.freshGreen;
    }
  }

  @override
  void write(BinaryWriter writer, ThemePackEnum obj) {
    switch (obj) {
      case ThemePackEnum.freshGreen:
        writer.writeByte(0);
        break;
      case ThemePackEnum.ocean:
        writer.writeByte(1);
        break;
      case ThemePackEnum.sunrise:
        writer.writeByte(2);
        break;
      case ThemePackEnum.coffeeHouse:
        writer.writeByte(3);
        break;
      case ThemePackEnum.roseKitchen:
        writer.writeByte(4);
        break;
      case ThemePackEnum.mangoDelight:
        writer.writeByte(5);
        break;
      case ThemePackEnum.indianSpice:
        writer.writeByte(6);
        break;
      case ThemePackEnum.organicLeaf:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemePackEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
