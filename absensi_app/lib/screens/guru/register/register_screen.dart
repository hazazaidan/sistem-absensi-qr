import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _namaController = TextEditingController();
  final _idController = TextEditingController(); // tetap ada (tidak dihapus)
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  // State
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  // Animations
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _namaController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_namaController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passController.text.length < 6) {
      _showCustomToast(
          "Lengkapi data & Password min. 6 karakter", Colors.orangeAccent);
      return;
    }

    if (_passController.text != _confirmPassController.text) {
      _showCustomToast("Konfirmasi password tidak cocok", Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    _showCustomToast("Akun Berhasil Dibuat!", Colors.green);
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  void _showCustomToast(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _BackgroundPainter()),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: isWide
                  ? _buildWideLayout(size)
                  : _buildMobileLayout(size),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(Size size) {
    return Container(
      width: size.width * 0.85,
      constraints:
          const BoxConstraints(maxWidth: 1100, minHeight: 720),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 40,
              offset: Offset(0, 20))
        ],
      ),
      child: Row(
        children: [
          Expanded(flex: 5, child: _buildBannerPanel()),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 50, vertical: 40),
              child: _buildFormContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerPanel() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A1DA8), Color(0xFF6C63FF)],
        ),
      ),
      child: const Center(
        child: Text(
          "Smart Presence",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(Size size) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 20)
                ],
              ),
              child: _buildFormContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Buat Akun",
            style:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        _premiumInput(
            _namaController, "Nama", "Nama lengkap", Icons.person),

        _premiumInput(
            _emailController, "Email", "email@gmail.com", Icons.email),

        _premiumInput(
          _passController,
          "Password",
          "******",
          Icons.lock,
          isPassword: true,
          obscure: _obscurePass,
          onToggle: () =>
              setState(() => _obscurePass = !_obscurePass),
        ),

        // ✅ TAMBAHAN (FIX BUG)
        _premiumInput(
          _confirmPassController,
          "Konfirmasi Password",
          "******",
          Icons.lock_outline,
          isPassword: true,
          obscure: _obscureConfirm,
          onToggle: () =>
              setState(() => _obscureConfirm = !_obscureConfirm),
        ),

        const SizedBox(height: 20),
        _buildAnimatedButton(),
      ],
    );
  }

  Widget _buildAnimatedButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleRegister,
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text("Daftar"),
    );
  }

  Widget _premiumInput(
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(obscure
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: onToggle,
              )
            : null,
      ),
    );
  }
}

class _BackgroundPainter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _OrnamentsPainter());
  }
}

class _OrnamentsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()..color = Colors.purple.withOpacity(0.05);
    canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.1), 150, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}