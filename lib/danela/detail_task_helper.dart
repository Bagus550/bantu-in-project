import 'dart:convert';

import 'package:bantuin/config/app_config.dart';
import 'package:bantuin/utils/currency_extension.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DetailTugasHelper extends StatefulWidget {
  final Map<String, dynamic> taskData;
  final Map<String, dynamic>? userData;
  final String? token;
  final bool adaTugasAktif;

  const DetailTugasHelper({
    super.key,
    required this.taskData,
    this.userData,
    this.token,
    required this.adaTugasAktif,
  });

  @override
  State<DetailTugasHelper> createState() => _DetailTugasState();
}

class _DetailTugasState extends State<DetailTugasHelper> {
  bool _sedangMemproses = false;

  String formatJam(String? tanggalRaw) {
    if (tanggalRaw == null || tanggalRaw.isEmpty) return "--:--";

    try {
      DateTime dateTime = DateTime.parse(tanggalRaw);

      return DateFormat("d MMMM yyyy, 'pukul' HH:mm", 'id').format(dateTime);
    } catch (e) {
      return "-";
    }
  }

  Future<void> _eksekusiAmbilTugas() async {
    if (widget.adaTugasAktif) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Selesaikan dulu tugas aktifmu saat ini sebelum mengambil tugas baru!",
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    bool konfirmasi =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Ambil Tugas"),
            content: const Text("Apakah kamu yakin ambil tugas ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Ya, Ambil"),
              ),
            ],
          ),
        ) ??
        false;

    if (!konfirmasi) return;

    setState(() {
      _sedangMemproses = true;
    });

    try {
      final String takeTaskUrl = AppConfig.ambilTugas;
      final String idHelperLogin = widget.userData?['id']?.toString() ?? '1';

      final respon = await http.post(
        Uri.parse(takeTaskUrl),
        headers: {'Authorization': 'Bearer ${widget.token}'},
        body: {
          'id_task': widget.taskData['id_task'].toString(),
          'id_helper': idHelperLogin,
        },
      );

      if (respon.statusCode == 200) {
        final jsonRespon = json.decode(respon.body);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(jsonRespon['message'] ?? "Tugas Berhasil diambil!"),
          ),
        );

        // Tutup halaman detail dan kirim sinyal 'true' agar dashboard auto-refresh
        Navigator.pop(context, true);
      } else {
        final jsonRespon = json.decode(respon.body);
        throw Exception(jsonRespon['messages'] ?? "Gagal mengambil tugas");
      }
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Gagal"),
          content: Text(e.toString().replaceAll("Exception:", "")),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sedangMemproses = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String judul = widget.taskData['judul_tugas'] ?? 'Tidak ada judul';
    final String harga = widget.taskData['nominal_pembayaran'] ?? 'Rp 0';
    final String lokasi = widget.taskData['lokasi_tugas'] ?? 'Tidak ada lokasi';
    final String deskripsi =
        widget.taskData['deskripsi'] ?? 'Tidak ada deskripsi';
    final String namaPelanggan = widget.taskData['nama_requester'] ?? 'Anonim';
    final String waktu = widget.taskData['created_at'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Bantu.In", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        toolbarHeight: 80,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://picsum.photos/199'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            judul,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      harga.toString().toRupiah(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.timer_sharp, size: 15, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(formatJam(waktu), style: TextStyle(fontSize: 13)),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.black,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            lokasi,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Deskripsi",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    deskripsi,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Pelanggan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.account_circle, size: 36, color: Colors.black),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          namaPelanggan,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Icon(Icons.verified, color: Colors.green,)
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 24),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _sedangMemproses ? null : _eksekusiAmbilTugas,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(25),
                  ),
                  elevation: 0,
                ),
                child: _sedangMemproses
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        "Ambil Tugas",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
