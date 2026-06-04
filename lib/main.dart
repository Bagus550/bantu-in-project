import 'package:bantuin/dava/helper_setting.dart';
import 'package:bantuin/dava/user_setting.dart';
import 'package:bantuin/ida/lupa_katasandi.dart';
import 'package:bantuin/ida/register.dart';
// ignore: unused_import
import 'package:bantuin/bagus/screens/detail_task_user.dart';
import 'package:flutter/material.dart';
import 'ida/profile.dart';
import 'package:google_fonts/google_fonts.dart';


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
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFF3B82F6),
          surface: const Color(0xFFF8FAFC),
        ),
        scaffoldBackgroundColor: Color(0xFFF8FAFC),
      ),
      initialRoute: '/',

      routes: {
        '/': (context) => const DashboardHelperScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
