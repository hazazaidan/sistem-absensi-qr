import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return Container(
      width: 250,
      // ✅ GANTI: solid hitam → gradient purple
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A3F9F),
            Color(0xFF6C63FF),
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/logo_man2.png',
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "E-ABSENSI",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    "SCHOOL SYSTEM",
                    // ✅ GANTI: grey → putih transparan biar keliatan di bg ungu
                    style: TextStyle(color: Colors.white60, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 50),
          _buildUserSection(),
          const SizedBox(height: 30),

          _menuItem(context, Icons.dashboard_rounded, "Dashboard",
              route: AppRoutes.dashboard,
              isActive: currentRoute == AppRoutes.dashboard),
          _menuItem(context, Icons.remove_red_eye_outlined, "Monitoring",
              route: AppRoutes.monitoring,
              isActive: currentRoute == AppRoutes.monitoring),
          _menuItem(context, Icons.qr_code_scanner_rounded, "Scan Absensi",
              route: AppRoutes.scan,
              isActive: currentRoute == AppRoutes.scan),
          _menuItem(context, Icons.bar_chart_rounded, "Rekap Data",
              route: AppRoutes.rekap,
              isActive: currentRoute == AppRoutes.rekap),

          const Spacer(),

          _menuItem(context, Icons.logout_rounded, "Keluar Aplikasi",
              isLogout: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildUserSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // ✅ GANTI: opacity lebih tinggi biar kontras di bg gradient
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            // ✅ GANTI: avatar putih transparan biar nyatu sama gradient
            backgroundColor: Colors.white24,
            child: Text("G", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("guru1",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  // ✅ GANTI: badge putih transparan
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text("GURU",
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title, {
    String? route,
    bool isActive = false,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        // ✅ GANTI: active = putih transparan (bukan ungu solid, karena bg udah ungu)
        color: isActive ? Colors.white.withOpacity(0.25) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive ? Border.all(color: Colors.white.withOpacity(0.3)) : null,
      ),
      child: ListTile(
        onTap: () {
          if (isLogout) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: const Text("Keluar Aplikasi",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                content: const Text("Apakah kamu yakin ingin keluar?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: const Text("Keluar"),
                  ),
                ],
              ),
            );
          } else if (route != null && !isActive) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}