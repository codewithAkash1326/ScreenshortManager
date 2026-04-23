import 'package:flutter/material.dart';

class AppTheme {
  static const _accent = Color(0xFF00D1B2);
  static const _bgDark = Color(0xFF0B0B0F);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _accent, brightness: Brightness.light),
        scaffoldBackgroundColor: Colors.grey[50],
        inputDecorationTheme: _inputDecoration,
        elevatedButtonTheme: _buttonTheme,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _accent,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: _bgDark,
        inputDecorationTheme: _inputDecoration.copyWith(
          fillColor: Colors.white10,
        ),
        elevatedButtonTheme: _buttonTheme,
      );

  static const _inputDecoration = InputDecorationTheme(
    filled: true,
    fillColor: Color(0x0DFFFFFF),
    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: _accent, width: 1.6),
    ),
  );

  static final _buttonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _accent,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}
