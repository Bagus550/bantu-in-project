import 'package:bantuin/data_tugas.dart';
import 'package:flutter/material.dart';

class NotifikasiRequester extends StatefulWidget {
  const NotifikasiRequester({super.key});

  @override
  State<NotifikasiRequester> createState() => _NotifikasiRequesterState();
}

class _NotifikasiRequesterState extends State<NotifikasiRequester> {
  IconData ambilIconNotif(String type) {
    switch (type) {
      case "completed":
        return Icons.done;
      case "helper_found":
        return Icons.info;
      case "cancelled":
        return Icons.clear;
      default:
        return Icons.help_outline;
    }
  }

  Color ambilWarnaNotif(String type) {
    switch (type) {
      case "completed":
        return Colors.green;
      case "helper_found":
        return Colors.blue;
      case "cancelled":
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notifikasi",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Clear Notification",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: notifikasiRequester.length,
                itemBuilder: (context, index) {
                  final notif = notifikasiRequester[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ambilWarnaNotif(notif['type']),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: ambilWarnaNotif(notif['type']),
                              ),
                              child: Icon(
                                ambilIconNotif(notif['type']),
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notif['title'],
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(notif['description']),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
