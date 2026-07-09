import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bantuin/config/app_config.dart';
import 'package:http/http.dart' as http;

class TaskService {
  final String apiUrl = '${AppConfig.baseUrl}/api';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> createTask({
    required String judulTugas,
    required String deskripsi,
    required String kategoriLayanan,
    required String lokasi,
    required String latitude,
    required String longitude,
    required String nominalPembayaran,
    required String idRequester,
  }) async {
    try {
      String? token = await _storage.read(key: 'jwt_token');

      final response = await http.post(
        Uri.parse('$apiUrl/tasks/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'judul_tugas': judulTugas,
          'deskripsi': deskripsi,
          'kategori_layanan': kategoriLayanan,
          'lokasi': lokasi,
          'latitude': latitude,
          'longitude': longitude,
          'nominal_pembayaran': nominalPembayaran,
          'id_requester': idRequester,
          'status': 'Mencari helper',
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 ||
          response.statusCode == 200 ||
          data['status'] == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Berhasil posting!',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal posting',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }
}
