import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timy_attend/controllers/edit_profile.dart';
import 'package:timy_attend/models/user/name_user_edit_request_model.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  // Data user saat ini.
  final String currentName;

  final String currentEmail;

  final String currentRole;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentRole,
  });

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  bool isLoading = false;
  // Controller untuk nama.
  late TextEditingController nameController;

  // Controller untuk email.
  late TextEditingController emailController;

  // Menyimpan role yang dipilih.
  late String selectedRole;

  @override
  void initState() {
    super.initState();

    // Mengisi form dengan data user sebelumnya.
    nameController = TextEditingController(text: widget.currentName);

    emailController = TextEditingController(text: widget.currentEmail);

    selectedRole = widget.currentRole;
  }

  @override
  void dispose() {
    // Membersihkan controller
    // ketika halaman ditutup.
    nameController.dispose();

    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), centerTitle: true),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProfilePhoto(),

              const SizedBox(height: 30),

              buildNameField(),

              const SizedBox(height: 18),

              buildEmailField(),

              const SizedBox(height: 18),

              buildRoleField(),

              const SizedBox(height: 30),

              buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE PHOTO
  // ============================================================

  Widget buildProfilePhoto() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 95,
                height: 95,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF0FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 52,
                  color: Color(0xFF1557D6),
                ),
              ),

              // Tombol edit foto.
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1557D6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showPhotoMessage();
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text(
            'Profile Photo',
            style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NAME FIELD
  // ============================================================

  Widget buildNameField() {
    return buildTextField(
      label: 'Full Name',
      hint: 'Enter your full name',
      controller: nameController,
      icon: Icons.person_outline_rounded,
    );
  }

  // ============================================================
  // EMAIL FIELD
  // ============================================================

  Widget buildEmailField() {
    return buildTextField(
      label: 'Email Address',
      hint: 'Enter your email address',
      controller: emailController,
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
    );
  }

  // ============================================================
  // ROLE FIELD
  // ============================================================

  Widget buildRoleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Role',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172033),
          ),
        ),

        const SizedBox(height: 8),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F7FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE1E5EF)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedRole,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: const [
                DropdownMenuItem(value: 'Student', child: Text('Student')),
                DropdownMenuItem(value: 'Staff', child: Text('Staff')),
                DropdownMenuItem(value: 'Teacher', child: Text('Teacher')),
              ],
              onChanged: (String? value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedRole = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172033),
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : saveProfile,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.check_rounded),
        label: Text(isLoading ? 'Saving...' : 'Save Changes'),
      ),
    );
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    // Validasi nama
    if (name.isEmpty) {
      showError('Full name cannot be empty.');
      return;
    }

    // Validasi email kosong & format email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) {
      showError('Email address cannot be empty.');
      return;
    } else if (!emailRegex.hasMatch(email)) {
      showError('Please enter a valid email address.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final newName = nameController.text.trim();
      final request = NameUserEditRequestModel(name: newName);

      final response = await ref
          .read(editProfileProvider.notifier)
          .editProfile(request);

      if (!mounted) return;

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Berhasil menyimpan!, Nama Profil berhasil diperbarui!',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
      } else {
        final editState = ref.read(editProfileProvider);
        final errorMsg = editState.hasError
            ? editState.error.toString()
            : 'Gagal memperbarui profil';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      if (response != null) {
        // Ambil objek user/data jika dibungkus oleh response backend
        final userData = response.data ?? response.data?.name ?? response.data;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.pop(context, {
          'name': (userData is Map ? userData['name'] : null) ?? name,
          'email': (userData is Map ? userData['email'] : null) ?? email,
          'role': selectedRole,
        });
      } else {
        showError('Gagal memperbarui profil. Periksa koneksi atau input Anda.');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan, terjadi kesalahan'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  // ============================================================
  // PHOTO MESSAGE
  // ============================================================

  void showPhotoMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile photo upload will be connected later.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
