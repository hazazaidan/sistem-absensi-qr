import 'package:flutter/material.dart';
import '../../layouts/web_layout.dart';
import '../../models/absensi_model.dart';
import '../../themes/app_theme.dart';
import '../../widgets/status_badge.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _search = '';

  List<AbsensiModel> get _filtered => dummyAbsensi
      .where((a) =>
          a.nama.toLowerCase().contains(_search.toLowerCase()) ||
          a.nis.contains(_search))
      .toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WebLayout(
      currentRoute: '/dashboard',
      title: 'Selamat Datang, Siswa!',
      subtitle: 'Pantau kehadiran dan aktivitasmu di sini.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  children: [
                    Expanded(child: _buildStatCard(
                      icon: Icons.calendar_today_rounded,
                      title: 'Status Hari Ini',
                      value: 'Hadir',
                      subtitle: '07:15 WIB',
                      iconColor: AppTheme.primaryColor,
                      iconBg: AppTheme.primaryColor.withOpacity(0.1),
                      valueColor: AppTheme.primaryColor,
                      isDark: isDark,
                    )),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard(
                      icon: Icons.check_circle_rounded,
                      title: 'Total Hadir',
                      value: '20 Hari',
                      subtitle: '85%',
                      iconColor: AppTheme.accentColor,
                      iconBg: AppTheme.accentColor.withOpacity(0.1),
                      valueColor: AppTheme.accentColor,
                      isDark: isDark,
                    )),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatCard(
                      icon: Icons.info_rounded,
                      title: 'Total Izin',
                      value: '2 Hari',
                      subtitle: '8%',
                      iconColor: AppTheme.warningColor,
                      iconBg: AppTheme.warningColor.withOpacity(0.1),
                      valueColor: AppTheme.warningColor,
                      isDark: isDark,
                    )),
                  ],
                );
              }
              return Column(
                children: [
                  _buildStatCard(
                    icon: Icons.calendar_today_rounded,
                    title: 'Status Hari Ini',
                    value: 'Hadir',
                    subtitle: '07:15 WIB',
                    iconColor: AppTheme.primaryColor,
                    iconBg: AppTheme.primaryColor.withOpacity(0.1),
                    valueColor: AppTheme.primaryColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    icon: Icons.check_circle_rounded,
                    title: 'Total Hadir',
                    value: '20 Hari',
                    subtitle: '85%',
                    iconColor: AppTheme.accentColor,
                    iconBg: AppTheme.accentColor.withOpacity(0.1),
                    valueColor: AppTheme.accentColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildStatCard(
                    icon: Icons.info_rounded,
                    title: 'Total Izin',
                    value: '2 Hari',
                    subtitle: '8%',
                    iconColor: AppTheme.warningColor,
                    iconBg: AppTheme.warningColor.withOpacity(0.1),
                    valueColor: AppTheme.warningColor,
                    isDark: isDark,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // Absensi table card
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Absen Siswa',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Daftar siswa yang absen hari ini.',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search + Refresh row
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF252540) : const Color(0xFFF8F8FC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isDark ? const Color(0xFF353560) : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Icon(Icons.search_rounded, size: 18, color: Colors.grey.shade400),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  onChanged: (v) => setState(() => _search = v),
                                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                                  decoration: const InputDecoration(
                                    hintText: 'Cari siswa...',
                                    hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () => setState(() => _search = ''),
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text(
                          'Refresh',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

                // Table
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: _buildTable(isDark),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color iconColor,
    required Color iconBg,
    required Color valueColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTable(bool isDark) {
    final headerColor = isDark ? const Color(0xFF252540) : const Color(0xFFF8F8FC);
    final headerText = isDark ? Colors.white60 : Colors.grey.shade500;
    final rowText = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final divider = isDark ? const Color(0xFF252540) : const Color(0xFFF0F0F8);

    const headers = ['No.', 'NIS', 'Nama Siswa', 'Status', 'Jam Masuk', 'Jam Pulang', 'Keterangan'];
    const widths = [60.0, 100.0, 180.0, 100.0, 110.0, 110.0, 180.0];

    return Column(
      children: [
        // Header
        Container(
          color: headerColor,
          child: Row(
            children: List.generate(headers.length, (i) => Container(
              width: widths[i],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                headers[i],
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: headerText,
                ),
              ),
            )),
          ),
        ),
        // Rows
        ..._filtered.map((a) => Column(
          children: [
            Divider(height: 1, color: divider),
            Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  _cell(a.no.toString(), widths[0], rowText),
                  _cell(a.nis, widths[1], rowText),
                  _cell(a.nama, widths[2], rowText, bold: true),
                  Container(
                    width: widths[3],
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: StatusBadge(status: a.status),
                  ),
                  _cell(a.jamMasuk, widths[4], rowText),
                  _cell(a.jamPulang, widths[5], rowText),
                  _cell(a.keterangan, widths[6], Colors.grey.shade500),
                ],
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _cell(String text, double width, Color color, {bool bold = false}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: color,
          fontWeight: bold ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
    );
  }
}