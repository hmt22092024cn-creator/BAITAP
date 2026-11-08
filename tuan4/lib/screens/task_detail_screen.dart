import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_api_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TaskApiService _apiService = TaskApiService();
  late TaskModel _task;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  Future<void> _toggleDone() async {
    setState(() => _isLoading = true);
    bool newDone = !_task.done;
    bool success = await _apiService.updateTask(_task.id, {'done': newDone});
    setState(() {
      _isLoading = false;
      if (success) {
        _task.done = newDone;
      }
    });
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_task.done ? 'Đã hoàn thành công việc!' : 'Đã bỏ đánh dấu hoàn thành')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thất bại, vui lòng thử lại.')),
      );
    }
  }

  Future<void> _deleteTask() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa công việc này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      bool success = await _apiService.deleteTask(_task.id);
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context, true); // Trở về và báo refresh
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa công việc thành công!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa thất bại, vui lòng thử lại.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E293B), size: 20),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          'Chi tiết',
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF2F66F6)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chức năng chỉnh sửa đang phát triển')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2F66F6)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Priority Badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _task.category,
                          style: const TextStyle(color: Color(0xFF2F66F6), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _task.priority == 'high'
                              ? Colors.red.shade50
                              : _task.priority == 'medium'
                                  ? Colors.orange.shade50
                                  : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Ưu tiên: ${_task.priority.toUpperCase()}',
                          style: TextStyle(
                            color: _task.priority == 'high'
                                ? Colors.red
                                : _task.priority == 'medium'
                                    ? Colors.orange
                                    : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Task Title
                  Text(
                    _task.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                      decoration: _task.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Date & Time card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today_outlined, color: Color(0xFF2F66F6)),
                          title: const Text('Hạn chót (Date)'),
                          trailing: Text(_task.date, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(Icons.access_time, color: Color(0xFF2F66F6)),
                          title: const Text('Thời gian'),
                          trailing: Text(_task.time, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        ListTile(
                          leading: const Icon(Icons.notifications_outlined, color: Color(0xFF2F66F6)),
                          title: const Text('Nhắc nhở'),
                          trailing: Text(_task.remind ? 'Bật' : 'Tắt', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Note section
                  const Text('Ghi chú', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                    ),
                    child: Text(
                      _task.note.isNotEmpty ? _task.note : 'Không có ghi chú nào.',
                      style: TextStyle(color: _task.note.isNotEmpty ? const Color(0xFF1E293B) : Colors.grey.shade400, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Subtasks section
                  if (_task.subtasks.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Việc nhỏ (Subtasks)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                        Text(
                          '${_task.subtasks.where((s) => s.done).length}/${_task.subtasks.length}',
                          style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._task.subtasks.map((sub) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: CheckboxListTile(
                            title: Text(
                              sub.title,
                              style: TextStyle(
                                fontSize: 14,
                                decoration: sub.done ? TextDecoration.lineThrough : null,
                                color: sub.done ? Colors.grey : const Color(0xFF1E293B),
                              ),
                            ),
                            value: sub.done,
                            activeColor: const Color(0xFF2F66F6),
                            onChanged: (val) {
                              setState(() {
                                sub.done = val ?? false;
                              });
                            },
                          ),
                        )),
                    const SizedBox(height: 20),
                  ],

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _task.done ? Colors.grey.shade600 : const Color(0xFF2F66F6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _toggleDone,
                      child: Text(
                        _task.done ? 'Đánh dấu chưa hoàn thành' : 'Đánh dấu hoàn thành',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: _deleteTask,
                      child: const Text(
                        'Xóa công việc',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
