import 'package:bantuin/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UbahKatasandi extends StatefulWidget {
  const UbahKatasandi({super.key});

  @override
  State<UbahKatasandi> createState() => _UbahKatasandiState();
}

class _UbahKatasandiState extends State<UbahKatasandi> {
  final String ubahSandiUrl = AppConfig.changePassword;
  final _secureStorage = const FlutterSecureStorage();
  String? _currentUserId;

  bool _isObscureOld = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    String? id = await _secureStorage.read(key: 'id_users');
    setState(() {
      _currentUserId = id;
    });
  }

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> _ubahPassword() async {
    print("DEBUG: Tombol ditekan, memulai proses ubah password...");

    if (_currentUserId == null) {
      _showSnackbar(
        "Sesi tidak valid, silakan login ulang (ID tidak ditemukan)",
        Colors.red,
      );
      return;
    }
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnackbar("Semua kolom wajib diisi", Colors.red);
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      print("DEBUG: Validasi gagal, password baru tidak cocok.");
      _showSnackbar("Konfirmasi password tidak cocok", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? token = await _secureStorage.read(key: 'auth_token');
      print("DEBUG: Token yang digunakan: $token");
      print("DEBUG: Mengirim request ke URL: $ubahSandiUrl");
      final url = Uri.parse("$ubahSandiUrl/$_currentUserId");
      print("DEBUG: Mengirim ke: $url");

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'old_password': _oldPasswordController.text.trim(),
          'new_password': _newPasswordController.text.trim(),
        }),
      );

      print("DEBUG: Response Status Code: ${response.statusCode}");
      print("DEBUG: Response Body: ${response.body}");

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("DEBUG: Berhasil mengubah password!");
        _showSnackbar(
          data['message'] ?? "Password berhasil diubah!",
          Colors.green,
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context);
      } else {
        print("DEBUG: Server mengembalikan error: ${response.body}");
        _showSnackbar(data['message'] ?? "Gagal mengubah password", Colors.red);
      }
    } catch (e) {
      print("DEBUG: Terjadi error saat koneksi: $e");
      _showSnackbar("Terjadi kesalahan koneksi", Colors.red);
    } finally {
      setState(() => _isLoading = false);
      print("DEBUG: Proses selesai.");
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ubah Kata Sandi"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: _isObscureOld,
              decoration: InputDecoration(
                labelText: "Kata Sandi Lama",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureOld ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureOld = !_isObscureOld;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _newPasswordController,
              obscureText: _isObscureNew,
              decoration: InputDecoration(
                labelText: "Kata Sandi Baru",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureNew ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureNew = !_isObscureNew;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _isObscureConfirm,
              decoration: InputDecoration(
                labelText: "Konfirmasi Kata Sandi",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock_person),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureConfirm ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureConfirm = !_isObscureConfirm;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _isLoading ? null : _ubahPassword,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Simpan Kata Sandi"),
            ),
          ],
        ),
      ),
    );
  }
}
