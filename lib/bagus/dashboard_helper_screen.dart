import 'dart:convert';
import 'package:bantuin/bagus/history_helper.dart';
import 'package:bantuin/bagus/tugas_aktif_helper.dart';
import 'package:bantuin/bagus/tugas_aktif_screen.dart';
import 'package:bantuin/bagus/upload_bukti.dart';
import 'package:bantuin/danela/detail_task_helper.dart';
// import 'package:bantuin/data_tugas.dart';
import 'package:bantuin/dava/helper_setting.dart';
import 'package:bantuin/danela/message_list.dart';
import 'package:bantuin/ida/profile.dart';
import 'package:bantuin/ida/profile_tab.dart';
import 'package:bantuin/yuliana/Faq_Helper.dart';
import 'package:flutter/material.dart';
import 'package:bantuin/config/app_config.dart';
import 'package:http/http.dart' as http;

class DashboardHelperScreen extends StatefulWidget {
  const DashboardHelperScreen({super.key});

  @override
  State<DashboardHelperScreen> createState() => _DashboardHelperScreenState();
}

class _DashboardHelperScreenState extends State<DashboardHelperScreen> {
  final String apiUrl = AppConfig.taskFeed;

  int _currentIndex = 0;
  String _kategoriAktif = 'Semua';

  Future<List<dynamic>>? _futureTasks;

  @override
  void initState() {
    super.initState();
    _futureTasks = fetchTasksForHelper();
  }

  Future<List<dynamic>> fetchTasksForHelper() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responsData = json.decode(response.body);

