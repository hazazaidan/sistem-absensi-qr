import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String value;

  const CustomCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: const TextStyle(fontSize: 24)),
            Text(title),
          ],
        ),
      ),
    );
  }
}