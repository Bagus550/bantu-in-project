import 'package:bantuin/alen/admin.dart';
import 'package:bantuin/alen/registhelper.dart';
import 'package:flutter/material.dart';

class RegistPage3 extends StatefulWidget {
  const RegistPage3({super.key});

  @override
  State<RegistPage3> createState() => _RegistPage3State();
}

class _RegistPage3State extends State<RegistPage3> {
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Bantu.In - Registration Helper",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
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
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Banking Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Please provide your bank account information so we can process your payments securely.",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bank Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Select your bank",
                        suffixIcon: Icon(
                          Icons.keyboard_arrow_down,
                        ), // Ikon panah bawah
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Account Number",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      keyboardType:
                          TextInputType.number, // Munculin keyboard angka
                      decoration: InputDecoration(
                        hintText: "e.g. 1234567890",
                        suffixIcon: Icon(
                          Icons.account_balance,
                        ), // Ikon gedung bank
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                          255,
                          243,
                          240,
                          255,
                        ), // Background ungu sangat pudar
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color.fromARGB(255, 220, 210, 250),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.security_outlined,
                            color: Color.fromARGB(255, 88, 26, 246),
                            size: 18,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Your banking information is encrypted and stored securely. We only use this to facilitate your earnings payouts.",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 88, 26, 246),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Finish Registration",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.check_circle_outline,
                        size: 20,
                      ), // Ikon centang
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back to Personal Info",
                    style: TextStyle(
                      color: Color.fromARGB(255, 88, 26, 246),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
        destinations: [
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
