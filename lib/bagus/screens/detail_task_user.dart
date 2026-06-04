import 'package:bantuin/danela/roomchat.dart';
import 'package:bantuin/data_tugas.dart';
import 'package:flutter/material.dart';

class DetailTugas extends StatefulWidget {
  final Map<String, dynamic> dataTugas;
  const DetailTugas({super.key, required this.dataTugas});

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
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.dataTugas;
    String statusTugas = widget.dataTugas['status'];
    bool isButtonActive =
        statusTugas != 'Mencari helper' && statusTugas != 'Selesai';

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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(radius: 30, child: Icon(Icons.person)),
          ),
        ],
        foregroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Colors.grey.shade300, height: 1),
        ),
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
                  Text("Dibuat: 24 Oktober 2023"),
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
                      Text(
                        data['judul_tugas'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                                  data['nominal_pembayaran'] ?? '0',
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
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          data['lokasi_tugas'] ?? "Lokasi tidak ditentukan",
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
                        data['nama_helper'] != null &&
                                data['nama_helper'].toString().trim().isEmpty
                            ? 'Belum ada helper'
                            : data['nama_helper'],
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RoomChatPage(namaData: widget.dataTugas,),
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
                  onPressed: () {},
                  icon: Icon(Icons.cancel_outlined),
                  label: Text("Batalkan Tugas"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.red, width: 1.5),
                    foregroundColor: Colors.red,
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
