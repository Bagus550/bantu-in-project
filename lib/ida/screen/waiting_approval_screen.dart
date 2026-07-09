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
    // Membaca email user yang sedang aktif dari storage
    final email = await _secureStorage.read(key: 'email_user') ?? 'helper';
    setState(() {
      _userEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    // Diubah menggunakan Scaffold utuh agar merender background dan layout secara sempurna
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Indikator Status: Ikon Jam Pasir Menunggu Validasi
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

              // Judul Status Utama
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

              // Deskripsi Status Verifikasi Berkas
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

              // Informasi Akun Terdaftar
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

              // Tombol untuk Kembali dan Keluar dari Sesi
              OutlinedButton(
                onPressed: () async {
                  // Bersihkan token lokal agar user bisa kembali ke screen login dengan aman
                  await _secureStorage.delete(key: 'auth_token');
                  await _secureStorage.delete(key: 'jwt_token');

                  if (!mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
