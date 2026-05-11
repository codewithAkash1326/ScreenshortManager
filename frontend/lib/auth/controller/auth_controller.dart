import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app_routes.dart';
import 'package:frontend/auth/services/auth_service.dart';
import 'package:frontend/auth/view/verify_email_screen.dart';
import 'package:frontend/utils/ui_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final _box = GetStorage();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final forgotPasswordEmailController = TextEditingController();

  final forgotPasswordEmailError = ''.obs;

  final isForgotPasswordLoading = false.obs;

  final isResetEmailSent = false.obs;

  final signupEmailController = TextEditingController();
  final signupNameController = TextEditingController();
  final signupPasswordController = TextEditingController();

  final isLoginLoading = false.obs;
  final isSignupLoading = false.obs;

  final signupNameError = ''.obs;
  final signupEmailError = ''.obs;
  final signupPasswordError = ''.obs;

  final loginEmailError = ''.obs;
  final loginPasswordError = ''.obs;

  bool validateSignup() {
    bool isValid = true;

    signupNameError.value = '';
    signupEmailError.value = '';
    signupPasswordError.value = '';

    final name = signupNameController.text.trim();
    final email = signupEmailController.text.trim();
    final password = signupPasswordController.text;

    if (name.isEmpty) {
      signupNameError.value = "Name is required";
      isValid = false;
    }

    if (email.isEmpty) {
      signupEmailError.value = "Email is required";
      isValid = false;
    } else if (!GetUtils.isEmail(email)) {
      signupEmailError.value = "Invalid email";
      isValid = false;
    }

    if (password.isEmpty) {
      signupPasswordError.value = "Password is required";
      isValid = false;
    } else if (password.length < 6) {
      signupPasswordError.value = "Password must be at least 6 characters";
      isValid = false;
    }

    return isValid;
  }

  Future<void> sendResetPasswordEmail() async {
    final email = forgotPasswordEmailController.text.trim();

    forgotPasswordEmailError.value = '';

    if (email.isEmpty) {
      forgotPasswordEmailError.value = "Email is required";
      return;
    }

    if (!GetUtils.isEmail(email)) {
      forgotPasswordEmailError.value = "Enter a valid email";
      return;
    }

    try {
      isForgotPasswordLoading.value = true;

      print("step1");

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print("step2");
      isResetEmailSent.value = true;
    } catch (e) {
      if (e is FirebaseAuthException) {
        UiUtils.showError(getFirebaseErrorMessage(e.code));
      } else {
        UiUtils.showError("Something went wrong");
      }
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }

  void goToForgotPassword() {
    forgotPasswordEmailController.clear();
    forgotPasswordEmailError.value = '';
    isResetEmailSent.value = false;

    Get.toNamed(AppRoutes.FORGOT_PASSWORD);
  }

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
      UiUtils.showError("Email and password are required");
      return;
    }

    try {
      isLoginLoading.value = true;

      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;

      print("step1");

      if (user != null && !user.emailVerified) {
        await FirebaseAuth.instance.signOut();
        UiUtils.showError("Please verify your email before logging in");

        return;
      }

      print("step2");

      final firebaseToken = await cred.user?.getIdToken();
      if (firebaseToken == null || firebaseToken.isEmpty) {
        throw Exception("Failed to get auth token");
      }

      print("step3");

      final jwt = await _authService.loginWithFirebaseToken(
        firebaseToken: firebaseToken,
      );
      print("step4");

      await _box.write("token", jwt);

      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      if (e is FirebaseAuthException) {
        UiUtils.showError(getFirebaseErrorMessage(e.code));
      } else {
        UiUtils.showError("Something went wrong");
      }
    } finally {
      isLoginLoading.value = false;
    }
  }

  Future<void> signup() async {
    final email = signupEmailController.text.trim();
    final password = signupPasswordController.text;
    final name = signupNameController.text;
    if (!validateSignup()) return;

    try {
      isSignupLoading.value = true;
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user?.updateDisplayName(name);

      await cred.user?.sendEmailVerification();
      Get.to(const VerifyEmailScreen());
    } catch (e) {
      if (e is FirebaseAuthException) {
        UiUtils.showError(getFirebaseErrorMessage(e.code));
      } else {
        UiUtils.showError("Something went wrong");
      }
    } finally {
      isSignupLoading.value = false;
    }
  }

  void goToSignup() => Get.toNamed(AppRoutes.SIGNUP);
  void goToLogin() => Get.offAllNamed(AppRoutes.LOGIN);
}
