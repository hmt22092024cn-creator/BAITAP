import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_api_service.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskApiService _apiService = TaskApiService();
  late Future<List<TaskModel>> _futureTasks;
  String _searchQuery = '';
  String _selectedCategory = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      _futureTasks = _apiService.getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Danh sách công việc',
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF2F66F6)),
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Tìm công việc...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                const SizedBox(height: 12),
                // Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Tất cả', 'Học tập', 'Cuộc sống', 'study', 'life'].map((cat) {
                      bool isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: const Color(0xFF2F66F6),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF1E293B),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          backgroundColor: const Color(0xFFF8FAFC),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedCategory = cat);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Task List Builder
          Expanded(
            child: FutureBuilder<List<TaskModel>>(
              future: _futureTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF2F66F6)));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.red),
                          const SizedBox(height: 12),
                          Text('Lỗi tải dữ liệu: ${snapshot.error}', textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(onPressed: _loadTasks, child: const Text('Thử lại'))
                        ],
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có công việc nào.'));
                }

                List<TaskModel> tasks = snapshot.data!;

                // Filter by search query & category
                tasks = tasks.where((task) {
                  bool matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      task.note.toLowerCase().contains(_searchQuery.toLowerCase());
                  bool matchesCategory = _selectedCategory == 'Tất cả' ||
                      task.category.toLowerCase() == _selectedCategory.toLowerCase();
                  return matchesSearch && matchesCategory;
                }).toList();

                if (tasks.isEmpty) {
                  return const Center(child: Text('Không tìm thấy công việc phù hợp.'));
                }

                List<TaskModel> pendingTasks = tasks.where((t) => !t.done).toList();
                List<TaskModel> doneTasks = tasks.where((t) => t.done).toList();

                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  children: [
                    if (pendingTasks.isNotEmpty) ...[
                      const Text('CẦN LÀM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 8),
                      ...pendingTasks.map((task) => _buildTaskTile(task)),
                      const SizedBox(height: 16),
                    ],
                    if (doneTasks.isNotEmpty) ...[
                      const Text('ĐÃ XONG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 8),
                      ...doneTasks.map((task) => _buildTaskTile(task)),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskTile(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () async {
            bool newDone = !task.done;
            bool success = await _apiService.updateTask(task.id, {'done': newDone});
            if (success) {
              setState(() {
                task.done = newDone;
              });
            }
          },
          child: Icon(
            task.done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: task.done ? const Color(0xFF2F66F6) : Colors.grey.shade400,
            size: 24,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: task.done ? Colors.grey.shade500 : const Color(0xFF1E293B),
            decoration: task.done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: task.category.toLowerCase() == 'life' || task.category == 'Cuộc sống'
                    ? const Color(0xFFFEF3C7)
                    : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                task.category,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: task.category.toLowerCase() == 'life' || task.category == 'Cuộc sống'
                      ? const Color(0xFFD97706)
                      : const Color(0xFF2F66F6),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(task.time, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        onTap: () async {
          bool? shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
          );
          if (shouldRefresh == true) {
            _loadTasks();
          }
        },
      ),
    );
  }
}
