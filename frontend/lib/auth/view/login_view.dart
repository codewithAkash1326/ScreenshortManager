import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/auth/controller/auth_controller.dart';
import 'package:frontend/utils/ui_utils.dart';
import 'package:get/get.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

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
                        'Welcome back',

                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Sign in to manage your screenshots securely.',

                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),

                      const SizedBox(height: 24),

                      _AuthField(
                        label: 'Email',

                        controller: controller.loginEmailController,

                        icon: Icons.mail_outline,

                        errorText: controller.loginEmailError,
                      ),

                      const SizedBox(height: 14),

                      _AuthField(
                        label: 'Password',

                        controller: controller.loginPasswordController,

                        icon: Icons.lock_outline,

                        obscure: true,

                        errorText: controller.loginPasswordError,
                      ),

                      GestureDetector(
                        onTap: () => controller.goToForgotPassword(),
                        child: Container(
                          padding: EdgeInsets.only(top: 8),

                          alignment: AlignmentGeometry.centerRight,
                          child: Text("Forgot password ?"),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Obx(
                        () => SizedBox(
                          width: double.infinity,

                          child: ElevatedButton(
                            onPressed: controller.isLoginLoading.value
                                ? null
                                : controller.login,

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00D1B2),

                              foregroundColor: Colors.black,

                              padding: const EdgeInsets.symmetric(vertical: 14),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),

                            child: controller.isLoginLoading.value
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,

                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                    ),
                                  )
                                : const Text('Login'),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Center(
                        child: TextButton(
                          onPressed: controller.goToSignup,

                          child: const Text(
                            'New here? Create an account',

                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text("OR"),
                        ),
                      ),

                      googleLoginButton(onTap: null),
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

  Widget googleLoginButton({
    VoidCallback? onTap,
    bool isLoading = false,
    String text = "Continue with Google",
  }) {
    return SizedBox(
      width: double.infinity,

      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        onTap: isLoading ? null : onTap,

        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),

            borderRadius: BorderRadius.circular(14),

            border: Border.all(color: Colors.white10),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              if (isLoading)
                const SizedBox(
                  height: 18,
                  width: 18,

                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else ...[
                SvgPicture.asset(
                  'assets/images/google_logo.svg',
                  width: 24,
                  height: 24,
                ),

                const SizedBox(width: 12),

                Text(
                  text,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
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

  Widget _blob(Color color, double size) {
    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,

        boxShadow: [BoxShadow(color: color, blurRadius: 90, spreadRadius: 40)],
      ),
    );
  }
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
