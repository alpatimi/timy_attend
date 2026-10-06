import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timy_attend/preferences/login_preferences.dart';
import 'package:timy_attend/screens/auth/login_screen.dart';
import 'package:timy_attend/screens/dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Satu controller mengatur semua animasi (durasi total = 3 detik,
  // sama seperti Timer lama), lalu pindah halaman saat selesai.
  late final AnimationController _controller;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.6, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward().whenComplete(_goNext);
  }

  Future<void> _goNext() async {
    final isLogin = await LoginPreferences.isLogin;

    if (!mounted) return;

    // Sudah login -> Dashboard, belum login -> Login.
    // pushReplacement supaya tombol back tidak kembali ke splash.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isLogin ? const LoginScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFF0A1535),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // =========================
            // BACKGROUND
            // =========================
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1B4FD1),
                      Color(0xFF0F2F8F),
                      Color(0xFF0A1535),
                    ],
                  ),
                ),
              ),
            ),

            // Lingkaran cahaya di belakang kaca (efek glow).
            Positioned(
              top: -90,
              left: -70,
              child: _buildGlow(300, const Color(0xFF60A5FA), 0.55),
            ),
            Positioned(
              bottom: -110,
              right: -80,
              child: _buildGlow(340, const Color(0xFF22C55E), 0.35),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.52,
              left: -60,
              child: _buildGlow(200, const Color(0xFF7C3AED), 0.3),
            ),

            // =========================
            // CONTENT
            // =========================
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Kartu kaca berisi logo.
                    FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: _buildGlassLogo(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Nama aplikasi + teks animasi.
                    FadeTransition(
                      opacity: _textFade,
                      child: SlideTransition(
                        position: _textSlide,
                        child: Column(
                          children: [
                            const Text(
                              'TimyAttend',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.8,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Attendance Portal',
                              style: TextStyle(
                                fontSize: 13,
                                letterSpacing: 1.2,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),

                            const SizedBox(height: 28),

                            SizedBox(
                              height: 28,
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'Welcome to',
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    speed: const Duration(milliseconds: 70),
                                  ),
                                  TypewriterAnimatedText(
                                    'TIMY ATTEND',
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    speed: const Duration(milliseconds: 70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =========================
            // PROGRESS BAR (kaca)
            // =========================
            Positioned(
              left: 48,
              right: 48,
              bottom: 48,
              child: SafeArea(
                child: FadeTransition(
                  opacity: _textFade,
                  child: _buildGlassProgress(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // GLOW
  // ============================================================

  Widget _buildGlow(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // GLASS LOGO CARD
  // ============================================================

  Widget _buildGlassLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(44),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.28),
                Colors.white.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(44),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'assets/images/timy_logo.jpg',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GLASS PROGRESS BAR
  // ============================================================

  Widget _buildGlassProgress() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: _controller.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF93C5FD), Colors.white],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}