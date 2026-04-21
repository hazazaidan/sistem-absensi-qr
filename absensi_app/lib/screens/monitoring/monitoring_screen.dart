import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../widgets/sidebar.dart';
import '../../widgets/topbar.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  String _selectedStatus = "Semua Status";
  String _searchQuery = "";
  int _showCount = 10;
  int _currentPage = 0;

  final List<String> _statusList = [
    "Semua Status", "Hadir", "Sakit", "Izin", "Alpa", "Terlambat"
  ];

  // ✅ TAMBAH 4 DATA — total jadi 10
  final List<Map<String, dynamic>> _dataSiswa = [
    {"nama": "Amir", "nis": "123456", "kelas": "VI A", "jamDatang": "07:00", "jamPulang": "13:00", "terlambat": null, "status": "Hadir"},
    {"nama": "Ahmad Rizki", "nis": "1234567890", "kelas": "VI B", "jamDatang": "07:15", "jamPulang": "13:00", "terlambat": "15 m", "status": "Hadir"},
    {"nama": "Anisa Maharani", "nis": "4321", "kelas": "VI C", "jamDatang": "07:00", "jamPulang": "13:00", "terlambat": null, "status": "Hadir"},
    {"nama": "Budi", "nis": "11111", "kelas": "VI A", "jamDatang": "-", "jamPulang": "-", "terlambat": null, "status": "Alpa"},
    {"nama": "Sari", "nis": "22222", "kelas": "VI B", "jamDatang": "-", "jamPulang": "-", "terlambat": null, "status": "Sakit"},
    {"nama": "Reza", "nis": "33333", "kelas": "VI C", "jamDatang": "-", "jamPulang": "-", "terlambat": null, "status": "Izin"},
    {"nama": "Dina Fitriani", "nis": "44444", "kelas": "VI A", "jamDatang": "07:30", "jamPulang": "13:00", "terlambat": "30 m", "status": "Hadir"},
    {"nama": "Eko Prasetyo", "nis": "55555", "kelas": "VI B", "jamDatang": "07:00", "jamPulang": "13:00", "terlambat": null, "status": "Hadir"},
    {"nama": "Fani Anggraini", "nis": "66666", "kelas": "VI C", "jamDatang": "-", "jamPulang": "-", "terlambat": null, "status": "Izin"},
    {"nama": "Gilang Ramadan", "nis": "77777", "kelas": "VI A", "jamDatang": "07:05", "jamPulang": "13:00", "terlambat": "5 m", "status": "Hadir"},
  ];

  List<Map<String, dynamic>> get _filteredData {
    return _dataSiswa.where((s) {
      final statusMatch = _selectedStatus == "Semua Status" || s["status"] == _selectedStatus;
      final searchMatch = _searchQuery.isEmpty ||
          s["nama"].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s["kelas"].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s["nis"].contains(_searchQuery);
      return statusMatch && searchMatch;
    }).toList();
  }

  List<Map<String, dynamic>> get _pagedData {
    final start = _currentPage * _showCount;
    final end = (start + _showCount).clamp(0, _filteredData.length);
    if (start >= _filteredData.length) return [];
    return _filteredData.sublist(start, end);
  }

  int get _totalPages => (_filteredData.length / _showCount).ceil();

  Color _statusColor(String status) {
    switch (status) {
      case "Hadir": return const Color(0xFF00B69B);
      case "Terlambat": return Colors.orange;
      case "Izin": return Colors.blue;
      case "Sakit": return Colors.purple;
      case "Alpa": return Colors.red;
      default: return Colors.grey;
    }
  }

  Color _kelasColor(String kelas) {
    switch (kelas) {
      case "VI A": return Colors.blue;
      case "VI B": return Colors.green;
      case "VI C": return Colors.orange;
      default: return Colors.grey;
    }
  }

  String _getFormattedDate() {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
  }

  // ✅ EXPORT EXCEL — bisa didownload dengan data lengkap
  Future<void> _exportExcel() async {
    final excel = Excel.createExcel();
    final sheet = excel['Monitoring Kehadiran'];

    // Style header
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#4C3FCB'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
    );

    final headers = ['No', 'Nama', 'NIS', 'Kelas', 'Jam Datang', 'Jam Pulang', 'Keterangan', 'Status'];
    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    // Data rows
    for (var i = 0; i < _filteredData.length; i++) {
      final d = _filteredData[i];
      final row = [
        '${i + 1}',
        d["nama"],
        d["nis"],
        d["kelas"],
        d["jamDatang"],
        d["jamPulang"],
        d["terlambat"] != null ? "Terlambat (${d["terlambat"]})" : "-",
        d["status"],
      ];
      for (var j = 0; j < row.length; j++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
          ..value = TextCellValue(row[j]);
      }
    }

    // Auto width kolom
    sheet.setColumnWidth(0, 5);
    sheet.setColumnWidth(1, 20);
    sheet.setColumnWidth(2, 15);
    sheet.setColumnWidth(3, 10);
    sheet.setColumnWidth(4, 12);
    sheet.setColumnWidth(5, 12);
    sheet.setColumnWidth(6, 20);
    sheet.setColumnWidth(7, 12);

    final bytes = excel.save();
    if (bytes == null) return;

    // Simpan ke file
    final dir = await getApplicationDocumentsDirectory();
    final tanggal = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
    final file = File('${dir.path}/Monitoring_Kehadiran_$tanggal.xlsx');
    await file.writeAsBytes(bytes);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text('Excel disimpan: ${file.path}', style: const TextStyle(fontSize: 12))),
          ],
        ),
        backgroundColor: const Color(0xFF1E7E34),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 4),
      ));
    }
  }

  // ✅ EXPORT PDF — bisa didownload dengan data lengkap
  Future<void> _exportPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          // Judul
          pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 12),
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Monitoring Kehadiran Siswa',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo800)),
                pw.SizedBox(height: 4),
                pw.Text('MAN 2 Banyumas  |  ${_getFormattedDate()}',
                    style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
                pw.SizedBox(height: 2),
                pw.Text('Total Data: ${_filteredData.length} siswa  |  Filter: $_selectedStatus',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // Tabel
          pw.Table.fromTextArray(
            headers: ['No', 'Nama Siswa', 'NIS', 'Kelas', 'Jam Datang', 'Jam Pulang', 'Keterangan', 'Status'],
            data: List.generate(_filteredData.length, (i) {
              final d = _filteredData[i];
              return [
                '${i + 1}',
                d["nama"],
                d["nis"],
                d["kelas"],
                d["jamDatang"],
                d["jamPulang"],
                d["terlambat"] != null ? "Terlambat (${d["terlambat"]})" : "-",
                d["status"],
              ];
            }),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
              color: PdfColors.white,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
            cellStyle: const pw.TextStyle(fontSize: 9),
            oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey50),
            cellAlignments: {
              0: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.center,
              5: pw.Alignment.center,
              7: pw.Alignment.center,
            },
            columnWidths: {
              0: const pw.FixedColumnWidth(25),
              2: const pw.FixedColumnWidth(80),
              3: const pw.FixedColumnWidth(40),
              4: const pw.FixedColumnWidth(60),
              5: const pw.FixedColumnWidth(60),
              7: const pw.FixedColumnWidth(55),
            },
          ),

          pw.SizedBox(height: 16),
          pw.Text(
            'Dicetak pada: ${DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ],
      ),
    );

    // Share/download PDF
    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: 'Monitoring_Kehadiran_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf',
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header ──
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Monitoring Kehadiran",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1C24),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text("Data Realtime: ",
                                        style: TextStyle(
                                            color: Colors.blueGrey[400],
                                            fontSize: 13)),
                                    Text(
                                      _getFormattedDate(),
                                      style: const TextStyle(
                                        color: Color(0xFF6C63FF),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),

                            // Export Dropdown
                            _buildExportDropdown(),
                            const SizedBox(width: 10),

                            // Refresh
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: IconButton(
                                onPressed: () => setState(() {}),
                                icon: const Icon(Icons.refresh_rounded,
                                    color: Color(0xFF6C63FF)),
                                tooltip: "Refresh",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // ── Table Card ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Show", style: TextStyle(fontSize: 13)),
                                  const SizedBox(width: 8),
                                  _buildDropdown(
                                    ["10", "25", "50"],
                                    _showCount.toString(),
                                    (v) => setState(() {
                                      _showCount = int.parse(v!);
                                      _currentPage = 0;
                                    }),
                                  ),
                                  const SizedBox(width: 12),
                                  _buildDropdown(
                                    _statusList,
                                    _selectedStatus,
                                    (v) => setState(() {
                                      _selectedStatus = v!;
                                      _currentPage = 0;
                                    }),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 250,
                                    child: TextField(
                                      onChanged: (v) => setState(() {
                                        _searchQuery = v;
                                        _currentPage = 0;
                                      }),
                                      decoration: InputDecoration(
                                        hintText: "Cari Nama / Kelas...",
                                        hintStyle: const TextStyle(
                                            fontSize: 13, color: Color(0xFFB0B8C1)),
                                        prefixIcon: const Icon(Icons.search,
                                            size: 18, color: Color(0xFFB0B8C1)),
                                        filled: true,
                                        fillColor: const Color(0xFFF5F6FA),
                                        contentPadding:
                                            const EdgeInsets.symmetric(vertical: 10),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(
                                      const Color(0xFFF5F6FA)),
                                  headingTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                    letterSpacing: 0.5,
                                  ),
                                  dataRowMinHeight: 64,
                                  dataRowMaxHeight: 64,
                                  columnSpacing: 24,
                                  columns: const [
                                    DataColumn(label: Text("NO")),
                                    DataColumn(label: Text("SISWA")),
                                    DataColumn(label: Text("KELAS")),
                                    DataColumn(label: Text("JAM DATANG")),
                                    DataColumn(label: Text("JAM PULANG")),
                                    DataColumn(label: Text("KETERANGAN WAKTU")),
                                    DataColumn(label: Text("STATUS KEHADIRAN")),
                                  ],
                                  rows: List.generate(_pagedData.length, (i) {
                                    final data = _pagedData[i];
                                    final globalIndex = _currentPage * _showCount + i + 1;
                                    return DataRow(cells: [
                                      DataCell(Text("$globalIndex",
                                          style: const TextStyle(color: Color(0xFF64748B)))),
                                      DataCell(Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(data["nama"],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600, fontSize: 14)),
                                          Text(data["nis"],
                                              style: TextStyle(
                                                  fontSize: 12, color: Colors.blueGrey[400])),
                                        ],
                                      )),
                                      DataCell(Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: _kelasColor(data["kelas"]).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(data["kelas"],
                                            style: TextStyle(
                                              color: _kelasColor(data["kelas"]),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            )),
                                      )),
                                      DataCell(Text(data["jamDatang"])),
                                      DataCell(Text(data["jamPulang"])),
                                      DataCell(data["terlambat"] != null
                                          ? Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(0.08),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(Icons.access_time_rounded,
                                                      size: 13, color: Colors.red),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "Terlambat (${data["terlambat"]})",
                                                    style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const Text("-",
                                              style: TextStyle(color: Color(0xFFB0B8C1)))),
                                      DataCell(Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _statusColor(data["status"]).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(data["status"],
                                            style: TextStyle(
                                              color: _statusColor(data["status"]),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            )),
                                      )),
                                    ]);
                                  }),
                                ),
                              ),

                              const SizedBox(height: 20),

                              Row(
                                children: [
                                  Text(
                                    "Menampilkan ${_filteredData.isEmpty ? 0 : _currentPage * _showCount + 1} - "
                                    "${(_currentPage * _showCount + _pagedData.length)} dari ${_filteredData.length} data",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.blueGrey[400]),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: _currentPage > 0
                                        ? () => setState(() => _currentPage--)
                                        : null,
                                    child: const Text("Prev"),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    onPressed: _currentPage < _totalPages - 1
                                        ? () => setState(() => _currentPage++)
                                        : null,
                                    child: const Text("Next"),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ EXPORT DROPDOWN BUTTON
  Widget _buildExportDropdown() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'excel') _exportExcel();
        if (value == 'pdf') _exportPdf();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 44),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'excel',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E7E34).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.table_chart_outlined,
                    color: Color(0xFF1E7E34), size: 18),
              ),
              const SizedBox(width: 10),
              const Text("Export Excel",
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'pdf',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.picture_as_pdf_outlined,
                    color: Colors.red, size: 18),
              ),
              const SizedBox(width: 10),
              const Text("Export PDF",
                  style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF6C63FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Icon(Icons.download_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text("Export",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 13))))
              .toList(),
          onChanged: onChanged,
          style: const TextStyle(color: Color(0xFF1A1C24), fontSize: 13),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ),
      ),
    );
  }
}