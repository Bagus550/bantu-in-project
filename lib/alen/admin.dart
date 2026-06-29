import 'package:bantuin/alen/paypage.dart';
import 'package:bantuin/alen/registhelper.dart';
import 'package:bantuin/ida/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bantuin/config/app_config.dart';

class MyAdmin extends StatefulWidget {
  const MyAdmin({super.key});

  @override
  State<MyAdmin> createState() => _MyAdminState();
}

class _MyAdminState extends State<MyAdmin> {
  int _currentIndex = 0;
  int currentPage = 1;
  final int itemsPerPage = 5;

  bool isLoading = true;
  List<dynamic> helpersList = [];
  List<dynamic> filteredHelpers = [];
  final TextEditingController _searchController = TextEditingController();

  int jumlahHelperTerdaftar = 0;
  int jumlahHelperAktif = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _filterHelpers(String query) {
    setState(() {
      filteredHelpers = helpersList
          .where(
            (h) =>
                (h['nama'] ?? '').toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      currentPage = 1;
    });
  }

  Future<void> fetchData() async {
    try {
      var response = await http.get(
        Uri.parse('${AppConfig.baseUrl}/api/admin/dashboard'),
        headers: {"ngrok-skip-browser-warning": "69420"},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          helpersList = data['data']['helpers'] ?? [];
          filteredHelpers = helpersList;
          jumlahHelperTerdaftar = helpersList.length;
          jumlahHelperAktif = helpersList
              .where(
                (h) =>
                    h['status_aktif'] == 1 ||
                    h['status_aktif'] == '1' ||
                    h['status_aktif'] == true ||
                    h['status_aktif'] == 'ACTIVE',
              )
              .length;
          isLoading = false;
        });
      } else {
        print("Gagal mengambil data. Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _updateHelperStatus(dynamic id, String action) async {
    String targetUrl = (action == 'delete')
        ? '${AppConfig.baseUrl}/api/admin/delete-helper'
        : '${AppConfig.baseUrl}/api/admin/toggle-helper-status';

    Map<String, String> requestBody = {'id_helper': id.toString()};

    if (action != 'delete') {
      requestBody['status_aktif'] = (action == 'activate') ? '1' : '0';
    }

    try {
      var response = await http.post(
        Uri.parse(targetUrl),
        body: requestBody,
        headers: {"ngrok-skip-browser-warning": "69420"},
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        fetchData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Berhasil $action akun helper'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Tampilkan pesan error dari backend (misal: gagal hapus karena ada tugas)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['messages']?['message'] ?? 'Gagal memproses aksi',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan koneksi!')));
    }
  }

