import 'package:bantuin/bagus/detail_task_user.dart';
import 'package:bantuin/bagus/service/task_service.dart';
import 'package:bantuin/config/app_config.dart';
import 'package:bantuin/danela/message_list.dart';
import 'package:bantuin/danela/roomchat.dart';
import 'package:bantuin/dava/user_setting.dart';
import 'package:bantuin/ida/screen/notifikasi_requester.dart';
import 'package:bantuin/ida/screen/profile.dart';
import 'package:bantuin/ida/screen/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:bantuin/pilihan.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardUserScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const DashboardUserScreen({super.key, required this.userData});

  @override
  State<DashboardUserScreen> createState() => _DashboardUserScreenState();
}

class _DashboardUserScreenState extends State<DashboardUserScreen> {
  int _currentIndex = 0;
  final TaskService _taskService = TaskService();

  late String idUserLogin;
  late String namaUserLogin;
  late String emailLogin;

  List<dynamic> listTugasDariApi = [];
  List<dynamic> listTugasSelesai = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    idUserLogin = widget.userData['id'].toString();
    namaUserLogin = widget.userData['username'] ?? "User";
    emailLogin = widget.userData['email'];

    fetchTasksByRequester();
    fetchHistoryUser(idUserLogin);
  }

  Future<void> fetchTasksByRequester() async {
    setState(() {
      isLoading = true;
    });

    final String apiUrl =
        "${AppConfig.taskRequester}?id_requester=$idUserLogin";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          listTugasDariApi = responseData['data'];
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Gagal mengambil data dari server")),
        );
      }
    }
  }

  Future<void> _batalkanTugasLangsung(String idTask) async {
    setState(() => isLoading = true);

    try {
      final respon = await http.post(
        Uri.parse("${AppConfig.baseUrl}/api/tasks/update-status"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({'id_task': idTask, 'status_task': 'dibatalkan'}),
      );

      if (!mounted) return;

      final Map<String, dynamic> dataRespons = jsonDecode(respon.body);

      if (respon.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tugas berhasil dibatalkan!"),

            backgroundColor: Colors.green,
          ),
        );

        fetchTasksByRequester();
      } else {
        throw Exception(dataRespons['message'] ?? "Gagal membatalkan tugas");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error: ${e.toString().replaceAll('Exception:', '')}",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> fetchHistoryUser(String idRequester) async {
    final url = Uri.parse("${AppConfig.historyUser}?id_requester=$idRequester");

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Tambahkan token authorization di sini jika backend kamu menggunakan proteksi JWT/Shield
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Sesuai dengan struktur return respond() dari CodeIgniter kamu (status => 200)
        if (jsonResponse['status'] == 200 && jsonResponse['data'] != null) {
          setState(() {
            listTugasSelesai = jsonResponse['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            listTugasSelesai = [];
            isLoading = false;
          });
          print("Log: ${jsonResponse['message']}");
        }
      } else {
        print("Gagal memuat data. Status Code: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Terjadi kesalahan network saat fetch history: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pesanUlangTugas(Map<String, dynamic> tugasLama) async {
    setState(() => isLoading = true);
    try {
      final result = await _taskService.createTask(
        idRequester: idUserLogin,
        judulTugas: tugasLama['judul_tugas'] ?? '',
        deskripsi: tugasLama['deskripsi'] ?? '',
        lokasi: tugasLama['lokasi_tugas'] ?? '',
        nominalPembayaran: tugasLama['nominal_pembayaran'] ?? '',
        kategoriLayanan: tugasLama['kategori_layanan'] ?? '',
      );

      if (!mounted) return;

      if (result?['status'] == 201 || result?['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tugas berhasil dipesan ulang!"),
            backgroundColor: Colors.green,
          ),
        );
        fetchTasksByRequester();
      } else {
        throw Exception(result?['message'] ?? "Gagal memesan ulang");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
      setState(() => isLoading = false);
    }
  }

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
        return NotifikasiRequester();
      case 2:
        return MessageList();
      case 3:
        return ProfileTab();
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
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
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
                    "Halo, $namaUserLogin",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (emailLogin.isNotEmpty)
                    Text(
                      emailLogin,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.black87),
              title: Text("History Tugas"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.black87),
              title: Text("Pengaturan"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserSetting()),
                );
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchTasksByRequester,
              child: _dapatkanHalaman(_currentIndex),
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
    final listTugasAktif = listTugasDariApi.where((item) {
      return item['status'] == 'Mencari helper' ||
          item['status'] == 'Berjalan' ||
          item['status'] == 'Menunggu validasi';
    }).toList();

    // final listTugasSelesai = listTugasDariApi.where((item) {
    //   return item['status'] == 'Selesai' || item['Status'] == 'Dibatalkan';
    // }).toList();

    // final historyTampilkan = listTugasSelesai.take(5).toList();

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
                    "Halo, $namaUserLogin",
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
            listTugasAktif.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Buat pesanan anda dan tugaskan helper",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
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
                                builder: (context) =>
                                    DetailTugas(taskData: bantuan),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                        RoomChatPage(
                                                          namaData: bantuan,
                                                        ),
                                                  ),
                                                );
                                              }
                                            : null,
                                        icon: Icon(
                                          Icons.chat_outlined,
                                          color: isButtonActive
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                              : Color(0XFF666565),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          bantuan['nama_helper'] == null ||
                                                  bantuan['nama_helper']
                                                      .toString()
                                                      .trim()
                                                      .isEmpty
                                              ? 'Belum ada helper'
                                              : bantuan['nama_helper']
                                                    .toString(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          final idHelper = bantuan['id_helper'];
                                          final bool belumAdaHelper =
                                              idHelper == null ||
                                              idHelper == 0 ||
                                              idHelper.toString() == '0' ||
                                              idHelper.toString().isEmpty;

                                          if (belumAdaHelper) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Konfirmasi Batal",
                                                  ),
                                                  content: const Text(
                                                    "Apakah kamu yakin ingin membatalkan tugas ini?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Text(
                                                        "Tidak",
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _batalkanTugasLangsung(
                                                          bantuan['id_task']
                                                              .toString(),
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Ya, Batalkan",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Peringatan Penting!",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    "Tugas ini sudah diambil oleh helper dan sedang berjalan. Membatalkan sepihak bisa merugikan helper.",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            context,
                                                          ),
                                                      child: const Text(
                                                        "Kembali (Amankan Tugas)",
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(
                                                          context,
                                                        ); // Tutup dialog lapis 1

                                                        // Buka Dialog Lapis 2: Konfirmasi Nekat & suruh chat
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                "Yakin Tetap Batal?",
                                                              ),
                                                              content: const Text(
                                                                "Pastikan kamu sudah berdiskusi dan nego dengan helper melalui fitur CHAT sebelum membatalkan tugas ini secara sepihak!",
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                        context,
                                                                      ),
                                                                  child: const Text(
                                                                    "Batal, saya mau chat dulu",
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                    _batalkanTugasLangsung(
                                                                      bantuan['id_task']
                                                                          .toString(),
                                                                    );
                                                                  },
                                                                  child: const Text(
                                                                    "Saya Paham, Tetap Batalkan",
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: const Text(
                                                        "Lanjutkan Pembatalan",
                                                        style: TextStyle(
                                                          color: Colors.orange,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
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
              "RIWAYAT TUGAS",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            listTugasSelesai.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Belum ada riwayat tugas",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
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
                                builder: (context) =>
                                    DetailTugas(taskData: history),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                        RoomChatPage(
                                                          namaData: history,
                                                        ),
                                                  ),
                                                );
                                              }
                                            : null,
                                        icon: Icon(
                                          Icons.chat_outlined,
                                          color: isButtonActive
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                              : Color(0XFF666565),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  "Pesan Ulang",
                                                ),
                                                content: Text(
                                                  "Apakah kamu ingin membuat tugas baru dengan rincian yang sama seperti '${history['judul_tugas']}'?",
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: const Text("Batal"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      _pesanUlangTugas(history);
                                                    },
                                                    child: const Text(
                                                      "Pesan Lagi",
                                                      style: TextStyle(
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.refresh,
                                          size: 14,
                                        ),
                                        label: const Text(
                                          "Pesan Lagi",
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
                  keyboardType: TextInputType.multiline,
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

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      final result = await _taskService.createTask(
                        judulTugas: judulController.text.trim(),
                        deskripsi: deskripsiController.text.trim(),
                        kategoriLayanan: kategoriDipilih!,
                        lokasi: lokasiController.text.trim(),
                        nominalPembayaran: nominalController.text.trim(),
                        idRequester: idUserLogin,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                      }

                      if (result != null && result['success'] == true) {
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                result['message'] ??
                                    "Berhasil memposting bantuan!",
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );

                          fetchTasksByRequester();
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                result?['message'] ??
                                    "Gagal memposting bantuan",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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
