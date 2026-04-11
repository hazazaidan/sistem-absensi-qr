import 'package:flutter/material.dart';
import '../../layouts/web_layout.dart';
import '../../models/absensi_model.dart';
import '../../themes/app_theme.dart';
import '../../widgets/status_badge.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  String _filter = 'Semua';
  final List<String> _filters = ['Semua', 'Hadir', 'Izin', 'Alfa'];

  final List<Map<String, String>> _riwayat = [
    {'tanggal': '09 Apr 2026', 'hari': 'Rabu', 'status': 'Hadir', 'masuk': '07:05', 'pulang': '14:45'},
    {'tanggal': '08 Apr 2026', 'hari': 'Selasa', 'status': 'Hadir', 'masuk': '06:58', 'pulang': '14:50'},
    {'tanggal': '07 Apr 2026', 'hari': 'Senin', 'status': 'Hadir', 'masuk': '07:12', 'pulang': '14:44'},
    {'tanggal': '04 Apr 2026', 'hari': 'Jumat', 'status': 'Izin', 'masuk': '-', 'pulang': '-', 'ket': 'Sakit'},
    {'tanggal': '03 Apr 2026', 'hari': 'Kamis', 'status': 'Hadir', 'masuk': '07:00', 'pulang': '14:50'},
    {'tanggal': '02 Apr 2026', 'hari': 'Rabu', 'status': 'Hadir', 'masuk': '07:22', 'pulang': '14:40'},
    {'tanggal': '01 Apr 2026', 'hari': 'Selasa', 'status': 'Alfa', 'masuk': '-', 'pulang': '-'},
    {'tanggal': '31 Mar 2026', 'hari': 'Senin', 'status': 'Hadir', 'masuk': '06:55', 'pulang': '14:48'},
    {'tanggal': '28 Mar 2026', 'hari': 'Jumat', 'status': 'Hadir', 'masuk': '07:03', 'pulang': '14:55'},
    {'tanggal': '27 Mar 2026', 'hari': 'Kamis', 'status': 'Izin', 'masuk': '-', 'pulang': '-', 'ket': 'Keperluan keluarga'},
  ];

  List<Map<String, String>> get _filtered => _filter == 'Semua'
      ? _riwayat
      : _riwayat.where((r) => r['status'] == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WebLayout(
      currentRoute: '/riwayat',
      title: 'Riwayat Absensi',
      subtitle: 'Lihat rekap kehadiran Anda.',
      child: Column(
        children: [
          // Summary cards
          LayoutBuilder(builder: (context, constraints) {
            final hadir = _riwayat.where((r) => r['status'] == 'Hadir').length;
            final izin = _riwayat.where((r) => r['status'] == 'Izin').length;
            final alfa = _riwayat.where((r) => r['status'] == 'Alfa').length;
            final cards = [
              {'label': 'Total Hadir', 'value': '$hadir', 'color': AppTheme.accentColor},
              {'label': 'Total Izin', 'value': '$izin', 'color': AppTheme.warningColor},
              {'label': 'Total Alfa', 'value': '$alfa', 'color': AppTheme.dangerColor},
            ];

            return Row(
              children: cards.asMap().entries.map((e) {
                final c = e.value;
                final color = c['color'] as Color;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: e.key < cards.length - 1 ? 12 : 0),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          c['value'] as String,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                        Text(
                          c['label'] as String,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),

          const SizedBox(height: 24),

          // Table card
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
              children: [
                // Filter
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  child: Row(
                    children: [
                      Text(
                        'Riwayat Kehadiran',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                        ),
                      ),
                      const Spacer(),
                      ..._filters.map((f) => GestureDetector(
                            onTap: () => setState(() => _filter = f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: _filter == f
                                    ? AppTheme.primaryColor
                                    : (isDark ? const Color(0xFF252540) : const Color(0xFFF0F0F8)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                f,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: _filter == f ? Colors.white : Colors.grey.shade500,
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),

                // List
                ..._filtered.map((r) => _buildRow(r, isDark)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(Map<String, String> r, bool isDark) {
    return Column(
      children: [
        Divider(
          height: 1,
          color: isDark ? const Color(0xFF252540) : const Color(0xFFF0F0F8),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            children: [
              // Date
              SizedBox(
                width: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r['hari']!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      r['tanggal']!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              StatusBadge(status: r['status']!),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.login_rounded, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      r['masuk']!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.logout_rounded, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      r['pulang']!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              if (r.containsKey('ket'))
                Text(
                  r['ket']!,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.grey.shade400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}