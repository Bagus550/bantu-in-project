import 'package:flutter/material.dart';

class FaqUser extends StatelessWidget {
  const FaqUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Color(0xFFF8FAFC), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo/logo.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Bantu.in",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      "Temukan Jawaban Anda",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Punya Pertanyaan? Cari jawabannya disini atau hubungi kami",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Apa itu Bantu.In?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Bantu.in merupakan platform yang menghubungkan pengguna dengan penyedia jasa atau tenaga bantuan terpercaya untuk membantu menyelesaikan berbagai kebutuhan sehari-hari secara cepat dan mudah.",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Divider(color: Colors.grey.shade300, thickness: 2),
                  ),
                  Text(
                    "Bagaimana cara memesan jasa?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "1. Pesan Bantuan dengan mengklik tombol + di bottom navigation.",
                        ),
                        Text(
                          "2. Anda bisa mengisi bagian judul dengan nama bantuan yang di buat.",
                        ),
                        Text(
                          "3. Isikan deskripsi untuk keterangan lebih lengkap terkait bantuan yang ada buat.",
                        ),
                        Text(
                          "4. Untuk lokasi bisa dibuat sendiri dengan menggunakan patokan jalan atau otomatis dari alamat akun. ",
                        ),
                        Text(
                          "5. Buat nominal pembayaran berdasarkan jenis bantuan dan berat bantuan, setiap jenis bantuan memiliki minimum bayar yang berbeda.",
                        ),
                        Text(
                          "6. Klik posting bantuan untuk mempublikasikan bantuan anda agar terlacak oleh helper dan bantuan akan segera di ambil. ",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Divider(color: Colors.grey.shade300, thickness: 2),
                  ),
                  Text(
                    "Layanan apa yang tersedia?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Perbaikan, Pembersihan, Belanja, Pendidikan, dll",
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        "Hubungi Kami",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
