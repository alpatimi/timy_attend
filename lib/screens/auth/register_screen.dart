import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timy_attend/controllers/register_user.dart';
import 'package:timy_attend/models/register/register_request_model.dart';
import 'package:timy_attend/screens/auth/login_screen.dart';

class RegistrasiScreen extends ConsumerStatefulWidget {
  const RegistrasiScreen({super.key});

  @override
  ConsumerState<RegistrasiScreen> createState() => _RegistrasiScreenState();
}

class _RegistrasiScreenState extends ConsumerState<RegistrasiScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> validateForm() async {
    // Mengambil nilai input dan menghapus spasi di awal/akhir.
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();

    final String password = passwordController.text;

    // Memeriksa nama.
    if (name.isEmpty) {
      showMessage('Nama lengkap wajib diisi.');
      return;
    }

    // Memeriksa email.
    if (email.isEmpty) {
      showMessage('Email wajib diisi.');
      return;
    }

    // Memeriksa format email sederhana.
    if (!email.contains('@')) {
      showMessage('Masukkan email yang valid.');
      return;
    }

    // Memeriksa password.
    if (password.isEmpty) {
      showMessage('Password wajib diisi.');
      return;
    }

    // Memeriksa panjang password.
    if (password.length < 8) {
      showMessage('Password minimal 8 karakter.');
      return;
    }

    final signUpRequest = RegisterRequestModel(
      name: name,
      email: email,
      password: password,
    );

    ref.read(registerUserProvider.notifier).register(signUpRequest);
  }

  // Fungsi untuk menampilkan pesan kepada pengguna.
  void showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registerUserProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          if (response == null) return;

          showMessage('Registrasi berhasil.');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        error: (error, _) {
          showMessage('Registrasi gagal. Email mungkin sudah terdaftar.');
        },
      );
    });

    return Scaffold(
      // AppBar sederhana.
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF172033),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFEAF1FF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF172033)),
      ),

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
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =========================
                    // LOGO
                    // =========================
                    Center(
                      child: Image.asset(
                        'assets/images/timy_attend_logo.png',
                        width: 170,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // =========================
                    // COHORT LABEL
                    // =========================
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCE8FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'COHORT ENROLLMENT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1557D6),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // =========================
                    // TITLE
                    // =========================
                    const Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: Color(0xFF172033),
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // =========================
                    // SUBTITLE
                    // =========================
                    const Center(
                      child: Text(
                        'Join your training cohort on TimyAttend',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // =========================
                    // FORM CARD
                    // =========================
                    Form(
                      key: _formKey,
                      child: Container(
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
                            // FULL NAME
                            // =========================
                            const Text(
                              'Full Name',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF172033),
                              ),
                            ),

                            const SizedBox(height: 8),

                            TextField(
                              controller: nameController,
                              textCapitalization: TextCapitalization.words,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF172033),
                              ),
                              decoration: InputDecoration(
                                hintText: 'e.g. Alex Morgan',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                                prefixIcon: const Icon(
                                  Icons.person_outline,
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

                            const SizedBox(height: 18),

                            // =========================
                            // EMAIL
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

                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF172033),
                              ),
                              decoration: InputDecoration(
                                hintText: 'e.g. alex@example.com',
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

                            const SizedBox(height: 18),

                            // =========================
                            // PASSWORD
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

                            TextField(
                              controller: passwordController,
                              obscureText: isPasswordHidden,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF172033),
                              ),
                              decoration: InputDecoration(
                                hintText: 'At least 8 characters',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),

                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Color(0xFF6B7280),
                                ),

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

                            const SizedBox(height: 18),

                            // CONFIRM PASSWORD
                            const Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF172033),
                              ),
                            ),
                            const SizedBox(height: 22),

                            // CREATE ACCOUNT BUTTON
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
                              child: ElevatedButton.icon(
                                onPressed: validateForm,

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

                                icon: const Icon(Icons.arrow_forward, size: 18),

                                label: const Text('Create Account'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // =========================
                    // LOGIN LINK
                    // =========================
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF1557D6),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Already have an account? Sign In'),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // =========================
                    // SECURITY INFO
                    // =========================
                    Center(
                      child: Container(
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
                              'Protected by secure attendance logging',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3B5BA5),
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
          ),
        ),
      ),
    );
  }
}
