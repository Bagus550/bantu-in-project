import 'package:bantuin/alen/paypage.dart';
import 'package:bantuin/alen/registhelper.dart';
import 'package:bantuin/data_tugas.dart';
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
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          helpersList = data['data']['helpers'] ?? [];
          filteredHelpers = helpersList;
          jumlahHelperTerdaftar = helpersList.length;
          jumlahHelperAktif = helpersList
              .where(
                (h) => h['status_aktif'] == 1 || h['status_aktif'] == 'ACTIVE',
              )
              .length;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $e");
    }
  }

  Future<void> _updateHelperStatus(int id, String action) async {
    try {
      var response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/admin/helper/$action/$id'),
      );
      if (response.statusCode == 200) {
        fetchData();
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal $action helper')));
    }
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
                icon: Icon(
                  Icons.logout,
                  color: Colors.red,
                  size: 28,
                ),
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
    int jumlahTugasDiambil = data['total_tasks'] ?? 0;

    return Padding(
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
    );
  }

  Widget _buildStatusBadge(dynamic statusAktif) {
    Color bgColor;
    String textStatus;

    if (statusAktif == 1 || statusAktif == "ACTIVE") {
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
    if (statusAktif == 1 || statusAktif == "ACTIVE") {
      return [
        _buildElevatedButton(
          label: "Suspend Akun",
          color: Colors.red,
          onPressed: () => _updateHelperStatus(idHelper, 'suspend'),
          ),
        ];
    } else {
      return [
        _buildElevatedButton(
          label: "Buka Suspend",
          color: Colors.blue,
          onPressed: () => _updateHelperStatus(idHelper, 'activate'),
          ),
        const SizedBox(width: 8),
        _buildElevatedButton(
          label: "Hapus Akun",
          color: Colors.red,
          onPressed: () => _updateHelperStatus(idHelper, 'delete'),
        ),
      ];
    }
  }

  Widget _buildElevatedButton({required String label, required Color color, required VoidCallback onPressed,
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
