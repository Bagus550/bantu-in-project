import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pusat Bantuan (FAQ)"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFF8FAFC), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logo/logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 12),
                    const Text(
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text(
                      "Temukan Jawaban Anda",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    "Punya Pertanyaan tentang Bantu.in? Cari jawabannya disini atau hubungi Customer Service kami.",
                  ),
                  
                  // Pertanyaan 1
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Apa itu Bantu.in?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    "Bantu.in merupakan platform yang menghubungkan pengguna dengan penyedia jasa atau tenaga bantuan (Helper) terpercaya untuk membantu menyelesaikan berbagai kebutuhan sehari-hari secara cepat dan mudah.",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Divider(color: Colors.grey.shade300, thickness: 2),
                  ),

                  // Pertanyaan 2
                  const Text(
                    "Bagaimana cara memesan jasa? (Bagi Pengguna)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1. Pesan Bantuan dengan mengklik tombol + di bottom navigation."),
                        Text("2. Anda bisa mengisi bagian judul dengan nama bantuan yang di buat."),
                        Text("3. Isikan deskripsi untuk keterangan lebih lengkap terkait bantuan yang ada buat."),
                        Text("4. Untuk lokasi bisa dibuat sendiri dengan menggunakan patokan jalan atau otomatis dari alamat akun."),
                        Text("5. Buat nominal pembayaran berdasarkan jenis bantuan dan berat bantuan, setiap jenis bantuan memiliki minimum bayar yang berbeda."),
                        Text("6. Klik posting bantuan untuk mempublikasikan bantuan anda agar terlacak oleh helper dan bantuan akan segera di ambil."),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Divider(color: Colors.grey.shade300, thickness: 2),
                  ),

                  // Pertanyaan 3
                  const Text(
                    "Bagaimana cara mengerjakan tugas? (Bagi Helper)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      "Cari jasa yang ingin diambil melalui dashboard, terima pesanan dan kerjakan dengan baik, pastikan pengguna telah membayar atau mengkonfirmasi pembayaran, kemudian selesaikan tugas.",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Divider(color: Colors.grey.shade300, thickness: 2),
                  ),

                  // Pertanyaan 4
                  const Text(
                    "Layanan apa yang tersedia?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text("Perbaikan, Pembersihan, Belanja, dan Pendidikan."),
                  ),

                  const SizedBox(height: 30),
                  
                  // Tombol Hubungi CS
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showContactBottomSheet(context);
                      },
                      icon: const Icon(Icons.support_agent_rounded),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      label: const Text(
                        "Hubungi Customer Service",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactBottomSheet(BuildContext context) {
    final String whatsappUrl = "https://wa.me/6285955035351";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hubungi Customer Service',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silahkan hubungi kami melalui WhatsApp untuk mendapatkan bantuan lebih lanjut.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final Uri url = Uri.parse(whatsappUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tidak dapat membuka WhatsApp'),
                          ),
                        );
                      }
                    }
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Hubungi via WhatsApp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: whatsappUrl)).then((_) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nomor WhatsApp CS berhasil disalin!'),
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.copy, color: Colors.black87),
                  label: const Text(
                    'Salin Nomor WhatsApp',
                    style: TextStyle(color: Colors.black87),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
