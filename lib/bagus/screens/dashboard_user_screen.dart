import 'package:flutter/material.dart';

class DashboardUserScreen extends StatefulWidget {
  const DashboardUserScreen({super.key});

  @override
  State<DashboardUserScreen> createState() => _DashboardUserScreenState();
}

class _DashboardUserScreenState extends State<DashboardUserScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bantu.In", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withAlpha(10),
        toolbarHeight: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
          ),
        ],
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Halo, Nama!",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text("Apa yang bisa kami bantu hari ini?"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "MINTA BANTUAN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withAlpha(50),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withAlpha(50),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                  ),
                ),
              ),
            ),
            Text(
              "TUGAS BERLANGSUNG",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black.withAlpha(50)),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFE0E7FF,
                            ), // Warna ungu/biru muda soft
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Icon(
                            Icons
                                .cleaning_services_rounded, // Ganti ikon sesuai kebutuhan
                            size: 32.0,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary, // Biru utama
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bersihin Ruang Tamu",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 6),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF1D4ED8,
                                  ), // Biru status tegas
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.autorenew_rounded,
                                      size: 14.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      'Sedang Dikerjakan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    const Divider(color: Color(0xFFE2E8F0), thickness: 1.5),

                    const SizedBox(height: 12.0),

                    Row(
                      children: [
                        // 1. Foto Profil Bulat
                        const CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage(
                            'https://placekitty.com/100/100', // Gantilah dengan path/asset gambar aslimu
                          ),
                        ),
                        const SizedBox(width: 12.0),

                        // 2. Nama Helper
                        const Expanded(
                          child: Text(
                            'Nama Helper',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        // 3. Tombol Chat (Ikon Pesan Kanan)
                        IconButton(
                          icon: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary, // Otomatis Biru Utama
                            size: 26.0,
                          ),
                          onPressed: () {
                            // Aksi ketika diklik langsung menerbangkan ke fitur Chat milik Danela
                            Navigator.pushNamed(context, '/chat-room');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.withAlpha(50), width: 1.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(index: 0, icon: Icons.home_filled, label: 'Home'),
              _buildNavItem(
                index: 1,
                icon: Icons.assignment_outlined,
                label: 'My Task',
              ),
              _buildPostButton(),
              _buildNavItem(
                index: 2,
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Message',
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline_rounded,
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index; // Ganti halaman aktif saat diklik
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          // Jika aktif, kasih warna background biru utama kelompok kita
          color: isActive ? const Color(0xFF1E3A8A) : Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              // Jika aktif warna ikon putih, jika tidak aktif warna hitam/abu
              color: isActive ? Colors.white : Colors.black87,
              size: 26.0,
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostButton() {
    return GestureDetector(
      onTap: () {
        // Aksi ketika klik tombol tambah tugas baru
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(
                  0xFF3B82F6,
                ), // Biru terang sesuai secondary theme kita
                width: 2.0,
              ),
            ),
            child: const Icon(Icons.add, color: Color(0xFF3B82F6), size: 26.0),
          ),
          const SizedBox(height: 4.0),
          const Text(
            'Post',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
