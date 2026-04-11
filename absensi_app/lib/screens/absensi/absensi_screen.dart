import 'package:flutter/material.dart';
import '../../layouts/web_layout.dart';
import '../../themes/app_theme.dart';
import '../../widgets/status_badge.dart';

class AbsensiScreen extends StatefulWidget {
  const AbsensiScreen({super.key});

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  String? _selectedStatus;
  final _keteranganController = TextEditingController();
  bool _submitted = false;

  final List<Map<String, String>> _history = [];

  void _submit() {
    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih status absensi terlebih dahulu!')),
      );
      return;
    }
    setState(() {
      _submitted = true;
      _history.insert(0, {
        'status': _selectedStatus!,
        'keterangan': _keteranganController.text.isEmpty ? '-' : _keteranganController.text,
        'waktu': TimeOfDay.now().format(context),
        'tanggal': '09 April 2026',
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Absensi $_selectedStatus berhasil disimpan!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WebLayout(
      currentRoute: '/absensi',
      title: 'Absensi',
      subtitle: 'Lakukan absensi harian Anda di sini.',
      child: Column(
        children: [
          // Absensi form card
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.check_circle_outline_rounded,
                          color: AppTheme.primaryColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Form Absensi',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                          ),
                        ),
                        Text(
                          'Rabu, 09 April 2026',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Text(
                  'Pilih Status Kehadiran',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                ),

                const SizedBox(height: 14),

                // Status buttons
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 500;
                    final buttons = [
                      _StatusOption(label: 'Hadir', icon: Icons.check_circle_rounded, color: AppTheme.accentColor),
                      _StatusOption(label: 'Izin', icon: Icons.info_rounded, color: AppTheme.infoColor),
                      _StatusOption(label: 'Alfa', icon: Icons.cancel_rounded, color: AppTheme.dangerColor),
                    ];

                    if (isWide) {
                      return Row(
                        children: buttons
                            .map((b) => Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: b == buttons.last ? 0 : 12),
                                    child: _buildStatusButton(b, isDark),
                                  ),
                                ))
                            .toList(),
                      );
                    }

                    return Column(
                      children: buttons
                          .map((b) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: _buildStatusButton(b, isDark),
                                ),
                              ))
                          .toList(),
                    );
                  },
                ),

                const SizedBox(height: 20),

                if (_selectedStatus == 'Izin' || _selectedStatus == 'Alfa') ...[
                  Text(
                    'Keterangan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _keteranganController,
                    maxLines: 3,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Masukkan alasan...',
                      hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitted ? null : _submit,
                    icon: const Icon(Icons.save_rounded, size: 18),
                    label: Text(
                      _submitted ? 'Sudah Absen Hari Ini' : 'Simpan Absensi',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_history.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riwayat Input',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._history.map((h) => _buildHistoryItem(h, isDark)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusButton(_StatusOption opt, bool isDark) {
    final isSelected = _selectedStatus == opt.label;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedStatus = opt.label;
        _submitted = false;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? opt.color : (isDark ? const Color(0xFF252540) : const Color(0xFFF8F8FC)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? opt.color : (isDark ? const Color(0xFF353560) : const Color(0xFFE2E8F0)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: opt.color.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4))]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(opt.icon, color: isSelected ? Colors.white : opt.color, size: 28),
            const SizedBox(height: 8),
            Text(
              opt.label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF1A1A2E)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, String> h, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252540) : const Color(0xFFF8F8FC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          StatusBadge(status: h['status']!),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${h['tanggal']} · ${h['waktu']}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          if (h['keterangan'] != '-')
            Text(
              h['keterangan']!,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusOption {
  final String label;
  final IconData icon;
  final Color color;

  _StatusOption({required this.label, required this.icon, required this.color});
}