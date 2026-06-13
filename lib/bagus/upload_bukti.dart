import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadBuktiTab extends StatefulWidget {
  const UploadBuktiTab({super.key});

  @override
  State<UploadBuktiTab> createState() => _UploadBuktiTabState();
}

class _UploadBuktiTabState extends State<UploadBuktiTab> {
  File? _gambarBukti;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _catatanController = TextEditingController();

  Future<void> _ambilFotoDariKamera() async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (foto != null) {
        setState(() {
          _gambarBukti = File(foto.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal membuka kamera: $e")));
    }
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Bukti"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, size: 30),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0XFFE2DFFF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0XFF4F46E5), width: 1),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.info,
                          size: 33,
                          color: Color(0XFF4F46E5),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Instruksi Unggah (Keamanan Ketat)",
                              style: TextStyle(
                                color: Color(0XFF4F46E5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Pastikan foto struk atau fisik transaksi diambil langsung lewat kamera secara jelas. Sistem tidak menerima unggahan file manipulasi dari galeri ponsel.",
                              style: TextStyle(color: Color(0XFF4F46E5)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Bukti foto (Ambil Langsung)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              InkWell(
                onTap: _ambilFotoDariKamera,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _gambarBukti != null
                          ? Colors.green.shade400
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                    color: Colors.grey.shade50,
                  ),
                  child: _gambarBukti != null
                      ? Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _gambarBukti!,
                                width: double.infinity,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Kamera Aktif",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey.shade300,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Color.fromARGB(255, 111, 111, 111),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text("Klik untuk membuka KAMERA ponsel"),
                              const Text(
                                "Hanya mendukung pengambilan foto langsung",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              const Text("Catatan tambahan (Opsional)"),
              const SizedBox(height: 15),
              TextField(
                controller: _catatanController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText:
                      "Tuliskan pesan atau detail transaksi jika diperlukan",
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Row(children: [Text("ID Bantuan : "), Text("ID ##")]),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: _gambarBukti == null
                        ? Colors.grey
                        : Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _gambarBukti == null
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Bukti kamera siap dikirim ke API!",
                              ),
                            ),
                          );
                        },
                  child: const Text("Kirim Bukti Pembayaran"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
