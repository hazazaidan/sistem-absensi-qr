import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/absensi/absensi_screen.dart';
import 'screens/riwayat/riwayat_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'themes/app_theme.dart';
import 'providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'screens/register/register_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const SiswaApp(),
    ),
  );
}

class SiswaApp extends StatelessWidget {
  const SiswaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'SISWA - Sistem Informasi Absensi Siswa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/absensi': (context) => const AbsensiScreen(),
        '/riwayat': (context) => const RiwayatScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}