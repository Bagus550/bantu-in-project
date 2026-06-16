import 'package:bantuin/data_tugas.dart';
import 'package:flutter/material.dart';

class NotificationsHelper extends StatefulWidget {
  const NotificationsHelper({super.key});

  @override
  State<NotificationsHelper> createState() => _NotificationsHelperState();
}

class _NotificationsHelperState extends State<NotificationsHelper> {
  IconData ambilIkonNotif(String judul_notifikasi) {
    switch (judul_notifikasi) {
      case 'Pembayaran Valid':
        return Icons.done;
      case 'Pembayaran Gagal':
        return Icons.close;
      default:
        return Icons.error_outline_outlined;
    }
  }

  Color ambilWarnaNotif(String judul_notifikasi) {
    switch (judul_notifikasi) {
      case 'Pembayaran Valid':
        return Theme.of(context).colorScheme.primary;
      case 'Pembayaran Gagal':
        return Colors.red;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  "Tandai semua dibaca",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: notifikasi.length,
              itemBuilder: (context, index) {
                final notif = notifikasi[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ambilWarnaNotif(notif['judul_notifikasi']),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ambilWarnaNotif(notif['judul_notifikasi']),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                ambilIkonNotif(notif['judul_notifikasi']),
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      notif['judul_notifikasi'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.grey.shade300,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 8,
                                        ),
                                        child: Text(notif['waktu']),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(notif['deskripsi']),
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Tandai sudah dibaca",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
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
    );
  }
}
