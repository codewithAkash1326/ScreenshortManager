import 'package:flutter/material.dart';
import 'package:frontend/app_pages.dart';
import 'package:frontend/app_routes.dart';
import 'package:frontend/bindings/app_binding.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:frontend/theme/theme_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  if (!Get.isRegistered<ThemeService>()) {
    Get.put<ThemeService>(ThemeService(), permanent: true);
  }
  runApp(MyApp());
}

String getInitialRoute() {
  final box = GetStorage();
  final token = box.read('token') ?? '';

  if (token != '') {
    return AppRoutes.HOME;
  } else {
    return AppRoutes.LOGIN;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService();
    return GetMaterialApp(
      initialRoute: getInitialRoute(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeService.themeMode,
    );
  }
}
