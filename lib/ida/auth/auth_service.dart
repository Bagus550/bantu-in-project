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
            (user['id_user'] ?? user['id'] ?? data['id_user'] ?? data['id'] ?? '')
                .toString();
        final nama = (user['username'] ?? user['nama'] ?? data['username'] ?? '')
            .toString();
        final email = (user['email'] ?? data['email'] ?? '').toString();
        final noHp = (user['no_hp'] ?? user['phone'] ?? data['no_hp'] ?? '')
            .toString();

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
          } catch (_) {}
        }

        return {
          'success': true,
          'role': role,
          'token': token,
          'user': user,
        };
      } else {
        return {'success': false, 'role': null};
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
          'role': 'requester',
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // response body tidak dipakai di production
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false};
      }
    } catch (e) {
      return {'success': false};
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
  }
}
