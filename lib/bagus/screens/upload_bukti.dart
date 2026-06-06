import 'package:flutter/material.dart';

class UploadBuktiTab extends StatefulWidget {
  const UploadBuktiTab({super.key});

  @override
  State<UploadBuktiTab> createState() => _UploadBuktiTabState();
}

class _UploadBuktiTabState extends State<UploadBuktiTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Bukti"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.help_outline, size: 30),
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
                  color: Color(0XFFE2DFFF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0XFF4F46E5), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
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
                              "Instruksi Unggah",
                              style: TextStyle(
                                color: Color(0XFF4F46E5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Pastikan foto struk atau tangkapan layar terlihat jelas, tidak terpotong, dan nominal pembayaran terbaca dengan gamblang oleh sistem admin.",
                              style: TextStyle(color: Color(0XFF4F46E5)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text("Bukti foto atau screenshot"),
              SizedBox(height: 15),
              InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey.shade300,
                          ),
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            color: const Color.fromARGB(255, 111, 111, 111),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Klik untuk pilih/ambil gambar"),
                        Text("Mendukung JPG, PNG (Max 5MB)"),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text("Catatan tambahan (Opsional)"),
              SizedBox(height: 15),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  label: Text(
                    "Tuliskan pesan atau detail transaksi jika diperlukan",
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 10,
                  ),
                  child: Row(children: [Text("ID Bantuan : "), Text("ID ##")]),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: Text("Kirim Bukti Pembayaran"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
