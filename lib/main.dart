import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timy_attend/splash_screen.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: TimyAttendApp(),
    ),
  );
}

class TimyAttendApp extends ConsumerWidget {
  const TimyAttendApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ambil ThemeMode dari themeModeProvider
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'TimyAttend',

      debugShowCheckedModeBanner: false,

      // Tema terang
      theme: AppTheme.lightTheme,

      // Tema gelap
      darkTheme: AppTheme.darkTheme,

      // Tema yang sedang dipilih
      themeMode: themeMode,

      home: const SplashScreen(),
    );
  }
}