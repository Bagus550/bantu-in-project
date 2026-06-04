import 'package:bantuin/bagus/screens/detail_task_user.dart';
import 'package:bantuin/bagus/screens/notifications.dart';
import 'package:bantuin/danela/roomchat.dart';
import 'package:flutter/material.dart';
import 'package:bantuin/data_tugas.dart';
import 'package:bantuin/pilihan.dart';

class DashboardUserScreen extends StatefulWidget {
  const DashboardUserScreen({super.key});

  @override
  State<DashboardUserScreen> createState() => _DashboardUserScreenState();
}

class _DashboardUserScreenState extends State<DashboardUserScreen> {
  int _currentIndex = 0;

  String idUserLogin = "1";

  Color ambilWarnaStatus(String status) {
    switch (status) {
      case 'Mencari helper':
        return const Color.fromARGB(255, 255, 158, 79);
      case 'Berjalan':
        return Color(0xFF283593);
      case 'Menunggu validasi':
        return Colors.teal.shade800;
      case 'Selesai':
        return Colors.green.shade800;
      case 'Dibatalkan':
        return Color(0xFFCD2528);
      default:
        return Color(0xFF283593);
    }
  }

  Color ambilBgStatus(String status) {
    switch (status) {
      case 'Berjalan':
        return Color(0XFFDFDDF5);
      case 'Selesai':
        return Color(0XFFDDF5E2);
      case 'Dibatalkan':
        return Color(0XFFF5DDDD);
      default:
        return Color(0XFFEEEEEE);
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

  // ignore: non_constant_identifier_names
  IconData ambilIconBantuan(String kategori_layanan) {
    switch (kategori_layanan) {
      case 'BantuFix':
        return Icons.home_repair_service_outlined;
      case 'BantuClean':
        return Icons.cleaning_services_outlined;
      case 'BantuShop':
        return Icons.shopping_cart_outlined;
      case 'BantuStudy':
        return Icons.school;
      default:
        return Icons.grid_view_rounded;
    }
  }

  // ignore: non_constant_identifier_names
  Color ambilWarnaBantuan(String kategori_layanan) {
    switch (kategori_layanan) {
      case 'BantuFix':
        return Color(0xFFDDF5DF);
      case 'BantuClean':
        return Color(0xFFDFDDF5);
      case 'BantuShop':
        return Color(0XFFF3F5DD);
      case 'BantuStudy':
        return Color(0XFFF5DEDD);
      default:
        return Color(0XFFEEEEEE);
    }
  }

  // ignore: non_constant_identifier_names
  Color ambilWarnaIkonBantuan(String kategori_layanan) {
    switch (kategori_layanan) {
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

  Widget _dapatkanHalaman(int index) {
    switch (index) {
      case 0:
        return _buildDashboardHome();
      case 1:
        return NotificationsTab(tasks: tasks);
      case 2:
        return Center(
          child: Text("Halaman Message", style: TextStyle(fontSize: 20)),
        );
      case 3:
        return Center(
          child: Text("Halaman Profile", style: TextStyle(fontSize: 20)),
        );
      default:
        return _buildDashboardHome();
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
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 35, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Halo, ${tasks.isNotEmpty ? tasks[0]['nama_requester'] : 'User'}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.black87),
              title: Text("History Tugas"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Pindah ke halaman history")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black87),
              title: Text("Pengaturan"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Pindah ke halaman pengaturan")),
                );
              },
            ),
          ],
        ),
      ),
      body: _dapatkanHalaman(_currentIndex),
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
                icon: Icons.notifications_none_outlined,
                label: 'Notifikasi',
              ),
              _buildPostButton(),
              _buildNavItem(
                index: 2,
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Pesan',
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

  Widget _buildDashboardHome() {
    final listTugasAktif = tasks.where((item) {
      return item['nama_requester'] == 'Bagus' &&
          (item['status'] == 'Mencari helper' ||
              item['status'] == 'Berjalan' ||
              item['status'] == 'Menunggu validasi');
    }).toList();

    final listTugasSelesai = tasks.where((item) {
      return item['nama_requester'] == 'Bagus' &&
          (item['status'] == 'Selesai' || item['status'] == 'Dibatalkan');
    }).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
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
            SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: opsi['kategori_layanan'].length,
                itemBuilder: (context, index) {
                  final cardPost = opsi['kategori_layanan'][index];
                  final deskripsi = opsi['deskripsi'][index];

                  return SizedBox(
                    width: 180,
                    height: 180,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: EdgeInsets.only(right: 16),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          _showAddTaskModal(context, initialKategori: cardPost);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: ambilWarnaBantuan(cardPost),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  ambilIconBantuan(cardPost),
                                  color: ambilWarnaIkonBantuan(cardPost),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 16,
                              ),
                              child: Text(
                                cardPost,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                deskripsi,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              "TUGAS BERLANGSUNG",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: listTugasAktif.length,
              itemBuilder: (context, index) {
                final bantuan = listTugasAktif[index];

                String statusTugas = (bantuan['status'] ?? '')
                    .toString()
                    .trim()
                    .toLowerCase();
                bool isButtonActive =
                    statusTugas != 'mencari helper' &&
                    statusTugas != 'selesai' &&
                    statusTugas != 'dibatalkan';

                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailTugas(dataTugas: bantuan),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: ambilWarnaBantuan(
                                          bantuan['kategori_layanan'],
                                        ),
                                      ),
                                      child: Icon(
                                        ambilIconBantuan(
                                          bantuan['kategori_layanan'],
                                        ),
                                        color: ambilWarnaIkonBantuan(
                                          bantuan['kategori_layanan'],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            bantuan['judul_tugas'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'ID : ${bantuan['id']}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ambilBgStatus(bantuan['status']),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    bantuan['status'],
                                    style: TextStyle(
                                      color: ambilWarnaStatus(
                                        bantuan['status'],
                                      ),
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  bantuan['nominal_pembayaran'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: isButtonActive
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RoomChatPage(namaData: tasks[index],),
                                            ),
                                          );
                                        }
                                      : null,
                                  icon: Icon(
                                    Icons.chat_outlined,
                                    color: isButtonActive
                                        ? Theme.of(context).colorScheme.primary
                                        : Color(0XFF666565),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey.shade300, thickness: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.grey.shade300,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    bantuan['nama_helper'] != null &&
                                            bantuan['nama_helper']
                                                .toString()
                                                .trim()
                                                .isEmpty
                                        ? 'Belum ada helper'
                                        : bantuan['nama_helper'],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ambilWarnaStatus(
                                      'Dibatalkan',
                                    ),
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: Icon(Icons.clear),
                                  label: Text(
                                    "Batalkan",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              "TUGAS SELESAI",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: listTugasSelesai.length,
              itemBuilder: (context, index) {
                final history = listTugasSelesai[index];

                String statusTugas = (history['status'] ?? '')
                    .toString()
                    .trim()
                    .toLowerCase();
                bool isButtonActive =
                    statusTugas != 'mencari helper' &&
                    statusTugas != 'selesai' &&
                    statusTugas != 'dibatalkan';

                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailTugas(dataTugas: history),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: ambilWarnaBantuan(
                                          history['kategori_layanan'],
                                        ),
                                      ),
                                      child: Icon(
                                        ambilIconBantuan(
                                          history['kategori_layanan'],
                                        ),
                                        color: ambilWarnaIkonBantuan(
                                          history['kategori_layanan'],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            history['judul_tugas'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'ID : ${history['id']}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ambilBgStatus(history['status']),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    history['status'],
                                    style: TextStyle(
                                      color: ambilWarnaStatus(
                                        history['status'],
                                      ),
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  history['nominal_pembayaran'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: isButtonActive
                                      ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RoomChatPage(namaData: tasks[index],),
                                            ),
                                          );
                                        }
                                      : null,
                                  icon: Icon(
                                    Icons.chat_outlined,
                                    color: isButtonActive
                                        ? Theme.of(context).colorScheme.primary
                                        : Color(0XFF666565),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey.shade300, thickness: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.grey.shade300,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    history['nama_helper'] != null &&
                                            history['nama_helper']
                                                .toString()
                                                .trim()
                                                .isEmpty
                                        ? 'Belum ada helper'
                                        : history['nama_helper'],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ambilWarnaStatus(
                                      'Selesai',
                                    ),
                                    foregroundColor: Colors.white,
                                  ),
                                  icon: Icon(Icons.refresh),
                                  label: Text(
                                    "Pesan Ulang",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
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

  void _showAddTaskModal(BuildContext context, {String? initialKategori}) {
    final TextEditingController judulController = TextEditingController();
    final TextEditingController deskripsiController = TextEditingController();
    final TextEditingController nominalController = TextEditingController();
    final TextEditingController lokasiController = TextEditingController();

    String? kategoriDipilih = initialKategori;

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

                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setModalState) {
                    return DropdownButtonFormField(
                      initialValue: kategoriDipilih,
                      decoration: const InputDecoration(
                        labelText: 'Kategori Layanan',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          ['BantuFix', 'BantuClean', 'BantuShop', 'BantuStudy']
                              .map(
                                (kat) => DropdownMenuItem(
                                  value: kat,
                                  child: Text(kat),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          kategoriDipilih = value;
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: lokasiController,
                  maxLines: 2,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Lokasi (atau tempel link Gmaps)',
                    border: OutlineInputBorder(),
                  ),
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
                            content: Text("Semua kolom harus diisi!"),
                          ),
                        );
                        return;
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
