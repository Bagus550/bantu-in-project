import 'dart:async';
import 'package:flutter/material.dart';

class IdaSplashScreen extends StatefulWidget {
  const IdaSplashScreen({super.key});

  @override
  State<IdaSplashScreen> createState() => _IdaSplashScreenState();
}

class _IdaSplashScreenState extends State<IdaSplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      // Navigasi ke halaman login yang sudah kita perbaiki tadi
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.background, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/logo_splash.png', 
              width: 150,
            ),
            const SizedBox(height: 24),

            Text(
              'Bantu.In',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.primary, 
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.secondary), // Otomatis pakai Biru Terang (#3B82F6)
              strokeWidth: 3,
            )
          ],
        ),
      ),
    );
  }
}