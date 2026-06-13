import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bantuin/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<dynamic> listHistoryAPI = [];
  bool isLoading = true;
  String errorPesan = '';

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    setState(() {
      isLoading = true;
      errorPesan = '';
    });

    try {
      final response = await http.get(Uri.parse(AppConfig.taskFeed));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> semuaTugas = responseData['data'] ?? [];

        setState(() {
          listHistoryAPI = semuaTugas.where((item) {
            String status = (item['status_task'] ?? '')
                .toString()
                .trim()
                .toLowerCase();
            return status == 'selesai' || status == 'dibatalkan';
          }).toList();

          isLoading = false;
        });
      } else {
        setState(() {
          errorPesan = "Gagal memuat history (${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorPesan = "Terjadi kesalahan jaringan: $e";
        isLoading = false;
      });
    }
  }

  String formatTanggal(String? tanggalRaw) {
    if (tanggalRaw == null || tanggalRaw.isEmpty) return '-';
    try {
      DateTime waktuTugas = DateTime.parse(tanggalRaw).toLocal();
      DateTime sekarang = DateTime.now();

      String jamMenit = DateFormat('HH.mm').format(waktuTugas);

      DateTime tanggalTugasSelesai = DateTime(
        waktuTugas.year,
        waktuTugas.month,
        waktuTugas.day,
      );
      DateTime tanggalSekarang = DateTime(
        sekarang.year,
        sekarang.month,
        sekarang.day,
      );

      int selisihHari = tanggalSekarang.difference(tanggalTugasSelesai).inDays;

      if (selisihHari == 0) {
        return "Hari ini, $jamMenit";
      } else if (selisihHari == 1) {
        return "Kemarin, $jamMenit";
      } else {
        String tanggalLengkap = DateFormat(
          'd MMMM yyyy',
          'id',
        ).format(waktuTugas);
        return "$tanggalLengkap, $jamMenit";
      }
    } catch (e) {
      return '-';
    }
  }

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
        child: Column(children: [Expanded(child: _buildBodyContent())]),
      ),
    );
  }

  Widget _buildBodyContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorPesan.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorPesan, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: fetchHistory,
              child: const Text("Coba Lagi"),
            ),
          ],
        ),
      );
    }

    if (listHistoryAPI.isEmpty) {
      return const Center(
        child: Text(
          "Belum ada riwayat tugas",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      itemCount: listHistoryAPI.length,
      itemBuilder: (context, index) {
        final histori = listHistoryAPI[index];
        final String statusTask = histori['status_task'] ?? 'Dibatalkan';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                          ambilIconBantuan(histori['kategori_layanan']),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    histori['judul_tugas'] ?? '-',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text("23 Mei 2026"),
                                ],
                              ),
                            ),
                            Text(
                              formatTanggal(histori['created_at']),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Rp ${histori['nominal_pembayaran']}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey.shade300, thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        histori['nama_helper'] ?? 'Belum ada helper',
                        style: TextStyle(
                          color: histori['nama_helper'] == null
                              ? Colors.grey
                              : Colors.black87,
                          fontSize: 13,
                        ),
                      ),
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
    );
  }
}
