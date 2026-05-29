import 'package:flutter/material.dart';

class LupaKatasandi extends StatefulWidget {
  const LupaKatasandi({super.key});

  @override
  State<LupaKatasandi> createState() => _LupaKatasandiState();
}

class _LupaKatasandiState extends State<LupaKatasandi> {
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
              child: Text("Lupa Kata Sandi",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                label: Text("Masukan Email Anda"),
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
              child: Text("Kirim Tautan"),
            )
          ],
        ),
      ),
    );
  }
}
