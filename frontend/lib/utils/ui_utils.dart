import 'package:flutter/material.dart';

class UiUtils {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(
    String message, {
    Color backgroundColor = const Color(0xFF18181B),
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  static void showSuccess(String message) {
    showSnackBar(
      message,
      backgroundColor: const Color(0xFF00D1B2),
      textColor: Colors.black,
    );
  }

  static void showError(String message) {
    showSnackBar(message, backgroundColor: const Color(0xFFB91C1C));
  }
}
