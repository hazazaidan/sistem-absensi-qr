import 'package:flutter/material.dart';
import 'package:excel/excel.dart' as ex;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import '../../../widgets/sidebar.dart';
import '../../../widgets/topbar.dart';

class RekapScreen extends StatefulWidget {
  const RekapScreen({super.key});

  @override
  State<RekapScreen> createState() => _RekapScreenState();
}

class _RekapScreenState extends State<RekapScreen> {
  String _selectedBulan = "April";
  String _selectedKelas = "Semua Kelas";
  bool _showExportMenu = false;

  final List<String> _bulanList = [
    "Januari", "Februari", "Maret", "April", "Mei", "Juni",
    "Juli", "Agustus", "September", "Oktober", "November", "Desember"
  ];

  final List<String> _kelasList = [
    "Semua Kelas", "VI A", "VI B", "VI C"
  ];

  final List<Map<String, dynamic>> _rekapData = [
    {"no": 1, "nama": "Amir Hamzah",   "kelas": "VI A", "hadir": 20, "sakit": 1, "izin": 0, "alpa": 0},
    {"no": 2, "nama": "Ahmad Fauzi",   "kelas": "VI B", "hadir": 18, "sakit": 2, "izin": 1, "alpa": 0},
    {"no": 3, "nama": "Anisa Rahma",   "kelas": "VI C", "hadir": 17, "sakit": 0, "izin": 2, "alpa": 2},
    {"no": 4, "nama": "Budi Santoso",  "kelas": "VI A", "hadir": 21, "sakit": 0, "izin": 0, "alpa": 0},
    {"no": 5, "nama": "Citra Dewi",    "kelas": "VI B", "hadir": 19, "sakit": 1, "izin": 1, "alpa": 0},
    {"no": 6, "nama": "Dian Pratama",  "kelas": "VI C", "hadir": 15, "sakit": 3, "izin": 2, "alpa": 1},
    {"no": 7, "nama": "Eka Putra",     "kelas": "VI A", "hadir": 20, "sakit": 2, "izin": 0, "alpa": 0},
    {"no": 8, "nama": "Fajar Nugroho", "kelas": "VI B", "hadir": 22, "sakit": 0, "izin": 0, "alpa": 0},
    {"no": 9, "nama": "Gita Sari",     "kelas": "VI C", "hadir": 16, "sakit": 1, "izin": 3, "alpa": 1},
    {"no": 10,"nama": "Hendra Wijaya", "kelas": "VI A", "hadir": 14, "sakit": 2, "izin": 1, "alpa": 4},
  ];

  List<Map<String, dynamic>> get _filteredData {
    if (_selectedKelas == "Semua Kelas") return _rekapData;
    return _rekapData.where((d) => d["kelas"] == _selectedKelas).toList();
  }

