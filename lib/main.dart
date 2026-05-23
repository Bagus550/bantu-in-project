import 'package:bantuin/bagus/screens/dashboard_helper_screen.dart';
import 'package:bantuin/ida/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'bagus/screens/dashboard_user_screen.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BantuInApp());
}

class BantuInApp extends StatelessWidget {
  const BantuInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bantu.In',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFF3B82F6),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: Color(0xFFF8FAFC),
      ),
      initialRoute: '/',

      routes: {'/': (context) => const LoginScreen()},
    );
  }
}
