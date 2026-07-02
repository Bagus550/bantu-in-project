import 'dart:convert';
import 'package:bantuin/utils/currency_extension.dart';
import 'package:bantuin/utils/date_time_utils.dart';
import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HistoryUser extends StatefulWidget {
  final String idRequester;
  const HistoryUser({super.key, required this.idRequester});

  @override
  State<HistoryUser> createState() => _HistoryUserState();
}

class _HistoryUserState extends State<HistoryUser> {
  final ScrollController _scrollController = ScrollController();

  List<dynamic> listHistoryAPI = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  final int perPage = 10;
  String errorPesan = '';

  @override
  void initState() {
    super.initState();
    fetchHistory(isFirstLoad: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!isLoading && !isLoadingMore && hasMoreData) {
          fetchHistory(isFirstLoad: false);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchHistory({required bool isFirstLoad}) async {
    if (isFirstLoad) {
      setState(() {
        isLoading = true;
        currentPage = 1;
        hasMoreData = true;
        listHistoryAPI.clear();
        errorPesan = '';
      });
    } else {
      setState(() {
        isLoadingMore = true;
      });
    }

    try {
      final basisUrl = Uri.parse(AppConfig.historyUser);
      final urlDenganParam = Uri(
        scheme: basisUrl.scheme,
        host: basisUrl.host,
        port: basisUrl.port,
        path: basisUrl.path,
        queryParameters: {
          'id_requester': widget.idRequester.toString(),
          'page': currentPage.toString(),
          'per_page': perPage.toString(),
        },
      );

      final response = await http.get(urlDenganParam);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> semuaTugasSelesai = responseData['data'] ?? [];

        setState(() {
          if (semuaTugasSelesai.length < perPage) {
            hasMoreData = false;
          }

          listHistoryAPI.addAll(semuaTugasSelesai);
          currentPage++;
          errorPesan = '';
        });
      } else {
        setState(() {
          errorPesan =
              "Gagal memuat data dari server (Status: ${response.statusCode}).";
        });
      }
    } catch (e) {
      setState(() {
        if (!mounted) return;
        setState(() {
          errorPesan = "Terjadi kesalahan koneksi: $e";
        });
      });
    } finally {
      if (mounted) {
      setState(() {
        isLoading = false;
        isLoadingMore = false;
      });
    }
    }
  }

  String formatTanggal(String? tanggalRaw) {
    if (tanggalRaw == null || tanggalRaw.isEmpty) return '-';
    try {
      DateTime waktuTugas = DateTimeUtils.toLocalDateTime(tanggalRaw);
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
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorPesan.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(errorPesan, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => fetchHistory(isFirstLoad: true),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Coba Lagi"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
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

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => fetchHistory(isFirstLoad: true),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: listHistoryAPI.length,
              itemBuilder: (context, index) {
                final histori = listHistoryAPI[index];
                final String statusTask =
                    histori['status_task'] ?? 'Dibatalkan';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
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
                                histori['nominal_pembayaran']
                                    .toString()
                                    .toRupiah(),
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
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
