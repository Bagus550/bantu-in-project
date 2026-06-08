import 'package:bantuin/data_tugas.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  IconData ambilIconBantuan(String kategori_layanan) {
    switch (kategori_layanan) {
      case 'BantuFix':
        return Icons.home_repair_service_outlined;
      case 'BantuClean':
        return Icons.cleaning_services_outlined;
      case 'BantuShop':
        return Icons.shopping_cart_outlined;
      case 'BantuStudy':
        return Icons.school;
      default:
        return Icons.grid_view_rounded;
    }
  }

  Color ambilWarnaStatus(String status) {
    switch (status) {
      case 'Mencari helper':
        return const Color.fromARGB(255, 255, 158, 79);
      case 'Berjalan':
        return Color(0xFF283593);
      case 'Menunggu validasi':
        return Colors.teal.shade800;
      case 'Selesai':
        return Colors.green.shade800;
      case 'Dibatalkan':
        return Color(0xFFCD2528);
      default:
        return Color(0xFF283593);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final histori = tasks[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0XFFDFDDF5),
                                  ),
                                  child: Icon(
                                    ambilIconBantuan(
                                      histori['kategori_layanan'],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              histori['judul_tugas'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text("23 Mei 2026"),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        histori['nominal_pembayaran'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.grey.shade300, thickness: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(histori['nama_helper'] ?? 'Tanpa Nama'),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: ambilWarnaStatus(histori['status']),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      histori['status'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
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
