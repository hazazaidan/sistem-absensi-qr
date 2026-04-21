import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Topbar extends StatelessWidget {
  const Topbar({super.key});

  String _getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.menu, color: Colors.grey),
          const SizedBox(width: 20),
          const Text(
            "Dashboard",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3250),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          const VerticalDivider(indent: 20, endIndent: 20),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("HARI INI",
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text(
                _getFormattedDate(), // ✅ Tanggal otomatis
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(width: 15),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFFF3F4F9),
            child: Icon(Icons.person_outline,
                color: Color(0xFF6C63FF), size: 20),
          ),
        ],
      ),
    );
  }
}