import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../core/service/theme_service.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  late final RxBool isDark;

  @override
  void onInit() {
    super.onInit();
    final saved = _box.read<bool>(_key) ?? true;
    isDark = saved.obs;
  }

  bool get isDarkMode => isDark.value;
  ThemeMode get themeMode => isDark.value ? ThemeMode.dark : ThemeMode.light;

  void switchTheme(bool value) {
    isDark.value = value;
    _box.write(_key, value);
    Get.changeTheme(value ? ThemeService.darkTheme : ThemeService.lightTheme);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    switchTheme(!isDark.value);
  }
}
