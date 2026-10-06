import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timy_attend/controllers/history_absen.dart';
import 'package:timy_attend/core/theme/app_theme.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final historyAsync = ref.watch(historyAbsenProvider);

    return Container(
      color: c.bg,
      child: historyAsync.when(
        // =========================
        // LOADING
        // =========================
        loading: () => Center(
          child: CircularProgressIndicator(color: c.primary, strokeWidth: 3),
        ),

        // =========================
        // ERROR
        // =========================
        error: (error, stackTrace) => _buildError(c, ref, error),

        // =========================
        // DATA
        // =========================
        data: (response) {
          final history = response?.data ?? [];

          return RefreshIndicator(
            color: c.primary,
            backgroundColor: c.surface,
            onRefresh: () async {
              await ref.read(historyAbsenProvider.notifier).refresh();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(c, history)),
                if (history.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmpty(c),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    sliver: SliverList.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return buildHistoryCard(c, history[index]);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // HEADER + SUMMARY
  // ============================================================

  Widget _buildHeader(AppColors c, List<dynamic> history) {
    final presentCount = history.where((e) => e.status == 'masuk').length;
    final permissionCount = history.where((e) => e.status == 'izin').length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance History',
            style: TextStyle(
              color: c.text,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Riwayat kehadiran kamu',
            style: TextStyle(color: c.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _buildSummaryTile(
                c,
                label: 'Total',
                value: history.length.toString(),
                icon: Icons.event_note_rounded,
                color: c.primary,
                soft: c.primarySoft,
              ),
              const SizedBox(width: 10),
              _buildSummaryTile(
                c,
                label: 'Present',
                value: presentCount.toString(),
                icon: Icons.check_circle_rounded,
                color: c.success,
                soft: c.successSoft,
              ),
              const SizedBox(width: 10),
              _buildSummaryTile(
                c,
                label: 'Permission',
                value: permissionCount.toString(),
                icon: Icons.assignment_late_rounded,
                color: c.warning,
                soft: c.warningSoft,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTile(
    AppColors c, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required Color soft,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: soft,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: c.text,
              ),
            ),
            Text(label, style: TextStyle(fontSize: 11, color: c.textMuted)),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STATES
  // ============================================================

  Widget _buildEmpty(AppColors c) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: c.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history_rounded, size: 44, color: c.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada riwayat absensi.',
            style: TextStyle(
              color: c.text,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tarik ke bawah untuk memuat ulang.',
            style: TextStyle(color: c.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildError(AppColors c, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: c.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: c.dangerSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 36,
                  color: c.danger,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Gagal memuat riwayat absensi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: c.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: c.textMuted),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: c.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    ref.read(historyAbsenProvider.notifier).refresh();
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Coba Lagi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HISTORY CARD
  // ============================================================

  Widget buildHistoryCard(AppColors c, dynamic item) {
    final statusStyle = _statusStyle(c, item.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(
            color: statusStyle.color.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Garis aksen sesuai status.
            Container(width: 5, color: statusStyle.color),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =========================
                    // DATE + STATUS
                    // =========================
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 15,
                          color: c.textMuted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            formatDate(item.createdAt),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: c.text,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: statusStyle.soft,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusStyle.icon,
                                size: 12,
                                color: statusStyle.color,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                formatStatus(item.status),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: statusStyle.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // =========================
                    // CHECK IN / CHECK OUT
                    // =========================
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildTime(
                              c,
                              title: 'Check-in',
                              value: formatTime(item.checkIn),
                              icon: Icons.login_rounded,
                              iconColor: c.success,
                            ),
                          ),
                          Container(width: 1, height: 32, color: c.border),
                          Expanded(
                            child: buildTime(
                              c,
                              title: 'Check-out',
                              value: formatTime(item.checkOut),
                              icon: Icons.logout_rounded,
                              iconColor: c.danger,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // =========================
                    // LOCATION
                    // =========================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: c.primarySoft,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: c.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              item.checkInAddress ?? '-',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: c.textMuted,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
  // TIME
  // ============================================================

  Widget buildTime(
    AppColors c, {
    required String title,
    required String value,
    IconData? icon,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: iconColor ?? c.textMuted),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 11, color: c.textMuted)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: c.text,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS STYLE
  // ============================================================

  ({Color color, Color soft, IconData icon}) _statusStyle(
    AppColors c,
    String? status,
  ) {
    switch (status) {
      case 'masuk':
        return (
          color: c.success,
          soft: c.successSoft,
          icon: Icons.check_circle_rounded,
        );
      case 'izin':
        return (
          color: c.warning,
          soft: c.warningSoft,
          icon: Icons.assignment_late_rounded,
        );
      default:
        return (
          color: c.textMuted,
          soft: c.surfaceAlt,
          icon: Icons.info_rounded,
        );
    }
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String formatDate(DateTime? date) {
    if (date == null) {
      return '-';
    }

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

    return '${date.day.toString().padLeft(2, '0')} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================

  String formatTime(dynamic dateTime) {
    if (dateTime == null) {
      return '--:--';
    }

    final date = DateTime.tryParse(dateTime.toString());

    if (date == null) {
      return '--:--';
    }

    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  // ============================================================
  // FORMAT STATUS
  // ============================================================

  String formatStatus(String? status) {
    if (status == null || status.isEmpty) {
      return '-';
    }

    if (status == 'masuk') {
      return 'Present';
    }

    if (status == 'izin') {
      return 'Permission';
    }

    return status;
  }
}