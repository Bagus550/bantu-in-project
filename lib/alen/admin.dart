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
        title: const Text('Admin'),
      ),
      body: const Center(
        child: Text('Admin Page'),
      ),
    ) ;
  }
}