import 'package:flutter/material.dart';

class UbahKatasandi extends StatefulWidget {
  const UbahKatasandi({super.key});

  @override
  State<UbahKatasandi> createState() => _UbahKatasandiState();
}

class _UbahKatasandiState extends State<UbahKatasandi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.only(bottom: 30),
              child: Text("Ubah Kata Sandi",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                label: Text("Masukan Kata Sandi Baru Anda"),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 15,),
            TextField(
              decoration: InputDecoration(
                label: Text("Konfirmasi Kata Sandi"),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context,).colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: (){},
              child: Text("Ubah Sandi"),
            )
          ],
        ),
      ),
    );
  }
}