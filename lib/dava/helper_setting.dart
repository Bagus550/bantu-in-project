import 'package:bantuin/ida/auth/auth_service.dart';
import 'package:bantuin/ida/screen/login_screen.dart';
import 'package:bantuin/ida/screen/ubah_katasandi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Mencegah error Clipboard
import 'package:bantuin/dava/edit_profile.dart';
import 'package:bantuin/config/app_config.dart';
import 'package:bantuin/ida/screen/profile.dart';
import 'package:bantuin/yuliana/about_helper.dart';
import 'package:bantuin/yuliana/Faq_Helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HelperSetting extends StatefulWidget {
  const HelperSetting({super.key});

  @override
  State<HelperSetting> createState() => _HelperSettingState();
}

class _HelperSettingState extends State<HelperSetting> {
  int currentUserId = 1;

  String _namaUser = "Memuat...";
  String _emailUser = "Memuat...";
  String? _fotoProfilUrl;

  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? idString = await _secureStorage.read(key: 'id_helper') ?? await _secureStorage.read(key: 'id_users');
    String? savedNama = await _secureStorage.read(key: 'nama_user');
    String? savedEmail = await _secureStorage.read(key: 'email_user');
    String? savedFoto = await _secureStorage.read(key: 'foto_profil_url');

    if (mounted) {
      setState(() {
        if (idString != null) {
          currentUserId = int.tryParse(idString) ?? 1;
        }
        _namaUser = savedNama ?? "Helper Bantu.in";
        _emailUser = savedEmail ?? "Email tidak tersedia";
        _fotoProfilUrl = savedFoto;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Section Dinamis
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Profile()),
                    ),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey,
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
                          ? const Icon(Icons.person, size: 36, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _namaUser,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _emailUser,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () async {
                            final isUpdated = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfile(),
                              ),
                            );
                            if (isUpdated == true) {
                              _loadUserData();
                            }
                          },
                          child: const Text(
                            'Edit Profil',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            const Text(
              'Akun & Keamanan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            _buildMenuItem(
              Icons.lock_outline,
              'Ubah Kata Sandi',
              true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UbahKatasandi()),
              ),
            ),
            const Divider(height: 24, thickness: 1),

            const Text(
              'Bantuan & Legalitas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            _buildMenuItem(
              Icons.info_outline,
              'Tentang Kami',
              true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutHelper()),
              ),
            ),
            _buildMenuItem(
              Icons.headset_mic_outlined,
              'Hubungi Kami',
              true,
              onTap: () => _showContactBottomSheet(context),
            ),
            _buildMenuItem(
              Icons.help_outline,
              'Pusat Bantuan (FAQ)',
              true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FaqHelper()),
              ),
            ),

            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  bool konfirmasi =
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Keluar Akun'),
                          content: const Text(
                            'Apakah kamu yakin ingin keluar dari aplikasi?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Ya, Keluar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ) ??
                      false;

                  if (konfirmasi) {
                    try {
                      final authService = AuthService();
                      await authService.logout();
                      await _secureStorage.deleteAll();

                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    } catch (e) {
                      print("Error saat logout: $e");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Keluar Akun',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Hapus Akun"),
                    content: const Text(
                      "Apakah Anda yakin ingin menghapus akun ini?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Batal"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _hapusAkunBackend();
                        },
                        child: const Text(
                          "Ya, Hapus",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Hapus Akun',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showContactBottomSheet(BuildContext context) {
    final String whatsappUrl = "https://wa.me/6285955035351";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hubungi Kami',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silahkan pilih metode di bawah ini untuk menghubungi tim dukungan kami.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final Uri url = Uri.parse(whatsappUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tidak dapat membuka WhatsApp'),
                          ),
                        );
                      }
                    }
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Hubungi via WhatsApp',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: whatsappUrl)).then((
                      _,
                    ) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link WhatsApp berhasil disalin!'),
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.copy, color: Colors.black87),
                  label: const Text(
                    'Salin Link Tautan',
                    style: TextStyle(color: Colors.black87),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _hapusAkunBackend() async {
    // 🔥 PERBAIKAN: Hapus Akun Helper pake Endpoint Helper, Jangan User
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/helpers/$currentUserId/hapus', 
    );
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        await _secureStorage.deleteAll();
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      }
    } catch (e) {
      print("Gagal: $e");
    }
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    bool hasTrailingAction, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(vertical: -2),
      leading: Icon(icon, color: Colors.black87, size: 26),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
      trailing: hasTrailingAction
          ? const Icon(Icons.chevron_right, color: Colors.grey)
          : null,
      onTap: onTap,
    );
  }
}