import 'package:flutter/material.dart';
import 'package:frontend/app_routes.dart';
import 'package:frontend/login/services/login_service.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final AuthService _auth = AuthService();

  final nameController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> signup() async {
    final name = nameController.text.trim();
    final userName = userNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    if ([name, userName, email, password].any((e) => e.isEmpty)) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }
    try {
      isLoading.value = true;
      await _auth.register(
        name: name,
        userName: userName,
        email: email,
        password: password,
      );
      Get.snackbar('Success', 'Account created. Please login.');
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      Get.snackbar('Signup failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
