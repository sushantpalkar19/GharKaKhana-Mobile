import 'package:flutter/material.dart';
import '../models/theme_settings.dart';

// Preserve existing AppColors for backward compatibility
class AppColors {
  static const Color primary = Color(0xFFF97316);
  static const Color secondary = Color(0xFF10B981);
  static const Color accent = Color(0xFFF59E0B);
  static const Color surface = Color(0xFFFFFBF7);
  static const Color background = Color(0xFFFFF8F3);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color card = Color(0xFFFFFFFF);
}

// Theme Pack Definitions
class ThemePack {
  final String name;
  final String emoji;
  final Color primary;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color container;
  final Color card;
  final Color button;
  final Color success;
  final Color error;
  final Color gradientStart;
  final Color gradientEnd;

  const ThemePack({
    required this.name,
    required this.emoji,
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.container,
    required this.card,
    required this.button,
    required this.success,
    required this.error,
    required this.gradientStart,
    required this.gradientEnd,
  });

  static const Map<ThemePackEnum, ThemePack> packs = {
    ThemePackEnum.freshGreen: ThemePack(
      name: 'Fresh Green',
      emoji: '🌿',
      primary: Color(0xFF10B981),
      secondary: Color(0xFF059669),
      background: Color(0xFFF0FDF4),
      surface: Color(0xFFFFFFFF),
      container: Color(0xFFDCFCE7),
      card: Color(0xFFFFFFFF),
      button: Color(0xFF10B981),
      success: Color(0xFF10B981),
      error: Color(0xFFEF4444),
      gradientStart: Color(0xFF10B981),
      gradientEnd: Color(0xFF34D399),
    ),
    ThemePackEnum.ocean: ThemePack(
      name: 'Ocean',
      emoji: '🌊',
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF2563EB),
      background: Color(0xFFEFF6FF),
      surface: Color(0xFFFFFFFF),
      container: Color(0xFFDBEAFE),
      card: Color(0xFFFFFFFF),
      button: Color(0xFF3B82F6),
      success: Color(0xFF10B981),
      error: Color(0xFFEF4444),
      gradientStart: Color(0xFF3B82F6),
      gradientEnd: Color(0xFF60A5FA),
    ),
    ThemePackEnum.sunrise: ThemePack(
      name: 'Sunrise',
      emoji: '🌅',
      primary: Color(0xFFF97316),
      secondary: Color(0xFFEA580C),
      background: Color(0xFFFFF7ED),
      surface: Color(0xFFFFFFFF),
      container: Color(0xFFFFEDD5),
      card: Color(0xFFFFFFFF),
      button: Color(0xFFF97316),
      success: Color(0xFF10B981),
      error: Color(0xFFEF4444),
      gradientStart: Color(0xFFF97316),
      gradientEnd: Color(0xFFFB923C),
    ),
    ThemePackEnum.coffeeHouse: ThemePack(
      name: 'Coffee House',
      emoji: '☕',
      primary: Color(0xFFA16207),
      secondary: Color(0xFF854D0E),
      background: Color(0xFFFEFCE8),
      surface: Color(0xFFFFFFFF),
      container: Color(0xFFFEF9C3),
      card: Color(0xFFFFFFFF),
      button: Color(0xFFA16207),
      success: Color(0xFF10B981),
      error: Color(0xFFEF4444),
      gradientStart: Color(0xFFA16207),
      gradientEnd: Color(0xFFCA8A04),
    ),
    ThemePackEnum.roseKitchen: ThemePack(
      name: 'Rose Kitchen',
      emoji: '🌸',
      primary: Color(0xFFEC4899),
      secondary: Color(0xFFDB2777),
      background: Color(0xFFFDF2F8),
      surface: Color(0xFFFFFFFF),
      container: Color(0xFFFCE7F3),
      card: Color(0xFFFFFFFF),
      button: Color(0xFFEC4899),
      success: Color(0xFF10B981),
      error: Color(0xFFEF4444),
      gradientStart: Color(0xFFEC4899),
      gradientEnd: Color(0xFFF472B6),
    ),
    ThemePackEnum.mangoDelight: ThemePack(
      name: 'Mango Delight',
      emoji: '🥭',
      primary: Color(0xFFF59E0B),
      secondary: Color(0xFFD97706),
      background: Color(0xFFFFFBEB),
      surface: Color(0xFFFFFFFF),
      container: Color(0xFFFEF3C7),
      card: Color(0xFFFFFFFF),
      button: Color(0xFFF59E0B),
      success: Color(0xFF10B981),
      error: Color(0xFFEF4444),
      gradientStart: Color(0xFFF59E0B),
      gradientEnd: Color(0xFFFBBF24),
    ),
    ThemePackEnum.indianSpice: ThemePack(
      name: 'Indian Spice',
      emoji: '🍛',
      primary: Color(0xFFDC2626),
      secondary: Color(0xFFB91C1C),
      background: Color(0xFFFEF2F2),
      surface: Color(0xFFFFFFFF),
      container: Color(0xFFFEE2E2),
      card: Color(0xFFFFFFFF),
      button: Color(0xFFDC2626),
      success: Color(0xFF10B981),
      error: Color(0xFFDC2626),
      gradientStart: Color(0xFFDC2626),
      gradientEnd: Color(0xFFEF4444),
    ),
    ThemePackEnum.organicLeaf: ThemePack(
      name: 'Organic Leaf',
      emoji: '🌱',
      primary: Color(0xFF65A30D),
      secondary: Color(0xFF4D7C0F),
      background: Color(0xFFF7FEE7),
      surface: Color(0xFFFFFFFF),
      container: Color(0xFFECFCCB),
      card: Color(0xFFFFFFFF),
      button: Color(0xFF65A30D),
      success: Color(0xFF65A30D),
      error: Color(0xFFEF4444),
      gradientStart: Color(0xFF65A30D),
      gradientEnd: Color(0xFF84CC16),
    ),
  };
}

