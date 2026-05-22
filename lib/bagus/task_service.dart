import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bantuin/bagus/task_model.dart';

class TaskService {
  static const String baseUrl = 'http://192.168.43.202/bantu-in-project/public';

  Future<List<TaskModel>> getTasksForHelper() async {
    final url = Uri.parse('$baseUrl/index.php/api/tasks/feed');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> listDataRaw = responseData['data'];

        return listDataRaw.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        // Biar kita tahu kode error aslinya dari server, ganti pesannya seperti ini dulu, Gus:
        throw Exception(
          'Server merespon dengan status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Gagal koneksi ke server: $e');
    }
  }
}
