// ignore_for_file: empty_catches, use_build_context_synchronously

import 'dart:convert';
import 'package:bantuin/yuliana/history_helper.dart';
import 'package:bantuin/bagus/tugas_aktif_helper.dart';
import 'package:bantuin/bagus/peta_rute_helper.dart';
import 'package:bantuin/danela/detail_task_helper.dart';
import 'package:bantuin/danela/message_list.dart';
import 'package:bantuin/ida/screen/profile.dart';
import 'package:bantuin/ida/screen/profile_tab.dart';
import 'package:bantuin/dava/helper_setting.dart';
import 'package:bantuin/utils/currency_extension.dart';
import 'package:bantuin/yuliana/Faq_Helper.dart';
import 'package:flutter/material.dart';
import 'package:bantuin/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

class DashboardHelperScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;
  final String? token;

  const DashboardHelperScreen({super.key, this.userData, this.token});

  @override
  State<DashboardHelperScreen> createState() => _DashboardHelperScreenState();
}

class _DashboardHelperScreenState extends State<DashboardHelperScreen> {
  final String apiUrl = AppConfig.taskFeed;

  int _currentIndex = 0;
  String _kategoriAktif = 'Semua';

  Future<List<dynamic>>? _futureTasks;

  Map<String, dynamic> _tugasAktifSaya = {};
  String? _fotoProfilUrl;
  Position? _posisiHelper;
  bool _gagalDapatLokasi = false;
  final _secureStorage = const FlutterSecureStorage();

