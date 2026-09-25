import 'package:flutter/material.dart';
import 'package:timy_attend/screens/auth/login_screen.dart';

import 'edit_profile_screen.dart';
import '../profile/profile_screen.dart'; //Pastikan path ini sesuai dengan file login Anda

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ============================================================
  // DATA USER SEMENTARA
  // ============================================================
  String userName = 'Timi';
  String userEmail = 'timi@example.com';
  String userRole = 'Student';
  String userId = 'TIMY-2026-001';
  String userBatch = 'Batch 4 - Android Developer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
              const SizedBox(height: 24),
              buildProfileCard(),
              const SizedBox(height: 22),
              buildAccountSection(),
              const SizedBox(height: 20),
              buildApplicationSection(),
              const SizedBox(height: 25),
              buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF0FF),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: Color(0xFF1557D6),
            size: 25,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Manage your account information',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================
  Widget buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF0FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 45,
              color: Color(0xFF1557D6),
            ),
          ),
          const SizedBox(height: 13),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              userRole,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1557D6),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton.icon(
              onPressed: openEditProfile,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACCOUNT SECTION
  // ============================================================
  Widget buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172033),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            children: [
              buildInformationItem(
                icon: Icons.badge_outlined,
                title: 'User ID',
                value: userId,
              ),
              buildDivider(),
              buildInformationItem(
                icon: Icons.email_outlined,
                title: 'Email Address',
                value: userEmail,
              ),
              buildDivider(),
              buildInformationItem(
                icon: Icons.school_outlined,
                title: 'Training Program',
                value: userBatch,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // APPLICATION SECTION
  // ============================================================
  Widget buildApplicationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Application',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172033),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            children: [
              buildActionItem(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                subtitle: 'Manage attendance notifications',
                onTap: () {},
              ),
              buildDivider(),
              buildActionItem(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy & Security',
                subtitle: 'Manage your account security',
                onTap: () {},
              ),
              buildDivider(),
              buildActionItem(
                icon: Icons.info_outline_rounded,
                title: 'About TimyAttend',
                subtitle: 'Attendance Portal',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'TimyAttend',
                    applicationVersion: '1.0.0',
                    applicationLegalese: 'Attendance Management Application',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INFORMATION ITEM
  // ============================================================
  Widget buildInformationItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 19,
              color: const Color(0xFF1557D6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF172033),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION ITEM
  // ============================================================
  Widget buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(17),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 19,
                color: const Color(0xFF1557D6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF172033),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DIVIDER
  // ============================================================
  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 65),
      child: Divider(
        height: 1,
        color: Color(0xFFE5E7EB),
      ),
    );
  }

  // ============================================================
  // LOGOUT BUTTON
  // ============================================================
  Widget buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: showLogoutDialog,
        icon: const Icon(
          Icons.logout_rounded,
          color: Color(0xFFDC2626),
        ),
        label: const Text(
          'Sign Out',
          style: TextStyle(
            color: Color(0xFFDC2626),
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(0xFFFECACA),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OPEN EDIT PROFILE
  // ============================================================
  Future<void> openEditProfile() async {
    final Map<String, String>? updatedData =
        await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EditProfileScreen(
            currentName: userName,
            currentEmail: userEmail,
            currentRole: userRole,
          );
        },
      ),
    );

    if (updatedData != null) {
      setState(() {
        userName = updatedData['name'] ?? userName;
        userEmail = updatedData['email'] ?? userEmail;
        userRole = updatedData['role'] ?? userRole;
      });
    }
  }

  // ============================================================
  // LOGOUT LOGIC & DIALOG
  // ============================================================
  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text(
            'Are you sure you want to sign out from TimyAttend?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                logout();
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}