import 'package:flutter/material.dart';

class Ida extends StatefulWidget {
  const Ida({super.key});

  @override
  State<Ida> createState() => _IdaState();
}

class _IdaState extends State<Ida> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Icon(Icons.stars_rounded)
          ],
        ),
      ),
    );
  }
}