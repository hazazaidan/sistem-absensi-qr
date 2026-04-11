import 'package:flutter/material.dart';

class AppHelpers {
  static String formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  static String formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
  }

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir': return const Color(0xFF10B981);
      case 'izin': return const Color(0xFF3B82F6);
      case 'alfa': return const Color(0xFFEF4444);
      default: return Colors.grey;
    }
  }
}