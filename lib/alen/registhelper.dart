import 'package:bantuin/alen/paypage.dart';
import 'package:flutter/material.dart';
import 'admin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bantuin/config/app_config.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistPage extends StatefulWidget {
  const RegistPage({super.key});

  @override
  State<RegistPage> createState() => _RegistPageState();
}

class _RegistPageState extends State<RegistPage> {
  int _currentIndex = 1;
  bool isLoading = true;
  List<dynamic> pendingHelpers = [];

  @override
  void initState() {
    super.initState();
    fetchPendingHelpers();
  }

  Future<void> fetchPendingHelpers() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/admin/dashboard'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> allHelpers = data['data']['helpers'] ?? [];
        
        // Filter helper yang status_aktif == 0
        // Kita juga pastikan mereka memiliki KTP (artinya sudah mengisi form dokumen di Step 2)
        setState(() {
          pendingHelpers = allHelpers.where((h) {
            final int status = int.tryParse(h['status_aktif'].toString()) ?? 1;
            final String? ktp = h['ktp'];
            return status == 0 && ktp != null && ktp.isNotEmpty;
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _verifikasiHelper(int idHelper, int status) async {
    try {
      var response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/admin/toggle-helper-status'),
        body: {
          'id_helper': idHelper.toString(),
          'status_aktif': status.toString(),
        },
      );

      var resData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(status == 1 ? 'Helper berhasil disetujui!' : 'Helper ditolak/suspend.'),
            backgroundColor: status == 1 ? Colors.green : Colors.orange,
          ),
        );
        fetchPendingHelpers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resData['message'] ?? 'Gagal memproses aksi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan koneksi!')),
      );
    }
  }

  void _showDetailReview(Map<String, dynamic> helper) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Review Berkas: ${helper['nama']}",
            style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoSection("Nama Jasa/Bank", helper['nama_bank'] ?? '-'),
                _buildInfoSection("Nomor Rekening", helper['nomor_rekening'] ?? '-'),
                const SizedBox(height: 16),
                _buildDocumentView("Foto Profil (Selfie)", helper['foto_profil'], isProfile: true),
                const SizedBox(height: 12),
                _buildDocumentView("KTP", helper['ktp']),
                const SizedBox(height: 12),
                _buildDocumentView("SIM", helper['sim']),
                const SizedBox(height: 12),
                _buildDocumentView("SKCK", helper['skck']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _verifikasiHelper(int.parse(helper['id_helper'].toString()), 0);
              },
              child: const Text("Tolak"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _verifikasiHelper(int.parse(helper['id_helper'].toString()), 1);
              },
              child: const Text("Setujui"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildDocumentView(String label, String? filename, {bool isProfile = false}) {
    final String folder = isProfile ? 'profiles' : 'documents';
    final String imageUrl = filename != null && filename.isNotEmpty
        ? "${AppConfig.baseUrl}/uploads/$folder/$filename"
        : "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade100,
          ),
          child: imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text("Gagal memuat gambar"));
                    },
                  ),
                )
              : const Center(child: Text("Tidak ada berkas")),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bantu.In - Validasi Helper",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        elevation: 3,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pendingHelpers.isEmpty
              ? Center(
                  child: Text(
                    "Tidak ada pendaftaran helper baru yang perlu divalidasi.",
                    style: GoogleFonts.openSans(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: pendingHelpers.length,
                  itemBuilder: (context, index) {
                    final helper = pendingHelpers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple.shade100,
                          child: const Icon(Icons.person, color: Colors.deepPurple),
                        ),
                        title: Text(helper['nama'] ?? 'Helper', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(helper['email'] ?? '-'),
                        trailing: ElevatedButton(
                          onPressed: () => _showDetailReview(helper),
                          child: const Text("Tinjau Berkas"),
                        ),
                      ),
                    );
                  },
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
              MaterialPageRoute(builder: (context) => const MyAdmin()),
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
            icon: Icon(Icons.verified_user_outlined, color: Colors.black),
            selectedIcon: Icon(Icons.verified_user, color: Colors.black),
            label: "Validation",
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
