import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:timy_attend/preferences/login_preferences.dart';
import 'package:timy_attend/screens/auth/login_screen.dart';
import 'package:timy_attend/screens/dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {
      final isLogin = await LoginPreferences.isLogin;

      if (!mounted) return;

      if (isLogin) {
        Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const DashboardScreen()),
);
      } else {
        Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const LoginScreen()),
);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(decoration: BoxDecoration(color: const Color.fromARGB(255, 65, 39, 7)))
          ),
          Positioned(
            bottom: 500,
            left: 100,
            child:  AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText('Mohon Bersabar...', textStyle: TextStyle(fontSize: 20, color:Colors.white, fontWeight:.w600)),
        TypewriterAnimatedText('Ini Ujian....', textStyle: TextStyle(fontSize: 20, color:Colors.white, fontWeight:.w600)),
      ],
      onTap: () {
        print("Tap Event");
      },
    ),
          ),
        ],
      ),
    );
  }
}