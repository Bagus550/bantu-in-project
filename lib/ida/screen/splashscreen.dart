import 'dart:async';
import 'package:bantuin/alen/admin.dart';
import 'package:bantuin/bagus/dashboard_helper_screen.dart';
import 'package:bantuin/bagus/dashboard_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class IdaSplashScreen extends StatefulWidget {
  const IdaSplashScreen({super.key});

  @override
  State<IdaSplashScreen> createState() => _IdaSplashScreenState();
}

class _IdaSplashScreenState extends State<IdaSplashScreen> {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> _cekSesiLogin() async {
    final token =
        await _secureStorage.read(key: 'auth_token') ??
        await _secureStorage.read(key: 'jwt_token');
    final role =
        await _secureStorage.read(key: 'role') ??
        await _secureStorage.read(key: 'user_role');
    final userId = await _secureStorage.read(key: 'id_users') ?? await _secureStorage.read(key: 'user_id');
    final namaUser = await _secureStorage.read(key: 'nama_user') ?? '';
    final emailUser = await _secureStorage.read(key: 'email_user') ?? '';
    final noHp = await _secureStorage.read(key: 'no_hp') ?? '';

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      final userData = {
        'id': userId,
        'username': namaUser,
        'email': emailUser,
        'no_hp': noHp,
      };

      switch (role?.toLowerCase()) {
        case 'helper':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardHelperScreen(
                userData: userData,
                token: token,
              ),
            ),
          );
          break;
        case 'requester':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardUserScreen(userData: userData),
            ),
          );
          break;
        case 'admin':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyAdmin()),
          );
          break;
        default:
          Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      _cekSesiLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo/logo.png', width: 150),
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
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.secondary,
              ), 
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
