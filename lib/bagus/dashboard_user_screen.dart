import 'package:bantuin/bagus/task_service.dart';
import 'package:flutter/material.dart';

class DashboardUserScreen extends StatefulWidget {
  const DashboardUserScreen({super.key});

  @override
  State<DashboardUserScreen> createState() => _DashboardUserScreenState();
}

class _DashboardUserScreenState extends State<DashboardUserScreen> {
  int _currentIndex = 0;

  String idUserLogin = "1";

  Map<String, dynamic> _getStatusConfig(String? statusTask) {
    switch (statusTask) {
      case 'mencari_helper':
        return {
          'text': 'Mencari Helper',
          'color': const Color(0xFFF59E0B),
          'icon': Icons.hourglass_empty_rounded,
        };
      case 'berjalan':
        return {
          'text': 'Sedang Dikerjakan',
          'color': const Color(0xFF1D4ED8),
          'icon': Icons.autorenew_rounded,
        };
      case 'menunggu_validasi':
        return {
          'text': 'Sedang Verifikasi',
          'color': const Color.fromARGB(255, 16, 185, 185),
          'icon': Icons.check_circle_outline_rounded,
        };
      case 'selesai':
        return {
          'text': 'Selesai',
          'color': const Color(0xFF10B981),
          'icon': Icons.check_circle_outline_rounded,
        };
      case 'dibatalkan':
        return {
          'text': 'Dibatalkan',
          'color': const Color.fromARGB(255, 185, 22, 16),
          'icon': Icons.clear_outlined,
        };
      default:
        return {
          'text': 'Unknown',
          'color': Colors.grey,
          'icon': Icons.help_outline_rounded,
        };
    }
  }

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
            padding: EdgeInsets.symmetric(horizontal: 15),
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
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Halo, Bagus!",
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
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 80,
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
                    child: IconButton(
                      onPressed: () => _showAddTaskModal(context),
                      icon: Icon(Icons.add),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "TUGAS BERLANGSUNG",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            FutureBuilder(
              future: TaskService().getTasksByRequester(idUserLogin),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("Kamu belum pernah mengupload bantuan."),
                  );
                }

                final listTugasRequester = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: listTugasRequester.length,
                    itemBuilder: (context, index) {
                      final task = listTugasRequester[index];

                      final statusConfig = _getStatusConfig(task.statusTask);

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black.withAlpha(50),
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(14.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE0E7FF),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Icon(
                                      task.kategoriLayanan == 'Pembersihan'
                                          ? Icons.cleaning_services_rounded
                                          : Icons.handyman_rounded,
                                      size: 32.0,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.judulTugas ?? 'Tanpa Judul',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusConfig['color'],
                                            borderRadius: BorderRadius.circular(
                                              20.0,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                statusConfig['icon'],
                                                size: 14.0,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Text(
                                                statusConfig['text'],
                                                style: const TextStyle(
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
                              SizedBox(height: 16.0),

                              Divider(color: Color(0xFFE2E8F0), thickness: 1.5),

                              SizedBox(height: 12.0),

                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: NetworkImage(
                                      'https://placekitty.com/100/100',
                                    ),
                                  ),
                                  SizedBox(width: 12.0),

                                  Expanded(
                                    child: Text(
                                      task.namaHelper ?? 'Belum Ada helper',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),

                                  IconButton(
                                    icon: Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      size: 26.0,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/chat-room',
                                        arguments: task.idHelper,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
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
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF1E3A8A) : Colors.transparent,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.black87,
              size: 26.0,
            ),
            SizedBox(height: 4.0),
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
      onTap: () => _showAddTaskModal(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF3B82F6), width: 2.0),
            ),
            child: Icon(Icons.add, color: Color(0xFF3B82F6), size: 26.0),
          ),
          SizedBox(height: 4.0),
          Text(
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

  void _showAddTaskModal(BuildContext context) {
    final TextEditingController judulController = TextEditingController();
    final TextEditingController deskripsiController = TextEditingController();
    final TextEditingController nominalController = TextEditingController();
    String? kategoriDipilih;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Tambah Bantuan Baru",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: 20),

                TextField(
                  controller: judulController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Tugas',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: deskripsiController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Detail',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Kategori Layanan',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Perbaikan', 'Pembersihan', 'Belanja']
                      .map(
                        (kat) => DropdownMenuItem(value: kat, child: Text(kat)),
                      )
                      .toList(),
                  onChanged: (value) {
                    kategoriDipilih = value;
                  },
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: nominalController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Nominal Pembayaran (Rp)',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (judulController.text.isEmpty ||
                          deskripsiController.text.isEmpty ||
                          kategoriDipilih == null ||
                          nominalController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Semua kolom harus diisi, Gus!"),
                          ),
                        );
                        return;
                      }
                      bool success = await TaskService().createTask(
                        idRequester: idUserLogin,
                        judulTugas: judulController.text,
                        deskripsi: deskripsiController.text,
                        kategoriLayanan: kategoriDipilih!,
                        nominalPembayaran: int.parse(nominalController.text),
                      );
                      if (success) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Bantuan Berhasil Diposting!"),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Gagal memposting bantuan. Cek server backend!",
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Posting Bantuan",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
