import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isPasswordVisible = false;
  String _activeRole = "Guru";

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          if (isDesktop)
            const Expanded(
              flex: 3,
              child: _LoginBanner(),
            ),
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFFFBFBFE),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  child: _buildLoginForm(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selamat Datang Kembali",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1A1C24),
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            "Silakan masuk ke akun Anda untuk mengelola data absensi siswa secara efisien.",
            style: TextStyle(color: Colors.blueGrey[400], height: 1.5, fontSize: 15),
          ),
          const SizedBox(height: 40),
          const Text(
            "Masuk Sebagai:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3250)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRoleTab(Icons.co_present_rounded, "Guru", const Color(0xFF6C63FF)),
              const SizedBox(width: 15),
              _buildRoleTab(Icons.admin_panel_settings_rounded, "Admin", const Color(0xFF2D3250)),
            ],
          ),
          const SizedBox(height: 35),
          _CustomTextField(
            label: "Alamat Email",
            hint: "Contoh: guru@sekolah.id",
            controller: _emailController,
            icon: Icons.alternate_email_rounded,
          ),
          const SizedBox(height: 25),
          _CustomTextField(
            label: "Kata Sandi",
            hint: "Masukkan kata sandi Anda",
            controller: _passController,
            icon: Icons.lock_person_rounded,
            isPassword: true,
            isObscured: !_isPasswordVisible,
            onToggleVisibility: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                try {
                  Navigator.pushNamed(context, AppRoutes.forgotPassword);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Halaman lupa password belum tersedia")),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: const Color(0xFF6C63FF)),
              child: const Text("Lupa Kata Sandi?", style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: const Color(0xFF6C63FF).withOpacity(0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              },
              child: const Text(
                "Masuk Sekarang",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: GestureDetector(
              onTap: () => _showRegisterDialog(context),
              child: RichText(
                text: const TextSpan(
                  text: "Belum memiliki akun? ",
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  children: [
                    TextSpan(
                      text: "Daftar Sekarang",
                      style: TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.w800),
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

  Widget _buildRoleTab(IconData icon, String label, Color activeColor) {
    bool isActive = _activeRole == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeRole = label),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? activeColor : Colors.grey.shade200,
              width: 2,
            ),
            boxShadow: isActive
                ? [BoxShadow(color: activeColor.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: isActive ? Colors.white : Colors.grey[400]),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    final namaController = TextEditingController();
    final nisController = TextEditingController();
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final confirmPassController = TextEditingController();
    bool obscurePass = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Buat Akun Baru",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1C24)),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Isi data diri kamu untuk mendaftar",
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 24),
                  _dialogLabel("Nama Lengkap"),
                  _dialogInput(controller: namaController, hint: "Masukkan nama lengkap", icon: Icons.badge_outlined),
                  const SizedBox(height: 16),
                  _dialogLabel("NIS"),
                  _dialogInput(controller: nisController, hint: "Masukkan NIS Anda", icon: Icons.person_outline, keyboardType: TextInputType.number),
                  const SizedBox(height: 16),
                  _dialogLabel("Email (Opsional)"),
                  _dialogInput(controller: emailController, hint: "Masukkan email Anda", icon: Icons.mail_outline, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _dialogLabel("Password"),
                  _dialogInput(
                    controller: passController,
                    hint: "Buat password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscure: obscurePass,
                    onToggle: () => setStateDialog(() => obscurePass = !obscurePass),
                  ),
                  const SizedBox(height: 16),
                  _dialogLabel("Ulangi Password"),
                  _dialogInput(
                    controller: confirmPassController,
                    hint: "Ulangi password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    obscure: obscureConfirm,
                    onToggle: () => setStateDialog(() => obscureConfirm = !obscureConfirm),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Color(0xFF6C63FF)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Batal", style: TextStyle(color: Color(0xFF6C63FF))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            if (namaController.text.isEmpty || nisController.text.isEmpty || passController.text.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text("Lengkapi data & Password min. 6 karakter"),
                                backgroundColor: Colors.orangeAccent,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                margin: const EdgeInsets.all(20),
                              ));
                              return;
                            }
                            if (passController.text != confirmPassController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text("Password tidak cocok"),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                margin: const EdgeInsets.all(20),
                              ));
                              return;
                            }
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Permintaan berhasil dikirim!"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              margin: const EdgeInsets.all(20),
                            ));
                          },
                          child: const Text("Daftar", style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _dialogLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2D3250)),
      ),
    );
  }

  Widget _dialogInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0B8C1), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFFB0B8C1), size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFFB0B8C1), size: 20),
                onPressed: onToggle,
              )
            : null,
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
        ),
      ),
    );
  }
}

// ================= BANNER (DIUBAH DISINI) =================
class _LoginBanner extends StatelessWidget {
  const _LoginBanner();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ✅ BACKGROUND IMAGE SEKOLAH
        Image.asset(
          'assets/images/sekolah.jpeg',
          fit: BoxFit.cover,
        ),

        // ✅ GRADIENT OVERLAY di atas gambar
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xCC6C63FF), // ungu transparan 80%
                Color(0xCC3F37C9), // biru-ungu transparan 80%
              ],
            ),
          ),
        ),

        // ✅ KONTEN BANNER
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ LOGO + NAMA SEKOLAH
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // ✅ GANTI ICON DENGAN LOGO IMAGE
                      child: Image.asset(
                        'assets/images/logo_man2.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.account_balance_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "MAN 2 BANYUMAS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 60),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Sistem Terintegrasi\nAbsensi Siswa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Kelola kehadiran siswa secara real-time,\nakurat, dan aman dalam satu dashboard.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 18,
                    height: 1.6,
                    letterSpacing: 0.2,
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ================= CUSTOM INPUT =================
class _CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;
  final bool isObscured;
  final VoidCallback? onToggleVisibility;

  const _CustomTextField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.isPassword = false,
    this.isObscured = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isObscured,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
    );
  }
}