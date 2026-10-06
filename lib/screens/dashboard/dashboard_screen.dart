import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:timy_attend/controllers/check_in_user.dart';
import 'package:timy_attend/controllers/check_out_user.dart';
import 'package:timy_attend/controllers/history_absen.dart';
import 'package:timy_attend/core/theme/app_theme.dart';
import 'package:timy_attend/core/theme/theme_provider.dart';
import 'package:timy_attend/models/absen/check_in_request_model.dart';
import 'package:timy_attend/models/absen/check_out_request_model.dart';
import 'package:timy_attend/screens/history/history_screen.dart';
import 'package:timy_attend/screens/maps/maps_widget.dart';
import 'package:timy_attend/services/maps_services.dart';

import '../profile/profile_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int selectedIndex = 0;
  bool isCheckedIn = false;
  bool isCheckedOut = false;
  final String userName = 'Timi';

  String? checkInTime;
  String? checkOutTime;

  // Jam digital yang berjalan setiap detik (hanya me-rebuild widget jam).
  late final Stream<DateTime> _clock = Stream<DateTime>.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );

  Future<void> checkIn() async {
    // 1. Loading AKTIF sebelum mengambil position/koordinat
    try {
      final Position coordinate = await MapsService().getCurrentLocation();
      final String address = await MapsService().getAddressFromCoordinates(
        coordinate.latitude,
        coordinate.longitude,
      );

      final checkInRequest = CheckInRequestModel(
        checkInLat: '${coordinate.latitude}',
        checkInLng: '${coordinate.longitude}',
        status: 'masuk',
        checkInAddress: address,
      );

      await ref.read(checkInUserProvider.notifier).checkIn(checkInRequest);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mendapatkan lokasi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDark = context.isDark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: c.surface,
            systemNavigationBarIconBrightness: isDark
                ? Brightness.light
                : Brightness.dark,
          ),
      child: Scaffold(
        backgroundColor: c.bg,

        // =========================
        // BODY
        // =========================
        body: SafeArea(
          child: IndexedStack(
            index: selectedIndex,
            children: [buildHomePage(), buildHistoryPage(), buildProfilePage()],
          ),
        ),

        // =========================
        // BOTTOM NAVIGATION
        // =========================
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: c.surface,
            border: Border(top: BorderSide(color: c.border)),
          ),
          child: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history_rounded),
                label: 'History',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HOME PAGE
  // ============================================================

  Widget buildHomePage() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          const SizedBox(height: 26),
          buildGreeting(),
          const SizedBox(height: 22),
          buildAttendanceCard(),
          const SizedBox(height: 22),
          MapsWidget(),
          const SizedBox(height: 28),
          buildMonthlyAttendance(),
          const SizedBox(height: 28),
          buildRecentRecords(),
        ],
      ),
    );
  }

  // ============================================================
  // SMALL HELPERS
  // ============================================================

  Widget _buildSectionTitle(String title, {Widget? trailing}) {
    final c = context.colors;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: c.text,
            ),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildIconButton({
    required Widget child,
    required VoidCallback onPressed,
    bool showDot = false,
  }) {
    final c = context.colors;

    return Material(
      color: c.surface,
      shape: CircleBorder(side: BorderSide(color: c.border)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Stack(
            alignment: Alignment.center,
            children: [
              child,
              if (showDot)
                Positioned(
                  top: 10,
                  right: 11,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: c.danger,
                      shape: BoxShape.circle,
                      border: Border.all(color: c.surface, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecorCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget buildHeader() {
    final c = context.colors;
    final isDark = context.isDark;

    return Row(
      children: [
        // Logo kecil aplikasi.
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B7BF2), Color(0xFF1557D6)],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1557D6).withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.access_time_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),

        const SizedBox(width: 12),

        // Nama aplikasi.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TimyAttend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: c.text,
                ),
              ),
              Text(
                'Attendance Portal',
                style: TextStyle(fontSize: 11, color: c.textMuted),
              ),
            ],
          ),
        ),

        // Tombol ganti tema (light / dark).
        _buildIconButton(
          onPressed: () {
            ref
                .read(themeModeProvider.notifier)
                .toggle(Theme.of(context).brightness);
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, animation) {
              return RotationTransition(
                turns: Tween<double>(begin: 0.75, end: 1.0).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              key: ValueKey<bool>(isDark),
              color: c.text,
              size: 21,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Tombol notifikasi.
        _buildIconButton(
          onPressed: () {},
          showDot: true,
          child: Icon(
            Icons.notifications_none_rounded,
            color: c.text,
            size: 22,
          ),
        ),

        const SizedBox(width: 8),

        // Avatar user.
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF60A5FA), Color(0xFF1557D6)],
            ),
          ),
          child: CircleAvatar(
            radius: 19,
            backgroundColor: c.primarySoft,
            child: Icon(Icons.person_rounded, color: c.primary),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // GREETING
  // ============================================================

  Widget buildGreeting() {
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${getGreeting()}, $userName 👋',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: c.text,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today_rounded, size: 13, color: c.primary),
              const SizedBox(width: 6),
              Text(
                getCurrentDate(),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: c.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ATTENDANCE CARD
  // ============================================================

  Widget buildAttendanceCard() {
    final c = context.colors;
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c.heroStart, c.heroEnd],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: c.heroEnd.withValues(alpha: isDark ? 0.55 : 0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Dekorasi lingkaran.
            Positioned(top: -40, right: -30, child: _buildDecorCircle(150, 0.08)),
            Positioned(
              bottom: -60,
              left: -40,
              child: _buildDecorCircle(170, 0.06),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header card.
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Today's Attendance",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.1,
                            color: Colors.white70,
                          ),
                        ),
                      ),

                      buildStatusBadge(),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Jam digital.
                  buildLiveClock(),

                  const SizedBox(height: 20),

                  // Check-in dan check-out.
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: buildTimeItem(
                            title: 'Check-in',
                            time: isCheckedIn
                                ? (checkInTime ?? '--:--')
                                : '--:--',
                            icon: Icons.login_rounded,
                          ),
                        ),

                        Container(
                          width: 1,
                          height: 58,
                          color: Colors.white.withValues(alpha: 0.25),
                        ),

                        Expanded(
                          child: buildTimeItem(
                            title: 'Check-out',
                            time: isCheckedOut
                                ? (checkOutTime ?? '--:--')
                                : '--:--',
                            icon: Icons.logout_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Tombol utama.
                  buildAttendanceButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LIVE CLOCK
  // ============================================================

  Widget buildLiveClock() {
    String two(int v) => v.toString().padLeft(2, '0');

    return StreamBuilder<DateTime>(
      stream: _clock,
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        final t = snapshot.data ?? DateTime.now();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '${two(t.hour)}:${two(t.minute)}',
              style: const TextStyle(
                fontSize: 46,
                height: 1,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
                color: Colors.white,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              two(t.second),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.6),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget buildStatusBadge() {
    String status;

    Color backgroundColor;

    Color textColor;

    if (isCheckedOut) {
      status = 'Completed';
      backgroundColor = const Color(0xFFE8F8EE);
      textColor = const Color(0xFF15803D);
    } else if (isCheckedIn) {
      status = 'Checked-in';
      backgroundColor = const Color(0xFFE8F8EE);
      textColor = const Color(0xFF15803D);
    } else {
      status = 'Not Checked-in';
      backgroundColor = const Color(0xFFFFF4E5);
      textColor = const Color(0xFFB45309);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
          ),

          const SizedBox(width: 6),

          Text(
            status,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TIME ITEM
  // ============================================================

  Widget buildTimeItem({
    required String title,
    required String time,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Colors.white.withValues(alpha: 0.85)),

          const SizedBox(height: 7),

          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            time,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ATTENDANCE BUTTON
  // ============================================================

  Widget buildAttendanceButton() {
    String buttonText;
    IconData buttonIcon;
    bool buttonEnabled = true;

    if (isCheckedOut) {
      buttonText = 'Attendance Completed';
      buttonIcon = Icons.check_circle_outline;
      buttonEnabled = false;
    } else if (isCheckedIn) {
      buttonText = 'Check Out';
      buttonIcon = Icons.logout_rounded;
    } else {
      buttonText = 'Check In';
      buttonIcon = Icons.login_rounded;
    }

    //snackbar checkin
    ref.listen(checkInUserProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          if (response == null) return;
          ref.invalidate(historyAbsenProvider);

          final now = DateTime.now();

          setState(() {
            isCheckedIn = true;
            checkInTime =
                '${now.hour.toString().padLeft(2, '0')}:'
                '${now.minute.toString().padLeft(2, '0')}';
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Check In berhasil!')));
        },
        error: (error, _) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Check In gagal!')));
        },
      );
    });

    //snackbar checkout
    ref.listen(checkOutUserProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          if (response == null) return;
          ref.invalidate(historyAbsenProvider);
          if (context.mounted) {
            Navigator.of(context).maybePop();
          }
          final now = DateTime.now();

          setState(() {
            isCheckedOut = true;
            checkOutTime =
                '${now.hour.toString().padLeft(2, '0')}:'
                '${now.minute.toString().padLeft(2, '0')}';
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Check Out berhasil!')));
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check Out gagal. Silakan coba lagi.'),
            ),
          );
        },
      );
    });

    // Hero card selalu berwarna biru gelap (light & dark),
    // jadi tombolnya memakai warna tetap.
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1557D6),
          disabledBackgroundColor: Colors.white.withValues(alpha: 0.25),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.85),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        onPressed: buttonEnabled
            ? () async {
                if (!isCheckedIn) {
                  if (!mounted) return;

                  try {
                    final Position coordinate = await MapsService()
                        .getCurrentLocation();
                    final String address = await MapsService()
                        .getAddressFromCoordinates(
                          coordinate.latitude,
                          coordinate.longitude,
                        );

                    final checkInRequest = CheckInRequestModel(
                      checkInLat: '${coordinate.latitude}',
                      checkInLng: '${coordinate.longitude}',
                      status: 'masuk',
                      checkInAddress: address,
                    );

                    //request checkin
                    await ref
                        .read(checkInUserProvider.notifier)
                        .checkIn(checkInRequest);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Check In gagal. Silakan coba lagi.'),
                      ),
                    );
                  }
                } else {
                  if (!mounted) return;
                  try {
                    final Position coordinate = await MapsService()
                        .getCurrentLocation();
                    final String address = await MapsService()
                        .getAddressFromCoordinates(
                          coordinate.latitude,
                          coordinate.longitude,
                        );

                    final checkOutRequest = CheckOutRequestModel(
                      checkOutLocation:
                          '${coordinate.latitude}, ${coordinate.longitude}',
                      checkOutAddress: address,
                      checkOutLat: '${coordinate.latitude}',
                      checkOutLng: '${coordinate.longitude}',
                    );
                    //post checkout
                    await ref
                        .read(checkOutUserProvider.notifier)
                        .checkOut(checkOutRequest);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gagal mendapatkan lokasi')),
                    );
                  }
                }
              }
            : null,
        icon: Icon(buttonIcon),
        label: Text(buttonText),
      ),
    );
  }

  // ============================================================
  // LOCATION CARD
  // ============================================================

  Widget buildLocationCard() {
    final c = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(
            color: c.primary.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            'Current Location',
            trailing: TextButton.icon(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: c.primary,
                backgroundColor: c.primarySoft,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: const Size(0, 34),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text(
                'Refresh',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // =========================
          // MAP PLACEHOLDER
          // =========================
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 170,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [c.primarySoft, c.surfaceAlt],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background garis sederhana
                  // untuk memberikan kesan map.
                  CustomPaint(
                    size: const Size(double.infinity, double.infinity),
                    painter: MapPlaceholderPainter(lineColor: c.border),
                  ),

                  // Marker lokasi.
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: c.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: c.primary.withValues(alpha: 0.3),
                          blurRadius: 14,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),

                  // Label lokasi.
                  Positioned(
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: c.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Your current location',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: c.text,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Koordinat.
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: c.primarySoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: c.primary,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Lat:    •   Long: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: c.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MONTHLY ATTENDANCE
  // ============================================================

  Widget buildMonthlyAttendance() {
    final c = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Monthly Attendance',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: c.primarySoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              getCurrentMonth(),
              style: TextStyle(
                fontSize: 12,
                color: c.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: buildStatisticCard(
                title: 'Attendance',
                value: '96%',
                subtitle: 'Attendance rate',
                icon: Icons.percent_rounded,
                color: c.primary,
                softColor: c.primarySoft,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: buildStatisticCard(
                title: 'Present',
                value: '18',
                subtitle: 'Days',
                icon: Icons.check_circle_outline_rounded,
                color: c.success,
                softColor: c.successSoft,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: buildStatisticCard(
                title: 'Absent',
                value: '0',
                subtitle: 'Days',
                icon: Icons.event_busy_outlined,
                color: c.danger,
                softColor: c.dangerSoft,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // STATISTIC CARD
  // ============================================================

  Widget buildStatisticCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color softColor,
  }) {
    final c = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: softColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, size: 18, color: color),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: c.textMuted,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: c.text,
            ),
          ),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: c.textFaint),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECENT RECORDS
  // ============================================================

  Widget buildRecentRecords() {
    final c = context.colors;

    final List<Map<String, String>> records = [
      {
        'day': 'Today',
        'date': 'Sep 25',
        'time': '08:30 AM - 05:00 PM',
        'status': 'Present',
      },
      {
        'day': 'Wednesday',
        'date': 'Sep 24',
        'time': '08:28 AM - 05:02 PM',
        'status': 'Present',
      },
      {
        'day': 'Tuesday',
        'date': 'Sep 23',
        'time': '08:35 AM - 05:00 PM',
        'status': 'Present',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Recent Records',
          trailing: TextButton(
            onPressed: () {
              setState(() {
                selectedIndex = 1;
              });
            },
            style: TextButton.styleFrom(foregroundColor: c.primary),
            child: const Text(
              'View All',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ),

        const SizedBox(height: 6),

        Column(
          children: records.map((record) {
            return buildRecordItem(record);
          }).toList(),
        ),
      ],
    );
  }

  // ============================================================
  // RECORD ITEM
  // ============================================================

  Widget buildRecordItem(Map<String, String> record) {
    final c = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: c.successSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.check_rounded, size: 22, color: c.success),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record['day']}, ${record['date']}',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: c.text,
                  ),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 12, color: c.textFaint),
                    const SizedBox(width: 4),
                    Text(
                      record['time']!,
                      style: TextStyle(fontSize: 11.5, color: c.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: c.successSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              record['status']!,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: c.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HISTORY PAGE
  // ============================================================
  Widget buildHistoryPage() {
    return const HistoryScreen();
  }

  // ============================================================
  // PROFILE PAGE
  // ============================================================

  Widget buildProfilePage() {
    return const ProfileScreen();
  }

  // ============================================================
  // GREETING TEXT
  // ============================================================

  String getGreeting() {
    final int hour = DateTime.now().hour;

    if (hour < 11) return 'Good morning';
    if (hour < 15) return 'Good afternoon';
    if (hour < 19) return 'Good evening';
    return 'Good night';
  }

  // ============================================================
  // DATE
  // ============================================================

  String getCurrentDate() {
    final DateTime now = DateTime.now();

    const List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${days[now.weekday - 1]}, '
        '${months[now.month - 1]} '
        '${now.day}, ${now.year}';
  }

  // ============================================================
  // MONTH
  // ============================================================

  String getCurrentMonth() {
    const List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final DateTime now = DateTime.now();

    return months[now.month - 1];
  }
}

// ============================================================
// MAP PLACEHOLDER PAINTER
// ============================================================
//
// Ini hanya visual sementara.
//
// Nanti akan kita ganti dengan Google Maps
// menggunakan latitude dan longitude sebenarnya.

class MapPlaceholderPainter extends CustomPainter {
  const MapPlaceholderPainter({required this.lineColor});

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Garis horizontal.
    for (double y = 20; y < size.height; y += 35) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Garis vertikal.
    for (double x = 20; x < size.width; x += 45) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant MapPlaceholderPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor;
  }
}