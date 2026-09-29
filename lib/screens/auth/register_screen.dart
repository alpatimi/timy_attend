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
final success = await authService.register(
  name,
  email,
  password,
);

if (success) {
  showMessage('Registrasi berhasil.');

  // Kembali ke halaman login.
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
} else {
  showMessage('Registrasi gagal. Email mungkin sudah terdaftar.');
}
  }

  // Fungsi untuk menampilkan pesan kepada pengguna.
  void showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar sederhana.
      appBar: AppBar(title: const Text('Create Account'), centerTitle: true),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // LOGO
              // =========================
              Center(
                child: Image.asset(
                  'assets/images/timy_attend_logo.png',
                  width: 190,
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
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'COHORT ENROLLMENT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1557D6),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // =========================
              // TITLE
              // =========================
              const Center(
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
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
                  style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
                ),
              ),

              const SizedBox(height: 30),

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
                decoration: const InputDecoration(
                  hintText: 'e.g. Alex Morgan',
                  prefixIcon: Icon(Icons.person_outline),
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
                decoration: const InputDecoration(
                  hintText: 'e.g. alex@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
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
                decoration: const InputDecoration(
                  hintText: 'e.g. Batch 4 - August 2026',
                  prefixIcon: Icon(Icons.groups_outlined),
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
                value: selectedTrainingId,

                decoration: const InputDecoration(
                  hintText: 'Select training program',
                  prefixIcon: Icon(Icons.school_outlined),
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
                decoration: InputDecoration(
                  hintText: 'At least 8 characters',

                  prefixIcon: const Icon(Icons.lock_outline),

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
                decoration: InputDecoration(
                  hintText: 'Re-enter your password',

                  prefixIcon: const Icon(Icons.lock_reset_outlined),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isConfirmPasswordHidden = !isConfirmPasswordHidden;
                      });
                    },
                    icon: Icon(
                      isConfirmPasswordHidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // AGREEMENT CHECKBOX
              // =========================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isAgreed,
                    onChanged: (bool? value) {
                      setState(() {
                        isAgreed = value ?? false;
                      });
                    },
                  ),

                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        'By registering, you agree to the attendance '
                        'logging and security requirements.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // =========================
              // CREATE ACCOUNT BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: validateForm,

                  icon: const Icon(Icons.arrow_forward, size: 18),

                  label: const Text('Create Account'),
                ),
              ),

              const SizedBox(height: 20),

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
                  child: const Text('Already have an account? Sign In'),
                ),
              ),

              const SizedBox(height: 4),

              // =========================
              // SECURITY INFO
              // =========================
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 15,
                      color: Color(0xFF1557D6),
                    ),

                    SizedBox(width: 6),

                    Text(
                      'Protected by secure attendance logging',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
