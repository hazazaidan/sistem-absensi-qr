import 'package:flutter/material.dart';
import '../models/absensi_model.dart';
import 'status_badge.dart';

class AbsensiTable extends StatelessWidget {
  final List<AbsensiModel> data;

  const AbsensiTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text("Nama")),
        DataColumn(label: Text("Status")),
      ],
      rows: data.map((e) {
        return DataRow(cells: [
          DataCell(Text(e.nama)),
          DataCell(StatusBadge(status: e.status)),
        ]);
      }).toList(),
    );
  }
}