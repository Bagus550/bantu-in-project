import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bantuin/bagus/task_model.dart';

class TaskService {
  static const String baseUrl =
      'http://192.168.42.83/bantu-in-project/public/index.php/api';

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
}
