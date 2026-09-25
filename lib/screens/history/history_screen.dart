import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Filter bulan yang sedang dipilih.
  String selectedMonth = 'September 2026';

  // Data sementara untuk tampilan history.
  //
  // Nanti data ini akan berasal dari API.
  final List<Map<String, String>> attendanceHistory = [
    {
      'date': '25 Sep 2026',
      'day': 'Friday',
      'checkIn': '08:30 AM',
      'checkOut': '05:00 PM',
      'location': 'Jakarta',
      'status': 'Present',
    },
    {
      'date': '24 Sep 2026',
      'day': 'Thursday',
      'checkIn': '08:28 AM',
      'checkOut': '05:02 PM',
      'location': 'Jakarta',
      'status': 'Present',
    },
    {
      'date': '23 Sep 2026',
      'day': 'Wednesday',
      'checkIn': '08:35 AM',
      'checkOut': '05:00 PM',
      'location': 'Jakarta',
      'status': 'Present',
    },
    {
      'date': '22 Sep 2026',
      'day': 'Tuesday',
      'checkIn': '08:32 AM',
      'checkOut': '05:04 PM',
      'location': 'Jakarta',
      'status': 'Present',
    },
    {
      'date': '21 Sep 2026',
      'day': 'Monday',
      'checkIn': '08:41 AM',
      'checkOut': '05:00 PM',
      'location': 'Jakarta',
      'status': 'Present',
    },
    {
      'date': '18 Sep 2026',
      'day': 'Friday',
      'checkIn': '08:25 AM',
      'checkOut': '05:01 PM',
      'location': 'Jakarta',
      'status': 'Present',
    },
    {
      'date': '17 Sep 2026',
      'day': 'Thursday',
      'checkIn': '08:30 AM',
      'checkOut': '05:00 PM',
      'location': 'Jakarta',
      'status': 'Present',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header halaman.
            buildHeader(),

            // Isi history.
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSummary(),

                    const SizedBox(height: 20),

                    buildMonthFilter(),

                    const SizedBox(height: 20),

                    buildHistoryList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        8,
      ),
      child: Row(
        children: [
          // Icon history.
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0FF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.history_rounded,
              color: Color(0xFF1557D6),
              size: 25,
            ),
          ),

          const SizedBox(width: 12),

          // Judul.
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172033),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Review your attendance records',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          // Tombol filter.
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.tune_rounded,
              color: Color(0xFF172033),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  Widget buildSummary() {
    return Row(
      children: [
        Expanded(
          child: buildSummaryCard(
            title: 'Present',
            value: '18',
            icon: Icons.check_circle_outline,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: buildSummaryCard(
            title: 'Absent',
            value: '0',
            icon: Icons.cancel_outlined,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: buildSummaryCard(
            title: 'Rate',
            value: '96%',
            icon: Icons.percent_rounded,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SUMMARY CARD
  // ============================================================

  Widget buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ),
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
          Icon(
            icon,
            size: 19,
            color: const Color(0xFF1557D6),
          ),

          const SizedBox(height: 7),

          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),

          const SizedBox(height: 2),

          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MONTH FILTER
  // ============================================================

  Widget buildMonthFilter() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Attendance Records',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedMonth,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
              ),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF172033),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'September 2026',
                  child: Text('Sep 2026'),
                ),
                DropdownMenuItem(
                  value: 'August 2026',
                  child: Text('Aug 2026'),
                ),
                DropdownMenuItem(
                  value: 'July 2026',
                  child: Text('Jul 2026'),
                ),
              ],
              onChanged: (String? value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  selectedMonth = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HISTORY LIST
  // ============================================================

  Widget buildHistoryList() {
    if (attendanceHistory.isEmpty) {
      return buildEmptyState();
    }

    return Column(
      children: attendanceHistory.map((attendance) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 12,
          ),
          child: buildAttendanceItem(attendance),
        );
      }).toList(),
    );
  }

  // ============================================================
  // ATTENDANCE ITEM
  // ============================================================

  Widget buildAttendanceItem(
    Map<String, String> attendance,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
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
          // =========================
          // DATE + STATUS
          // =========================
          Row(
            children: [
              // Icon tanggal.
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F8EE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF16A34A),
                  size: 22,
                ),
              ),

              const SizedBox(width: 11),

              // Tanggal.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attendance['day']!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      attendance['date']!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              // Status.
              buildStatusBadge(
                attendance['status']!,
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Garis pemisah.
          const Divider(
            height: 1,
            color: Color(0xFFE5E7EB),
          ),

          const SizedBox(height: 14),

          // =========================
          // CHECK IN / CHECK OUT
          // =========================
          Row(
            children: [
              Expanded(
                child: buildTimeDetail(
                  icon: Icons.login_rounded,
                  title: 'Check-in',
                  value: attendance['checkIn']!,
                ),
              ),

              Container(
                width: 1,
                height: 42,
                color: const Color(0xFFE5E7EB),
              ),

              Expanded(
                child: buildTimeDetail(
                  icon: Icons.logout_rounded,
                  title: 'Check-out',
                  value: attendance['checkOut']!,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =========================
          // LOCATION
          // =========================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8FC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 17,
                  color: Color(0xFF1557D6),
                ),

                const SizedBox(width: 7),

                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    attendance['location']!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF172033),
                    ),
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
  // TIME DETAIL
  // ============================================================

  Widget buildTimeDetail({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        const SizedBox(width: 4),

        Icon(
          icon,
          size: 18,
          color: Color(0xFF1557D6),
        ),

        const SizedBox(width: 8),

        Column(
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
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172033),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8EE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF16A34A),
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 5),

          Text(
            status,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFF15803D),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 50,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 48,
            color: Color(0xFF9CA3AF),
          ),

          SizedBox(height: 14),

          Text(
            'No attendance records',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),

          SizedBox(height: 5),

          Text(
            'Your attendance history will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}