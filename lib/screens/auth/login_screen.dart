import 'package:flutter/material.dart';
import 'package:timy_attend/screens/auth/register_screen.dart';
import 'package:timy_attend/screens/dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk mengambil isi email.
  final TextEditingController emailController = TextEditingController();

  // Controller untuk mengambil isi password.
  final TextEditingController passwordController = TextEditingController();

  // Menentukan apakah password sedang disembunyikan.
  bool isPasswordHidden = true;

  @override
  void dispose() {
    // Membersihkan controller ketika halaman dihancurkan.
    emailController.dispose();

    // Membersihkan controller password.
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),

              // =========================
              // LOGO
              // =========================
              Image.asset(
                'assets/images/timy_attend_logo.png',
                width: 250,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 12),

              // =========================
              // TAGLINE
              // =========================
              const Text(
                'Your attendance, made simple.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),

              const SizedBox(height: 42),

              // =========================
              // EMAIL LABEL
              // =========================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email Address',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF172033),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // =========================
              // EMAIL INPUT
              // =========================
              TextField(
                controller: emailController,

                keyboardType: TextInputType.emailAddress,

                decoration: const InputDecoration(
                  hintText: 'Enter your email',

                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // PASSWORD LABEL
              // =========================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF172033),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // =========================
              // PASSWORD INPUT
              // =========================
              TextField(
                controller: passwordController,

                // Menyembunyikan password.
                obscureText: isPasswordHidden,

                decoration: InputDecoration(
                  hintText: 'Enter your password',

                  prefixIcon: const Icon(Icons.lock_outline),

                  // Tombol untuk melihat/menyembunyikan password.
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // FORGOT PASSWORD
              // =========================
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton(
              //     onPressed: () {
              //       // Fitur forgot password belum diperlukan
              //       // untuk tahap tugas ini.
              //     },
              //     child: const Text(
              //       'Forgot password?',
              //     ),
              //   ),
              // ),
              const SizedBox(height: 12),

              // =========================
              // LOGIN BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  },
                  child: const Text('Login'),
                ),
              ),

              const SizedBox(height: 28),

              // =========================
              // REGISTER LINK
              // =========================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Color(0xFF6B7280)),
                  ), 

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrasiScreen(),
                        ),
                      );
                    },
                    child: const Text('Create account'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // =========================
              // SECURITY INFO
              // =========================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 15,
                    color: Color(0xFF1557D6),
                  ),

                  SizedBox(width: 6),

                  Text(
                    'Secure attendance system',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
