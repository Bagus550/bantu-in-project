import 'package:bantuin/ida/screen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'ida/screen/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
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
        '/': (context) => const IdaSplashScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
