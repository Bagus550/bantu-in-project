import 'package:flutter/material.dart';

class MyAdmin extends StatefulWidget {
  const MyAdmin({super.key});

  @override
  State<MyAdmin> createState() => _MyAdminState();
}

class _MyAdminState extends State<MyAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withAlpha(10),
        toolbarHeight: 80,

        leading: IconButton(
          icon: Icon(Icons.menu,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
          },
        ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Bantu.in",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Icon(Icons.account_circle_outlined,
              color: Colors.black,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}