import 'package:flutter/material.dart';
import 'package:frontend/app_routes.dart';
import 'package:frontend/signup/controller/signup_controller.dart';
import 'package:get/get.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return _AuthShell(
      title: 'Create Account',
      subtitle: 'Tag, search, and organize your screenshots effortlessly.',
      primaryLabel: 'Sign Up',
      footerText: 'Already have an account?',
      footerLink: 'Login',
      onFooterTap: () => Get.offAllNamed(AppRoutes.LOGIN),
      onSubmit: controller.signup,
      isLoading: controller.isLoading,
      fields: [
        _AuthField(label: 'Name', controller: controller.nameController, icon: Icons.person_outline),
        _AuthField(label: 'Username', controller: controller.userNameController, icon: Icons.alternate_email),
        _AuthField(label: 'Email', controller: controller.emailController, icon: Icons.mail_outline),
        _AuthField(label: 'Password', controller: controller.passwordController, icon: Icons.lock_outline, obscure: true),
      ],
    );
  }
}

class _AuthShell extends StatelessWidget {
  const _AuthShell({
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.onSubmit,
    required this.isLoading,
    required this.footerText,
    required this.footerLink,
    required this.onFooterTap,
    required this.fields,
  });

  final String title;
  final String subtitle;
  final String primaryLabel;
  final VoidCallback onSubmit;
  final RxBool isLoading;
  final String footerText;
  final String footerLink;
  final VoidCallback onFooterTap;
  final List<Widget> fields;

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
                        title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 24),
                      ..._withSpacing(fields, 14),
                      const SizedBox(height: 20),
                      Obx(
                        () => ElevatedButton(
                          onPressed: isLoading.value ? null : onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00D1B2),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: isLoading.value
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2.2),
                                )
                              : Text(primaryLabel),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: onFooterTap,
                        child: Text.rich(
                          TextSpan(
                            text: '$footerText ',
                            style: const TextStyle(color: Colors.white70),
                            children: [
                              TextSpan(
                                text: footerLink,
                                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      )
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
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 90,
              spreadRadius: 40,
            )
          ],
        ),
      );
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.controller,
    this.icon,
    this.obscure = false,
  });

  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF00D1B2), width: 1.6),
        ),
      ),
    );
  }
}

List<Widget> _withSpacing(List<Widget> widgets, double gap) {
  final out = <Widget>[];
  for (var i = 0; i < widgets.length; i++) {
    out.add(widgets[i]);
    if (i != widgets.length - 1) out.add(SizedBox(height: gap));
  }
  return out;
}
