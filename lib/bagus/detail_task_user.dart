import 'dart:convert';

import 'package:bantuin/config/app_config.dart';
import 'package:bantuin/danela/roomchat.dart';
import 'package:bantuin/utils/currency_extension.dart';
import 'package:bantuin/utils/task_extension.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/date_time_utils.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DetailTugas extends StatefulWidget {
  final Map<String, dynamic> taskData;
  const DetailTugas({super.key, required this.taskData});

  @override
  State<DetailTugas> createState() => _DetailTugasState();
}

class _DetailTugasState extends State<DetailTugas> {
  Color ambilWarnaStatus(String status) {
    switch (status) {
      case 'Mencari helper':
        return Color(0XFF4F46E5);
      case 'Berjalan':
        return Color(0XFFCDA325);
      case 'Menunggu validasi':
        return Color(0XFF9E9D9A);
      case 'Selesai':
        return Color(0XFF25CD25);
      case 'Dibatalkan':
      case 'tidak_valid':
        return Color(0XFFCD2525);
      default:
        return Color(0XFF9E9D9A);
    }
  }

  Color ambilWarnaIkonBantuan(String kategoriLayanan) {
    switch (kategoriLayanan) {
      case 'BantuFix':
        return Color(0xFF25CD25);
      case 'BantuClean':
        return Color(0xFF3525CD);
      case 'BantuShop':
        return Color(0XFFCACD25);
      case 'BantuStudy':
        return Color(0XFFCD2525);
      default:
        return Color(0XFFC7C7C7);
    }
  }

  Color ambilWarnaTombol(String status) {
    switch (status) {
      case 'Di batalkan' || 'Selesai':
        return Color(0xFF25CD25);
      case 'Berjalan':
        return Color(0XFFCD2525);
      default:
        return Color(0XFFCD2525);
    }
  }

  IconData ambilIkonTombol(String status) {
    switch (status) {
      case 'Di batalkan' || 'Selesai':
        return Icons.refresh;
      case 'Berjalan':
        return Icons.close;
      default:
        return Icons.close;
    }
  }

