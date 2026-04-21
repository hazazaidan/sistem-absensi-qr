import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black12,
          )
        ],
      ),
      child: Row(
        children: [
          // 🔥 TITLE
          const Text(
            "Dashboard",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Spacer(),

          // 🔥 PROFILE
          Row(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 10),
              Text("Guru"),
            ],
          ),

          const SizedBox(width: 20),

          // 🔥 LOGOUT BUTTON
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.login,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}