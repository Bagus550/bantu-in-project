import 'dart:convert';

import 'package:bantuin/bagus/upload_bukti.dart';
import 'package:bantuin/danela/roomchat.dart';
import 'package:bantuin/config/app_config.dart';
import 'package:bantuin/utils/currency_extension.dart';
import 'package:bantuin/utils/date_time_utils.dart';
import 'package:flutter/material.dart';
import 'package:bantuin/utils/task_extension.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class TugasAktifHelper extends StatefulWidget {
  final Map<String, dynamic> detailTugas;
  const TugasAktifHelper({super.key, required this.detailTugas});

  @override
  State<TugasAktifHelper> createState() => _TugasAktifHelperState();
}

class _TugasAktifHelperState extends State<TugasAktifHelper> {
  bool _isLoading = false;
  String _currentStatusTask = "berjalan";

  @override
  void initState() {
    super.initState();
    if (widget.detailTugas.containsKey('status_task') &&
        widget.detailTugas['status_task'] != null) {
      _currentStatusTask = widget.detailTugas['status_task']
          .toString()
          .trim()
          .toLowerCase()
          .replaceAll(' ', '_');
    }
  }

  String formatTanggalWaktu(String? tanggalRaw) {
    if (tanggalRaw == null || tanggalRaw.toString().isEmpty) return '-';

    try {
      DateTime waktuTugas = DateTimeUtils.toLocalDateTime(
        tanggalRaw.toString(),
      );
      DateTime sekarang = DateTime.now();

      String jamMenit = DateFormat('HH.mm').format(waktuTugas);

      DateTime tanggalTugas = DateTime(
        waktuTugas.year,
        waktuTugas.month,
        waktuTugas.day,
      );
      DateTime tanggalSekarang = DateTime(
        sekarang.year,
        sekarang.month,
        sekarang.day,
      );

      int selisihHari = tanggalSekarang.difference(tanggalTugas).inDays;

      if (selisihHari == 0) {
        return "Hari ini, $jamMenit WIB";
      } else if (selisihHari == 1) {
        return "Kemarin, $jamMenit WIB";
      } else {
        String tanggalLengkap = DateFormat(
          'd MMM yyyy',
          'id',
        ).format(waktuTugas);
        return "$tanggalLengkap, $jamMenit WIB";
      }
    } catch (e) {
      return '-';
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

  void _tampilkanModalCatatanAdmin(BuildContext context, String catatan) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red),
                  const SizedBox(width: 10),
                  Text(
                    "Alasan Validasi Ditolak",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade900,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20, thickness: 1),
              const Text(
                "Catatan dari Admin:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  catatan,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Saya Paham, Tutup"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImageModal(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
    final String judulTugas =
        widget.detailTugas['judul_tugas'] ?? 'Detail Tugas';
    final String idTugas = widget.detailTugas.toProfessionalId();
    final String tanggalDatabase =
        widget.detailTugas['created_at'] ??
        widget.detailTugas['waktu'] ??
        widget.detailTugas['tanggal'] ??
        '';
    final String alamatLokasi =
        ((widget.detailTugas['lokasi_tugas'] ?? widget.detailTugas['lokasi']) ??
                '')
            .toString()
            .trim();

    String statusValidasiPembayaran =
        (widget.detailTugas['status_validasi'] ?? '')
            .toString()
            .trim()
            .toLowerCase()
            .replaceAll(' ', '_');
    bool isMenungguValidasi =
        _currentStatusTask == 'menunggu_validasi' ||
        statusValidasiPembayaran == 'menunggu_validasi';

    bool isTidakValid =
        (_currentStatusTask == 'tidak_valid' ||
            statusValidasiPembayaran == 'tidak_valid') &&
        !isMenungguValidasi;

    String catatanAdmin =
        widget.detailTugas['catatan_admin'] ??
        'Tidak ada catatan khusus dari admin.';

    bool isBerjalan = _currentStatusTask == 'berjalan' && !isTidakValid;
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
                          // ignore: use_full_hex_values_for_flutter_colors
                          color: isTidakValid
                              ? const Color(0XFFFFF5F5)
                              : const Color(0xFFDEDCFF),
                          border: Border.all(
                            color: isTidakValid
                                ? Colors.red.shade300
                                : const Color(0xFF4D49E9),
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
                                    isTidakValid
                                        ? Icons.gpp_bad_outlined
                                        : (isBerjalan
                                              ? Icons.refresh
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
                                      isTidakValid
                                          ? "Validasi Ditolak Admin"
                                          : (isBerjalan
                                                ? "Tugas Berlangsung"
                                                : "Menunggu Validasi Admin"),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4D49E9),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isTidakValid
                                          ? "Bukti yang dikirim sebelumnya dinyatakan TIDAK VALID oleh admin. Harap baca catatan penolakan di bawah dan unggah ulang bukti."
                                          : (isBerjalan
                                                ? "Kerjakan tugas sesuai jenis layanan dan konfirmasi selesai jika pekerjaan sudah selesai."
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
                          Text(formatTanggalWaktu(tanggalDatabase)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              alamatLokasi,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),

                        ],
                      ),
                      Builder(
                        builder: (context) {
                          double? lat;
                          double? lng;

                          final rawLat =
                              widget.detailTugas['latitude_tugas'] ??
                              widget.detailTugas['latitude'];
                          final rawLng =
                              widget.detailTugas['longitude_tugas'] ??
                              widget.detailTugas['longitude'];

                          if (rawLat != null && rawLng != null) {
                            lat = double.tryParse(rawLat.toString());
                            lng = double.tryParse(rawLng.toString());
                          }

                          if (lat != null && lng != null) {
                            return Container(
                              height: 180, // Tinggi peta
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 15),
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
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "PEMBAYARAN",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showImageModal(context, 'assets/logo/QRIS.jpeg');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1E3A8A),
                            side: const BorderSide(
                              color: Color(0xFF1E3A8A),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text("Tampilkan QRIS"),
                        ),
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
                        if (isTidakValid)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.red.shade700,
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    "Validasi Ditolak Admin! Silakan upload ulang bukti yang benar.",
                                    style: TextStyle(
                                      color: Color(0xFFCD2528),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: isTidakValid
                                  ? Colors.red.shade700
                                  : (isBerjalan
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade400),
                              foregroundColor: Colors.white,
                            ),
                            onPressed:
                                (_isLoading ||
                                    (isMenungguValidasi && !isTidakValid))
                                ? null
                                : () async {
                                    if (isBerjalan || isTidakValid) {
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
                                        await _updateStatusTaskBackend(
                                          'menunggu_validasi',
                                        );
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
                                    isTidakValid
                                        ? "Upload Ulang Bukti Transaksi"
                                        : (isBerjalan
                                              ? "Konfirmasi Tugas Selesai & Upload Bukti"
                                              : "Menunggu Validasi Admin"),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                          ),
                        ),
                        if (isTidakValid) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton.icon(
                              onPressed: () {
                                _tampilkanModalCatatanAdmin(
                                  context,
                                  catatanAdmin,
                                );
                              },
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.orange,
                              ),
                              label: Text(
                                "Lihat Catatan Penolakan Admin",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              isTidakValid
                                  ? "Periksa catatan admin di atas sebelum mengunggah kembali."
                                  : (isBerjalan
                                        ? "Pastikan pekerjaan selesai dan upah sudah diterima sebelum mengunggah bukti."
                                        : "Bukti transfer telah dikirim. Menunggu admin memverifikasi pekerjaan Anda."),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
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
