import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskApiService {
  static const String baseUrl = 'https://share.tryapps.store/mock/teach/tasks';
  static const String token = 'TuanTruong-uth-student';

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

  // 1. GET /mock/teach/tasks - Lấy danh sách công việc
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl), headers: _headers);
      if (response.statusCode == 200) {
        List body = jsonDecode(response.body);
        return body.map((item) => TaskModel.fromJson(item)).toList();
      } else {
        throw Exception('Lỗi tải danh sách: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể kết nối đến API: $e');
    }
  }

  // 2. GET /mock/teach/tasks/{id} - Lấy chi tiết công việc
  Future<TaskModel> getTaskById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'), headers: _headers);
      if (response.statusCode == 200) {
        return TaskModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Không tìm thấy công việc (ID: $id)');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi lấy chi tiết: $e');
    }
  }

  // 3. POST /mock/teach/tasks - Thêm công việc mới
  Future<bool> createTask(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: _headers,
        body: jsonEncode(data),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 4. PATCH /mock/teach/tasks/{id} - Cập nhật công việc (ví dụ đổi trạng thái done)
  Future<bool> updateTask(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  // 5. DELETE /mock/teach/tasks/{id} - Xóa công việc
  Future<bool> deleteTask(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: _headers,
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}
