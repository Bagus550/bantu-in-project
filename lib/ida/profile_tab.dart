import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Judul Halaman",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                radius: 30,
                                child: Icon(Icons.person, size: 40),
                              ),
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text("Nama"),
                                ),
                                Text("nama@gmail.com"),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  child: Text(
                                    "Pengguna Aktif - Terverifikasi",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        "Data Akun",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.person_2_outlined, size: 30),
                          SizedBox(width: 10),
                          Text(
                            "Username: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("Nama"),
                        ],
                      ),
                      Divider(color: Colors.grey.shade400),
                      SizedBox(height: 10),
                      Text(
                        "Data Alamat",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(width: 10),
                          Text(
                            "Alamat Utama: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("Alamat Palsoe"),
                        ],
                      ),
                      Divider(color: Colors.grey.shade400),
                      SizedBox(height: 10),
                      Text(
                        "Kontak",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.mail_outline),
                          SizedBox(width: 10),
                          Text(
                            "Email: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("nama@gmail.com"),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.call_outlined),
                          SizedBox(width: 10),
                          Text(
                            "Nomor Telepon: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("0812********"),
                        ],
                      ),
                      Divider(color: Colors.grey.shade400),
                      SizedBox(height: 10),
                      Text(
                        "Data Tambahan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      Row(
                        children: [
                          Icon(Icons.date_range_outlined),
                          SizedBox(width: 10),
                          Text(
                            "Tanggal Lahir: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("**-**-****"),
                        ],
                      ),
                      Divider(color: Colors.grey.shade400),
                      SizedBox(height: 10),

                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  243,
                                  19,
                                  3,
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Keluar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
