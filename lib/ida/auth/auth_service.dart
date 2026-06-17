import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://localhost:8080/api";
  final _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        await _storage.write(key: 'jwt_token', value: data['token']);

        return {
          'success': true,
          'role':
              data['user']['role'], 
        };
      } else {
        return {'success': false, 'role': null};
      }
    } catch (e) {
      return {'success': false, 'role': null};
    }
  }

  Future<dynamic> getTasksFeed() async {
    String? token = await _storage.read(
      key:
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3ODEzNTUyMjAsImV4cCI6MTc4MTM1ODgyMCwiaWQiOiIyIiwiZW1haWwiOiJpZGFmZXJpYW5pMTkxNUBnbWFpbC5jb20ifQ.xgwNHYr2yIbFR8VxBOs1xOE1zCx2Dha-GQAv2oRQ07Q',
    );

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
    await _storage.delete(key: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3ODEzNTUyMjAsImV4cCI6MTc4MTM1ODgyMCwiaWQiOiIyIiwiZW1haWwiOiJpZGFmZXJpYW5pMTkxNUBnbWFpbC5jb20ifQ.xgwNHYr2yIbFR8VxBOs1xOE1zCx2Dha-GQAv2oRQ07Q');
  }
}
