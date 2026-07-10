import 'package:bantuin/ida/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _secureStorage = const FlutterSecureStorage();

  String _nama = "Memuat...";
  String _email = "Memuat...";
  String _noHp = "Memuat...";
  String? _fotoProfilUrl;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    String? savedNama = await _secureStorage.read(key: 'nama_user');
    String? savedEmail = await _secureStorage.read(key: 'email_user');
    String? savedNoHp = await _secureStorage.read(key: 'no_hp');
    String? savedFoto = await _secureStorage.read(key: 'foto_profil_url');
    String? role = await _secureStorage.read(key: 'role') ?? await _secureStorage.read(key: 'user_role');

    if (mounted) {
      setState(() {
        _nama = savedNama ?? "User";
        _email = savedEmail ?? "Email tidak tersedia";
        _noHp = (savedNoHp != null && savedNoHp != "null")
            ? savedNoHp
            : "Tidak tersedia";
        _fotoProfilUrl = savedFoto;
        _role = role;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              image: (_fotoProfilUrl != null &&
                                      _fotoProfilUrl!.isNotEmpty &&
                                      _fotoProfilUrl!.startsWith('http'))
                                  ? DecorationImage(
                                      image: NetworkImage(_fotoProfilUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: (_fotoProfilUrl == null ||
                                    _fotoProfilUrl!.isEmpty ||
                                    !_fotoProfilUrl!.startsWith('http'))
                                ? const Icon(Icons.person, size: 40, color: Colors.grey)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(_email),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Data Akun",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.person_2_outlined, size: 30),
                      const SizedBox(width: 10),
                      Text(
                        _role == 'helper' ? "Nama Lengkap: " : "Username: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(_nama),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Kontak",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.mail_outline, size: 30),
                      const SizedBox(width: 10),
                      const Text(
                        "Email: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(_email),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.call_outlined, size: 30),
                      const SizedBox(width: 10),
                      const Text(
                        "No Telepon: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(_noHp),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        final konfirmasi = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Keluar Akun'),
                            content: const Text(
                              'Apakah kamu yakin ingin keluar dari akun ini?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text(
                                  'Ya, Keluar',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (konfirmasi == true) {
                          final authService = AuthService();
                          await authService.logout();
                          await _secureStorage.deleteAll();

                          if (!mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      },
                      child: const Text(
                        "Keluar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