  // ✅ EXPORT EXCEL — sama persis kayak Monitoring
  Future<void> _exportExcel() async {
    try {
      final excel = ex.Excel.createExcel();
      excel.delete('Sheet1');
      final sheet = excel['Rekap Absensi'];

      final headerStyle = ex.CellStyle(
        bold: true,
        backgroundColorHex: ex.ExcelColor.fromHexString('#4C3FCB'),
        fontColorHex: ex.ExcelColor.fromHexString('#FFFFFF'),
        horizontalAlign: ex.HorizontalAlign.Center,
      );

      final headers = ['No', 'Nama Siswa', 'Kelas', 'Hadir', 'Sakit', 'Izin', 'Alpa', 'Total'];
      for (var i = 0; i < headers.length; i++) {
        final cell = sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = ex.TextCellValue(headers[i]);
        cell.cellStyle = headerStyle;
      }

      for (var i = 0; i < _filteredData.length; i++) {
        final d = _filteredData[i];
        final total = (d['hadir'] as int) + (d['sakit'] as int) + (d['izin'] as int) + (d['alpa'] as int);
        final rowData = <ex.CellValue>[
          ex.IntCellValue(d['no'] as int),
          ex.TextCellValue(d['nama'] as String),
          ex.TextCellValue(d['kelas'] as String),
          ex.IntCellValue(d['hadir'] as int),
          ex.IntCellValue(d['sakit'] as int),
          ex.IntCellValue(d['izin'] as int),
          ex.IntCellValue(d['alpa'] as int),
          ex.IntCellValue(total),
        ];
        for (var j = 0; j < rowData.length; j++) {
          sheet.cell(ex.CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1)).value = rowData[j];
        }
      }

      sheet.setColumnWidth(0, 6);
      sheet.setColumnWidth(1, 24);
      sheet.setColumnWidth(2, 10);
      sheet.setColumnWidth(3, 8);
      sheet.setColumnWidth(4, 8);
      sheet.setColumnWidth(5, 8);
      sheet.setColumnWidth(6, 8);
      sheet.setColumnWidth(7, 8);

      final bytes = excel.encode();
      if (bytes == null) {
        _showSnackbar('Gagal membuat file Excel', isError: true);
        return;
      }

      // ✅ Pakai Printing.sharePdf — sama persis kayak Monitoring
      final tanggal = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      await Printing.sharePdf(
        bytes: Uint8List.fromList(bytes),
        filename: 'Rekap_Absensi_${_selectedBulan}_$tanggal.xlsx',
      );

      _showSnackbar('Excel berhasil didownload!');
    } catch (e) {
      _showSnackbar('Error: $e', isError: true);
    }
  }

  // ✅ EXPORT PDF — sama persis kayak Monitoring
  Future<void> _exportPdf() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(28),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 1)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Rekap Absensi Siswa — $_selectedBulan',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.indigo800,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Kelas: $_selectedKelas  |  MAN 2 Banyumas  |  Total: ${_filteredData.length} siswa',
                        style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Table.fromTextArray(
                  headers: ['No', 'Nama Siswa', 'Kelas', 'Hadir', 'Sakit', 'Izin', 'Alpa', 'Total'],
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                    fontSize: 10,
                  ),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
                  oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  cellStyle: const pw.TextStyle(fontSize: 10),
                  cellAlignments: {
                    0: pw.Alignment.center,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.center,
                    5: pw.Alignment.center,
                    6: pw.Alignment.center,
                    7: pw.Alignment.center,
                  },
                  columnWidths: {
                    0: const pw.FixedColumnWidth(28),
                    2: const pw.FixedColumnWidth(45),
                    3: const pw.FixedColumnWidth(42),
                    4: const pw.FixedColumnWidth(42),
                    5: const pw.FixedColumnWidth(42),
                    6: const pw.FixedColumnWidth(42),
                    7: const pw.FixedColumnWidth(42),
                  },
                  data: _filteredData.map((d) {
                    final total = (d['hadir'] as int) + (d['sakit'] as int) + (d['izin'] as int) + (d['alpa'] as int);
                    return [
                      '${d['no']}', d['nama'], d['kelas'],
                      '${d['hadir']}', '${d['sakit']}', '${d['izin']}', '${d['alpa']}', '$total',
                    ];
                  }).toList(),
                ),
                pw.SizedBox(height: 14),
                pw.Text(
                  'Dicetak pada: ${DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                ),
              ],
            );
          },
        ),
      );

      // ✅ Pakai Printing.layoutPdf — sama persis kayak Monitoring
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Rekap_Absensi_${_selectedBulan}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
      );

      _showSnackbar('PDF berhasil didownload!');
    } catch (e) {
      _showSnackbar('Error: $e', isError: true);
    }
  }

  void _showSnackbar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(
            isError ? Icons.error_rounded : Icons.check_circle_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(msg, style: const TextStyle(fontSize: 13))),
        ],
      ),
      backgroundColor: isError ? Colors.red : const Color(0xFF1E7E34),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 4),
    ));
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Rekap Data Absensi",
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1C24))),
                                Text("Bulan $_selectedBulan · $_selectedKelas",
                                    style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                              ],
                            ),
                            Row(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF6C63FF),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () => setState(() => _showExportMenu = !_showExportMenu),
                                      icon: const Icon(Icons.download_rounded, size: 18),
                                      label: Row(
                                        children: [
                                          const Text("Export", style: TextStyle(fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 4),
                                          Icon(_showExportMenu
                                              ? Icons.keyboard_arrow_up_rounded
                                              : Icons.keyboard_arrow_down_rounded, size: 18),
                                        ],
                                      ),
                                    ),
                                    if (_showExportMenu)
                                      Positioned(
                                        top: 52,
                                        left: 0,
                                        child: Material(
                                          elevation: 8,
                                          borderRadius: BorderRadius.circular(14),
                                          child: Container(
                                            width: 180,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(14),
                                            ),
                                            child: Column(
                                              children: [
                                                _exportMenuItem(
                                                  icon: Icons.table_chart_rounded,
                                                  iconColor: const Color(0xFF00B69B),
                                                  iconBg: const Color(0xFF00B69B),
                                                  label: "Export Excel",
                                                  onTap: () {
                                                    setState(() => _showExportMenu = false);
                                                    _exportExcel();
                                                  },
                                                ),
                                                Divider(height: 1, color: Colors.grey.shade100),
                                                _exportMenuItem(
                                                  icon: Icons.picture_as_pdf_rounded,
                                                  iconColor: Colors.red,
                                                  iconBg: Colors.red,
                                                  label: "Export PDF",
                                                  onTap: () {
                                                    setState(() => _showExportMenu = false);
                                                    _exportPdf();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.refresh_rounded, color: Color(0xFF6C63FF)),
                                    onPressed: () => setState(() {}),
                                    tooltip: "Refresh",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            _buildDropdown(icon: Icons.calendar_month_rounded, value: _selectedBulan, items: _bulanList,
                                onChanged: (v) => setState(() => _selectedBulan = v!)),
                            const SizedBox(width: 16),
                            _buildDropdown(icon: Icons.class_rounded, value: _selectedKelas, items: _kelasList,
                                onChanged: (v) => setState(() => _selectedKelas = v!)),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            _summaryCard("Total Siswa", "${_filteredData.length}", Icons.people_rounded, const Color(0xFF6C63FF)),
                            const SizedBox(width: 16),
                            _summaryCard("Total Hadir", "${_filteredData.fold(0, (s, d) => s + (d['hadir'] as int))}", Icons.check_circle_rounded, const Color(0xFF00B69B)),
                            const SizedBox(width: 16),
                            _summaryCard("Total Sakit", "${_filteredData.fold(0, (s, d) => s + (d['sakit'] as int))}", Icons.local_hospital_rounded, Colors.orange),
                            const SizedBox(width: 16),
                            _summaryCard("Total Alpa", "${_filteredData.fold(0, (s, d) => s + (d['alpa'] as int))}", Icons.cancel_rounded, Colors.red),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FF),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20), topRight: Radius.circular(20),
                                  ),
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
                                ),
                                child: const Row(
                                  children: [
                                    SizedBox(width: 40, child: Text("No", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B)))),
                                    Expanded(flex: 3, child: Text("Nama Siswa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B)))),
                                    Expanded(flex: 1, child: Text("Kelas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B)))),
                                    Expanded(flex: 1, child: Text("Hadir", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF00B69B)))),
                                    Expanded(flex: 1, child: Text("Sakit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.orange))),
                                    Expanded(flex: 1, child: Text("Izin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue))),
                                    Expanded(flex: 1, child: Text("Alpa", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red))),
                                    Expanded(flex: 1, child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF64748B)))),
                                  ],
                                ),
                              ),

                              ..._filteredData.asMap().entries.map((entry) {
                                final i = entry.key;
                                final d = entry.value;
                                final total = (d['hadir'] as int) + (d['sakit'] as int) + (d['izin'] as int) + (d['alpa'] as int);
                                final isEven = i % 2 == 0;
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isEven ? Colors.white : const Color(0xFFFAFAFF),
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade50)),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 40, child: Text("${i + 1}", style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)))),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundColor: const Color(0xFF6C63FF).withOpacity(0.1),
                                              child: Text(
                                                d['nama'].toString().substring(0, 1),
                                                style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.bold, fontSize: 12),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Flexible(
                                              child: Text(d['nama'],
                                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1A1C24)),
                                                  overflow: TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6C63FF).withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(d['kelas'],
                                              style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.w600, fontSize: 12)),
                                        ),
                                      ),
                                      _statCell("${d['hadir']}", const Color(0xFF00B69B)),
                                      _statCell("${d['sakit']}", Colors.orange),
                                      _statCell("${d['izin']}", Colors.blue),
                                      _statCell("${d['alpa']}", Colors.red),
                                      Expanded(
                                        flex: 1,
                                        child: Text("$total",
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A1C24))),
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF8F9FF),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  "Menampilkan ${_filteredData.length} siswa · Bulan $_selectedBulan",
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildDropdown({required IconData icon, required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6C63FF)),
          const SizedBox(width: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1C24))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCell(String value, Color color) {
    return Expanded(
      flex: 1,
      child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
    );
  }

  Widget _exportMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: iconBg.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1A1C24))),
          ],
        ),
      ),
    );
  }
}