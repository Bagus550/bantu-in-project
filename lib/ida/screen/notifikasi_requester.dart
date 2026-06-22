import 'dart:convert';
import 'package:bantuin/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotifikasiRequester extends StatefulWidget {
  final int idUser;

  const NotifikasiRequester({super.key, required this.idUser});

  @override
  State<NotifikasiRequester> createState() => _NotifikasiRequesterState();
}

class _NotifikasiRequesterState extends State<NotifikasiRequester> {
  final String apiUrl = AppConfig.notif;
  List<dynamic> listNotifikasi = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ambilDataNotifikasi();
  }

  Future<void> ambilDataNotifikasi() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('$apiUrl/${widget.idUser}'));

      if (response.statusCode == 200) {
        setState(() {
          listNotifikasi = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Gagal mengambil data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Koneksi bermasalah: $e")));
    }
  }

  IconData ambilIconNotif(String type) {
    switch (type) {
      case "selesai":
        return Icons.done;
      case "berjalan":
      case "menunggu_validasi":
      case "mencari_helper":
        return Icons.info;
      case "dibatalkan":
        return Icons.clear;
      default:
        return Icons.help_outline;
    }
  }

  Color ambilWarnaNotif(String type) {
    switch (type) {
      case "selesai":
        return Colors.green;
      case "berjalan":
        return Colors.blue;
      case "menunggu_validasi":
        return Colors.orange;
      case "mencari_helper":
        return Colors.teal;
      case "dibatalkan":
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
                const Text(
                  "Notifikasi",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      listNotifikasi.clear();
                    });
                  },
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
            const SizedBox(height: 30),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : listNotifikasi.isEmpty
                  ? const Center(child: Text("Tidak ada notifikasi baru"))
                  : RefreshIndicator(
                      onRefresh: ambilDataNotifikasi,
                      child: ListView.builder(
                        itemCount: listNotifikasi.length,
                        itemBuilder: (context, index) {
                          final notif = listNotifikasi[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ambilWarnaNotif(notif['type'] ?? ''),
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
                                        color: ambilWarnaNotif(
                                          notif['type'] ?? '',
                                        ),
                                      ),
                                      child: Icon(
                                        ambilIconNotif(notif['type'] ?? ''),
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ), // Memberi jarak agar tidak menempel
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notif['title'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(notif['description'] ?? ''),
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
            ),
          ],
        ),
      ),
    );
  }
}
