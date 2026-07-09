import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_screen.dart';

class WaitingApprovalScreen extends StatefulWidget {
  const WaitingApprovalScreen({super.key});

  @override
  State<WaitingApprovalScreen> createState() => _WaitingApprovalScreenState();
}

class _WaitingApprovalScreenState extends State<WaitingApprovalScreen> {
  final _secureStorage = const FlutterSecureStorage();
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  void _loadEmail() async {
    final email = await _secureStorage.read(key: 'email_user') ?? 'helper';
    setState(() {
      _userEmail = email;
    });
  }

  void _simulasikanPersetujuanAdmin() async {
    // Menyetujui dokumen secara lokal untuk testing
    await _secureStorage.write(key: 'helper_docs_submitted_$_userEmail', value: 'true');
    await _secureStorage.write(key: 'helper_admin_validated_$_userEmail', value: 'true');

    // Hapus sesi aktif agar pengguna dapat melakukan login ulang dengan status terverifikasi baru
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'jwt_token');

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Akun Berhasil Disetujui Admin (Simulasi)! Silakan login kembali.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      color: const Color(0xFFF8FAFC),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Jam pasir / Ikon verifikasi berdenyut
              Center(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amber.shade200, width: 2),
                  ),
                  child: const Icon(
                    Icons.hourglass_empty_rounded,
                    size: 80,
                    color: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Status Utama
              Text(
                "Menunggu Validasi Admin",
                style: GoogleFonts.openSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Deskripsi
              Text(
                "Terima kasih telah mengunggah dokumen Anda. Tim admin Bantu.in sedang memeriksa berkas pendaftaran Anda.\n\nProses verifikasi ini biasanya memakan waktu maksimal 1x24 jam. Kami akan mengaktifkan akun Anda segera setelah pemeriksaan selesai.",
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Info Email & Penutup
              Text(
                "Akun: $_userEmail",
                style: GoogleFonts.openSans(
                  fontSize: 12,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Tombol Keluar Sesi
              OutlinedButton(
                onPressed: () async {
                  // Hapus sesi login
                  await _secureStorage.delete(key: 'auth_token');
                  await _secureStorage.delete(key: 'jwt_token');
                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    this.context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  "Kembali ke Login",
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Tombol Testing Simulasi Admin Approval (Bypass)
              ElevatedButton.icon(
                onPressed: _simulasikanPersetujuanAdmin,
                icon: const Icon(Icons.verified_user_rounded, size: 18),
                label: Text(
                  "Simulasikan Validasi Admin (Bypass)",
                  style: GoogleFonts.openSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 44),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
