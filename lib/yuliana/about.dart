import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/logo/logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
            Text("Bantu.in", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
        
          ],
        ),
      ),
    );
  }
}
