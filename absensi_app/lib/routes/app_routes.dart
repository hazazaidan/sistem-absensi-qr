import 'package:flutter/material.dart';

import '../screens/login/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/absensi/absensi_screen.dart';
import '../screens/riwayat/riwayat_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/register/register_screen.dart';

class AppRoutes {
  static const login = '/';
  static const dashboard = '/dashboard';
  static const absensi = '/absensi';
  static const riwayat = '/riwayat';
  static const profile = '/profile';
  static const register = '/register';
  

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    dashboard: (_) => const DashboardScreen(),
    absensi: (_) => const AbsensiScreen(),
    riwayat: (_) => const RiwayatScreen(),
    profile: (_) => const ProfileScreen(),
    register: (_) => const RegisterScreen(),
    
  };
}