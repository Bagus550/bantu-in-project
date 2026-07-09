import 'dart:convert';
import 'package:bantuin/alen/paypage.dart';
import 'package:bantuin/config/app_config.dart';
import 'package:bantuin/ida/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'admin.dart';

class RegistPage extends StatefulWidget {
  const RegistPage({super.key});

  @override
  State<RegistPage> createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  int _currentIndex = 1;
  List<dynamic> _pendingHelpers = [];
  bool _isLoading = true;

  final AuthService _authService = AuthService();
  String? _currentAdminId;

  @override
  void initState() {
    super.initState();
    _initAdminSessionAndFetch();
  }

  Future<void> _initAdminSessionAndFetch() async {
    final adminId = await _authService.getUserId();
    setState(() {
      _currentAdminId = adminId;
    });
    await _fetchPendingHelpers();
  }

  Future<void> _fetchPendingHelpers() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(AppConfig.getPendingHelpers));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _pendingHelpers = data['data'] ?? [];
        });
      } else {
        _showSnackBar(
          "Gagal memuat data dari server (${response.statusCode})",
          Colors.orange,
        );
      }
    } catch (e) {
      _showSnackBar("Terjadi kesalahan jaringan: $e", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyHelperAction(int idHelper, int status) async {
    if (_currentAdminId == null) {
      _showSnackBar(
        "Sesi admin tidak valid. Silakan login kembali.",
        Colors.red,
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(AppConfig.verifikasiHelper),
        body: {
          'id_helper': idHelper.toString(),
          'id_admin_pendaftar':
              _currentAdminId, // Dinamis menggunakan ID admin aktif[cite: 5]
          'status_aktif': status.toString(),
        },
      );

      final resData = json.decode(response.body);
      if (response.statusCode == 200) {
        _showSnackBar(
          resData['message'] ?? "Status helper berhasil diperbarui",
          Colors.green,
        );
        _fetchPendingHelpers();
      } else {
        _showSnackBar(
          resData['message'] ?? "Gagal memperbarui status berkas",
          Colors.red,
        );
      }
    } catch (e) {
      _showSnackBar("Gagal menghubungi server: $e", Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  void _openVerificationSheet(Map<String, dynamic> helper) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Detail Berkas Pendaftaran",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(height: 24),

                // Informasi Profil Pendaftar
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.deepPurple[100],
                    backgroundImage: helper['foto_profil'] != null
                        ? NetworkImage(
                            "${AppConfig.baseUrl}/uploads/profiles/${helper['foto_profil']}",
                          )
                        : null,
                    child: helper['foto_profil'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(
                    helper['nama'] ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${helper['email']}\n${helper['no_hp']}"),
                ),
                const SizedBox(height: 16),

                // Informasi Rekening
                const Text(
                  "Rekening Pembayaran Helper",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${helper['nama_bank']} — ${helper['nomor_rekening']}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),

                // List Berkas / Dokumen Fisik
                const Text(
                  "Berkas Dokumen Pendukung",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                _buildFileTile(
                  Icons.credit_card,
                  "Kartu Tanda Penduduk (KTP)",
                  helper['ktp'],
                  "ktp",
                ),
                _buildFileTile(
                  Icons.assignment_ind,
                  "Surat Izin Mengemudi (SIM)",
                  helper['sim'],
                  "sim",
                ),
                _buildFileTile(
                  Icons.gavel,
                  "Surat Keterangan Catatan Kepolisian (SKCK)",
                  helper['skck'],
                  "skck",
                ),

                const SizedBox(height: 32),

                // Tombol Eksekusi Admin
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _verifyHelperAction(
                            int.parse(helper['id_helper'].toString()),
                            0,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "TOLAK BERKAS",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _verifyHelperAction(
                            int.parse(helper['id_helper'].toString()),
                            1,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "SETUJUI & AKTIFKAN",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFileTile(
    IconData icon,
    String title,
    String? fileName,
    String folderName,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          fileName ?? "Belum diunggah",
          style: TextStyle(
            color: fileName != null ? Colors.blue : Colors.red,
            fontSize: 13,
          ),
        ),
        trailing: fileName != null
            ? const Icon(Icons.visibility, size: 20, color: Colors.grey)
            : null,
        onTap: fileName != null
            ? () {
                final String fileUrl =
                    "${AppConfig.baseUrl}/uploads/$folderName/$fileName";

                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppBar(
                          backgroundColor: Colors.black54,
                          title: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          leading: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        InteractiveViewer(
                          // Supaya gambar berkas bisa di-zoom oleh admin
                          child: Image.network(
                            fileUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.all(20),
                                  child: const Column(
                                    children: [
                                      Icon(
                                        Icons.broken_image,
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Gagal memuat file gambar berkas.",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bantu.In — Verifikasi Berkas",
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        elevation: 3,
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingHelpers.isEmpty
          ? const Center(
              child: Text("Tidak ada berkas pendaftaran helper baru."),
            )
          : RefreshIndicator(
              onRefresh: _fetchPendingHelpers,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _pendingHelpers.length,
                itemBuilder: (context, index) {
                  final helper = _pendingHelpers[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage: helper['foto_profil'] != null
                            ? NetworkImage(
                                "${AppConfig.baseUrl}/uploads/profil/${helper['foto_profil']}",
                              )
                            : null,
                        child: helper['foto_profil'] == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(
                        helper['nama'] ?? '-',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Email: ${helper['email']}\nNo. HP: ${helper['no_hp']}",
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openVerificationSheet(helper),
                    ),
                  );
                },
              ),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          if (_currentIndex == index) return;
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyAdmin()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegistPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PayPage()),
            );
          }
        },
        backgroundColor: Colors.white,
        indicatorColor: Colors.deepPurpleAccent,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline, color: Colors.black),
            selectedIcon: Icon(Icons.people, color: Colors.black),
            label: "Helpers",
          ),
          NavigationDestination(
            icon: Icon(Icons.how_to_reg, color: Colors.black),
            label: "Verifikasi",
          ),
          NavigationDestination(
            icon: Icon(Icons.payment_outlined, color: Colors.black),
            label: "Payments",
          ),
        ],
      ),
    );
  }
}
