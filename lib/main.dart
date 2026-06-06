import 'package:bantuin/ida/login_screen.dart';
import 'package:bantuin/ida/splashscreen.dart';
import 'package:bantuin/yuliana/Faq_Helper.dart';
import 'package:bantuin/yuliana/faq_User.dart';
import 'package:flutter/material.dart';
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
        '/': (context) => const FaqHelper(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
