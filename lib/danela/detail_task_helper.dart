import 'package:bantuin/bagus/screens/tugas_aktif_helper.dart';
import 'package:bantuin/danela/roomchat.dart';
import 'package:flutter/material.dart';

class DetailTugasHelper extends StatefulWidget {
  final Map<String, dynamic> taskData;
  const DetailTugasHelper({super.key, required this.taskData});

  @override
  State<DetailTugasHelper> createState() => _DetailTugasState();
}

class _DetailTugasState extends State<DetailTugasHelper> {
  @override
  Widget build(BuildContext context) {
    final String judul = widget.taskData['judul_tugas'] ?? 'Tidak ada judul';
    final String harga = widget.taskData['nominal_pembayaran'] ?? 'Rp 0';
    final String lokasi = widget.taskData['lokasi_tugas'] ?? 'Tidak ada lokasi';
    final String deskripsi =
        widget.taskData['deskripsi'] ?? 'Tidak ada deskripsi';
    final String namaPelanggan = widget.taskData['nama_requester'] ?? 'Anonim';

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
                      child: Text(
                        judul,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      harga,
                      style: TextStyle(
                        fontSize: 15,
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
                    Text("Hari ini, 09.25", style: TextStyle(fontSize: 13)),
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

                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RoomChatPage(namaData: widget.taskData),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TugasAktifHelper(detailTugas: widget.taskData),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(25),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Terima Bantuan",
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
