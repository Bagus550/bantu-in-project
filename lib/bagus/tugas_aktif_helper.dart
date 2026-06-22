import 'dart:convert';

import 'package:bantuin/bagus/upload_bukti.dart';
import 'package:bantuin/danela/roomchat.dart';
import 'package:bantuin/config/app_config.dart';
import 'package:bantuin/utils/currency_extension.dart';
import 'package:flutter/material.dart';
import 'package:bantuin/utils/task_extension.dart';
import 'package:http/http.dart' as http;

class TugasAktifHelper extends StatefulWidget {
  final Map<String, dynamic> detailTugas;
  const TugasAktifHelper({super.key, required this.detailTugas});

  @override
  State<TugasAktifHelper> createState() => _TugasAktifHelperState();
}

class _TugasAktifHelperState extends State<TugasAktifHelper> {
  bool _isLoading = false;
  String _currentStatusTask = "Berjalan";

  @override
  void initState() {
    super.initState();
    if (widget.detailTugas.containsKey('status_task') &&
        widget.detailTugas['status_task'] != null) {
      _currentStatusTask = widget.detailTugas['status_task'].toString();
    }
  }

  Future<void> _updateStatusTaskBackend(String statusBaru) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String idTask = widget.detailTugas['id_task'].toString();

      final response = await http.post(
        Uri.parse(AppConfig.updateStatus),
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id_task': idTask, 'status_task': statusBaru}),
      );

      final hasilJson = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _currentStatusTask = statusBaru;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              hasilJson['message'] ?? "Status tugas berhasil diperbarui!",
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              hasilJson['message'] ?? "Gagal merubah status di server.",
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan koneksi: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.detailTugas.isEmpty) {
      return const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Kamu belum mengambil tugas apapun.\nSilakan cari bantuan tersedia di halaman Home.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    final String namaRequester =
        widget.detailTugas['nama_requester'] ?? 'Tanpa Nama';
    final String harga = widget.detailTugas['nominal_pembayaran'] ?? 0;
    final String lokasi = widget.detailTugas['lokasi_tugas'] ?? 'Tanpa Lokasi';
    final String judulTugas =
        widget.detailTugas['judul_tugas'] ?? 'Detail Tugas';
    final String idTugas = widget.detailTugas.toProfessionalId();

    bool isBerjalan = _currentStatusTask == 'berjalan';
    bool isMenungguValidasi = _currentStatusTask == 'menunggu_validasi';
    bool isSelesai = _currentStatusTask == 'selesai';

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFDEDCFF),
                          border: Border.all(
                            color: const Color(0xFF4D49E9),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4D49E9),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDEDCFF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isBerjalan
                                        ? Icons.refresh
                                        : (_currentStatusTask == 'selesai_kerja'
                                              ? Icons.payments_outlined
                                              : Icons
                                                    .admin_panel_settings_outlined),
                                    color: const Color(0xFF4D49E9),
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isBerjalan
                                          ? "Tugas Berlangsung"
                                          : (_currentStatusTask ==
                                                    'selesai_kerja'
                                                ? "Pekerjaan Selesai (Konfirmasi Upah)"
                                                : "Menunggu Validasi Admin"),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4D49E9),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isBerjalan
                                          ? "Kerjakan tugas sesuai jenis layanan dan konfirmasi selesai jika pekerjaan sudah selesai."
                                          : (_currentStatusTask ==
                                                    'selesai_kerja'
                                                ? "Kamu telah menyelesaikan pekerjaan! Pastikan upah dari requester sudah kamu terima dengan aman, lalu klik tombol di bawah untuk kirim bukti ke admin."
                                                : "Bukti pembayaran/transfer sudah dikirim ke server. Harap tunggu admin memvalidasi transaksi Anda untuk menutup tugas."),
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Container(
                      width: 85,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4D49E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ID TUGAS",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    idTugas,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "JUDUL TUGAS",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        judulTugas,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "REQUESTER",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            child: Icon(Icons.person, size: 30),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            namaRequester,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text("Hubungi via Chat"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RoomChatPage(namaData: widget.detailTugas),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
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
                      const Text(
                        "NOMINAL KOMISI / UPAH",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          harga.toString().toRupiah(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
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
                      const Text(
                        "RINCIAN LOKASI TUGAS",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      Row(
                        children: [
                          Icon(
                            Icons.add_task_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          const Text("24 Okt 2023, 14.30 WIB"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(lokasi)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              if (!isSelesai)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: isBerjalan
                                  ? Theme.of(context).colorScheme.primary
                                  : (_currentStatusTask == 'selesai_kerja'
                                        ? Colors.orange.shade700
                                        : Colors.grey.shade400),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: (_isLoading || isMenungguValidasi)
                                ? null
                                : () async {
                                    if (isBerjalan) {
                                      await _updateStatusTaskBackend(
                                        'selesai_kerja',
                                      );
                                    } else if (_currentStatusTask ==
                                        'selesai_kerja') {
                                      final bool? berhasilUpload =
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UploadBuktiTab(
                                                    idTask: widget
                                                        .detailTugas['id_task']
                                                        .toString(),
                                                  ),
                                            ),
                                          );

                                      if (berhasilUpload == true) {
                                        setState(() {
                                          _currentStatusTask =
                                              'menunggu_validasi';
                                        });
                                      }
                                    }
                                  },
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    isBerjalan
                                        ? "Konfirmasi Tugas Selesai"
                                        : (_currentStatusTask == 'selesai_kerja'
                                              ? "Konfirmasi Upah Diterima"
                                              : "Menunggu Validasi Admin"),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            isBerjalan
                                ? "Gunakan fitur chat di atas untuk koordinasi lapangan dengan pemesan."
                                : (_currentStatusTask == 'selesai_kerja'
                                      ? "Pekerjaan ditandai selesai! Pastikan upah sudah aman, lalu klik tombol di atas untuk upload bukti ke admin."
                                      : "Bukti transfer telah dikirim. Menunggu admin memverifikasi pekerjaan Anda."),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Pastikan Anda telah menerima dana sebelum melakukan konfirmasi.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
