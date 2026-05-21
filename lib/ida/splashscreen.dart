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

    Timer(const Duration(seconds: 3), (){
      // Nanti klo halaman login atau home sudah jadi, 
      // ganti '/login' sesuai nama route nya
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/logo_splash.png',
              width: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
            )
          ],
        ),
      ),
    );
  }
}