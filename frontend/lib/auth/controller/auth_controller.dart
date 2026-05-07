import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app_routes.dart';
import 'package:frontend/auth/services/auth_service.dart';
import 'package:frontend/auth/view/verify_email_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final _box = GetStorage();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();

  final isLoginLoading = false.obs;
  final isSignupLoading = false.obs;

  String getFirebaseErrorMessage(String code) {
    switch (code) {
      // Signup
      case 'email-already-in-use':
        return 'Email already exists. Please login.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password login is disabled.';

      // Login
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';

      // Network
      case 'network-request-failed':
        return 'No internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }

  Future<void> login() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text;
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password are required");
      return;
    }

    try {
      isLoginLoading.value = true;

      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // final user = cred.user;

      // if (user != null && !user.emailVerified) {
      //   await FirebaseAuth.instance.signOut();

      //   Get.snackbar(
      //     "Email not verified",
      //     "Please verify your email before logging in",
      //     snackPosition: SnackPosition.BOTTOM,
      //   );

      //   return;
      // }

      final firebaseToken = await cred.user?.getIdToken();
      if (firebaseToken == null || firebaseToken.isEmpty) {
        throw Exception("Failed to get auth token");
      }

      print("firebase token ");
      print(firebaseToken);

      final jwt = await _authService.loginWithFirebaseToken(
        firebaseToken: firebaseToken,
      );

      await _box.write("token", jwt);

      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      if (e is FirebaseAuthException) {
        Get.snackbar(
          "Error",
          getFirebaseErrorMessage(e.code),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } finally {
      isLoginLoading.value = false;
    }
  }

  Future<void> signup() async {
    final email = signupEmailController.text.trim();
    final password = signupPasswordController.text;
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password are required");
      return;
    }

    try {
      isSignupLoading.value = true;
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user?.sendEmailVerification();
      Get.to(const VerifyEmailScreen());
    } catch (e) {
      if (e is FirebaseAuthException) {
        Get.snackbar(
          "Error",
          getFirebaseErrorMessage(e.code),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } finally {
      isSignupLoading.value = false;
    }
  }

  void goToSignup() => Get.toNamed(AppRoutes.SIGNUP);
  void goToLogin() => Get.offAllNamed(AppRoutes.LOGIN);
}
