import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import '../providers/theme_provider.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;

  const AppSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bgColor = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);

    return Container(
      width: 260,
      color: bgColor,
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.school, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  'SISWA',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: isDark ? const Color(0xFF2A2A40) : const Color(0xFFEEEEF5)),

          const SizedBox(height: 16),

          // Menu Items
          _buildMenuItem(
            context,
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            route: '/dashboard',
            isActive: currentRoute == '/dashboard',
            textColor: textColor,
          ),
          _buildMenuItem(
            context,
            icon: Icons.check_circle_outline_rounded,
            label: 'Absensi',
            route: '/absensi',
            isActive: currentRoute == '/absensi',
            textColor: textColor,
          ),
          _buildMenuItem(
            context,
            icon: Icons.history_rounded,
            label: 'Riwayat',
            route: '/riwayat',
            isActive: currentRoute == '/riwayat',
            textColor: textColor,
          ),
          _buildMenuItem(
            context,
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            route: '/profile',
            isActive: currentRoute == '/profile',
            textColor: textColor,
          ),

          const Spacer(),

          // Dark Mode Toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF252540) : const Color(0xFFF5F5FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    size: 20,
                    color: isDark ? Colors.white70 : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: themeProvider.isDark,
                    onChanged: (_) => themeProvider.toggleTheme(),
                    activeColor: AppTheme.primaryColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Logout
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: InkWell(
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 20, color: Colors.red.shade400),
                    const SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.red.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: InkWell(
        onTap: () {
          if (!isActive) Navigator.pushReplacementNamed(context, route);
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryColor.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? AppTheme.primaryColor : textColor.withOpacity(0.5),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppTheme.primaryColor : textColor.withOpacity(0.7),
                ),
              ),
              if (isActive) ...[
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}