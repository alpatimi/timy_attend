import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
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
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
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
    nameController = TextEditingController(
      text: widget.currentName,
    );

    emailController = TextEditingController(
      text: widget.currentEmail,
    );

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
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            24,
            20,
            30,
          ),
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
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
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
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F7FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE1E5EF),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedRole,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Student',
                  child: Text('Student'),
                ),
                DropdownMenuItem(
                  value: 'Staff',
                  child: Text('Staff'),
                ),
                DropdownMenuItem(
                  value: 'Teacher',
                  child: Text('Teacher'),
                ),
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
            prefixIcon: Icon(
              icon,
              size: 20,
            ),
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
        onPressed: saveProfile,
        icon: const Icon(
          Icons.check_rounded,
        ),
        label: const Text(
          'Save Changes',
        ),
      ),
    );
  }

  // ============================================================
  // SAVE PROFILE
  // ============================================================

  void saveProfile() {
    // Validasi nama.
    if (nameController.text.trim().isEmpty) {
      showError(
        'Full name cannot be empty.',
      );

      return;
    }

    // Validasi email.
    if (emailController.text.trim().isEmpty) {
      showError(
        'Email address cannot be empty.',
      );

      return;
    }

    // Mengembalikan data ke ProfileScreen.
    Navigator.pop(
      context,
      {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'role': selectedRole,
      },
    );
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
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
        content: Text(
          'Profile photo upload will be connected later.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}