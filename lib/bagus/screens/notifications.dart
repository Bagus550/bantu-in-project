import 'package:flutter/material.dart';

class NotificationsTab extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;

  const NotificationsTab({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Notifikasi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(child: Center(child: Text("Konten Notifications di Sini"))),
        ],
      ),
    );
  }
}
