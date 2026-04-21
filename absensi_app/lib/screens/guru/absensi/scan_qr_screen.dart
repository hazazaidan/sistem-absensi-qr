import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../widgets/sidebar.dart';
import '../../../widgets/topbar.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  // ✅ CONTROLLER MOBILE SCANNER
  MobileScannerController _scannerController = MobileScannerController(
    facing: CameraFacing.back,
  );

  String _selectedCamera = "Belakang";
  bool _isScanned = false; // biar ngga spam detect

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  // ✅ SWITCH KAMERA BELAKANG / DEPAN
  void _switchCamera(String camera) {
    setState(() => _selectedCamera = camera);
    _scannerController.dispose();
    _scannerController = MobileScannerController(
      facing: camera == "Belakang" ? CameraFacing.back : CameraFacing.front,
    );
  }

  // ✅ HANDLER KETIKA QR BERHASIL DIBACA
  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    setState(() => _isScanned = true);
    final String scannedValue = barcode!.rawValue!;

    // Tampilkan dialog hasil scan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF00B69B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF00B69B), size: 52),
            ),
            const SizedBox(height: 16),
            const Text(
              "QR Berhasil Dibaca!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1C24)),
            ),
            const SizedBox(height: 8),
            Text(
              scannedValue,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _isScanned = false); // reset untuk scan lagi
                },
                child: const Text("Scan Lagi", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F9),
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Column(
              children: [
                const Topbar(),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(30),
                      child: Center(
                        child: Container(
                          width: 380,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // HEADER
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF6C63FF), Color(0xFF4E54C8)],
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 22),
                                    SizedBox(width: 10),
                                    Text(
                                      "Scanner Absensi",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    // ✅ AREA KAMERA BENERAN
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 280,
                                        child: Stack(
                                          children: [
                                            // Kamera live
                                            MobileScanner(
                                              controller: _scannerController,
                                              onDetect: _onDetect,
                                            ),

                                            // Overlay sudut scanner
                                            _buildScannerCorners(),

                                            // Label bawah
                                            Positioned(
                                              bottom: 12,
                                              left: 0,
                                              right: 0,
                                              child: Center(
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.45),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        width: 6,
                                                        height: 6,
                                                        decoration: const BoxDecoration(
                                                          color: Color(0xFF00B69B),
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      const Text(
                                                        "Arahkan ke QR Code siswa",
                                                        style: TextStyle(color: Colors.white, fontSize: 11),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // TOMBOL BELAKANG / DEPAN
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => _switchCamera("Belakang"),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              padding: const EdgeInsets.symmetric(vertical: 13),
                                              decoration: BoxDecoration(
                                                color: _selectedCamera == "Belakang"
                                                    ? const Color(0xFF6C63FF).withOpacity(0.12)
                                                    : const Color(0xFFF3F4F9),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: _selectedCamera == "Belakang"
                                                      ? const Color(0xFF6C63FF)
                                                      : Colors.transparent,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.camera_rear_rounded, size: 18,
                                                      color: _selectedCamera == "Belakang"
                                                          ? const Color(0xFF6C63FF) : Colors.grey),
                                                  const SizedBox(width: 8),
                                                  Text("Belakang",
                                                      style: TextStyle(
                                                        color: _selectedCamera == "Belakang"
                                                            ? const Color(0xFF6C63FF) : Colors.grey,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 14,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => _switchCamera("Depan"),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 200),
                                              padding: const EdgeInsets.symmetric(vertical: 13),
                                              decoration: BoxDecoration(
                                                color: _selectedCamera == "Depan"
                                                    ? const Color(0xFF6C63FF).withOpacity(0.12)
                                                    : const Color(0xFFF3F4F9),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: _selectedCamera == "Depan"
                                                      ? const Color(0xFF6C63FF)
                                                      : Colors.transparent,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.camera_front_rounded, size: 18,
                                                      color: _selectedCamera == "Depan"
                                                          ? const Color(0xFF6C63FF) : Colors.grey),
                                                  const SizedBox(width: 8),
                                                  Text("Depan",
                                                      style: TextStyle(
                                                        color: _selectedCamera == "Depan"
                                                            ? const Color(0xFF6C63FF) : Colors.grey,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 14,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerCorners() {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Stack(
          children: [
            Positioned(top: 0, left: 0, child: _corner(topLeft: true)),
            Positioned(top: 0, right: 0, child: _corner(topRight: true)),
            Positioned(bottom: 0, left: 0, child: _corner(bottomLeft: true)),
            Positioned(bottom: 0, right: 0, child: _corner(bottomRight: true)),
          ],
        ),
      ),
    );
  }

  Widget _corner({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _CornerPainter(
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool topLeft, topRight, bottomLeft, bottomRight;

  _CornerPainter({
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6C63FF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (topLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (topRight) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (bottomLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else if (bottomRight) {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerPainter oldDelegate) => false;
}