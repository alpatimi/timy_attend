import 'package:flutter/material.dart';

// ============================================================
// APP COLORS (ThemeExtension)
// ============================================================
//
// Cara pakai di widget mana pun:
//
//   final c = context.colors;
//   Container(color: c.surface, ...)
//   Text('Halo', style: TextStyle(color: c.text))
//
// Warna otomatis berganti saat light/dark mode berubah.

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.primary,
    required this.primarySoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.heroStart,
    required this.heroEnd,
  });

  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color text;
  final Color textMuted;
  final Color textFaint;
  final Color primary;
  final Color primarySoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Color heroStart;
  final Color heroEnd;

  static const light = AppColors(
    bg: Color(0xFFF5F7FB),
    surface: Colors.white,
    surfaceAlt: Color(0xFFF1F3FC),
    border: Color(0xFFE8EDF5),
    text: Color(0xFF172033),
    textMuted: Color(0xFF6B7280),
    textFaint: Color(0xFF9CA3AF),
    primary: Color(0xFF1557D6),
    primarySoft: Color(0xFFEAF1FF),
    success: Color(0xFF16A34A),
    successSoft: Color(0xFFE8F8EE),
    warning: Color(0xFFD97706),
    warningSoft: Color(0xFFFFF4E5),
    danger: Color(0xFFEF4444),
    dangerSoft: Color(0xFFFEECEC),
    heroStart: Color(0xFF2F6BEA),
    heroEnd: Color(0xFF1245B0),
  );

  static const dark = AppColors(
    bg: Color(0xFF0B1020),
    surface: Color(0xFF141A2B),
    surfaceAlt: Color(0xFF1B2338),
    border: Color(0xFF263049),
    text: Color(0xFFE8ECF6),
    textMuted: Color(0xFF9AA4B8),
    textFaint: Color(0xFF6B7690),
    primary: Color(0xFF3B7BF2),
    primarySoft: Color(0xFF1B2A4D),
    success: Color(0xFF4ADE80),
    successSoft: Color(0xFF12301F),
    warning: Color(0xFFFBBF24),
    warningSoft: Color(0xFF3A2A0E),
    danger: Color(0xFFF87171),
    dangerSoft: Color(0xFF3B1618),
    heroStart: Color(0xFF2350C0),
    heroEnd: Color(0xFF0F1F5C),
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? text,
    Color? textMuted,
    Color? textFaint,
    Color? primary,
    Color? primarySoft,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Color? heroStart,
    Color? heroEnd,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      textFaint: textFaint ?? this.textFaint,
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      bg: l(bg, other.bg),
      surface: l(surface, other.surface),
      surfaceAlt: l(surfaceAlt, other.surfaceAlt),
      border: l(border, other.border),
      text: l(text, other.text),
      textMuted: l(textMuted, other.textMuted),
      textFaint: l(textFaint, other.textFaint),
      primary: l(primary, other.primary),
      primarySoft: l(primarySoft, other.primarySoft),
      success: l(success, other.success),
      successSoft: l(successSoft, other.successSoft),
      warning: l(warning, other.warning),
      warningSoft: l(warningSoft, other.warningSoft),
      danger: l(danger, other.danger),
      dangerSoft: l(dangerSoft, other.dangerSoft),
      heroStart: l(heroStart, other.heroStart),
      heroEnd: l(heroEnd, other.heroEnd),
    );
  }
}

extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

// ============================================================
// APP THEME
// ============================================================

class AppTheme {
  // ---- Konstanta lama (tetap ada supaya file lain tidak error) ----

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

  // ---- Theme ----

  static ThemeData get lightTheme => _build(Brightness.light, AppColors.light);

  static ThemeData get darkTheme => _build(Brightness.dark, AppColors.dark);

  static ThemeData _build(Brightness brightness, AppColors c) {
    final isDark = brightness == Brightness.dark;

    const radius = BorderRadius.all(Radius.circular(14));

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
      ).copyWith(
        primary: c.primary,
        surface: c.surface,
        error: c.danger,
      ),

      scaffoldBackgroundColor: c.bg,
      extensions: <ThemeExtension<dynamic>>[c],

      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surfaceAlt,
        hintStyle: TextStyle(color: c.textFaint),
        border: const OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: c.primary, width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: c.primarySoft,
        elevation: 0,
        height: 68,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? c.primary : c.textMuted,
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? c.primary : c.textMuted,
          );
        }),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? c.surfaceAlt : c.text,
        contentTextStyle: TextStyle(
          color: isDark ? c.text : Colors.white,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),

      dividerColor: c.border,
    );
  }
}