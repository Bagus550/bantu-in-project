import 'package:bantuin/alen/registhelper.dart';
import 'package:bantuin/data_tugas.dart';
import 'package:bantuin/ida/login_screen.dart';
import 'package:flutter/material.dart';

class MyAdmin extends StatefulWidget {
  const MyAdmin({super.key});

  @override
  State<MyAdmin> createState() => _MyAdminState();
}

class _MyAdminState extends State<MyAdmin> {
  int _currentIndex = 0;
  int currentPage = 1;
  final int itemsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    int jumlahHelperTerdaftar = tasks
        .where((task) => task['nama_helper'] != "")
        .map((task) => task["nama_helper"])
        .toSet()
        .length;

    int jumlahHelperAktif = helpers
        .where((helper) => helper['status_aktif'] == 1)
        .length;

    int validasi = tasks
        .where((task) => task['status'] == "Menunggu validasi")
        .length;

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
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  color: Theme.of(context).colorScheme.primary,
                  size: 25,
                ),
              ),
              SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Helper Management",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: "Search Helpers",
                  prefixIcon: Icon(Icons.search),
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
              SizedBox(height: 16),
              _buildWideCard(
                title: "Pending Approval",
                value: validasi.toString(),
                subtitle: "Action Required",
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
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_list,
                          size: 18,
                          color: Colors.black,
                        ),
                        label: Text(
                          "Filter",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.download_rounded,
                          size: 18,
                          color: Colors.black,
                        ),
                        label: Text(
                          "Export",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                        ),
                      ),
                    ],
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
                    // Rumus memotong list data berdasarkan halaman aktif
                    int startIndex = (currentPage - 1) * itemsPerPage;
                    List<Map<String, dynamic>> pagedHelpers = helpers
                        .skip(startIndex)
                        .take(itemsPerPage)
                        .toList();

                    return pagedHelpers.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> helper = entry.value;

                      return Column(
                        children: [
                          _buildHelperItem(helper),
                          // Divider tidak muncul di item paling bawah pada halaman tersebut
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
                    "Showing ${((currentPage - 1) * itemsPerPage) + 1} to "
                    "${(currentPage * itemsPerPage) > helpers.length ? helpers.length : (currentPage * itemsPerPage)} "
                    "of ${helpers.length} helpers",
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
                        onTap: (currentPage * itemsPerPage) < helpers.length
                            ? () {
                                setState(() {
                                  currentPage++;
                                });
                              }
                            : null,
                        child: _buildPageButton(
                          Icons.chevron_right,
                          isDisabled:
                              (currentPage * itemsPerPage) >= helpers.length,
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
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.black),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

Widget _buildSmallCard({
  required String title,
  required String value,
  String? subtitle,
}) {
  return Container(
    height: 125,
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

Widget _buildWideCard({
  required String title,
  required String value,
  required String subtitle,
}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}

Widget _buildHelperItem(Map<String, dynamic> data) {
  var statusAktif = data['status_aktif'] ?? 1;

  String namaHelper = data['nama'] ?? 'anonim';

  int jumlahTugasDiambil = tasks.where((task) {
    return task['nama_helper'] == namaHelper && task['status'] != "Dibatalkan";
  }).length;

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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    data['email'] ?? '-',
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

        SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _buildActionButtons(statusAktif),
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

List<Widget> _buildActionButtons(dynamic statusAktif) {
  if (statusAktif == 1) {
    return [_buildElevatedButton(label: "Suspend Akun", isDanger: true)];
  } else {
    return [
      _buildElevatedButton(label: "Buka Suspend", isDanger: false),
      const SizedBox(width: 8),
      _buildElevatedButton(label: "Hapus Akun", isDanger: true),
    ];
  }
}

Widget _buildElevatedButton({required String label, required bool isDanger}) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: isDanger ? Colors.red : Colors.blue,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(6),
      ),
      minimumSize: Size(0, 36),
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
