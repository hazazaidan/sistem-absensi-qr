import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ TAMBAH INI
import 'routes/app_routes.dart';

import 'screens/guru/dashboard/dashboard_screen.dart';
import 'screens/guru/absensi/absensi_screen.dart';
import 'screens/guru/rekap/rekap_screen.dart';
import 'screens/guru/login/login_screen.dart';
import 'screens/guru/register/register_screen.dart';
import 'screens/guru/absensi/scan_qr_screen.dart';
import '/features/auth/screens/forgot_password_screen.dart';
import 'screens/monitoring/monitoring_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 
  await initializeDateFormatting('id_ID', null); // 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.dashboard: (context) => const DashboardScreen(),
        AppRoutes.absensi: (context) => const AbsensiScreen(),
        AppRoutes.rekap: (context) => const RekapScreen(),
        AppRoutes.scan: (context) => const ScanQrScreen(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
        AppRoutes.monitoring: (context) => const MonitoringScreen(),
      },
    );
  }
}