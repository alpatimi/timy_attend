import 'package:flutter/material.dart';
import 'package:timy_attend/screens/auth/login_screen.dart';
import 'package:timy_attend/services/auth_service.dart';

class RegistrasiScreen extends StatefulWidget {
  const RegistrasiScreen({super.key});

  @override
  State<RegistrasiScreen> createState() => _RegistrasiScreenState();
}

class _RegistrasiScreenState extends State<RegistrasiScreen> {
  final AuthService authService = AuthService();
  // Controller untuk mengambil nama pengguna.
  final TextEditingController nameController = TextEditingController();

  // Controller untuk mengambil email pengguna.
  final TextEditingController emailController = TextEditingController();

  // Controller untuk mengambil batch pengguna.
  final TextEditingController batchController = TextEditingController();

  // Controller untuk mengambil password.
  final TextEditingController passwordController = TextEditingController();

  // Controller untuk mengambil konfirmasi password.
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Menyimpan training ID yang dipilih.
  int? selectedTrainingId;

  // Menentukan apakah password disembunyikan.
  bool isPasswordHidden = true;

  // Menentukan apakah confirm password disembunyikan.
  bool isConfirmPasswordHidden = true;

  // Menentukan apakah checkbox persetujuan dicentang.
  bool isAgreed = false;

  // Data training sementara untuk kebutuhan UI.
  //
  // Nanti data ini akan kita ganti dengan data dari API
  // setelah kita mempelajari endpoint training dari Postman.
  final List<Map<String, dynamic>> trainingOptions = [
    {'id': 1, 'name': 'Android Developer'},
    {'id': 2, 'name': 'Web Developer'},
    {'id': 3, 'name': 'UI/UX Designer'},
  ];

  @override
  void dispose() {
    // Membersihkan controller nama.
    nameController.dispose();

    // Membersihkan controller email.
    emailController.dispose();

    // Membersihkan controller batch.
    batchController.dispose();

    // Membersihkan controller password.
    passwordController.dispose();

    // Membersihkan controller konfirmasi password.
    confirmPasswordController.dispose();

    super.dispose();
  }

  // Fungsi untuk memeriksa input sebelum register.
  Future<void> validateForm() async {
    // Mengambil nilai input dan menghapus spasi di awal/akhir.
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String batch = batchController.text.trim();
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

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

    // Memeriksa batch.
    if (batch.isEmpty) {
      showMessage('Batch / Cohort wajib diisi.');
      return;
    }

    // Memeriksa training.
    if (selectedTrainingId == null) {
      showMessage('Silakan pilih training.');
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

    // Memeriksa confirm password.
    if (confirmPassword.isEmpty) {
      showMessage('Konfirmasi password wajib diisi.');
      return;
    }

    // Memastikan kedua password sama.
    if (password != confirmPassword) {
      showMessage('Password dan konfirmasi password tidak sama.');
      return;
    }

    // Memeriksa checkbox persetujuan.
    if (!isAgreed) {
      showMessage('Silakan centang persetujuan terlebih dahulu.');
      return;
    }

    // Untuk sekarang baru menampilkan data.
    //
    // API register akan kita masukkan pada tahap berikutnya.
    // Mengirim data register ke API.
    final success = await authService.register(name, email, password);

    if (success) {
      showMessage('Registrasi berhasil.');

      // Kembali ke halaman login.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      showMessage('Registrasi gagal. Email mungkin sudah terdaftar.');
    }
  }

  // Fungsi untuk menampilkan pesan kepada pengguna.
  void showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
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
                          // BATCH / COHORT
                          // =========================
                          const Text(
                            'Batch / Cohort',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF172033),
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextField(
                            controller: batchController,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF172033),
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. Batch 4 - August 2026',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.groups_outlined,
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
                          // TRAINING
                          // =========================
                          const Text(
                            'Training Program',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF172033),
                            ),
                          ),

                          const SizedBox(height: 8),

                          DropdownButtonFormField<int>(
                            initialValue: selectedTrainingId,

                            isExpanded: true,
                            borderRadius: BorderRadius.circular(16),
                            dropdownColor: Colors.white,
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF6B7280),
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF172033),
                            ),

                            decoration: InputDecoration(
                              hintText: 'Select training program',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.school_outlined,
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

                            items: trainingOptions.map((training) {
                              return DropdownMenuItem<int>(
                                value: training['id'] as int,
                                child: Text(training['name'] as String),
                              );
                            }).toList(),

                            onChanged: (int? value) {
                              setState(() {
                                selectedTrainingId = value;
                              });
                            },
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

                          // =========================
                          // CONFIRM PASSWORD
                          // =========================
                          const Text(
                            'Confirm Password',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF172033),
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextField(
                            controller: confirmPasswordController,
                            obscureText: isConfirmPasswordHidden,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF172033),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Re-enter your password',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),

                              prefixIcon: const Icon(
                                Icons.lock_reset_outlined,
                                color: Color(0xFF6B7280),
                              ),

                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordHidden =
                                        !isConfirmPasswordHidden;
                                  });
                                },
                                icon: Icon(
                                  isConfirmPasswordHidden
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

                          // =========================
                          // AGREEMENT CHECKBOX
                          // =========================
                          Container(
                            padding: const EdgeInsets.fromLTRB(4, 6, 12, 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F7FB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: isAgreed,
                                  activeColor: const Color(0xFF1557D6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFF9CA3AF),
                                    width: 1.5,
                                  ),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isAgreed = value ?? false;
                                    });
                                  },
                                ),

                                const Expanded(
                                  child: Text(
                                    'By registering, you agree to the attendance '
                                    'logging and security requirements.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.4,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 22),

                          // =========================
                          // CREATE ACCOUNT BUTTON
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