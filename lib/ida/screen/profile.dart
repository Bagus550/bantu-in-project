import 'package:bantuin/dava/helper_setting.dart';
import 'package:bantuin/dava/user_setting.dart';
import 'package:bantuin/ida/screen/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profil Saya",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        toolbarHeight: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                String? role = await _secureStorage.read(key: 'role');

                print("DEBUG ROLE SAAT INI: $role");

                if (!mounted) return;

                if (role == 'helper') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelperSetting(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserSetting(),
                    ),
                  );
                }
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
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade400, height: 1),
        ),
      ),
      body: const ProfileTab(),
    );
  }
}
