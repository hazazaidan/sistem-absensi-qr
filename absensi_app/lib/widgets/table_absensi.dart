import 'package:flutter/material.dart';

class TableAbsensi extends StatelessWidget {
  const TableAbsensi({super.key});

  DataRow row(String nama, String status, String jam) {
    return DataRow(
      cells: [
        DataCell(Text(nama)),
        DataCell(
          Text(
            status,
            style: TextStyle(
              color: status == "Hadir"
                  ? Colors.green
                  : status == "Izin"
                      ? Colors.orange
                      : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(Text(jam)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black12,
          )
        ],
      ),
      child: DataTable(
        columns: const [
          DataColumn(label: Text("Nama")),
          DataColumn(label: Text("Status")),
          DataColumn(label: Text("Jam Masuk")),
        ],
        rows: [
          row("Ahmad", "Hadir", "07:10"),
          row("Budi", "Izin", "-"),
          row("Citra", "Alfa", "-"),
        ],
      ),
    );
  }
}