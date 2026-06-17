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

      if (data['status'] == 200 || response.statusCode == 200 || response.statusCode == 201) {

        if (data['token'] != null) {
          try{
            await _storage.write(key: 'jwt_token', value: data['token']);
          } catch (_){
          }
        }

        return {
          'success': true,
          'role': data['user']['role'],
          'user': data['user'],
        };
      } else {
        return {'success': false, 'role': null};
      }
    } catch (e) {
      return {'success': false, 'role': null};
    }
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
        Uri.parse('$baseUrl/auth/register'),
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
  }
}