  Future<void> _showConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
    required Color confirmColor,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(content),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmColor,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text('Ya, Lanjutkan'),
            ),
          ],
        );
      },
    );
  }

  void _showHelperDetail(Map<String, dynamic> helper) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                "Informasi Lengkap",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Widget untuk menampilkan tiap baris detail
              _buildDetailRow(
                Icons.phone,
                "No. WhatsApp",
                helper['no_hp'] ?? '-',
              ),
              _buildDetailRow(
                Icons.account_balance,
                "Nama Bank",
                helper['nama_bank'] ?? '-',
              ),
              _buildDetailRow(
                Icons.credit_card,
                "Nomor Rekening",
                helper['nomor_rekening'] ?? '-',
              ),

              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Tutup"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurpleAccent, size: 22),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                value,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bantu.In - Admin",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 3,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                icon: Icon(Icons.logout, color: Colors.red, size: 28),
              ),
              SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Helper Management",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      onChanged: _filterHelpers,
                      decoration: InputDecoration(
                        labelText: "Search Helpers",
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSmallCard(
                            title: "Total Helpers",
                            value: jumlahHelperTerdaftar.toString(),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildSmallCard(
                            title: "Active Now",
                            value: jumlahHelperAktif.toString(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Helper Database",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: () {
                          if (filteredHelpers.isEmpty) {
                            return [
                              const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text("Tidak Ada Data"),
                              ),
                            ];
                          }

                          int startIndex = (currentPage - 1) * itemsPerPage;
                          List<dynamic> pagedHelpers = helpersList
                              .skip(startIndex)
                              .take(itemsPerPage)
                              .toList();

                          return pagedHelpers.asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> helper = entry.value;

                            return Column(
                              children: [
                                _buildHelperItem(helper),
                                if (index != pagedHelpers.length - 1)
                                  const Divider(height: 1, color: Colors.grey),
                              ],
                            );
                          }).toList();
                        }(),
                      ),
                    ),

                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Showing ${helpersList.isEmpty ? 0 : ((currentPage - 1) * itemsPerPage) + 1} to "
                          "${(currentPage * itemsPerPage) > helpersList.length ? helpersList.length : (currentPage * itemsPerPage)} "
                          "of ${helpersList.length} helpers",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: currentPage > 1
                                  ? () {
                                      setState(() {
                                        currentPage--;
                                      });
                                    }
                                  : null,
                              child: _buildPageButton(
                                Icons.chevron_left,
                                isDisabled: currentPage == 1,
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap:
                                  (currentPage * itemsPerPage) <
                                      helpersList.length
                                  ? () {
                                      setState(() {
                                        currentPage++;
                                      });
                                    }
                                  : null,
                              child: _buildPageButton(
                                Icons.chevron_right,
                                isDisabled:
                                    (currentPage * itemsPerPage) >=
                                    helpersList.length,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                  ],
                ),
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
            icon: Icon(Icons.how_to_reg, color: Colors.black),
            label: "Registration",
          ),
          NavigationDestination(
            icon: Icon(Icons.payment_outlined, color: Colors.black),
            label: "Payments",
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard({
    required String title,
    required String value,
    String? subtitle,
  }) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 88, 26, 246),
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 8),
            Row(children: [Text(subtitle, style: TextStyle(fontSize: 11))]),
          ],
        ],
      ),
    );
  }

  Widget _buildHelperItem(Map<String, dynamic> data) {
    var statusAktif = data['status_aktif'] ?? 1;
    int jumlahTugasDiambil = int.tryParse(data['total_tasks'].toString()) ?? 0;

    return InkWell(
      onTap: () => _showHelperDetail(data),
      child: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color.fromARGB(255, 205, 205, 205),
                  child: Icon(Icons.person, size: 30),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['nama'] ?? 'anonim',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Helper Bantu.In",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(statusAktif),
              ],
            ),

            SizedBox(height: 12),
            Text(
              "Tasks: $jumlahTugasDiambil Tugas Diambil",
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),

            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _buildActionButtons(statusAktif, data['id_helper']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(dynamic statusAktif) {
    Color bgColor;
    String textStatus;

    if (statusAktif == 1 ||
        statusAktif == '1' ||
        statusAktif == true ||
        statusAktif == "ACTIVE") {
      bgColor = Colors.green;
      textStatus = "ACTIVE";
    } else {
      bgColor = Colors.red;
      textStatus = "SUSPEND";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        textStatus,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons(dynamic statusAktif, dynamic idHelper) {
    int safeId = int.tryParse(idHelper.toString()) ?? 0;

    if (statusAktif == 1 ||
        statusAktif == '1' ||
        statusAktif == true ||
        statusAktif == "ACTIVE") {
      return [
        _buildElevatedButton(
          label: "Suspend Akun",
          color: Colors.red,
          onPressed: () {
            _showConfirmationDialog(
              title: "Suspend Akun?",
              content:
                  "Helper ini tidak akan bisa menerima tugas baru. Anda yakin?",
              confirmColor: Colors.red,
              onConfirm: () => _updateHelperStatus(safeId, 'suspend'),
            );
          },
        ),
      ];
    } else {
      return [
        _buildElevatedButton(
          label: "Buka Suspend",
          color: Colors.blue,
          onPressed: () {
            _showConfirmationDialog(
              title: "Aktifkan Akun?",
              content:
                  "Helper ini akan dapat menerima tugas kembali. Anda yakin?",
              confirmColor: Colors.blue,
              onConfirm: () => _updateHelperStatus(safeId, 'activate'),
            );
          },
        ),
        const SizedBox(width: 8),
        _buildElevatedButton(
          label: "Hapus Akun",
          color: Colors.red,
          onPressed: () {
            _showConfirmationDialog(
              title: "Hapus Permanen?",
              content:
                  "Akun ini akan dihapus permanen dari database. Data yang hilang tidak dapat dikembalikan. Yakin?",
              confirmColor: Colors.red.shade900,
              onConfirm: () => _updateHelperStatus(safeId, 'delete'),
            );
          },
        ),
      ];
    }
  }

  Widget _buildElevatedButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(6),
        ),
        minimumSize: Size(0, 32),
        elevation: 0,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPageButton(IconData icon, {bool isDisabled = false}) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Icon(icon, size: 20, color: Colors.grey),
    );
  }
}
