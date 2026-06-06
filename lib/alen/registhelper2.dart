import 'package:bantuin/alen/registhelper3.dart';
import 'package:flutter/material.dart';
import 'admin.dart';
import 'registhelper.dart';

class RegistPage2 extends StatefulWidget {
  const RegistPage2({super.key});

  @override
  State<RegistPage2> createState() => _RegistPage2State();
}

class _RegistPage2State extends State<RegistPage2> {
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bantu.In - Registration Helper",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 17,
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
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Account & Contact Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Secure your account and let clients reach you easily.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 24),
              Text(
                "Email Address",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: "name@example.com",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              SizedBox(height: 8),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Min. 8 characters",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: Icon(Icons.visibility_outlined),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "WhatsApp Number",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "+62 812 3456 789",
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Used for quick coordination on active tasks.",
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistPage3()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 88, 26, 246),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Next Step",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 88, 26, 246),
                    side: BorderSide(color: Colors.grey),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Back",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.privacy_tip_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Data Privacy",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Your contact details are only shared with clients once a task is confirmed.",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
