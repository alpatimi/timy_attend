import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Menyimpan pilihan tema (system / light / dark) dan
// menyimpannya ke SharedPreferences supaya tidak hilang
// ketika aplikasi ditutup.

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const String _key = 'theme_mode';

  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);

    if (saved == null) return;

    state = ThemeMode.values.firstWhere(
      (mode) => mode.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  // Dipakai tombol toggle: ubah ke kebalikan dari tema yang sedang tampil.
  Future<void> toggle(Brightness currentBrightness) {
    return setMode(
      currentBrightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark,
    );
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);