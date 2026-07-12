import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bantuin/config/app_config.dart';
import 'package:image_picker/image_picker.dart'; // Pastikan import ini ada

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final Color accentColor = const Color(0xFF4A44D4);

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _secureStorage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool _hasChanges = false;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String? _fotoProfilUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
    _namaController.addListener(_onFormChanged);
    _usernameController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
  }

  Future<void> _loadProfileData() async {
    String? savedFoto = await _secureStorage.read(key: 'foto_profil_url');
    String? savedName = await _secureStorage.read(key: 'user_nama');
    String? savedUsername = await _secureStorage.read(key: 'username');
    String? savedPhone = await _secureStorage.read(key: 'no_hp');

    if (mounted) {
      setState(() {
        _fotoProfilUrl = savedFoto;
        _namaController.text = savedName ?? '';
        _usernameController.text = savedUsername ?? savedName ?? '';
        _phoneController.text = savedPhone ?? '';
      });
    }
  }

  void _onFormChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Future<bool> _showExitConfirmation() async {
    if (!_hasChanges) return true;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buang Perubahan?'),
        content: const Text(
          'Kamu belum menyimpan perubahan ini. Yakin ingin kembali?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Jangan keluar
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // Ya, keluar
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return confirm ?? false;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final File file = File(pickedFile.path);

        final int sizeInBytes = await file.length();
        final double sizeInMb = sizeInBytes / (1024 * 1024);

        if (sizeInMb > 2) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ukuran file maksimal 2MB!'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        setState(() {
          _imageFile = file;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<bool> _uploadFotoProfil(String id, bool isHelper) async {
    if (_imageFile == null) return true;

    try {
      Uri url;
      if (isHelper) {
        url = Uri.parse('${AppConfig.baseUrl}/api/helpers/$id/foto-profil');
      } else {
        url = Uri.parse('${AppConfig.baseUrl}/api/users/$id/foto-profil');
      }

      var request = http.MultipartRequest(
        'POST',
        url,
      ); 
      request.files.add(
        await http.MultipartFile.fromPath('foto_profil', _imageFile!.path),
      );
      var response = await request.send();
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Upload foto error: $e');
      return false;
    }
  }

  Future<void> _simpanPerubahanBackend() async {
    setState(() => _isLoading = true);

    try {
      String? idUser = await _secureStorage.read(key: 'id_users');
      String? idHelper = await _secureStorage.read(key: 'id_helper');
      String? role = await _secureStorage.read(key: 'role');

      int currentId = 0;
      Uri urlProfil;
      bool isHelper = (role == 'helper' || idHelper != null);

      if (isHelper) {
        currentId = int.tryParse(idHelper ?? idUser ?? '0') ?? 0;
        urlProfil = Uri.parse(
          '${AppConfig.baseUrl}/api/helpers/$currentId/profil',
        );
      } else {
        currentId = int.tryParse(idUser ?? '0') ?? 0;
        urlProfil = Uri.parse(
          '${AppConfig.baseUrl}/api/users/$currentId/profil',
        );
      }

      if (_imageFile != null) {
        bool uploadSuccess = await _uploadFotoProfil(currentId.toString(), isHelper);
        if (!uploadSuccess) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal mengunggah foto profil.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      Map<String, dynamic> requestBody = {};
      if (_namaController.text.isNotEmpty) {
        requestBody["nama"] = _namaController.text;
      }
      if (_usernameController.text.isNotEmpty) {
        requestBody["username"] = _usernameController.text;
      }
      if (_phoneController.text.isNotEmpty) {
        requestBody["no_hp"] = _phoneController.text;
      }

      if (requestBody.isNotEmpty) {
        final response = await http.put(
          urlProfil,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody),
        );

        if (response.statusCode == 200) {
          if (_namaController.text.isNotEmpty) {
            await _secureStorage.write(
              key: 'nama_user',
              value: _namaController.text,
            );
          }
          setState(() => _hasChanges = false);
          _tampilkanSukses();
        } else {
          _tampilkanError(response.statusCode.toString());
        }
      } else {
        _tampilkanSukses();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan koneksi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print("Error catch: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _tampilkanSukses() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  void _tampilkanError(String code) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal: $code. Cek Debug Console'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final bool shouldPop = await _showExitConfirmation();
        if (shouldPop && context.mounted) {
          Navigator.pop(context); // Eksekusi keluar jika disetujui
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () async {
              final bool shouldPop = await _showExitConfirmation();
              if (shouldPop && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          title: const Text(
            'Edit Profil',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.circle,
                        image: _imageFile != null
                            ? DecorationImage(
                                image: FileImage(_imageFile!),
                                fit: BoxFit.cover,
                              )
                            : (_fotoProfilUrl != null && _fotoProfilUrl!.isNotEmpty && _fotoProfilUrl!.startsWith('http')
                                ? DecorationImage(
                                    image: NetworkImage(_fotoProfilUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                      ),
                      child: (_imageFile == null && (_fotoProfilUrl == null || _fotoProfilUrl!.isEmpty || !_fotoProfilUrl!.startsWith('http')))
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(
                label: 'Nama Lengkap',
                hintText: 'Masukkan nama baru',
                controller: _namaController,
              ),
              _buildTextField(
                label: 'Username',
                hintText: '@usernamebaru',
                controller: _usernameController,
              ),
              _buildTextField(
                label: 'Nomor Telepon / WA',
                hintText: '08123456789',
                controller: _phoneController,
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _simpanPerubahanBackend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: accentColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
