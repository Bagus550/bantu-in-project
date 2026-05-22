import 'package:flutter/material.dart';

class DashboardUserScreen extends StatefulWidget {
  const DashboardUserScreen({super.key});

  @override
  State<DashboardUserScreen> createState() => _DashboardUserScreenState();
}

class _DashboardUserScreenState extends State<DashboardUserScreen> {
  int _currentIndex = 0;

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
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withAlpha(50),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withAlpha(50),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                  ),
                ),
              ),
            ),
            Text(
              "TUGAS BERLANGSUNG",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black.withAlpha(50)),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFE0E7FF),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Icon(
                            Icons.cleaning_services_rounded,
                            size: 32.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bersihin Ruang Tamu",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 6),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1D4ED8),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.autorenew_rounded,
                                      size: 14.0,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      'Sedang Dikerjakan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),

                    Divider(color: Color(0xFFE2E8F0), thickness: 1.5),

                    SizedBox(height: 12.0),

                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage(
                            'https://placekitty.com/100/100',
                          ),
                        ),
                        SizedBox(width: 12.0),

                        Expanded(
                          child: Text(
                            'Dava H.',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        IconButton(
                          icon: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 26.0,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/chat-room');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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
              _buildNavItem(index: 0, icon: Icons.home_filled, label: 'Home'),
              _buildNavItem(
                index: 1,
                icon: Icons.assignment_outlined,
                label: 'My Task',
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
      onTap: () {},
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
}
