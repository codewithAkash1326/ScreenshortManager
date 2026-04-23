import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  static const _key = 'isDarkMode';
  final _box = GetStorage();

  ThemeMode get themeMode => _loadTheme() ? ThemeMode.dark : ThemeMode.light;

  bool _loadTheme() => _box.read(_key) ?? true; // default dark

  Future<void> _saveTheme(bool isDarkMode) async => _box.write(_key, isDarkMode);

  Future<void> switchTheme() async {
    final isDark = !_loadTheme();
    await _saveTheme(isDark);
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
