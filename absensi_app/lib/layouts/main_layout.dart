import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/navbar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Row(
        children: [
          // 🔥 SIDEBAR
          const Sidebar(),

          // 🔥 KONTEN UTAMA
          Expanded(
            child: Column(
              children: [
                const Navbar(),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}