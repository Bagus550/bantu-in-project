import 'package:bantuin/alen/registhelper.dart';
import 'package:bantuin/dava/edit_profile.dart';
import 'package:bantuin/dava/helper_setting.dart';
import 'package:bantuin/dava/user_setting.dart';
import 'package:bantuin/ida/login_screen.dart';
import 'package:bantuin/ida/splashscreen.dart';
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
<<<<<<< HEAD
        '/': (context) => const IdaSplashScreen(),
=======
        '/': (context) => const UserSetting(),
>>>>>>> 1133df189fb39c6c5d70bb9bbde06cdfea0d2bcc
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
