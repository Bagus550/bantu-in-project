import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tentang Kami"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
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
                  const SizedBox(height: 12),
                  Text(
                    "Selamat Datang di Bantu.in",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Bantu.In adalah platform yang menghubungkan Anda dengan penyediajasa terpercaya untuk berbagaikebutuhan. Dari perbaikan, pembersihan hingga berbelanja, kami di sini  untuk membantu.",
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Misi Kami",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Menyediakan layanan berkualitas Membangun komunitas terpecaya Memberikan kemudahan akses untuk semua",
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Nilai - Nilai Kami",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.handshake,
                            size: 80,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text("Kepercayaan"),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.verified,
                            size: 80,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text("Intergritas"),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.chair,
                            size: 80,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text("Kenyamanan"),
                        ],
                      ),
                    ],
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
                        "Hubungi kami",
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
