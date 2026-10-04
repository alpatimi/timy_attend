import 'package:flutter/material.dart';
import 'package:timy_attend/screens/auth/register_screen.dart';
import 'package:timy_attend/screens/dashboard/dashboard_screen.dart';
import 'package:timy_attend/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
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

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi.')),
      );
      return;
    }

    final success = await authService.login(email, password);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email atau password salah.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Latar belakang gradasi lembut.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF1FF), Color(0xFFF8FAFD), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // =========================
                    // LOGO
                    // =========================
                    Image.asset(
                      'assets/images/timy_attend_logo.png',
                      width: 200,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 12),

                    // =========================
                    // TAGLINE
                    // =========================
                    const Text(
                      'Your attendance, made simple.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 0.2,
                        color: Color(0xFF6B7280),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // =========================
                    // FORM CARD
                    // =========================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFFE8EDF5)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x141557D6),
                            blurRadius: 40,
                            offset: Offset(0, 16),
                          ),
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // =========================
                          // HEADING
                          // =========================
                          const Text(
                            'Welcome back',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                              color: Color(0xFF172033),
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            'Sign in to continue to your account.',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Color(0xFF6B7280),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // =========================
                          // EMAIL LABEL
                          // =========================
                          const Text(
                            'Email Address',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF172033),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // =========================
                          // EMAIL INPUT
                          // =========================
                          TextField(
                            controller: emailController,

                            keyboardType: TextInputType.emailAddress,

                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF172033),
                            ),

                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Color(0xFF6B7280),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF4F7FB),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE5EAF2),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1557D6),
                                  width: 1.6,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // =========================
                          // PASSWORD LABEL
                          // =========================
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF172033),
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

                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF172033),
                            ),

                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),

                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color(0xFF6B7280),
                              ),

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
                                  color: const Color(0xFF6B7280),
                                ),
                              ),

                              filled: true,
                              fillColor: const Color(0xFFF4F7FB),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE5EAF2),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF1557D6),
                                  width: 1.6,
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
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x401557D6),
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1557D6),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                minimumSize: const Size.fromHeight(54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              child: const Text('Login'),
                            ),
                          ),
                        ],
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
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                          ),
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
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF1557D6),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            minimumSize: const Size(0, 36),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          child: const Text('Create account'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // =========================
                    // SECURITY INFO
                    // =========================
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1FF),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            size: 15,
                            color: Color(0xFF1557D6),
                          ),

                          SizedBox(width: 6),

                          Text(
                            'Secure attendance system',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF3B5BA5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}