  Future<void> _fetchProfile() async {
    final String idHelperLogin = widget.userData?['id']?.toString() ?? '2';
    try {
      final token =
          await _secureStorage.read(key: 'auth_token') ??
          await _secureStorage.read(key: 'jwt_token');
      final response = await http.get(
        Uri.parse(
          '${AppConfig.baseUrl}/api/helpers/$idHelperLogin/foto-profil',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        String path = '';
        if (data['data'] is String) {
          path = data['data'];
        } else if (data['foto_profil'] != null) {
          path = data['foto_profil'];
        } else if (data['data'] != null &&
            data['data'] is Map &&
            data['data']['foto_profil'] != null) {
          path = data['data']['foto_profil'];
        }

        if (path.isNotEmpty) {
          if (!path.startsWith('http')) {
            if (path.startsWith('/')) {
              path = path.substring(1);
            }
            if (!path.contains('uploads/profiles')) {
              path = 'uploads/profiles/$path';
            }
            path = '${AppConfig.baseUrl}/$path';
          }
          await _secureStorage.write(key: 'foto_profil_url', value: path);
          if (mounted) {
            setState(() {
              _fotoProfilUrl = path;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchLokasiHelper();
    _futureTasks = fetchTasksForHelper();
  }

  Future<void> _fetchLokasiHelper() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _gagalDapatLokasi = true);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _gagalDapatLokasi = true);
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
            
        // Pakai lokasi terakhir agar tampil lebih cepat
        Position? lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null && mounted) {
          setState(() {
            _posisiHelper = lastPosition;
          });
        }

        // Ambil lokasi terbaru
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
          ),
        ).timeout(const Duration(seconds: 10));
        
        if (mounted) {
          setState(() {
            _posisiHelper = position;
          });
        }
      }
    } catch (e) {
      debugPrint("Gagal mendapat lokasi: $e");
      if (mounted) setState(() => _gagalDapatLokasi = true);
    }
  }

  String _hitungJarak(Map<String, dynamic> tugas) {
    if (_gagalDapatLokasi) return tugas['lokasi_tugas']?.toString() ?? "Lokasi tidak diketahui";
    if (_posisiHelper == null) return "Menghitung jarak...";

    final latRaw = tugas['latitude_tugas'] ?? tugas['latitude'];
    final lngRaw = tugas['longitude_tugas'] ?? tugas['longitude'];

    if (latRaw == null || lngRaw == null) {
      return tugas['lokasi_tugas']?.toString() ?? "Lokasi tidak diketahui";
    }

    final latTugas = double.tryParse(latRaw.toString());
    final lngTugas = double.tryParse(lngRaw.toString());

    if (latTugas == null || lngTugas == null) {
      return tugas['lokasi_tugas']?.toString() ?? "Lokasi tidak diketahui";
    }

    final jarakMeter = Geolocator.distanceBetween(
      _posisiHelper!.latitude,
      _posisiHelper!.longitude,
      latTugas,
      lngTugas,
    );

    if (jarakMeter < 1000) {
      return "${jarakMeter.toStringAsFixed(0)} m dari lokasi Anda";
    } else {
      return "${(jarakMeter / 1000).toStringAsFixed(1)} km dari lokasi Anda";
    }
  }


  Future<List<dynamic>> fetchTasksForHelper() async {
    final String idHelperLogin = widget.userData?['id']?.toString() ?? '2';
    final String urlWithParam =
        "${AppConfig.taskFeed}?id_helper=$idHelperLogin";

    final response = await http.get(Uri.parse(urlWithParam));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (mounted) {
        setState(() {
          if (jsonResponse['tugas_aktif'] != null &&
              jsonResponse['tugas_aktif'] is Map) {
            _tugasAktifSaya = Map<String, dynamic>.from(
              jsonResponse['tugas_aktif'],
            );
          } else {
            _tugasAktifSaya = {};
          }
        });
      }

      return jsonResponse['feed'] ?? [];
    } else {
      throw Exception('Gagal memuat data dari server');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureTasks = fetchTasksForHelper();
    });
  }

  Widget _dapatkanHalaman(int index, List<dynamic>? apiTasksData) {
    final listFeedBeranda = apiTasksData ?? [];

    switch (index) {
      case 0:
        return _buildDashboardHelper(listFeedBeranda);
      case 1:
        return TugasAktifHelper(
          detailTugas: _tugasAktifSaya.isEmpty ? {} : _tugasAktifSaya,
        );
      case 2:
        return PetaRuteHelper(tugasAktif: _tugasAktifSaya.isEmpty ? null : _tugasAktifSaya);
      case 3:
        return MessageList();
      case 4:
        return ProfileTab();
      default:
        return _buildDashboardHelper(listFeedBeranda);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String namaHelper =
        widget.userData?['nama'] ??
        widget.userData?['username'] ??
        'Mitra Helper';
    final String emailHelper = widget.userData?['email'] ?? '';

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
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      ).then((_) => _fetchProfile());
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                        image: (_fotoProfilUrl != null &&
                                _fotoProfilUrl!.isNotEmpty &&
                                _fotoProfilUrl!.startsWith('http'))
                            ? DecorationImage(
                                image: NetworkImage(_fotoProfilUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: (_fotoProfilUrl == null ||
                              _fotoProfilUrl!.isEmpty ||
                              !_fotoProfilUrl!.startsWith('http'))
                          ? const Icon(Icons.person, color: Colors.white, size: 24)
                          : null,
                    ),
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
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: (_fotoProfilUrl != null &&
                                    _fotoProfilUrl!.isNotEmpty &&
                                    _fotoProfilUrl!.startsWith('http'))
                                ? DecorationImage(
                                    image: NetworkImage(_fotoProfilUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (_fotoProfilUrl == null ||
                                  _fotoProfilUrl!.isEmpty ||
                                  !_fotoProfilUrl!.startsWith('http'))
                              ? const Icon(Icons.person, size: 35, color: Colors.grey)
                              : null,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Halo, $namaHelper!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (emailHelper.isNotEmpty)
                        Text(
                          emailHelper,
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
                  onTap: () {
                    final String idHelperLogin =
                        widget.userData?['id']?.toString() ?? '2';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => History(idHelper: idHelperLogin),
                      ),
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
                    ).then((_) => _fetchProfile());
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
                  child: Builder(
                    builder: (context) {
                      if (_currentIndex == 0) {
                        final listFeedBeranda = apiTasksData ?? [];
                        final listTerfilter = _kategoriAktif == 'Semua'
                            ? listFeedBeranda
                            : listFeedBeranda.where((item) {
                                final kategori =
                                    item['kategori_layanan']
                                        ?.toString()
                                        .toLowerCase()
                                        .trim() ??
                                    '';
                                return kategori ==
                                    _kategoriAktif.toLowerCase().trim();
                              }).toList();

                        if (listTerfilter.isEmpty) {
                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final viewportHeight = constraints.maxHeight;
                              return SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: viewportHeight,
                                  ),
                                  child: _buildDashboardHelperEmpty(
                                    listFeedBeranda,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }

                      return _dapatkanHalaman(_currentIndex, apiTasksData);
                    },
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
                  _buildNavItem(
                    index: 2,
                    icon: Icons.map_outlined,
                    label: 'Peta Navigasi',
                  ),
                  // _buildPostButton(),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Message',
                  ),
                  _buildNavItem(
                    index: 4,
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
          Text(
            "Kategori",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 18),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                          onTap: () async {
                            final apakahBerhasilAmbil = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailTugasHelper(
                                  taskData: tugas,
                                  userData: widget.userData,
                                  token: widget.token,
                                  adaTugasAktif:
                                      _tugasAktifSaya.isNotEmpty &&
                                      _tugasAktifSaya['id_task'] != null,
                                ),
                              ),
                            );

                            if (apakahBerhasilAmbil == true) {
                              _refreshData();
                              if (mounted) {
                                setState(() {
                                  _currentIndex =
                                      1; // Otomatis pindah ke tab Tugas Aktif
                                });
                              }
                            }
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
                                      tugas['nominal_pembayaran']
                                              ?.toString()
                                              .toRupiah() ??
                                          'Rp 0',
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
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            _hitungJarak(tugas),
                                            style: TextStyle(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
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
                                        if (_tugasAktifSaya.isNotEmpty &&
                                            _tugasAktifSaya['id_task'] !=
                                                null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Selesaikan dulu tugas aktifmu saat ini sebelum mengambil tugas baru!",
                                              ),
                                              backgroundColor: Colors.orange,
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                          return;
                                        }
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

                                          final String idHelperLogin =
                                              widget.userData?['id']
                                                  ?.toString() ??
                                              '1';

                                          final respon = await http.post(
                                            Uri.parse(takeTaskUrl),
                                            headers: {
                                              'Authorization':
                                                  'Bearer ${widget.token}',
                                            },
                                            body: {
                                              'id_task': tugas['id_task']
                                                  .toString(),
                                              'id_helper': idHelperLogin,
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

                                            if (mounted) {
                                              setState(() {
                                                _currentIndex = 1;
                                              });
                                            }
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
                                          if (!mounted) return;

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

  Widget _buildDashboardHelperEmpty(List<dynamic> realTasks) {
    return Padding(
      padding: EdgeInsets.only(top: 16, right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Menampilkan semua kategori... (Sedang dikembangkan)")),
                  );
                },
                child: const Text("View All"),
              ),
            ],
          ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Bantuan Tersedia",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // Empty state body (no Expanded/ListView)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Column(
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    "Tidak ada tugas untuk kategori ini",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
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

    return Expanded(
      child: GestureDetector(
        onTap: () async {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            try {
              await fetchTasksForHelper();
            } catch (e) {}
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Color(0xFF1E3A8A) : Colors.black54, 
              size: 24,
            ),
            SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? Color(0xFF1E3A8A) : Colors.black54,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPostButton() {
  //   return GestureDetector(
  //     onTap: () async {
  //       if (_tugasAktifSaya.isEmpty || _tugasAktifSaya['id_task'] == null) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text(
  //               "Kamu tidak memiliki tugas aktif yang perlu dikirim buktinya!",
  //             ),
  //             backgroundColor: Colors.amber,
  //           ),
  //         );
  //         return;
  //       }

  //       final String idTaskDinamis = _tugasAktifSaya['id_task'].toString();

  //       final isSuksesUpload = await Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => UploadBuktiTab(idTask: idTaskDinamis),
  //         ),
  //       );

  //       if (isSuksesUpload == true) {
  //         try {
  //           await fetchTasksForHelper();
  //         } catch (e) {}
  //       }
  //     },
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(8.0),
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             border: Border.all(color: Color(0xFF3B82F6), width: 2.0),
  //           ),
  //           child: Icon(Icons.camera, color: Color(0xFF3B82F6), size: 26.0),
  //         ),
  //         SizedBox(height: 4.0),
  //         Text(
  //           'Foto Bukti',
  //           style: TextStyle(
  //             fontSize: 12.0,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.black87,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
