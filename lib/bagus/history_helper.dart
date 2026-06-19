import 'dart:convert';
import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  final String idHelper;
  const History({super.key, required this.idHelper});

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
      final url = "${AppConfig.taskHistory}?id_helper=${widget.idHelper}";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        

        final List<dynamic> semuaTugasSelesai = responseData['data'] ?? [];

        setState(() {
          listHistoryAPI = semuaTugasSelesai;


          isLoading = false;
        });

      } else {
        setState(() {
          errorPesan = "Gagal memuat history (Status: ${response.statusCode})";
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

  IconData ambilIconBantuan(String? kategoriLayanan) {
    switch (kategoriLayanan) {
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
    switch (status.toLowerCase().trim()) {
      case 'mencari helper':
        return const Color.fromARGB(255, 255, 158, 79);
      case 'berjalan':
        return const Color(0xFF283593);
      case 'menunggu_validasi':
        return Colors.teal.shade800;
      case 'selesai':
        return Colors.green.shade800;
      case 'dibatalkan':
        return const Color(0xFFCD2528);
      default:
        return const Color(0xFF283593);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
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
        // Menggunakan 'status_task' secara konsisten sesuai filter API
        final String statusTask = histori['status_task'] ?? 'Dibatalkan';

        return RefreshIndicator(
          onRefresh: fetchHistory,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon Kategori
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0XFFDFDDF5),
                          ),
                          child: Icon(
                            ambilIconBantuan(histori['kategori_layanan']),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
          
                        // Detail Tugas (Judul & Tanggal)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                histori['judul_tugas'] ?? '-',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
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
                        const SizedBox(width: 8),
          
                        // Nominal Pembayaran
                        Text(
                          "Rp ${histori['nominal_pembayaran'] ?? '0'}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
          
                    const SizedBox(height: 8),
                    Divider(color: Colors.grey.shade200, thickness: 1),
                    const SizedBox(height: 4),
          
                    // Footer (Nama Helper & Status)
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
                            borderRadius: BorderRadius.circular(8),
                            color: ambilWarnaStatus(statusTask),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 10,
                          ),
                          child: Text(
                            statusTask,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
