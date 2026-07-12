import 'package:bantuin/alen/admin.dart';
import 'package:bantuin/ida/auth/auth_service.dart';
import 'package:bantuin/ida/screen/lupa_katasandi.dart';
import 'package:bantuin/ida/screen/role_selection_screen.dart';
import 'package:flutter/material.dart';
import 'waiting_approval_screen.dart';
import 'denied_approval_screen.dart';
import 'package:bantuin/ida/screen/register.dart';
import 'package:bantuin/ida/screen/faq_screen.dart';
import 'package:bantuin/bagus/dashboard_helper_screen.dart';
import 'package:bantuin/bagus/dashboard_user_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final _secureStorage = const FlutterSecureStorage();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final inputEmail = _emailController.text.trim();
      final inputPassword = _passwordController.text;

      Map<String, dynamic>? result = await _authService.login(
        inputEmail,
        inputPassword,
      );

      setState(() {
        _isLoading = false;
      });

      if (result != null && result['success'] == true) {
        final Map<String, dynamic> userData = result['user'] ?? {};
        final String? emailUser = userData['email'] ?? '';

        // Cek jika ada role override lokal untuk akun ini
        String role = result['role']?.toString() ?? 'requester';
        final localRole = await _secureStorage.read(
          key: 'role_override_$emailUser',
        );
        if (localRole != null) {
          role = localRole;
        }

        final String? token = result['token'] ?? userData['token'];
        final String? userId = userData['id']?.toString();
        final String? namaUser =
            userData['username'] ?? userData['nama'] ?? 'User';

        if (token != null) {
          await _secureStorage.write(key: 'auth_token', value: token);
        }
        if (userId != null) {
          await _secureStorage.write(key: 'id_users', value: userId);
        }
        await _secureStorage.write(key: 'nama_user', value: namaUser);
        await _secureStorage.write(key: 'email_user', value: emailUser);
        await _secureStorage.write(
          key: 'no_hp',
          value: result['user']['no_hp'].toString(),
        );
        await _secureStorage.write(key: 'role', value: role);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Berhasil sebagai $role!'),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          );
          _navigateBasedOnRole(role, userData);
        }
      } else {
        if (result != null &&
            result['message'] != null &&
            result['message'].toString().contains('menunggu verifikasi')) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const WaitingApprovalScreen(),
              ),
            );
          }
        } else {
          // Gagal login biasa
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  result?['message'] ??
                      'Email atau Kata Sandi Salah / Gagal Terhubung Server',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  void _navigateBasedOnRole(String? role, Map<String, dynamic> userData) async {
    final String? token = userData['token'] ?? '';

    switch (role) {
      case 'helper':
        final bool isDocsComplete = userData['is_docs_complete'] ?? false;
        final String statusVerifikasi =
            userData['status_verifikasi'] ?? 'pending';
        final String catatanPenolakan =
            userData['catatan_penolakan'] ??
            'Ditolak oleh admin tanpa catatan.';

        if (!isDocsComplete) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Silakan lengkapi berkas pendaftaran Anda yang tertunda.",
                ),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Register(
                  selectedRole: 'helper',
                  initialPage:
                      1, // Melempar langsung ke Step 2 (HelperDocumentsScreen)
                  userData: userData,
                ),
              ),
            );
          }
        } else {
          if (mounted) {
            if (statusVerifikasi == 'diterima') {
              // Jika sukses diterima admin
              Navigator.pushReplacement(
                //[cite: 9]
                context, //[cite: 9]
                MaterialPageRoute(
                  //[cite: 9]
                  builder: (context) => DashboardHelperScreen(
                    userData: userData,
                    token: token,
                  ), //[cite: 9]
                ),
              );
            } else if (statusVerifikasi == 'ditolak') {
              // Jika berkas lengkap tapi ditolak oleh admin, arahkan ke screen penolakan
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DeniedApprovalScreen(
                    catatanPenolakan: catatanPenolakan,
                    userData: userData,
                  ),
                ),
              );
            } else {
              // Jika berkas lengkap tapi masih berstatus pending (belum ditinjau)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WaitingApprovalScreen(),
                ),
              );
            }
          }
        }
        break;
      case 'requester':
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardUserScreen(userData: userData),
            ),
          );
        }
        break;
      case 'admin':
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyAdmin()),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FaqScreen()),
              );
            },
            icon: const Icon(Icons.help_outline, color: Colors.black87),
            tooltip: 'Pusat Bantuan',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Bantu.in',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.primary,
                    ),
                  ),
                  SizedBox(height: 16),

                  Image.asset('assets/logo/logo.png', height: 120),
                  SizedBox(height: 40),

                  Text(
                    'Selamat Datang',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 32),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.onSurface.withAlpha(60),
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.onSurface.withAlpha(60),
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'Kata Sandi',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.onSurface.withAlpha(60),
                          width: 1.5,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LupaKatasandi(),
                            ),
                          );
                        },
                        child: Text(
                          'Lupa Kata Sandi?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                              ),
                              onPressed: () {
                                _handleLogin();
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Belum Punya Akun?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RoleSelectionScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Daftar di sini",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
