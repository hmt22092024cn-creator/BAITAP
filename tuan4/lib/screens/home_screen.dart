import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_api_service.dart';
import '../services/auth_service.dart';
import 'task_list_screen.dart';
import 'task_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskApiService _apiService = TaskApiService();
  final AuthService _authService = AuthService();
  
  late Future<List<TaskModel>> _futureTasks;
  int _currentNavIndex = 0;

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

  void _showAddTodoDialog() {
    final titleController = TextEditingController();
    final timeController = TextEditingController(text: '09:00');
    final noteController = TextEditingController();
    String selectedCategory = 'study';
    String priority = 'medium';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Thêm công việc mới (API POST)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Nhập tiêu đề công việc...',
                  prefixIcon: const Icon(Icons.edit_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  hintText: 'Nhập ghi chú (tùy chọn)...',
                  prefixIcon: const Icon(Icons.note_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: timeController,
                      decoration: InputDecoration(
                        hintText: 'Thời gian (09:00)',
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'study', child: Text('Học tập (study)')),
                        DropdownMenuItem(value: 'life', child: Text('Cuộc sống (life)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setModalState(() => selectedCategory = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F66F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final title = titleController.text.trim();
                  if (title.isNotEmpty) {
                    bool success = await _apiService.createTask({
                      'title': title,
                      'note': noteController.text.trim(),
                      'category': selectedCategory,
                      'date': '2026-10-20',
                      'time': timeController.text.trim().isNotEmpty ? timeController.text.trim() : '09:00',
                      'priority': priority,
                      'remind': true,
                      'done': false,
                      'subtasks': [],
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                    if (success) {
                      _loadTasks();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Thêm công việc thành công qua API (POST)!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Thêm công việc thất bại.')),
                      );
                    }
                  }
                },
                child: const Text(
                  'Thêm mới',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      _buildHomeBody(),
      const TaskListScreen(),
      Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Thông báo', style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
          elevation: 0,
        ),
        body: const Center(
          child: Text('Không có thông báo mới.', style: TextStyle(color: Colors.grey, fontSize: 16)),
        ),
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: screens[_currentNavIndex >= screens.length ? 0 : _currentNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex >= screens.length ? 0 : _currentNavIndex,
        selectedItemColor: const Color(0xFF2F66F6),
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Danh sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Thông báo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Cài đặt',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2F66F6),
        shape: const CircleBorder(),
        elevation: 4,
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHomeBody() {
    return FutureBuilder<List<TaskModel>>(
      future: _futureTasks,
      builder: (context, snapshot) {
        int totalTasks = 0;
        int completedTasks = 0;
        List<TaskModel> tasks = [];

        if (snapshot.hasData) {
          tasks = snapshot.data!;
          totalTasks = tasks.length;
          completedTasks = tasks.where((t) => t.done).length;
        }

        double progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Title & Profile Avatar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thứ Ba, 20 tháng 10',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Chào bạn!',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _currentNavIndex = 3),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFFEFF6FF),
                        child: const Icon(Icons.person, color: Color(0xFF2F66F6)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Progress Banner Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2F66F6), Color(0xFF1D4ED8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x332F66F6),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tiến độ hôm nay',
                            style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$completedTasks/$totalTasks việc',
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Đã hơn nửa chặng, cố lên!',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 64,
                            height: 64,
                            child: CircularProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 6,
                            ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Category summary cards
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryCard(
                        icon: Icons.school_outlined,
                        title: 'Học tập',
                        subtitle: '${tasks.where((t) => t.category.toLowerCase() == 'study' || t.category == 'Học tập').length} việc còn lại',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildCategoryCard(
                        icon: Icons.home_outlined,
                        title: 'Cuộc sống',
                        subtitle: '${tasks.where((t) => t.category.toLowerCase() == 'life' || t.category == 'Cuộc sống').length} việc còn lại',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Today tasks header & "Xem tất cả"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Việc hôm nay',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => _currentNavIndex = 1);
                      },
                      child: const Text('Xem tất cả', style: TextStyle(color: Color(0xFF2F66F6), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Tasks list builder
                if (snapshot.connectionState == ConnectionState.waiting)
                  const Center(child: Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator(color: Color(0xFF2F66F6))))
                else if (snapshot.hasError)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Lỗi tải API: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
                    ),
                  )
                else if (tasks.isEmpty)
                  const Center(child: Text('Không có công việc nào.'))
                else
                  ...tasks.take(5).map((task) => _buildTaskItem(task)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF2F66F6), size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E293B)),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(TaskModel task) {
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
