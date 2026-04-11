import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';

class WebLayout extends StatelessWidget {
  final String currentRoute;
  final Widget child;
  final String title;
  final String subtitle;

  const WebLayout({
    super.key,
    required this.currentRoute,
    required this.child,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 768;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            AppSidebar(currentRoute: currentRoute),
            VerticalDivider(
              width: 1,
              color: isDark ? const Color(0xFF2A2A40) : const Color(0xFFEEEEF5),
            ),
            Expanded(
              child: Column(
                children: [
                  _buildHeader(context, isDark),
                  Expanded(
                    child: SingleChildScrollView(
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
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
          ),
        ),
        drawer: Drawer(child: AppSidebar(currentRoute: currentRoute)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final bgColor = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildUserChip(context, isDark),
        ],
      ),
    );
  }

  Widget _buildUserChip(BuildContext context, bool isDark) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isDark ? const Color(0xFF2A2A40) : const Color(0xFFEEEEF5),
          child: Icon(Icons.person_rounded, size: 18, color: isDark ? Colors.white54 : Colors.grey),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Andi Saputra',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              ),
            ),
            Text(
              'NIS: 123456',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}