        return responsData['data'];
      } else {
        throw Exception('Gagal memuat tugas (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureTasks = fetchTasksForHelper();
    });
  }

  Widget _dapatkanHalaman(int index, List<dynamic>? apiTasksData) {
    switch (index) {
      case 0:
        return _buildDashboardHelper(apiTasksData ?? []);
      case 1:
        return TugasAktifHelper(
          detailTugas: (apiTasksData != null && apiTasksData.isNotEmpty)
              ? apiTasksData[0]
              : {},
        );
      case 2:
        return MessageListTab();
      case 3:
        return ProfileTab();
      default:
        return _buildDashboardHelper(apiTasksData ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureTasks,
      builder: (context, snapshot) {
        final apiTasksData = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Bantu.In - Helper",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: Colors.black.withAlpha(10),
            toolbarHeight: 80,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FaqHelper()),
                  );
                },
                icon: Icon(Icons.help_outline),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      );
                    },
                    icon: Icon(Icons.person, color: Colors.white),
                  ),
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
                        "Halo, Mitra Helper!",
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => History()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.black87),
                  title: Text("Pengaturan"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelperSetting()),
                    );
                  },
                ),
              ],
            ),
          ),
          body: snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : snapshot.hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Terjadi Error: ${snapshot.error}"),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _refreshData,
                        child: const Text("Coba Lagi"),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: _dapatkanHalaman(_currentIndex, apiTasksData),
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
                  _buildNavItem(
                    index: 0,
                    icon: Icons.home_filled,
                    label: 'Home',
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.task_outlined,
                    label: 'Tugas Aktif',
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
      },
    );
  }

  Padding _buildDashboardHelper(List<dynamic> realTasks) {
    final listTerfilter = _kategoriAktif == 'Semua'
        ? realTasks
        : realTasks.where((item) {
            final kategori =
                item['kategori_layanan']?.toString().toLowerCase().trim() ?? '';
            return kategori == _kategoriAktif.toLowerCase().trim();
          }).toList();

    return Padding(
      padding: EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: Text("View All")),
            ],
          ),
          // SizedBox(height: 10),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTombolKategori(
                    nama: 'Semua',
                    icon: Icons.grid_view_rounded,
                  ),
                  _buildTombolKategori(
                    nama: 'BantuFix',
                    icon: Icons.business_center_rounded,
                  ),
                  _buildTombolKategori(
                    nama: 'BantuClean',
                    icon: Icons.cleaning_services_rounded,
                  ),
                  _buildTombolKategori(
                    nama: 'BantuShop',
                    icon: Icons.shopping_bag_rounded,
                  ),
                  _buildTombolKategori(nama: 'BantuStudy', icon: Icons.school),
                ],
              ),
            ),
          ),
          // SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Bantuan Tersedia",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: listTerfilter.isEmpty
                ? Center(child: Text("Tidak ada tugas untuk kategori ini"))
                : ListView.builder(
                    itemCount: listTerfilter.length,
                    itemBuilder: (context, index) {
                      final tugas = listTerfilter[index];

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
                                builder: (context) =>
                                    DetailTugasHelper(taskData: tugas),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  left: 16,
                                  right: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          tugas['kategori_layanan'].toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Rp ${tugas['nominal_pembayaran'].toString()}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 12,
                                  left: 16,
                                  right: 16,
                                  bottom: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      tugas['judul_tugas'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Flexible(
                                      child: Text(
                                        tugas['deskripsi'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.location_on, size: 12),
                                        Text(
                                          tugas['lokasi_tugas'],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Divider(
                                  color: Colors.grey.shade400,
                                  thickness: 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 12,
                                  left: 16,
                                  right: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor:
                                                Colors.grey.shade300,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            tugas['nama_requester'] ?? 'User',
                                          ),
                                        ],
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        bool konfirmasi =
                                            await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("Ambil Tugas"),
                                                content: Text(
                                                  "Apakah kamu yakin ambil?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                        context,
                                                        false,
                                                      );
                                                    },
                                                    child: Text("Batal"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                        context,
                                                        true,
                                                      );
                                                    },
                                                    child: Text("Ya, Ambil"),
                                                  ),
                                                ],
                                              ),
                                            ) ??
                                            false;

                                        if (!konfirmasi) return;

                                        try {
                                          final String takeTaskUrl =
                                              AppConfig.ambilTugas;

                                          final respon = await http.post(
                                            Uri.parse(takeTaskUrl),
                                            body: {
                                              'id_task': tugas['id_task']
                                                  .toString(),
                                              'id_helper': '1',
                                            },
                                          );
                                          if (respon.statusCode == 200) {
                                            final jsonRespon = json.decode(
                                              respon.body,
                                            );

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  jsonRespon['message'] ??
                                                      "Tugas Berhasil diambil!",
                                                ),
                                              ),
                                            );
                                            _refreshData();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TugasAktifScreen(
                                                      detailTugas: tugas,
                                                    ),
                                              ),
                                            );
                                          } else {
                                            final jsonRespon = json.decode(
                                              respon.body,
                                            );
                                            throw Exception(
                                              jsonRespon['messages'] ??
                                                  "Gagal mengambil tugas",
                                            );
                                          }
                                        } catch (e) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text("Gagal"),
                                              content: Text(
                                                e.toString().replaceAll(
                                                  "Exception:",
                                                  "",
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("OK"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 25,
                                        ),
                                      ),
                                      child: Text(
                                        "Ambil Tugas",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
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
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTombolKategori({required String nama, required IconData icon}) {
    final bool isAktif = _kategoriAktif == nama;

    return GestureDetector(
      onTap: () {
        setState(() {
          _kategoriAktif = nama;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isAktif
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: !isAktif
                    ? Border.all(color: Colors.grey, width: 1.5)
                    : null,
              ),
              child: Icon(
                icon,
                color: isAktif ? Colors.white : Colors.grey,
                size: 28,
              ),
            ),
            SizedBox(height: 6),
            Text(
              nama,
              style: TextStyle(
                fontWeight: isAktif ? FontWeight.bold : FontWeight.normal,
              ),
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
          _currentIndex = index; // Ganti halaman aktif saat diklik
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UploadBuktiTab(idTask: '12', kodeReferensi: ''),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF3B82F6), width: 2.0),
            ),
            child: Icon(Icons.camera, color: Color(0xFF3B82F6), size: 26.0),
          ),
          SizedBox(height: 4.0),
          Text(
            'Foto Bukti',
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