  IconData ambilIconStatus(String status) {
    switch (status) {
      case 'Mencari helper':
        return Icons.search;
      case 'Berjalan':
        return Icons.refresh;
      case 'Menunggu validasi':
        return Icons.warning_amber_rounded;
      case 'Dibatalkan':
        return Icons.clear;
      case 'Selesai':
        return Icons.check;
      case 'tidak_valid':
        return Icons.cancel;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String formatTanggal(String? tanggalRaw) {
    return DateTimeUtils.formatDateOnly(tanggalRaw);
  }

  bool _isLoadingBatal = false;

  Future<void> _batalkanTugas(String idTask) async {
    setState(() {
      _isLoadingBatal = true;
    });

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/api/tasks/ajuan-batal"),
        body: {'id_task': idTask},
      );

      final dataResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && dataResponse['status'] == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Tugas berhasil dibatalkan!"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                dataResponse['message'] ?? "Gagal membatalkan tugas",
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Terjadi kesalahan koneksi: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBatal = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.taskData;
    String statusTugas = widget.taskData['status'];
    bool isButtonActive =
        statusTugas != 'Mencari helper' && statusTugas != 'Selesai';
    String tanggalDatabase = data['created_at'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Tugas",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ambilWarnaStatus(data['status'] ?? ''),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 20,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            ambilIconStatus(data['status']),
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            data['status'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text("Dibuat: ${formatTanggal(tanggalDatabase)}"),
                ],
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['kategori_layanan'],
                        style: TextStyle(
                          color: ambilWarnaIkonBantuan(
                            data['kategori_layanan'],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data['judul_tugas'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4D49E9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "ID: ${data.toProfessionalId()}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0XFFF0ECF9),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nominal Pembayaran"),
                                Text(
                                  data['nominal_pembayaran']
                                          ?.toString()
                                          .toRupiah() ??
                                      'Rp 0',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF3525CD),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: Color(0xFF3525CD),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Deskripsi Tugas",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(data['deskripsi'] ?? "Tidak ada deskripsi"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFF3525CD),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Lokasi",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 5),
                        child: Text(
                          data['lokasi_tugas'] != null &&
                                  data['lokasi_tugas'].toString().isNotEmpty
                              ? data['lokasi_tugas']
                              : "Lokasi detail tidak disebutkan",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          double? lat;
                          double? lng;

                          if (data['latitude_tugas'] != null &&
                              data['longitude_tugas'] != null) {
                            lat = double.tryParse(
                              data['latitude_tugas'].toString(),
                            );
                            lng = double.tryParse(
                              data['longitude_tugas'].toString(),
                            );
                          }
                          if (lat != null && lng != null) {
                            return Container(
                              height: 180, // Tinggi peta
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(lat, lng),
                                  initialZoom: 16.0,
                                  interactionOptions: const InteractionOptions(
                                    // Matikan gestur biar peta nggak kegeser gak sengaja pas scroll halaman
                                    flags: InteractiveFlag.none,
                                  ),
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.bantu.in',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        point: LatLng(lat, lng),
                                        width: 40,
                                        height: 40,
                                        child: const Icon(
                                          Icons.location_pin,
                                          color: Color(0xFFCD2528),
                                          size: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 8),
                          child: CircleAvatar(
                            radius: 45,
                            child: Icon(Icons.person, size: 60),
                          ),
                        ),
                      ),
                      Text(
                        data['nama_helper'] != null
                            ? data["nama_helper"]
                            : "Belum ada helper",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(color: Colors.grey.shade300, thickness: 2),
                      SizedBox(
                        height: 45,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isButtonActive
                              ? () {
                                  Map<String, dynamic> kirimDataChat = {
                                    // Jika dari detail tugas belum ada id_room, kita pakai id_task sebagai fallback sementara
                                    'id_room':
                                        data['id_room'] ?? data['id_task'],
                                    'id_task': data['id_task'],
                                    'is_active': data['status'] == 'Berjalan'
                                        ? 1
                                        : 0,
                                    'nama_requester':
                                        data['nama_requester'] ?? 'Pelanggan',
                                    'nama_helper':
                                        data['nama_helper'] ?? 'Helper',
                                  };

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RoomChatPage(namaData: kirimDataChat),
                                    ),
                                  );
                                }
                              : null,
                          icon: Icon(Icons.chat_outlined),
                          label: Text("Chat dengan Helper"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.contact_support),
                  label: Text("Hubungi Bantuan"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final String statusTugas = (data['status'] ?? '')
                        .toString()
                        .trim()
                        .toLowerCase();

                    if (statusTugas == 'selesai' ||
                        statusTugas == 'dibatalkan') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Pesan Ulang"),
                            content: Text(
                              "Apakah kamu ingin membuat tugas baru dengan rincian yang sama seperti '${data['judul_tugas']}'?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Pesan Lagi",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      final idHelper = data['id_helper'];
                      final bool belumAdaHelper =
                          idHelper == null ||
                          idHelper == 0 ||
                          idHelper.toString() == '0' ||
                          idHelper.toString().isEmpty;

                      if (belumAdaHelper) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Konfirmasi Batal"),
                              content: const Text(
                                "Apakah kamu yakin ingin membatalkan tugas ini?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Tidak"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _batalkanTugas(
                                      widget.taskData['id_task'].toString(),
                                    );
                                  },
                                  child: const Text(
                                    "Ya, Batalkan",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                "Peringatan Penting!",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                "Tugas ini sudah diambil oleh helper dan sedang berjalan. Membatalkan sepihak bisa merugikan helper.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Kembali (Amankan Tugas)"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Yakin Tetap Batal?",
                                          ),
                                          content: const Text(
                                            "Pastikan kamu sudah berdiskusi dan nego dengan helper melalui fitur CHAT sebelum membatalkan tugas ini secara sepihak!",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text(
                                                "Batal, saya mau chat dulu",
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _batalkanTugas(
                                                  widget.taskData['id_task']
                                                      .toString(),
                                                );
                                              },
                                              child: const Text(
                                                "Saya Paham, Tetap Batalkan",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    "Lanjutkan Pembatalan",
                                    style: TextStyle(color: Colors.orange),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  icon: Icon(
                    (data['status'].toString().toLowerCase() == 'selesai' ||
                            data['status'].toString().toLowerCase() ==
                                'dibatalkan')
                        ? Icons.refresh
                        : Icons.clear,
                  ),
                  label: _isLoadingBatal
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFFCD2528),
                          ),
                        )
                      : (data['status'].toString().toLowerCase() == 'selesai' ||
                            data['status'].toString().toLowerCase() ==
                                'dibatalkan')
                      ? const Text("Pesan Ulang")
                      : const Text("Batalkan Tugas"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(
                      color:
                          (data['status'].toString().toLowerCase() ==
                                  'selesai' ||
                              data['status'].toString().toLowerCase() ==
                                  'dibatalkan')
                          ? Colors.blueAccent
                          : const Color(0xFFCD2528),
                      width: 1.5,
                    ),
                    foregroundColor:
                        (data['status'].toString().toLowerCase() == 'selesai' ||
                            data['status'].toString().toLowerCase() ==
                                'dibatalkan')
                        ? Colors.blueAccent
                        : const Color(0xFFCD2528),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Tugas dapat dibatalkan sebelum helper menerima pesanan. namun jika sudah diterima, pembatalan akan melibatkan persetujuan helper",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
