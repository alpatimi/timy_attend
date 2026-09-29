import 'package:flutter/material.dart';
import 'package:timy_attend/screens/history/history_screen.dart';
import 'package:timy_attend/services/attendance_service.dart';

import '../profile/profile_screen.dart';
import '../../services/attendance_service.dart';

import 'package:geolocator/geolocator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AttendanceService attendanceService = AttendanceService();
  // Menyimpan index menu yang sedang dipilih.
  int selectedIndex = 0;

  // Menentukan apakah user sudah melakukan check-in.
  bool isCheckedIn = false;

  // Menentukan apakah user sudah melakukan check-out.
  bool isCheckedOut = false;

  // Nama user sementara.
  //
  // Nanti akan berasal dari response API profile/login.
  final String userName = 'Timi';

  String? checkInTime;
  String? checkOutTime;

  // Latitude sementara.
  final String latitude = '-6.175392';

  // Longitude sementara.
  final String longitude = '106.824964';
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;

    // Cek apakah GPS/lokasi HP aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (!mounted) return null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan aktifkan lokasi/GPS terlebih dahulu.'),
        ),
      );

      return null;
    }

    // Cek permission lokasi
    LocationPermission permission = await Geolocator.checkPermission();

    // Kalau belum diberikan, minta permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        if (!mounted) return null;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Izin lokasi ditolak.')));

        return null;
      }
    }

    // Kalau ditolak permanen
    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Izin lokasi ditolak permanen. Silakan aktifkan dari Settings.',
          ),
        ),
      );

      return null;
    }

    // Ambil lokasi GPS
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HOME PAGE
  // ============================================================

  Widget buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),

          const SizedBox(height: 24),

          buildGreeting(),

          const SizedBox(height: 20),

          buildAttendanceCard(),

          const SizedBox(height: 20),

          buildLocationCard(),

          const SizedBox(height: 20),

          buildMonthlyAttendance(),

          const SizedBox(height: 20),

          buildRecentRecords(),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget buildHeader() {
    return Row(
      children: [
        // Logo kecil aplikasi.
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.access_time_rounded,
            color: Color(0xFF1557D6),
            size: 25,
          ),
        ),

        const SizedBox(width: 10),

        // Nama aplikasi.
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TimyAttend',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),
              Text(
                'Attendance Portal',
                style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),

        // Tombol notifikasi.
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF172033),
          ),
        ),

        // Avatar user.
        CircleAvatar(
          radius: 19,
          backgroundColor: const Color(0xFFEAF0FF),
          child: const Icon(Icons.person, color: Color(0xFF1557D6)),
        ),
      ],
    );
  }

  // ============================================================
  // GREETING
  // ============================================================

  Widget buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning, $userName 👋',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172033),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          getCurrentDate(),
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  // ============================================================
  // ATTENDANCE CARD
  // ============================================================

  Widget buildAttendanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172033),
                  ),
                ),
              ),

              buildStatusBadge(),
            ],
          ),

          const SizedBox(height: 18),

          // Check-in dan check-out.
          Row(
            children: [
              Expanded(
                child: buildTimeItem(
                  title: 'Check-in',
                  time: isCheckedIn ? (checkInTime ?? '--:--') : '--:--',
                  icon: Icons.login_rounded,
                ),
              ),

              Container(width: 1, height: 55, color: const Color(0xFFE5E7EB)),

              Expanded(
                child: buildTimeItem(
                  title: 'Check-out',
                  time: isCheckedOut ? (checkOutTime ?? '--:--') : '--:--',
                  icon: Icons.logout_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Tombol utama.
          buildAttendanceButton(),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
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
              fontSize: 11,
              fontWeight: FontWeight.w600,
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
          Icon(icon, size: 19, color: const Color(0xFF1557D6)),

          const SizedBox(height: 7),

          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
          ),

          const SizedBox(height: 3),

          Text(
            time,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
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

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: buttonEnabled
            ? () async {
                if (!isCheckedIn) {
                  print('CHECK IN DITEKAN');
                  final position = await getCurrentLocation();

                  if (position == null) {
                    return;
                  }

                  final success = await attendanceService.checkIn(
                    latitude: position.latitude.toString(),
                    longitude: position.longitude.toString(),
                    address: 'Lokasi GPS',
                  );

                  if (!mounted) return;

                  if (success) {
                    final now = DateTime.now();

                    setState(() {
                      isCheckedIn = true;
                      checkInTime =
                          '${now.hour.toString().padLeft(2, '0')}:'
                          '${now.minute.toString().padLeft(2, '0')}';
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Check In berhasil!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Check In gagal. Silakan coba lagi.'),
                      ),
                    );
                  }
                } else {
                  final success = await attendanceService.checkOut(
                    latitude: latitude,
                    longitude: longitude,
                    address: 'Jakarta',
                  );

                  if (!mounted) return;

                  if (success) {
                    final now = DateTime.now();

                    setState(() {
                      isCheckedOut = true;
                      checkOutTime =
                          '${now.hour.toString().padLeft(2, '0')}:'
                          '${now.minute.toString().padLeft(2, '0')}';
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Check Out berhasil!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Check Out gagal. Silakan coba lagi.'),
                      ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Current Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172033),
                  ),
                ),
              ),

              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =========================
          // MAP PLACEHOLDER
          // =========================
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0F8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background garis sederhana
                // untuk memberikan kesan map.
                CustomPaint(
                  size: const Size(double.infinity, double.infinity),
                  painter: MapPlaceholderPainter(),
                ),

                // Marker lokasi.
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1557D6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1557D6).withValues(alpha: 0.25),
                        blurRadius: 12,
                        spreadRadius: 5,
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
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Your current location',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF172033),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Koordinat.
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 17,
                color: Color(0xFF1557D6),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  'Lat: $latitude   •   Long: $longitude',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Monthly Attendance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),
            ),

            Text(
              getCurrentMonth(),
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF1557D6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: buildStatisticCard(
                title: 'Attendance',
                value: '96%',
                subtitle: 'Attendance rate',
                icon: Icons.percent,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: buildStatisticCard(
                title: 'Present',
                value: '18',
                subtitle: 'Days',
                icon: Icons.check_circle_outline,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: buildStatisticCard(
                title: 'Absent',
                value: '0',
                subtitle: 'Days',
                icon: Icons.event_busy_outlined,
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
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1557D6)),

          const SizedBox(height: 7),

          Text(
            title,
            style: const TextStyle(fontSize: 9, color: Color(0xFF6B7280)),
          ),

          const SizedBox(height: 2),

          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),

          Text(
            subtitle,
            style: const TextStyle(fontSize: 8, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECENT RECORDS
  // ============================================================

  Widget buildRecentRecords() {
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
        Row(
          children: [
            const Expanded(
              child: Text(
                'Recent Records',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172033),
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
              child: const Text('View All', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: records.map((record) {
              return buildRecordItem(record);
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RECORD ITEM
  // ============================================================

  Widget buildRecordItem(Map<String, String> record) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F8EE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 18, color: Color(0xFF16A34A)),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record['day']}, ${record['date']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF172033),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  record['time']!,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              record['status']!,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Color(0xFF15803D),
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
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFD7E0EA)
      ..strokeWidth = 2
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
