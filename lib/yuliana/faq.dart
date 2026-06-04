import 'package:flutter/material.dart';

class Faq extends StatelessWidget {
  const Faq({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQ"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        
      
      ),
    );
  }
}