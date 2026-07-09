import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'waiting_approval_screen.dart';

class HelperDocumentsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final VoidCallback? onNext;
  const HelperDocumentsScreen({super.key, required this.userData, this.onNext});

  @override
  State<HelperDocumentsScreen> createState() => _HelperDocumentsScreenState();
}

class _HelperDocumentsScreenState extends State<HelperDocumentsScreen> {
  final _secureStorage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  // Dokumen Status (simulasi nama file terunggah)
  String? _ktpFileName;
  String? _simFileName;
  String? _skckFileName;
  String? _selfieFileName;

  // Rekening Bank
  String _selectedBank = 'Pilih Bank';
  final TextEditingController _noRekeningController = TextEditingController();
  final TextEditingController _pemilikRekeningController = TextEditingController();

  final List<String> _bankList = [
    'Pilih Bank',
    'BCA (Bank Central Asia)',
    'Mandiri',
    'BRI (Bank Rakyat Indonesia)',
    'BNI (Bank Negara Indonesia)',
    'CIMB Niaga',
  ];

  @override
  void initState() {
    super.initState();
    // Default nama pemilik rekening dengan nama lengkap helper
    _pemilikRekeningController.text = widget.userData['username'] ?? widget.userData['nama'] ?? '';
  }

  @override
  void dispose() {
    _noRekeningController.dispose();
    _pemilikRekeningController.dispose();
    super.dispose();
  }

  // Fungsi untuk memvalidasi kelengkapan semua dokumen
  bool _areDocumentsComplete() {
    return _ktpFileName != null &&
        _simFileName != null &&
        _skckFileName != null &&
        _selfieFileName != null &&
        _selectedBank != 'Pilih Bank' &&
        _noRekeningController.text.trim().isNotEmpty &&
        _pemilikRekeningController.text.trim().isNotEmpty;
  }

