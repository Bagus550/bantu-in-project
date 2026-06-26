import 'package:bantuin/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LupaKatasandi extends StatefulWidget {
  const LupaKatasandi({super.key});

  @override
  State<LupaKatasandi> createState() => _LupaKatasandiState();
}

class _LupaKatasandiState extends State<LupaKatasandi> {
  final String lupaSandi = AppConfig.forgotPassword;
  final String resetSandi = AppConfig.resetPassword;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isOtpSent = false;
  bool _isLoading = false;

  Future<void> _kirimOtp() async {
    if (_emailController.text.trim().isEmpty) {
      _showSnackbar("Email tidak boleh kosong", Colors.red);
      return;
    }
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(lupaSandi),
        body: {'email': _emailController.text.trim()},
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showSnackbar(data['message'] ?? "OTP berhasil dikirim!", Colors.green);
        setState(() {
          _isOtpSent = true;
        });
      } else {
        _showSnackbar(
          data['messages']?['error'] ??
              data['message'] ??
              "Email tidak ditemukan",
          Colors.red,
        );
      }
    } catch (e) {
      _showSnackbar(
        "Gagal terhubung ke server. Periksa koneksi internet Anda.",
        Colors.red,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (_otpController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showSnackbar("Semua kolom wajib diisi", Colors.red);
      return;
    }

    if (_passwordController.text.trim().length < 6) {
      _showSnackbar("Password minimal 6 karakter", Colors.red);
      return;
    }
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(resetSandi),
        body: {
          'token': _otpController.text.trim(),
          'password': _passwordController.text.trim(),
        },
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _showSnackbar(
          data['message'] ?? "Password berhasil diperbarui!",
          Colors.green,
        );

        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      } else {
        _showSnackbar(
          data['messages']?['error'] ??
              data['message'] ??
              "Gagal mereset password",
          Colors.red,
        );
      }
    } catch (e) {
      _showSnackbar("Gagal mengeksekusi reset password.", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.only(bottom: 30),
              child: Text(
                _isOtpSent ? "Verifikasi & Reset" : "Lupa Kata Sandi",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            if (!_isOtpSent) ...[
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  label: Text("Masukkan Email Anda"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _isLoading ? null : _kirimOtp,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim Kode OTP"),
              ),
            ] else ...[
              const Text(
                "Silakan periksa kotak masuk email Anda untuk melihat 6-digit kode OTP.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text("Masukkan Kode OTP"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_clock),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text("Masukkan Kata Sandi Baru"),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green, // Ganti warna hijau tanda konfirmasi
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _isLoading ? null : _resetPassword,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan Kata Sandi Baru"),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _isOtpSent = false);
                },
                child: const Text("Kembali isi email"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
