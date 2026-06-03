import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil Saya",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                size: 30,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Colors.grey.shade400, height: 1),
        ),
      ),
      body: Padding(
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
                        padding: const EdgeInsets.symmetric(vertical: 15),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              children: [
                Icon(Icons.mail_outline),
                SizedBox(width: 10),
                Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold)),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                      backgroundColor: const Color.fromARGB(255, 243, 19, 3),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Keluar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
