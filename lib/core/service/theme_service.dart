import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  final _box = GetStorage();
  static const String _key = 'isDarkMode';
  static const String _amoledKey = 'isAmoledMode';

  /// Check whether dark mode is currently active (defaults to true for cinema feel)
  bool get isDarkMode => _box.read<bool>(_key) ?? true;

  /// Check whether pure AMOLED black is active
  bool get isAmoled => _box.read<bool>(_amoledKey) ?? false;

  /// Get ThemeMode for GetMaterialApp
  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  /// Get initial active ThemeData
  ThemeData get initialTheme => isDarkMode ? darkTheme : lightTheme;

  // --- Cinematic Dark Theme ---
  static ThemeData getDarkTheme({bool amoled = false}) {
    final bgColor = amoled ? const Color(0xFF000000) : const Color(0xFF0C1017);
    final cardColor = amoled ? const Color(0xFF0E1218) : const Color(0xFF161B26);
    final navColor = amoled ? const Color(0xFF000000) : const Color(0xFF111622);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgColor,
      primaryColor: const Color(0xFF5A7ED0),
      cardColor: cardColor,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF5A7ED0),
        secondary: const Color(0xFFFFB800),
        surface: cardColor,
        surfaceContainerHighest: amoled ? const Color(0xFF141924) : const Color(0xFF1F2636),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardColor,
        selectedColor: const Color(0xFF5A7ED0),
        disabledColor: const Color(0xFF1F2636),
        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        side: BorderSide(color: amoled ? const Color(0xFF181F2B) : const Color(0xFF1F2636)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: navColor,
        selectedItemColor: const Color(0xFF6B8AFF),
        unselectedItemColor: const Color(0xFF6B7280),
      ),
      dividerColor: amoled ? const Color(0xFF1A202C) : const Color(0xFF1F2636),
    );
  }

  static ThemeData get darkTheme => getDarkTheme(amoled: _instance.isAmoled);

  // --- Clean Light Theme ---
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8F9FD),
      primaryColor: const Color(0xFF110E47),
      cardColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF110E47),
        secondary: Color(0xFFFFB800),
        surface: Colors.white,
        surfaceContainerHighest: Color(0xFFEFF2F8),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF110E47),
        disabledColor: const Color(0xFFEFF2F8),
        labelStyle: const TextStyle(color: Color(0xFF374151), fontSize: 12),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF8F9FD),
        foregroundColor: Color(0xFF110E47),
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: Color(0xFF110E47),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF110E47),
        unselectedItemColor: Colors.grey,
      ),
      dividerColor: const Color(0xFFE5E7EB),
    );
  }
}
