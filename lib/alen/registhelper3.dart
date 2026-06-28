import 'package:bantuin/alen/admin.dart';
import 'package:bantuin/alen/paypage.dart';
import 'package:bantuin/alen/registhelper.dart';
import 'package:bantuin/ida/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bantuin/config/app_config.dart';

class RegistPage3 extends StatefulWidget {
  final String fullName;
  final String email;
  final String password;
  final String whatsapp;

  const RegistPage3({
    super.key,
    required this.fullName,
    required this.email,
    required this.password,
    required this.whatsapp,
  });

  @override
  State<RegistPage3> createState() => _RegistPage3State();
}

class _RegistPage3State extends State<RegistPage3> {
  int _currentIndex = 1;
  bool _isLoading = false;

  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accNumberController = TextEditingController();

  @override
  void dispose() {
    _bankNameController.dispose();
    _accNumberController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (_bankNameController.text.trim().isEmpty ||
        _accNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi data bank!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      String? adminId = await authService.getUserId();

      if (adminId == null || adminId.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sesi login tidak ditemukan. Silakan login ulang sebagai Admin.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      var response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/admin/register-helper'),
        headers: {
          "ngrok-skip-browser-warning": "69420",
        },
        body: {
          'id_admin_pendaftar': adminId,
          'nama': widget.fullName,
          'email': widget.email,
          'password': widget.password,
          'no_hp': widget.whatsapp,
          'nama_bank': _bankNameController.text.trim(),
          'nomor_rekening': _accNumberController.text.trim(),
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi Berhasil! Silakan Login.')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegistPage()),
        );
      } else {
        var errorData = jsonDecode(response.body);
        String errorMessage = "Gagal mendaftar";

        if (errorData['messages'] != null) {
          errorMessage = errorData['messages'].toString();
        } else if (errorData['message'] != null) {
          errorMessage = errorData['message'];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error jaringan: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Bantu.In - Registration Helper",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Banking Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Please provide your bank account information so we can process your payments securely.",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bank Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _bankNameController,
                      decoration: InputDecoration(
                        hintText: "ex. BCA, BNI, Mandiri",
                        prefixIcon: Icon(
                          Icons.account_balance_outlined,
                        ), // Ikon panah bawah
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Account Number",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _accNumberController,
                      keyboardType:
                          TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "e.g. 1234567890",
                        prefixIcon: Icon(
                          Icons.credit_card_outlined, color: Colors.grey,
                        ), // Ikon gedung bank
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(
                          255,
                          243,
                          240,
                          255,
                        ), // Background ungu sangat pudar
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color.fromARGB(255, 220, 210, 250),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.security_outlined,
                            color: Color.fromARGB(255, 88, 26, 246),
                            size: 18,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Your banking information is encrypted and stored securely. We only use this to facilitate your earnings payouts.",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitRegistration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 88, 26, 246),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Finish Registration",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.check_circle_outline,
                              size: 20,
                            ), // Ikon centang
                          ],
                        ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back to Personal Info",
                    style: TextStyle(
                      color: Color.fromARGB(255, 88, 26, 246),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          if (_currentIndex == index) return;
          setState(() {
            _currentIndex = index;
          });
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyAdmin()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegistPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PayPage()),
            );
          }
        },
        backgroundColor: Colors.white,
        indicatorColor: Colors.deepPurpleAccent,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline, color: Colors.black),
            selectedIcon: Icon(Icons.people, color: Colors.black),
            label: "Helpers",
          ),
          NavigationDestination(
            icon: Icon(Icons.how_to_reg, color: Colors.black),
            label: "Registration",
          ),
          NavigationDestination(
            icon: Icon(Icons.payment_outlined, color: Colors.black),
            label: "Payments",
          ),
        ],
      ),
    );
  }
}
