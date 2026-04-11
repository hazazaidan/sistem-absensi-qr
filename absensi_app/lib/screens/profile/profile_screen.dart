import 'package:flutter/material.dart';
import '../../layouts/web_layout.dart';
import '../../models/user_model.dart';
import '../../themes/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _nama;
  late String _email;
  late String _kelas;
  late String _jurusan;
  late String _noHpOrtu;

  @override
  void initState() {
    super.initState();
    _nama = dummyUser.nama;
    _email = dummyUser.email;
    _kelas = dummyUser.kelas;
    _jurusan = dummyUser.jurusan;
    _noHpOrtu = dummyUser.noHpOrtu ?? '';
  }

  // ─── EDIT PROFILE DIALOG ───────────────────────────────────────────────────
  void _showEditProfileDialog() {
    final namaCtrl = TextEditingController(text: _nama);
    final emailCtrl = TextEditingController(text: _email);
    final kelasCtrl = TextEditingController(text: _kelas);
    final jurusanCtrl = TextEditingController(text: _jurusan);
    final hpOrtuCtrl = TextEditingController(text: _noHpOrtu);
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          return Dialog(
            backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: 480,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.85,
              ),
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.edit_rounded,
                            color: AppTheme.primaryColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                              ),
                            ),
                            Text(
                              'Perbarui data diri kamu',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: Icon(Icons.close_rounded,
                            color: Colors.grey.shade400, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Scrollable Fields
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _dialogField(
                            ctrl: namaCtrl,
                            label: 'Nama Lengkap',
                            hint: 'Masukkan nama lengkap',
                            icon: Icons.person_outline_rounded,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 14),
                          _dialogField(
                            ctrl: emailCtrl,
                            label: 'Email',
                            hint: 'Masukkan email',
                            icon: Icons.email_outlined,
                            isDark: isDark,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 14),
                          _dialogField(
                            ctrl: kelasCtrl,
                            label: 'Kelas',
                            hint: 'Contoh: XI RPL 1',
                            icon: Icons.class_outlined,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 14),
                          _dialogField(
                            ctrl: jurusanCtrl,
                            label: 'Jurusan',
                            hint: 'Masukkan jurusan',
                            icon: Icons.computer_outlined,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 14),
                          _dialogField(
                            ctrl: hpOrtuCtrl,
                            label: 'No. HP Orang Tua (untuk notif WA)',
                            hint: 'Contoh: 08123456789',
                            icon: Icons.phone_outlined,
                            isDark: isDark,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  size: 13, color: Colors.green.shade400),
                              const SizedBox(width: 4),
                              Text(
                                'Orang tua akan dapat notif WA saat absen',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: Colors.green.shade400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading ? null : () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (namaCtrl.text.trim().isEmpty) {
                                    _showSnackbar(ctx, 'Nama tidak boleh kosong',
                                        isError: true);
                                    return;
                                  }
                                  setStateDialog(() => isLoading = true);
                                  await Future.delayed(
                                      const Duration(milliseconds: 800));
                                  setState(() {
                                    _nama = namaCtrl.text.trim();
                                    _email = emailCtrl.text.trim();
                                    _kelas = kelasCtrl.text.trim();
                                    _jurusan = jurusanCtrl.text.trim();
                                    _noHpOrtu = hpOrtuCtrl.text.trim();
                                  });
                                  if (ctx.mounted) {
                                    Navigator.pop(ctx);
                                    _showSnackbar(context,
                                        'Profile berhasil diperbarui! ✅');
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── GANTI PASSWORD DIALOG ─────────────────────────────────────────────────
  void _showGantiPasswordDialog() {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    bool obscureOld = true;
    bool obscureNew = true;
    bool obscureConfirm = true;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          return Dialog(
            backgroundColor: isDark ? const Color(0xFF1A1A2E) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              width: 440,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.85,
              ),
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.lock_outline_rounded,
                            color: Colors.orange.shade600, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ganti Password',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                              ),
                            ),
                            Text(
                              'Pastikan password baru kuat',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: Icon(Icons.close_rounded,
                            color: Colors.grey.shade400, size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Password fields
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _passwordField(
                            ctrl: oldPassCtrl,
                            label: 'Password Lama',
                            hint: 'Masukkan password lama',
                            obscure: obscureOld,
                            isDark: isDark,
                            onToggle: () =>
                                setStateDialog(() => obscureOld = !obscureOld),
                          ),
                          const SizedBox(height: 14),
                          _passwordField(
                            ctrl: newPassCtrl,
                            label: 'Password Baru',
                            hint: 'Minimal 8 karakter',
                            obscure: obscureNew,
                            isDark: isDark,
                            onToggle: () =>
                                setStateDialog(() => obscureNew = !obscureNew),
                          ),
                          const SizedBox(height: 14),
                          _passwordField(
                            ctrl: confirmPassCtrl,
                            label: 'Konfirmasi Password Baru',
                            hint: 'Ulangi password baru',
                            obscure: obscureConfirm,
                            isDark: isDark,
                            onToggle: () =>
                                setStateDialog(() => obscureConfirm = !obscureConfirm),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading ? null : () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  if (oldPassCtrl.text.isEmpty ||
                                      newPassCtrl.text.isEmpty ||
                                      confirmPassCtrl.text.isEmpty) {
                                    _showSnackbar(ctx, 'Semua field wajib diisi',
                                        isError: true);
                                    return;
                                  }
                                  if (newPassCtrl.text.length < 8) {
                                    _showSnackbar(
                                        ctx, 'Password minimal 8 karakter',
                                        isError: true);
                                    return;
                                  }
                                  if (newPassCtrl.text != confirmPassCtrl.text) {
                                    _showSnackbar(
                                        ctx, 'Password baru tidak cocok',
                                        isError: true);
                                    return;
                                  }
                                  setStateDialog(() => isLoading = true);
                                  await Future.delayed(
                                      const Duration(milliseconds: 800));
                                  if (ctx.mounted) {
                                    Navigator.pop(ctx);
                                    _showSnackbar(
                                        context, 'Password berhasil diubah! 🔒');
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── HELPERS ───────────────────────────────────────────────────────────────
  void _showSnackbar(BuildContext ctx, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(msg, style: const TextStyle(fontFamily: 'Poppins')),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _dialogField({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                fontFamily: 'Poppins', color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 18),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            filled: true,
            fillColor:
                isDark ? const Color(0xFF252540) : const Color(0xFFF8F8FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppTheme.primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordField({
    required TextEditingController ctrl,
    required String label,
    required String hint,
    required bool obscure,
    required bool isDark,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
                fontFamily: 'Poppins', color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(Icons.lock_outline_rounded,
                color: Colors.grey.shade400, size: 18),
            suffixIcon: IconButton(
              onPressed: onToggle,
              icon: Icon(
                obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey.shade400,
                size: 18,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            filled: true,
            fillColor:
                isDark ? const Color(0xFF252540) : const Color(0xFFF8F8FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.orange.shade600, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ─── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = dummyUser;

    return WebLayout(
      currentRoute: '/profile',
      title: 'Profile',
      subtitle: 'Informasi akun dan data diri Anda.',
      child: Column(
        children: [
          // Profile card
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
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryColor, AppTheme.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person_rounded,
                          size: 44, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: _showEditProfileDialog,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit_rounded,
                            size: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _nama,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'NIS: ${user.nis}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Info card
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
                  'Informasi Akun',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoRow(Icons.badge_rounded, 'NIS', user.nis, isDark),
                _buildDivider(isDark),
                _buildInfoRow(Icons.person_rounded, 'Nama Lengkap', _nama, isDark),
                _buildDivider(isDark),
                _buildInfoRow(Icons.class_rounded, 'Kelas', _kelas, isDark),
                _buildDivider(isDark),
                _buildInfoRow(Icons.email_rounded, 'Email', _email, isDark),
                _buildDivider(isDark),
                _buildInfoRow(Icons.computer_rounded, 'Jurusan', _jurusan, isDark),
                if (_noHpOrtu.isNotEmpty) ...[
                  _buildDivider(isDark),
                  _buildInfoRow(
                    Icons.phone_rounded,
                    'No. HP Ortu',
                    _noHpOrtu,
                    isDark,
                    badge: 'Notif WA Aktif',
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showEditProfileDialog,
                  icon: const Icon(Icons.edit_rounded, size: 16),
                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(
                        fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _showGantiPasswordDialog,
                  icon: const Icon(Icons.lock_rounded,
                      size: 16, color: AppTheme.primaryColor),
                  label: const Text(
                    'Ganti Password',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark,
      {String? badge}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? const Color(0xFF252540) : const Color(0xFFF0F0F8),
    );
  }
}