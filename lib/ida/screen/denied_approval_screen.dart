import 'package:bantuin/ida/screen/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_screen.dart';

class DeniedApprovalScreen extends StatefulWidget {
  final String catatanPenolakan;
  final Map<String, dynamic> userData;
  const DeniedApprovalScreen({
    super.key,
    required this.catatanPenolakan,
    required this.userData,
  });

  @override
  State<DeniedApprovalScreen> createState() => _WaitingApprovalScreenState();
}

class _WaitingApprovalScreenState extends State<DeniedApprovalScreen> {
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
              Center(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red.shade200, width: 2),
                  ),
                  child: const Icon(
                    Icons.cancel_outlined,
                    size: 80,
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Judul Status Utama
              Text(
                "Pendaftaran Anda Ditolak",
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
                "Mohon maaf, berkas pendaftaran Anda belum memenuhi kriteria tim verifikator Bantu.in. Silakan periksa alasan penolakan di bawah ini:",
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Alasan Penolakan Admin:",
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.catatanPenolakan,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
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

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(
                        selectedRole: 'helper',
                        initialPage:
                            1, // Langsung mengarah ke form unggah berkas
                        userData:
                            widget.userData, // Lempar data user ke register
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  "Upload Ulang Dokumen",
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),

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