// Theme Extension for Material 3
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final ThemePack themePack;
  final bool gradientEnabled;
  final LinearGradient gradient;

  const AppThemeExtension({
    required this.themePack,
    required this.gradientEnabled,
    required this.gradient,
  });

  @override
  AppThemeExtension copyWith({
    ThemePack? themePack,
    bool? gradientEnabled,
    LinearGradient? gradient,
  }) {
    return AppThemeExtension(
      themePack: themePack ?? this.themePack,
      gradientEnabled: gradientEnabled ?? this.gradientEnabled,
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      themePack: t < 0.5 ? themePack : other.themePack,
      gradientEnabled: t < 0.5 ? gradientEnabled : other.gradientEnabled,
      gradient: LinearGradient.lerp(gradient, other.gradient, t)!,
    );
  }

  static AppThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<AppThemeExtension>() ??
        AppThemeExtension(
          themePack: ThemePack.packs[ThemePackEnum.freshGreen]!,
          gradientEnabled: true,
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF34D399)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        );
  }
}

class AppTheme {
  // Generate theme from theme pack
  static ThemeData fromThemePack(
    ThemePack pack, {
    required Brightness brightness,
    bool isAMOLED = false,
    bool gradientEnabled = true,
  }) {
    final primary = pack.primary;
    final secondary = pack.secondary;
    final background = isAMOLED ? const Color(0xFF000000) : pack.background;
    final surface = isAMOLED ? const Color(0xFF000000) : pack.surface;
    final container = isAMOLED ? const Color(0xFF1A1A1A) : pack.container;
    final card = isAMOLED ? const Color(0xFF1A1A1A) : pack.card;
    final button = pack.button;
    final error = pack.error;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: brightness == Brightness.dark ? Colors.white : const Color(0xFF1F2937),
      onSurfaceVariant: brightness == Brightness.dark ? Colors.white70 : const Color(0xFF6B7280),
    );

