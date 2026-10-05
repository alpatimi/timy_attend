import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {

  bool isLoading = true;

  // Filter bulan yang sedang dipilih.
  String selectedMonth = 'Oktober 2026';

  // Data history dari API.
  List<Map<String, String>> attendanceHistory = [];

  // @override
  // void initState() {
  //   super.initState();
    // loadHistory();
  // }

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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
  // LOAD HISTORY DARI API
  // ============================================================

  // Future<void> loadHistory() async {
  //   final data = await historyService.getHistory(
  //     start: '2026-10-01',
  //     end: '2026-10-31',
  //   );

  //   final formattedData = data.map((item) {
  //     final checkIn = item['check_in']?.toString() ?? '';
  //     final checkOut = item['check_out']?.toString() ?? '';

  //     return <String, String>{
  //       'date': formatDate(checkIn),
  //       'day': getDay(checkIn),
  //       'checkIn': formatTime(checkIn),
  //       'checkOut': formatTime(checkOut),
  //       'location': item['check_in_address']?.toString() ?? '-',
  //       'status': formatStatus(item['status']?.toString() ?? ''),
  //     };
  //   }).toList();

  //   if (!mounted) return;

  //   setState(() {
  //     attendanceHistory = formattedData;
  //     isLoading = false;
  //   });
  // }



  // ============================================================
  // FORMAT TANGGAL
  // ============================================================

  String formatDate(String dateTime) {
    if (dateTime.isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(dateTime);

    if (date == null) {
      return '-';
    }

    return '${date.day.toString().padLeft(2, '0')} '
        '${monthName(date.month)} ${date.year}';
  }

  // ============================================================
  // NAMA BULAN
  // ============================================================

  String monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  // ============================================================
  // NAMA HARI
  // ============================================================

  String getDay(String dateTime) {
    if (dateTime.isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(dateTime);

    if (date == null) {
      return '-';
    }

    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[date.weekday - 1];
  }

  // ============================================================
  // FORMAT JAM
  // ============================================================

  String formatTime(String dateTime) {
    if (dateTime.isEmpty) {
      return '--:--';
    }

    final date = DateTime.tryParse(dateTime);

    if (date == null) {
      return '--:--';
    }

    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // FORMAT STATUS
  // ============================================================

  String formatStatus(String status) {
    if (status == 'masuk') {
      return 'Present';
    }

    if (status == 'izin') {
      return 'Permission';
    }

    return status;
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Row(
        children: [
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
                  style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune_rounded, color: Color(0xFF172033)),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
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
          Icon(icon, size: 19, color: const Color(0xFF1557D6)),
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
            style: const TextStyle(fontSize: 9, color: Color(0xFF6B7280)),
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedMonth,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: const [
                DropdownMenuItem<String>(
                  value: 'Oktober 2026',
                  child: Text('Okt 2026'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedMonth = value;
                  });
                }
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
    // Saat data sedang diambil dari API.
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Kalau API tidak mengembalikan data.
    if (attendanceHistory.isEmpty) {
      return buildEmptyState();
    }

    return Column(
      children: attendanceHistory.map((attendance) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: buildAttendanceItem(attendance),
        );
      }).toList(),
    );
  }

  // ============================================================
  // ATTENDANCE ITEM
  // ============================================================

  Widget buildAttendanceItem(Map<String, String> attendance) {
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
          // DATE + STATUS
          Row(
            children: [
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

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attendance['day'] ?? '-',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      attendance['date'] ?? '-',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              buildStatusBadge(attendance['status'] ?? '-'),
            ],
          ),

          const SizedBox(height: 15),

          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          const SizedBox(height: 14),

          // CHECK IN / CHECK OUT
          Row(
            children: [
              Expanded(
                child: buildTimeDetail(
                  icon: Icons.login_rounded,
                  title: 'Check-in',
                  value: attendance['checkIn'] ?? '--:--',
                ),
              ),
              Container(width: 1, height: 42, color: const Color(0xFFE5E7EB)),
              Expanded(
                child: buildTimeDetail(
                  icon: Icons.logout_rounded,
                  title: 'Check-out',
                  value: attendance['checkOut'] ?? '--:--',
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // LOCATION
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
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
                  style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    attendance['location'] ?? '-',
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
        Icon(icon, size: 18, color: const Color(0xFF1557D6)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
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
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Column(
        children: [
          Icon(Icons.event_busy_outlined, size: 48, color: Color(0xFF9CA3AF)),
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
            style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}
