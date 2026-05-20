import 'package:flutter/material.dart';

// TODO: Nanti kalau folder anak-anak udah di-merge, tinggal import ke sini:
// import 'ida/screens/splash_screen.dart';
// import 'ida/screens/login_screen.dart';
// import 'bagus/screens/dashboard_feed_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BantuInApp());
}

class BantuInApp extends StatelessWidget {
  const BantuInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bantu.In',
      debugShowCheckedModeBanner: false,

      // 1. Konfigurasi Tema Aplikasi (Sesuai Panduan UI & Psikologi Warna Biru di Proposal)
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Biru Utama (Corporate/Trust)
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFF3B82F6), // Biru Terang untuk Aksen/Tombol
          background: const Color(
            0xFFF8FAFC,
          ), // Background abu-abu sangat muda/bersih
        ),
        // Standarisasi font dan komponen UI global lainnya bisa ditaruh di sini
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),

      // 2. Alur Awal Aplikasi (Awal dibuka lari ke Splash Screen milik Ida)
      initialRoute: '/',

      // 3. Manajemen Main Routing Aplikasi (Tempat Gabungin Kerja Kelompok)
      routes: {
        '/': (context) =>
            const DummySplashScreen(), // Nating diganti: const SplashScreen()
        '/login': (context) =>
            const DummyLoginScreen(), // Nanti diganti: const LoginScreen()
        // Route Fitur Kamu (Bagus)
        '/dashboard-feed': (context) => const DummyDashboardFeed(),

        // Route Fitur Dava, Danela, Danelas, Yuliana bisa didaftarin di bawah ini nanti:
        // '/task-tracking': (context) => const TaskTrackingScreen(),
        // '/chat-room': (context) => const ChatRoomScreen(),
        // '/profile-settings': (context) => const ProfileScreen(),
        // '/admin-panel': (context) => const AdminPanelScreen(),
      },
    );
  }
}

// =========================================================================
// WIDGET DUMMY TEMPORARY (Biar Project Gak Error Saat Pertama Kali Di-run)
// Nanti kalau file asli dari tiap anggota kelompok udah jadi, widget di bawah ini tinggal dihapus.
// =========================================================================

class DummySplashScreen extends StatelessWidget {
  const DummySplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Visual filosofis jabat tangan (dummy icon)
            const Icon(
              Icons.handshake_rounded,
              size: 100,
              color: Color(0xFF1E3A8A),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bantu.In',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const Text(
              'On-Demand Service Platform',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: const Text('Simulasi Masuk ke Login Gateway'),
            ),
          ],
        ),
      ),
    );
  }
}

class DummyLoginScreen extends StatelessWidget {
  const DummyLoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Single Login Gateway')),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/dashboard-feed'),
          child: const Text(
            'Simulasi Login Berhasil -> Masuk Dashboard (Feed Tugas)',
          ),
        ),
      ),
    );
  }
}

class DummyDashboardFeed extends StatelessWidget {
  const DummyDashboardFeed({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantu.In - Feed Lowongan Tugas'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Tempat Tugas Utama Kamu (Bagus): CRUD Postingan & Feed Lowongan',
        ),
      ),
    );
  }
}