  void _simulasikanUpload(String tipeDokumen) {
    setState(() {
      final String mockName = "${tipeDokumen.toLowerCase()}_${widget.userData['id'] ?? 'user'}_scanned.jpg";
      if (tipeDokumen == 'KTP') _ktpFileName = mockName;
      if (tipeDokumen == 'SIM') _simFileName = mockName;
      if (tipeDokumen == 'SKCK') _skckFileName = mockName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dokumen $tipeDokumen Berhasil Dipilih (Simulasi)'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _hapusDokumen(String tipeDokumen) {
    setState(() {
      if (tipeDokumen == 'KTP') _ktpFileName = null;
      if (tipeDokumen == 'SIM') _simFileName = null;
      if (tipeDokumen == 'SKCK') _skckFileName = null;
      if (tipeDokumen == 'Selfie') _selfieFileName = null;
    });
  }

  // Fungsi untuk mensimulasikan pengambilan selfie dengan kamera depan
  void _ambilSelfieKameraDepan() {
    setState(() {
      _selfieFileName = "selfie_kamera_depan_${widget.userData['id'] ?? 'user'}_terverifikasi.jpg";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto Selfie Kamera Depan Berhasil Dipilih (Simulasi)'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Fungsi kirim semua dokumen ke server (simulasi & local state save)
  void _kirimDokumen() async {
    if (!_areDocumentsComplete()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                "Sedang mengunggah dokumen pendaftaran...",
                style: GoogleFonts.openSans(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    // Simulasi loading pengiriman 2.5 detik
    await Future.delayed(const Duration(milliseconds: 2500));

    final String email = widget.userData['email'] ?? 'helper';
    await _secureStorage.write(key: 'helper_docs_submitted_$email', value: 'true');
    // Akun terdaftar baru harus menunggu validasi admin terlebih dahulu
    await _secureStorage.write(key: 'helper_admin_validated_$email', value: 'false');

    if (mounted) {
      Navigator.pop(context); // Tutup loading dialog
      if (widget.onNext != null) {
        widget.onNext!();
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const WaitingApprovalScreen(),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Container(
      color: const Color(0xFFF8FAFC),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            onChanged: () => setState(() {}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: primaryColor, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Lengkapi berkas pendaftaran Anda di bawah ini untuk diverifikasi oleh admin Bantu.in.",
                          style: GoogleFonts.openSans(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Section 1: Dokumen Identitas
                _buildSectionHeader("Dokumen Identitas"),
                const SizedBox(height: 12),

                // Upload KTP
                _buildUploadCard(
                  title: "Kartu Tanda Penduduk (KTP)",
                  description: "Unggah foto KTP Anda yang masih berlaku dengan jelas.",
                  fileName: _ktpFileName,
                  icon: Icons.credit_card_rounded,
                  onUpload: () => _simulasikanUpload('KTP'),
                  onDelete: () => _hapusDokumen('KTP'),
                  secondaryColor: secondaryColor,
                ),
                const SizedBox(height: 16),

                // Upload SIM
                _buildUploadCard(
                  title: "Surat Izin Mengemudi (SIM)",
                  description: "Unggah foto SIM A/C aktif untuk penunjang transportasi.",
                  fileName: _simFileName,
                  icon: Icons.badge_rounded,
                  onUpload: () => _simulasikanUpload('SIM'),
                  onDelete: () => _hapusDokumen('SIM'),
                  secondaryColor: secondaryColor,
                ),
                const SizedBox(height: 16),

                // Upload SKCK
                _buildUploadCard(
                  title: "Surat Keterangan Catatan Kepolisian (SKCK)",
                  description: "Unggah bukti SKCK resmi terbaru Anda.",
                  fileName: _skckFileName,
                  icon: Icons.assignment_rounded,
                  onUpload: () => _simulasikanUpload('SKCK'),
                  onDelete: () => _hapusDokumen('SKCK'),
                  secondaryColor: secondaryColor,
                ),
                const SizedBox(height: 28),

                // Section 2: Foto Profil (Selfie)
                _buildSectionHeader("Foto Selfie (Foto Profil)"),
                const SizedBox(height: 4),
                Text(
                  "Diharuskan menggunakan Kamera Depan langsung demi memverifikasi wajah asli Anda.",
                  style: GoogleFonts.openSans(fontSize: 12, color: Colors.red[700]),
                ),
                const SizedBox(height: 12),

                // Selfie Camera Card
                _buildSelfieCard(
                  fileName: _selfieFileName,
                  onTake: _ambilSelfieKameraDepan,
                  onDelete: () => _hapusDokumen('Selfie'),
                  secondaryColor: secondaryColor,
                ),
                const SizedBox(height: 28),

                // Section 3: Informasi Rekening
                _buildSectionHeader("Detail Rekening Bank"),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Dropdown Nama Bank
                      DropdownButtonFormField<String>(
                        initialValue: _selectedBank,
                        decoration: InputDecoration(
                          labelText: "Nama Bank",
                          labelStyle: GoogleFonts.openSans(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        items: _bankList.map((bank) {
                          return DropdownMenuItem<String>(
                            value: bank,
                            child: Text(bank, style: GoogleFonts.openSans(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedBank = val ?? 'Pilih Bank';
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Nomor Rekening
                      TextFormField(
                        controller: _noRekeningController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Nomor Rekening",
                          labelStyle: GoogleFonts.openSans(fontSize: 14),
                          hintText: "Masukkan nomor rekening bank Anda",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Pemilik Rekening
                      TextFormField(
                        controller: _pemilikRekeningController,
                        decoration: InputDecoration(
                          labelText: "Nama Pemilik Rekening",
                          labelStyle: GoogleFonts.openSans(fontSize: 14),
                          hintText: "Sesuai dengan nama lengkap di buku tabungan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Button Kirim
                ElevatedButton(
                  onPressed: _areDocumentsComplete() ? _kirimDokumen : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[600],
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: _areDocumentsComplete() ? 3 : 0,
                    shadowColor: primaryColor.withValues(alpha: 0.3),
                  ),
                  child: Text(
                    "Kirim Dokumen",
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.openSans(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Card widget untuk unggahan berkas KTP, SIM, SKCK
  Widget _buildUploadCard({
    required String title,
    required String description,
    required String? fileName,
    required IconData icon,
    required VoidCallback onUpload,
    required VoidCallback onDelete,
    required Color secondaryColor,
  }) {
    final isUploaded = fileName != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUploaded ? Colors.green.shade200 : Colors.grey[200]!,
          width: isUploaded ? 1.8 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isUploaded ? Colors.green.shade50 : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUploaded ? Icons.check_circle_rounded : icon,
                color: isUploaded ? Colors.green : Colors.black54,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (!isUploaded)
                    Text(
                      description,
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    )
                  else
                    Text(
                      fileName,
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (!isUploaded)
              OutlinedButton.icon(
                onPressed: onUpload,
                icon: const Icon(Icons.upload_file_rounded, size: 16),
                label: Text("Unggah", style: GoogleFonts.openSans(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: secondaryColor,
                  side: BorderSide(color: secondaryColor.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              )
            else
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                splashRadius: 20,
              ),
          ],
        ),
      ),
    );
  }

  // Card widget khusus Selfie
  Widget _buildSelfieCard({
    required String? fileName,
    required VoidCallback onTake,
    required VoidCallback onDelete,
    required Color secondaryColor,
  }) {
    final isUploaded = fileName != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUploaded ? Colors.green.shade200 : Colors.grey[200]!,
          width: isUploaded ? 1.8 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isUploaded ? Colors.green.shade50 : const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUploaded ? Colors.green.shade200 : Colors.grey.shade300,
                ),
              ),
              child: Icon(
                isUploaded ? Icons.face_retouching_natural : Icons.camera_front_rounded,
                color: isUploaded ? Colors.green : Colors.black54,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Foto Selfie (Profil)",
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (!isUploaded)
                    Text(
                      "Klik tombol di samping untuk mengambil selfie dari kamera depan Anda secara langsung.",
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    )
                  else
                    Text(
                      "selfie_kamera_depan_terverifikasi.jpg",
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (!isUploaded)
              ElevatedButton.icon(
                onPressed: onTake,
                icon: const Icon(Icons.camera_alt_rounded, size: 16),
                label: Text("Selfie", style: GoogleFonts.openSans(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  elevation: 1,
                ),
              )
            else
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                splashRadius: 20,
              ),
          ],
        ),
      ),
    );
  }
}

