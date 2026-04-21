import 'package:flutter/material.dart';
import '../../../layouts/main_layout.dart';

class AbsensiScreen extends StatelessWidget {
  const AbsensiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      child: Center(
        child: Text(
          "Halaman Absensi Guru",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}