import 'package:flutter/material.dart';
import '../../../widgets/sidebar.dart';
import '../../../widgets/topbar.dart';
import '../../../widgets/dashboard_card.dart';
import '../../../routes/app_routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  int totalSiswa = 10;
  int sakit = 1;
  int izin = 2;
  int alpa = 1;

  // ✅ DATA DIPERBANYAK
  List<Map<String, dynamic>> absensi = [
    {"nama": "Amir Hamzah",     "kelas": "VI A", "jam": "07:15", "status": "Hadir"},
    {"nama": "Ahmad Fauzi",     "kelas": "VI B", "jam": "07:18", "status": "Hadir"},
    {"nama": "Anisa Rahma",     "kelas": "VI C", "jam": "07:20", "status": "Terlambat"},
    {"nama": "Budi Santoso",    "kelas": "VI A", "jam": "07:22", "status": "Hadir"},
    {"nama": "Citra Dewi",      "kelas": "VI B", "jam": "07:25", "status": "Hadir"},
    {"nama": "Dian Pratama",    "kelas": "VI C", "jam": "07:30", "status": "Izin"},
    {"nama": "Eka Putra",       "kelas": "VI A", "jam": "07:35", "status": "Sakit"},
    {"nama": "Fajar Nugroho",   "kelas": "VI B", "jam": "07:40", "status": "Hadir"},
    {"nama": "Gita Sari",       "kelas": "VI C", "jam": "07:45", "status": "Izin"},
    {"nama": "Hendra Wijaya",   "kelas": "VI A", "jam": "07:50", "status": "Alpa"},
  ];

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Hadir":     return const Color(0xFF00B69B);
      case "Terlambat": return Colors.orange;
      case "Izin":      return Colors.blue;
      case "Sakit":     return Colors.purple;
      case "Alpa":      return Colors.red;
      default:          return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case "Hadir":     return Icons.check_circle_rounded;
      case "Terlambat": return Icons.watch_later_rounded;
      case "Izin":      return Icons.mail_rounded;
      case "Sakit":     return Icons.local_hospital_rounded;
      case "Alpa":      return Icons.cancel_rounded;
      default:          return Icons.help_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F9),
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Column(
              children: [
                const Topbar(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatisticsCards(),
                          const SizedBox(height: 30),
                          _buildMiddleSection(),
                          const SizedBox(height: 30),
                          _buildRecentAbsensiTable(),
                        ],
                      ),
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

  Widget _buildStatisticsCards() {
    return Row(
      children: [
        Expanded(child: DashboardCard(title: "TOTAL SISWA", value: totalSiswa.toString(), icon: Icons.school, color: Colors.blue)),
        const SizedBox(width: 20),
        Expanded(child: DashboardCard(title: "SAKIT", value: sakit.toString(), icon: Icons.hotel, color: Colors.orange)),
        const SizedBox(width: 20),
        Expanded(child: DashboardCard(title: "IZIN", value: izin.toString(), icon: Icons.mail, color: Colors.blueAccent)),
        const SizedBox(width: 20),
        Expanded(child: DashboardCard(title: "ALPA", value: alpa.toString(), icon: Icons.cancel, color: Colors.red)),
      ],
    );
  }

  Widget _buildMiddleSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildChartSection()),
        const SizedBox(width: 30),
        Expanded(flex: 1, child: _buildScannerCard()),
      ],
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Statistik Kehadiran Hari Ini",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildRealtimeBadge(),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar((totalSiswa - sakit - izin - alpa).toDouble(), "Hadir", const Color(0xFF00B69B)),
              _buildBar(sakit.toDouble(), "Sakit", Colors.orange),
              _buildBar(izin.toDouble(), "Izin", Colors.blue),
              _buildBar(alpa.toDouble(), "Alpa", Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text("Realtime",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }

  Widget _buildScannerCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF4E54C8)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.qr_code_scanner, size: 50, color: Colors.white),
          const SizedBox(height: 20),
          const Text("Mulai Absensi",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          const Text("Scan QR siswa untuk mencatat kehadiran",
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.scan),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6C63FF),
            ),
            child: const Text("Buka Scanner"),
          )
        ],
      ),
    );
  }

  // ✅ TABEL ABSENSI DIPERINDAH
  Widget _buildRecentAbsensiTable() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ HEADER TABEL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Absensi Terbaru",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Total: ${absensi.length} siswa",
                  style: const TextStyle(
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ✅ HEADER KOLOM
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                SizedBox(width: 36, child: Text("#", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B)))),
                Expanded(flex: 3, child: Text("Nama Siswa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B)))),
                Expanded(flex: 2, child: Text("Kelas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B)))),
                Expanded(flex: 2, child: Text("Jam Masuk", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B)))),
                Expanded(flex: 2, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B)))),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ✅ ROWS
          ...absensi.asMap().entries.map((entry) {
            final i = entry.key;
            final data = entry.value;
            final color = _statusColor(data["status"]);
            final isEven = i % 2 == 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isEven ? Colors.white : const Color(0xFFFAFAFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.07)),
              ),
              child: Row(
                children: [
                  // Nomor
                  SizedBox(
                    width: 36,
                    child: Text(
                      "${i + 1}",
                      style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                    ),
                  ),
                  // Avatar + Nama
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: color.withOpacity(0.15),
                          child: Text(
                            data["nama"].toString().substring(0, 1),
                            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            data["nama"],
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A1C24)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Kelas
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data["kelas"],
                        style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                  ),
                  // Jam
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Text(data["jam"], style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  // Status badge
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_statusIcon(data["status"]), size: 13, color: color),
                          const SizedBox(width: 5),
                          Text(
                            data["status"],
                            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBar(double value, String label, Color color) {
    return Column(
      children: [
        Text(value.toInt().toString()),
        const SizedBox(height: 5),
        Container(
          width: 30,
          height: value == 0 ? 20 : value * 20,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}