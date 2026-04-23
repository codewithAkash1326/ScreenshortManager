import 'package:flutter/material.dart';
import 'package:frontend/app_routes.dart';
import 'package:frontend/login/services/login_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final AuthService _auth = AuthService();
  final box = GetStorage();

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> login() async {
    final userName = userNameController.text.trim();
    final password = passwordController.text;
    if (userName.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Username and password are required');
      return;
    }
    try {
      isLoading.value = true;
      final token = await _auth.login(userName: userName, password: password);
      await box.write('token', token);
      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      Get.snackbar('Login failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignup() => Get.toNamed(AppRoutes.SIGNUP);

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
