import 'package:bantuin/alen/registhelper.dart';
import 'package:bantuin/data_tugas.dart';
import 'package:flutter/material.dart';

class MyAdmin extends StatefulWidget {
  const MyAdmin({super.key});

  @override
  State<MyAdmin> createState() => _MyAdminState();
}

class _MyAdminState extends State<MyAdmin> {
  int _currentIndex = 0;

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
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(width: 12),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.account_circle,
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
                  icon: Icon(Icons.search),
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
                      value: "1,284",
                      subtitle: "+12% this month",
                      isTrendingUp: true,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildSmallCard(title: "Active Now", value: "456"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildWideCard(
                title: "Pending Approval",
                value: "42",
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
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  children: helperList.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> helper = entry.value;

                    return Column(
                      children: [
                        _buildHelperItem(helper),
                        if (index != helperList.length - 1)
                          Divider(height: 1, color: Colors.grey),
                      ],
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Showing 3 of 1,294 helpers",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Row(
                    children: [
                      _buildPageButton(Icons.chevron_left),
                      SizedBox(width: 8),
                      _buildPageButton(Icons.chevron_right),
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
  bool isTrendingUp = false,
}) {
  return Container(
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
          Row(
            children: [
              if (isTrendingUp)
                Icon(Icons.trending_up, color: Colors.lightGreenAccent),
              if (isTrendingUp) SizedBox(width: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isTrendingUp ? Colors.greenAccent : Colors.grey,
                ),
              ),
            ],
          ),
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
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.grey, size: 30),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    data['role'],
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            _buildStatusBadge(data['status']),
          ],
        ),

        SizedBox(height: 12),
        Text(
          "Tasks: ${data['tasks']}",
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),

        SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _buildActionButtons(data['status']),
        ),
      ],
    ),
  );
}

Widget _buildStatusBadge(String status) {
  Color bgColor;
  Color textColor;

  if (status == "ACTIVE") {
    bgColor = Colors.green;
    textColor = Colors.black;
  } else if (status == "SUSPENDED") {
    bgColor = Colors.red;
    textColor = Colors.black;
  } else {
    bgColor = Colors.deepPurple;
    textColor = Colors.black;
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
    ),
  );
}

List<Widget> _buildActionButtons(String status) {
  if (status == "ACTIVE") {
    return [_buildElevatedButton(label: "Suspend Akun", isDanger: true)];
  } else if (status == "SUSPEND") {
    return [
      _buildElevatedButton(label: "Buka Suspend", isDanger: false),
      SizedBox(width: 8),
      _buildElevatedButton(label: "Hapus Akun", isDanger: true),
    ];
  } else {
    return [_buildElevatedButton(label: "Terima", isDanger: false)];
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

Widget _buildPageButton(IconData icon) {
  return Container(
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
    child: Icon(icon, size: 20, color: Colors.grey),
  );
}