import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bantuin/bagus/task_model.dart';

class TaskService {
  static const String baseUrl = 'http://api.bagusdevstudio.xyz/index.php/api';

  Future<List<TaskModel>> getTasksForHelper() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks/feed'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final List<dynamic> listTugas = responseData['data'];

      print("Jumlah data yang diterima: ${listTugas.length}");

      return listTugas.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data dari server');
    }
  }

  Future<List<TaskModel>> getTasksByRequester(String idRequester) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks/requester?id_requester=$idRequester'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> listTugas = responseData['data'];
      return listTugas.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data tugas requester');
    }
  }

  Future<bool> createTask({
    required String idRequester,
    required String judulTugas,
    required String deskripsi,
    required String kategoriLayanan,
    required int nominalPembayaran,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks/create'),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          'id_requester': idRequester,
          'judul_tugas': judulTugas,
          'deskripsi': deskripsi,
          'lokasi_tugas': 'Yogyakarta (Default)', // Sesuai kolom NOT NULL di DB
          'nominal_pembayaran': nominalPembayaran.toString(),
          'kategori_layanan': kategoriLayanan,
        },
      );

      print("Response Create Task: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error createTask: $e");
      return false;
    }
  }
}
