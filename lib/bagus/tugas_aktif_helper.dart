import 'package:bantuin/danela/roomchat.dart';
import 'package:flutter/material.dart';

class TugasAktifHelper extends StatefulWidget {
  final Map<String, dynamic> detailTugas;
  const TugasAktifHelper({super.key, required this.detailTugas});

  @override
  State<TugasAktifHelper> createState() => _TugasAktifHelperState();
}

class _TugasAktifHelperState extends State<TugasAktifHelper> {
  bool _isTugasSelesai = false;
  bool _isSudahBayar = false;

  @override
  Widget build(BuildContext context) {
    if (widget.detailTugas.isEmpty) {
      return const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Kamu belum mengambil tugas apapun.\nSilakan cari bantuan tersedia di halaman Home.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    final String namaRequester =
        widget.detailTugas['nama_requester'] ?? 'Tanpa Nama';
    final String harga = "Rp ${widget.detailTugas['nominal_pembayaran'] ?? 0}";
    final String lokasi = widget.detailTugas['lokasi_tugas'] ?? 'Tanpa Lokasi';

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFDEDCFF),
                  border: Border.all(color: const Color(0xFF4D49E9), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4D49E9),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDEDCFF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            !_isTugasSelesai
                                ? Icons.refresh
                                : !_isSudahBayar
                                ? Icons.attach_money_outlined
                                : Icons.admin_panel_settings_outlined,
                            color: Color(0xFF4D49E9),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              !_isTugasSelesai
                                  ? "Tugas Berlangsung"
                                  : !_isSudahBayar
                                  ? "Menunggu Dibayar"
                                  : "Menunggu Validasi",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4D49E9),
                              ),
                            ),
                            Text(
                              !_isTugasSelesai
                                  ? "Kerjakan tugas sesuai jenis layanan dan konfirmasi selesai jika pekerjaan sudah selesai"
                                  : !_isSudahBayar
                                  ? "Pekerjaan selesai! Silakan tunggu atau mintalah klien untuk melakukan pembayaran nominal tugas."
                                  : "Pembayaran telah dikonfirmasi. Harap tunggu sistem memvalidasi transaksi Anda.",
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "REQUESTER",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            child: Icon(Icons.person, size: 30),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            namaRequester,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text("Chat"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RoomChatPage(namaData: widget.detailTugas),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "TOTAL PEMBAYARAN",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          harga,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "RINCIAN TUGAS",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(color: Colors.grey.shade300),
                      Row(
                        children: [
                          Icon(
                            Icons.add_task_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          const Text("24 Okt 2023, 14.30 WIB"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(lokasi)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: _isTugasSelesai
                                ? Colors.grey.shade200
                                : Theme.of(context).colorScheme.primary,
                            foregroundColor: _isTugasSelesai
                                ? Colors.grey.shade700
                                : Colors.white,
                          ),
                          onPressed: !_isTugasSelesai
                              ? () {
                                  setState(() {
                                    _isTugasSelesai = true;
                                  });
                                }
                              : null,
                          child: const Text("Konfirmasi Tugas Selesai"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: (_isTugasSelesai && !_isSudahBayar)
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade200,
                            foregroundColor: (_isTugasSelesai && !_isSudahBayar)
                                ? Colors.white
                                : Colors.grey.shade700,
                            elevation: 0,
                          ),
                          onPressed: (_isTugasSelesai && !_isSudahBayar)
                              ? () {
                                  setState(() {
                                    _isSudahBayar = true;
                                  });
                                }
                              : null,
                          child: const Text("Konfirmasi Sudah Dibayar"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Pastikan Anda telah menerima dana sebelum melakukan konfirmasi.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
