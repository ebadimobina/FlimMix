import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../core/service/theme_service.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  static const String _key = 'isDarkMode';
  static const String _amoledKey = 'isAmoledMode';

  late final RxBool isDark;
  late final RxBool isAmoled;

  @override
  void onInit() {
    super.onInit();
    final savedDark = _box.read<bool>(_key) ?? true;
    final savedAmoled = _box.read<bool>(_amoledKey) ?? false;
    isDark = savedDark.obs;
    isAmoled = savedAmoled.obs;
  }

  bool get isDarkMode => isDark.value;
  bool get isAmoledMode => isAmoled.value;
  ThemeMode get themeMode => isDark.value ? ThemeMode.dark : ThemeMode.light;

  void switchTheme(bool value) {
    isDark.value = value;
    _box.write(_key, value);
    if (value) {
      Get.changeTheme(ThemeService.getDarkTheme(amoled: isAmoled.value));
    } else {
      Get.changeTheme(ThemeService.lightTheme);
    }
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void switchAmoled(bool value) {
    isAmoled.value = value;
    _box.write(_amoledKey, value);
    if (isDark.value) {
      Get.changeTheme(ThemeService.getDarkTheme(amoled: value));
    }
  }

  void toggleTheme() {
    switchTheme(!isDark.value);
  }
}
