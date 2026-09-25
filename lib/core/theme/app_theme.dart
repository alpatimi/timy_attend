import 'package:flutter/material.dart';

class AppTheme {
  // Warna utama aplikasi TimyAttend.
  static const Color primaryColor = Color(0xFF1557D6);

  // Warna latar belakang aplikasi.
  static const Color backgroundColor = Color(0xFFF8F9FF);

  // Warna putih untuk card dan komponen.
  static const Color surfaceColor = Colors.white;

  // Warna utama untuk teks.
  static const Color textColor = Color(0xFF172033);

  // Warna teks sekunder.
  static const Color secondaryTextColor = Color(0xFF6B7280);

  // Warna untuk status berhasil / hadir.
  static const Color successColor = Color(0xFF22C55E);

  // Warna untuk error.
  static const Color errorColor = Color(0xFFEF4444);

  // Theme utama aplikasi.
  static ThemeData lightTheme = ThemeData(
    // Menggunakan Material 3.
    useMaterial3: true,

    // Warna utama aplikasi.
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),

    // Warna background.
    scaffoldBackgroundColor: backgroundColor,

    // Warna dasar AppBar.
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textColor,
      elevation: 0,
    ),

    // Theme untuk TextField.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF1F3FC),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        borderSide: BorderSide.none,
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        borderSide: BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    ),

    // Theme untuk tombol utama.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,

        minimumSize: const Size(
          double.infinity,
          52,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}