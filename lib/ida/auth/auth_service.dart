import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bantuin/config/app_config.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = '${AppConfig.baseUrl}/api';
  final _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 200 ||
          response.statusCode == 200 ||
          response.statusCode == 201) {
        final user = data['user'] ?? data;
        final token =
            data['token']?.toString() ??
            user['token']?.toString() ??
            data['access_token']?.toString() ??
            user['access_token']?.toString();
        final role = (user['role'] ?? data['role'] ?? 'requester').toString();
        final userId =
            (user['id_user'] ??
                    user['id'] ??
                    data['id_user'] ??
                    data['id'] ??
                    '')
                .toString();
        final nama =
            (user['username'] ?? user['nama'] ?? data['username'] ?? '')
                .toString();
        final email = (user['email'] ?? data['email'] ?? '').toString();
        final noHp = (user['no_hp'] ?? user['phone'] ?? data['no_hp'] ?? '')
            .toString();

        final isDocsComplete =
            (user['is_docs_complete'] == true ||
            user['is_docs_complete'] == 'true');
        final statusAktif = user['status_aktif']?.toString() ?? '0';

        final statusVerifikasi = (user['status_verifikasi'] ?? 'pending')
            .toString();
        final catatanPenolakan = (user['catatan_penolakan'] ?? '').toString();

        if (token != null && token.isNotEmpty) {
          try {
            await _storage.write(key: 'auth_token', value: token);
            await _storage.write(key: 'jwt_token', value: token);
            await _storage.write(key: 'role', value: role);
            await _storage.write(key: 'user_role', value: role);
            await _storage.write(key: 'id_users', value: userId);
            await _storage.write(key: 'user_id', value: userId);
            await _storage.write(key: 'nama_user', value: nama);
            await _storage.write(key: 'user_nama', value: nama);
            await _storage.write(key: 'email_user', value: email);
            await _storage.write(key: 'no_hp', value: noHp);
            await _storage.write(key: 'status_aktif', value: statusAktif);
            await _storage.write(
              key: 'status_verifikasi',
              value: statusVerifikasi,
            );
            await _storage.write(
              key: 'catatan_penolakan',
              value: catatanPenolakan,
            );

            if (role == 'helper') {
              if (isDocsComplete || statusAktif == '1' || statusAktif == '2') {
                await _storage.write(
                  key: 'helper_docs_submitted_$email',
                  value: 'true',
                );
              }
              if (statusVerifikasi == 'diterima') {
                await _storage.write(
                  key: 'helper_admin_validated_$email',
                  value: 'true',
                );
              } else {
                // Pastikan dihapus / di-set false jika statusnya pending atau ditolak
                await _storage.write(
                  key: 'helper_admin_validated_$email',
                  value: 'false',
                );
              }
            }
          } catch (_) {}
        }

        return {'success': true, 'role': role, 'token': token, 'user': user};
      } else {
        return {
          'success': false,
          'role': null,
          'message':
              data['message'] ??
              data['messages']?['error'] ??
              'Gagal melakukan login.',
        };
      }
    } catch (e) {
      return {'success': false, 'role': null};
    }
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<String?> getUserNama() async {
    return await _storage.read(key: 'user_nama');
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: 'user_role');
  }

  Future<Map<String, dynamic>?> register(
    String nama,
    String username,
    String email,
    String password,
    String noHp,
    String jenisKelamin,
    String role,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(AppConfig.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': nama,
          'username': username,
          'email': email,
          'password': password,
          'no_hp': noHp,
          'jenis_kelamin': jenisKelamin,
          'role': role,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'user': data['user'], // Membawa map berisi id, nama, email, dll.
        };
      } else {
        // Gabungkan pesan error jika berupa Map/Array
        String errorMsg = 'Registrasi gagal';
        if (data['messages'] != null) {
          if (data['messages'] is Map) {
            errorMsg = (data['messages'] as Map).values.join(', ');
          } else {
            errorMsg = data['messages'].toString();
          }
        } else if (data['message'] != null) {
          errorMsg = data['message'].toString();
        }
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  Future<dynamic> getTasksFeed() async {
    String? token = await _storage.read(key: 'jwt_token');

    final response = await http.get(
      Uri.parse('$baseUrl/tasks/feed'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Unauthorized / Gagal ambil data task');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_nama');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'user_role');
    await _storage.delete(key: 'id_users');
    await _storage.delete(key: 'nama_user');
    await _storage.delete(key: 'email_user');
    await _storage.delete(key: 'role');
    await _storage.delete(key: 'no_hp');
    await _storage.delete(key: 'status_verifikasi');
    await _storage.delete(key: 'catatan_penolakan');
  }

  Future<Map<String, dynamic>> updateProfilHelper(
    String id,
    String namaBank,
    String nomorRekening,
  ) async {
    String? token = await _storage.read(key: 'jwt_token');

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/helpers/$id/profil'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nama_bank': namaBank,
          'nomor_rekening': nomorRekening,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Profil berhasil diperbarui'};
      }
      return {'success': false, 'message': 'Gagal memperbarui profil'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<bool> uploadDokumenHelper(
    String userId,
    String tipeDokumen,
    String filePath,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/helpers/$userId/dokumen');
      final request = http.MultipartRequest('POST', url);

      // 1. Tambahkan parameter teks 'jenis' yang diminta oleh $this->request->getPost('jenis')
      request.fields['jenis'] =
          tipeDokumen; // Nilainya wajib string teks: 'ktp', 'sim', atau 'skck'

      // 2. Tambahkan berkas fisik dengan nama key MULTIPART 'dokumen' sesuai $this->request->getFile('dokumen')
      request.files.add(
        await http.MultipartFile.fromPath(
          'dokumen', // Key wajib menggunakan string 'dokumen'
          filePath,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Upload $tipeDokumen - HTTP Status: ${response.statusCode}");
      print("Respon Server: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error uploadDokumenHelper ($tipeDokumen): $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> uploadFotoProfilHelper(
    String id,
    String filePath,
  ) async {
    String? token = await _storage.read(key: 'jwt_token');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/helpers/$id/foto-profil'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('foto_profil', filePath),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Foto profil berhasil diunggah'};
      }
      return {'success': false, 'message': 'Gagal mengunggah foto profil'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
