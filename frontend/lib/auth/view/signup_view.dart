import 'package:flutter/material.dart';
import 'package:frontend/app_routes.dart';
import 'package:frontend/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),

      body: Stack(
        children: [
          const _Glows(),

          Center(
            child: SingleChildScrollView(
              child: AnimatedScale(
                duration: const Duration(milliseconds: 400),
                scale: 1,

                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),

                    borderRadius: BorderRadius.circular(20),

                    border: Border.all(color: Colors.white10),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 24,
                        spreadRadius: -8,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Create Account',

                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Tag, search, and organize your screenshots effortlessly.',

                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),

                      const SizedBox(height: 24),

                      _AuthField(
                        label: 'Name',
                        controller: controller.signupNameController,

                        icon: Icons.person_outline,

                        errorText: controller.signupNameError,
                      ),

                      const SizedBox(height: 14),

                      _AuthField(
                        label: 'Email',

                        controller: controller.signupEmailController,

                        icon: Icons.mail_outline,

                        errorText: controller.signupEmailError,
                      ),

                      const SizedBox(height: 14),

                      _AuthField(
                        label: 'Password',

                        controller: controller.signupPasswordController,

                        icon: Icons.lock_outline,

                        obscure: true,

                        errorText: controller.signupPasswordError,
                      ),

                      const SizedBox(height: 20),

                      Obx(
                        () => SizedBox(
                          child: ElevatedButton(
                            onPressed: controller.isSignupLoading.value
                                ? null
                                : controller.signup,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00D1B2),

                              foregroundColor: Colors.black,

                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 16,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),

                            child: controller.isSignupLoading.value
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,

                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                    ),
                                  )
                                : const Text('Sign Up'),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            Get.offAllNamed(AppRoutes.LOGIN);
                          },

                          child: Text.rich(
                            TextSpan(
                              text: 'Already have an account? ',

                              style: const TextStyle(color: Colors.white70),

                              children: const [
                                TextSpan(
                                  text: 'Login',

                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,

                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glows extends StatelessWidget {
  const _Glows();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -40,
          child: _blob(const Color(0xFF00D1B2).withOpacity(0.35), 220),
        ),
        Positioned(
          bottom: -120,
          right: -60,
          child: _blob(Colors.blue.withOpacity(0.35), 260),
        ),
      ],
    );
  }

  Widget _blob(Color color, double size) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
      boxShadow: [BoxShadow(color: color, blurRadius: 90, spreadRadius: 40)],
    ),
  );
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.controller,
    this.icon,
    this.obscure = false,
    required this.errorText,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final bool obscure;
  final RxString errorText;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TextField(
        controller: controller,
        obscureText: obscure,
        onChanged: (value) {
          if (value.trim().isNotEmpty && errorText.value.isNotEmpty) {
            errorText.value = '';
          }

          onChanged?.call(value);
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText.value.isEmpty ? null : errorText.value,

          labelStyle: const TextStyle(color: Colors.white70),

          errorStyle: const TextStyle(color: Colors.redAccent),

          prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,

          filled: true,
          fillColor: Colors.white.withOpacity(0.05),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF00D1B2), width: 1.6),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
        ),
      ),
    );
  }
}
