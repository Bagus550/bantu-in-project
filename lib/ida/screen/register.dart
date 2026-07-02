import 'package:bantuin/ida/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:bantuin/ida/auth/auth_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isRememberMe = false;
  bool _isLoading = false;

  bool _isObscurePassword = true;
  bool _isObscureConfirm = true;

  final AuthService _authService = AuthService();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _jenisKelaminDipilih = 'Pilih Jenis Kelamin';

  void _prosesDaftar() async {
    if (_namaController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _noHpController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _tampilkanSnackbar("Semua kolom wajib diisi!");
      return;
    }
    if (_passwordController.text.length < 6) {
      _tampilkanSnackbar("Kata sandi minimal harus 6 karakter!");
      return;
    }
    if (_jenisKelaminDipilih == 'Pilih Jenis Kelamin') {
      _tampilkanSnackbar("Silakan pilih Jenis Kelamin terlebih dahulu!");
      return;
    }
    //kecocokan passwrod
    if (_passwordController.text != _confirmPasswordController.text) {
      _tampilkanSnackbar("Kata sandi dan konfirmasi tidak cocok!");
      return;
    }
    //checkbox persetujuan
    if (!_isRememberMe) {
      _tampilkanSnackbar("Anda harus menyetujui Syarat & Ketentuan.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final hasil = await _authService.register(
      _namaController.text,
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
      _noHpController.text,
      _jenisKelaminDipilih,
    );

    setState(() {
      _isLoading = false;
    });

    if (hasil != null && hasil['success'] == true) {
      _tampilkanSnackbar("Registrasi Berhasil! Silakan Masuk.");
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      debugPrint("Respon Gagal dari API: $hasil");
      _tampilkanSnackbar("Registrasi Gagal! Periksa kembali data Anda.");
    }
  }

  void _tampilkanSnackbar(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: Text(
                                  "Buat Akun Baru",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextField(
                                controller: _namaController,
                                decoration: InputDecoration(
                                  label: Text("Nama Lengkap"),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  label: Text("Username"),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              DropdownButtonFormField<String>(
                                initialValue: _jenisKelaminDipilih,
                                decoration: const InputDecoration(
                                  label: Text("Jenis Kelamin"),
                                  border: OutlineInputBorder(),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'Pilih Jenis Kelamin',
                                    child: Text('Pilih Jenis Kelamin'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Laki-Laki',
                                    child: Text('Laki-Laki'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Perempuan',
                                    child: Text('Perempuan'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _jenisKelaminDipilih =
                                        value ?? 'Pilih Jenis Kelamin';
                                  });
                                },
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  label: Text("Email"),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),
                              TextField(
                                controller: _noHpController,
                                decoration: InputDecoration(
                                  label: Text("No Telepon"),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: _passwordController,
                                obscureText: _isObscurePassword,
                                decoration: InputDecoration(
                                  label: Text("Kata Sandi"),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscurePassword =
                                            !_isObscurePassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: _confirmPasswordController,
                                obscureText: _isObscurePassword,
                                decoration: InputDecoration(
                                  label: Text("Konfirmasi Kata Sandi"),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscureConfirm
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isObscureConfirm = !_isObscureConfirm;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isRememberMe,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        _isRememberMe = newValue ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text.rich(
                                        TextSpan(
                                          text: 'Saya setuju dengan ',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: 'Syarat & Ketentuan',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const TextSpan(
                                              text: ' serta ',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Kebijakan Privasi',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                onPressed: _isLoading ? null : _prosesDaftar,
                                child: _isLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text("Daftar"),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Sudah Punya Akun?"),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: Text("Masuk di sini"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
