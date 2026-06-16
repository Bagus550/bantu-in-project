import 'package:bantuin/dava/helper_setting.dart';
import 'package:bantuin/ida/profile_tab.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil Saya",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        toolbarHeight: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelperSetting()),
                );
              },
              icon: Icon(
                Icons.settings,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Colors.grey.shade400, height: 1),
        ),
      ),
      body: ProfileTab(),
    );
  }
}
