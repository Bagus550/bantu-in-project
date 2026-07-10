import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  // Menyimpan role yang dipilih: 'requester', 'helper', atau null jika belum memilih
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32, // Sesuaikan dengan padding
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Bagian Atas: Header
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          "Bergabung bersama Bantu.in",
                          style: GoogleFonts.openSans(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Pilih peran Anda untuk memulai perjalanan di Bantu.in",
                          style: GoogleFonts.openSans(
                            fontSize: 15,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 36),
                      ],
                    ),

                    // Bagian Tengah: Pilihan Peran (Role Cards)
                    Column(
                      children: [
                        // Kartu 1: Requester
                        _buildRoleCard(
                          context: context,
                          title: "Saya Ingin Mencari Jasa",
                          roleSubtitle: "Requester",
                          description:
                              "Pilih ini jika Anda membutuhkan bantuan untuk menyelesaikan berbagai pekerjaan, tugas harian, belanja, atau bersih-bersih.",
                          icon: Icons.person_search_rounded,
                          roleValue: "requester",
                          primaryColor: primaryColor,
                          secondaryColor: secondaryColor,
                        ),
                        const SizedBox(height: 20),

                        // Kartu 2: Helper
                        _buildRoleCard(
                          context: context,
                          title: "Saya Ingin Menawarkan Jasa",
                          roleSubtitle: "Helper",
                          description:
                              "Pilih ini jika Anda ingin bekerja paruh waktu, membantu orang lain menyelesaikan tugas mereka, dan menghasilkan pendapatan tambahan.",
                          icon: Icons.engineering_rounded,
                          roleValue: "helper",
                          primaryColor: primaryColor,
                          secondaryColor: secondaryColor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Bagian Bawah: Footer & Tombol Lanjutkan
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: _selectedRole == null
                              ? null
                              : () {
                                  // Navigasi ke halaman pendaftaran dengan melempar role pilihan
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Register(
                                        selectedRole: _selectedRole!,
                                      ),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[300],
                            disabledForegroundColor: Colors.grey[600],
                            minimumSize: const Size(double.infinity, 54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: _selectedRole == null ? 0 : 2,
                            shadowColor: primaryColor.withValues(alpha: 0.3),
                          ),
                          child: Text(
                            "Lanjutkan",
                            style: GoogleFonts.openSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Builder Helper untuk membuat kartu peran yang interaktif dan responsif
  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String roleSubtitle,
    required String description,
    required IconData icon,
    required String roleValue,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    final bool isActive = _selectedRole == roleValue;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? secondaryColor : Colors.grey[200]!,
          width: isActive ? 2.2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? secondaryColor.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: isActive ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedRole = roleValue;
            });
          },
          splashColor: secondaryColor.withValues(alpha: 0.1),
          highlightColor: secondaryColor.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ikon dengan kontainer sirkular
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isActive
                        ? secondaryColor.withValues(alpha: 0.12)
                        : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: isActive ? secondaryColor : Colors.black54,
                  ),
                ),
                const SizedBox(width: 18),

                // Informasi Peran (Judul & Deskripsi)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$title ($roleSubtitle)",
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isActive ? primaryColor : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: GoogleFonts.openSans(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Custom Radio Indicator di bagian kanan
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? secondaryColor : Colors.grey[400]!,
                      width: isActive ? 6 : 2,
                    ),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