    final gradient = LinearGradient(
      colors: gradientEnabled ? [pack.gradientStart, pack.gradientEnd] : [primary, secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final textTheme = _buildTextTheme(brightness);

    final inputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: isAMOLED ? const Color(0xFF1A1A1A) : card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: brightness == Brightness.dark ? Colors.white24 : const Color(0xFFE5E7EB), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: brightness == Brightness.dark ? Colors.white24 : const Color(0xFFE5E7EB), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: error, width: 1.5),
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(color: brightness == Brightness.dark ? Colors.white54 : const Color(0xFF9CA3AF)),
      labelStyle: textTheme.bodyMedium?.copyWith(color: brightness == Brightness.dark ? Colors.white70 : const Color(0xFF6B7280)),
      floatingLabelStyle: TextStyle(color: primary, fontWeight: FontWeight.w500),
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: button,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: textTheme.labelLarge?.copyWith(color: Colors.white),
        minimumSize: const Size(double.infinity, 50),
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return button.withValues(alpha: 0.5);
          }
          return button;
        }),
      ),
    );

    final outlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: BorderSide(color: primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: textTheme.labelLarge,
        minimumSize: const Size(double.infinity, 50),
      ),
    );

    final cardTheme = CardThemeData(
      color: card,
      elevation: isAMOLED ? 0 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: brightness == Brightness.dark ? Colors.white12 : const Color(0xFFE5E7EB), width: 0.5),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Colors.transparent,
    );

    final appBarTheme = AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.headlineSmall?.copyWith(color: brightness == Brightness.dark ? Colors.white : const Color(0xFF1F2937)),
      iconTheme: IconThemeData(color: brightness == Brightness.dark ? Colors.white : const Color(0xFF1F2937)),
      actionsIconTheme: IconThemeData(color: brightness == Brightness.dark ? Colors.white : const Color(0xFF1F2937)),
    );

    final bottomNavigationBarTheme = BottomNavigationBarThemeData(
      backgroundColor: isAMOLED ? const Color(0xFF1A1A1A) : card,
      selectedItemColor: primary,
      unselectedItemColor: brightness == Brightness.dark ? Colors.white54 : const Color(0xFF9CA3AF),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: textTheme.labelSmall,
      unselectedLabelStyle: textTheme.labelSmall,
      elevation: isAMOLED ? 0 : 8,
    );

    final dividerTheme = DividerThemeData(
      color: brightness == Brightness.dark ? Colors.white12 : const Color(0xFFE5E7EB),
      thickness: 1,
      space: 1,
    );

    final chipTheme = ChipThemeData(
      backgroundColor: container,
      labelStyle: textTheme.labelMedium,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: brightness == Brightness.dark ? Colors.white12 : const Color(0xFFE5E7EB)),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      inputDecorationTheme: inputDecorationTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      cardTheme: cardTheme,
      appBarTheme: appBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      dividerTheme: dividerTheme,
      chipTheme: chipTheme,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: button,
        foregroundColor: Colors.white,
        elevation: isAMOLED ? 0 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.dark ? const Color(0xFF1A1A1A) : const Color(0xFF1F2937),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: primary,
        textColor: Colors.white,
        smallSize: 8,
        largeSize: 18,
      ),
      extensions: [
        AppThemeExtension(
          themePack: pack,
          gradientEnabled: gradientEnabled,
          gradient: gradient,
        ),
      ],
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final textColor = brightness == Brightness.dark ? Colors.white : const Color(0xFF1F2937);
    final secondaryTextColor = brightness == Brightness.dark ? Colors.white70 : const Color(0xFF6B7280);

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textColor,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textColor,
        height: 1.25,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textColor,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.35,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.45,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.5,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.55,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.55,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondaryTextColor,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.45,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        height: 1.45,
        letterSpacing: 0.3,
      ),
    );
  }

  // Preserve original light theme for backward compatibility
  static ThemeData light() {
    const seedColor = Color(0xFFF97316);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    final textTheme = TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.25,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.35,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.45,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.55,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.55,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.45,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        height: 1.45,
        letterSpacing: 0.3,
      ),
    );

    final inputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
      labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
      floatingLabelStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500),
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: textTheme.labelLarge?.copyWith(color: Colors.white),
        minimumSize: const Size(double.infinity, 50),
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.primary.withValues(alpha: 0.5);
          }
          return AppColors.primary;
        }),
      ),
    );

    final outlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: textTheme.labelLarge,
        minimumSize: const Size(double.infinity, 50),
      ),
    );

    final cardTheme = CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.border, width: 0.5),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Colors.transparent,
    );

    final appBarTheme = AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.headlineSmall,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      actionsIconTheme: IconThemeData(color: AppColors.textPrimary),
    );

    final bottomNavigationBarTheme = BottomNavigationBarThemeData(
      backgroundColor: AppColors.card,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: textTheme.labelSmall,
      unselectedLabelStyle: textTheme.labelSmall,
      elevation: 8,
    );

    final dividerTheme = DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    );

    final chipTheme = ChipThemeData(
      backgroundColor: AppColors.surface,
      labelStyle: textTheme.labelMedium,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.border),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      inputDecorationTheme: inputDecorationTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      outlinedButtonTheme: outlinedButtonTheme,
      cardTheme: cardTheme,
      appBarTheme: appBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarTheme,
      dividerTheme: dividerTheme,
      chipTheme: chipTheme,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: AppColors.primary,
        textColor: Colors.white,
        smallSize: 8,
        largeSize: 18,
      ),
    );
  }
}
