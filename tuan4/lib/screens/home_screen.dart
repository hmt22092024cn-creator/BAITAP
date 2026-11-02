import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _todoTitleController = TextEditingController();
  final _todoTimeController = TextEditingController(text: '09:00');
  final _authService = AuthService();

  String _selectedCategory = 'Học tập';
  String _filterCategory = 'Tất cả';
  int _currentNavIndex = 0;
  bool _hasSeededInitialTasks = false;

  @override
  void dispose() {
    _todoTitleController.dispose();
    _todoTimeController.dispose();
    super.dispose();
  }

  // Tự động khởi tạo dữ liệu mẫu nếu Firestore của user đang trống
  Future<void> _seedDefaultTasksIfEmpty(String userId, List<QueryDocumentSnapshot> docs) async {
    if (_hasSeededInitialTasks || docs.isNotEmpty) return;
    _hasSeededInitialTasks = true;

    final defaultTasks = [
      {
        'title': 'Tập thể dục 30 phút',
        'category': 'Cuộc sống',
        'time': '06:30',
        'completed': true,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Nộp bài tập Lập trình di động',
        'category': 'Học tập',
        'time': '09:00',
        'completed': true,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Ôn chương 3 - Cấu trúc dữ liệu',
        'category': 'Học tập',
        'time': '14:00',
        'completed': false,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'title': 'Đi chợ mua đồ cho tuần',
        'category': 'Cuộc sống',
        'time': '17:30',
        'completed': false,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    try {
      final batch = FirebaseFirestore.instance.batch();
      for (final task in defaultTasks) {
        final docRef = FirebaseFirestore.instance.collection('todos').doc();
        batch.set(docRef, task);
      }
      await batch.commit();
    } catch (_) {
      // Bỏ qua nếu offline hoặc quyền hạn chưa cấp
    }
  }

  void _showAddTodoDialog() {
    _todoTitleController.clear();
    _selectedCategory = 'Học tập';

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
                'Thêm công việc mới',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _todoTitleController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Nhập nội dung công việc...',
                  prefixIcon: const Icon(Icons.edit_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Chọn nhóm công việc:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Học tập'),
                    selected: _selectedCategory == 'Học tập',
                    selectedColor: const Color(0xFFDBEAFE),
                    onSelected: (val) {
                      if (val) setModalState(() => _selectedCategory = 'Học tập');
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Cuộc sống'),
                    selected: _selectedCategory == 'Cuộc sống',
                    selectedColor: const Color(0xFFFED7AA),
                    onSelected: (val) {
                      if (val) setModalState(() => _selectedCategory = 'Cuộc sống');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _todoTimeController,
                decoration: InputDecoration(
                  hintText: 'Thời gian (ví dụ: 09:00)',
                  prefixIcon: const Icon(Icons.access_time),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
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
                  final text = _todoTitleController.text.trim();
                  final time = _todoTimeController.text.trim();
                  if (text.isNotEmpty) {
                    final user = _authService.currentUser;
                    final userId = user?.uid ?? 'guest';
                    await FirebaseFirestore.instance.collection('todos').add({
                      'title': text,
                      'category': _selectedCategory,
                      'time': time.isNotEmpty ? time : '09:00',
                      'completed': false,
                      'userId': userId,
                      'createdAt': FieldValue.serverTimestamp(),
                    });
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text(
                  'Thêm công việc',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    final user = _authService.currentUser;
    final userName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : (user?.email?.split('@').first ?? 'Minh Anh');
    final userId = user?.uid ?? 'guest';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('todos')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            final docs = snapshot.data?.docs ?? [];

            // Nếu Firestore trống, nạp 4 task mẫu từ slide đề bài
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _seedDefaultTasksIfEmpty(userId, docs);
            });

            // Tính toán tiến độ
            int total = docs.length;
            int completed = 0;
            int studyRemaining = 0;
            int lifeRemaining = 0;

            if (docs.isEmpty) {
              total = 4;
              completed = 2;
              studyRemaining = 2;
              lifeRemaining = 2;
            } else {
              for (final doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                final isDone = data['completed'] == true;
                final cat = data['category'] ?? 'Học tập';

                if (isDone) {
                  completed++;
                } else {
                  if (cat == 'Học tập') studyRemaining++;
                  if (cat == 'Cuộc sống') lifeRemaining++;
                }
              }
            }

            final double progressValue = total > 0 ? (completed / total) : 0.0;
            final int progressPercent = (progressValue * 100).round();

            String cheerMessage = 'Đã hơn nửa chặng, cố lên!';
            if (progressPercent == 100) {
              cheerMessage = 'Tuyệt vời! Đã hoàn thành mọi việc hôm nay 🎉';
            } else if (progressPercent < 50) {
              cheerMessage = 'Bắt đầu ngày mới đầy năng lượng nhé!';
            }

            // Lọc danh sách theo filterCategory nếu người dùng chọn
            List<QueryDocumentSnapshot> filteredDocs = docs;
            if (_filterCategory != 'Tất cả') {
              filteredDocs = docs.where((d) {
                final data = d.data() as Map<String, dynamic>;
                return data['category'] == _filterCategory;
              }).toList();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header: Avatar + Chào + Chuông
                  Row(
                    children: [
                      // Nhấn vào Avatar -> Vào màn hình thông tin cá nhân
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBEAFE),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFBFDBFE), width: 1.5),
                          ),
                          child: Center(
                            child: user?.photoURL != null
                                ? ClipOval(
                                    child: Image.network(
                                      user!.photoURL!,
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => Text(
                                        userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF2F66F6),
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF2F66F6),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thứ Ba, 20 tháng 10',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Chào $userName!',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF475569)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Không có thông báo mới nào.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 2. Card Tiến độ hôm nay (Màu xanh dương như mẫu)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2F66F6), Color(0xFF1E4FD8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x332F66F6),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tiến độ hôm nay',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$completed/$total việc',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cheerMessage,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 64,
                              height: 64,
                              child: CircularProgressIndicator(
                                value: progressValue,
                                strokeWidth: 7,
                                strokeCap: StrokeCap.round,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            Text(
                              '$progressPercent%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 3. Hai Card Phân Loại: Học tập & Cuộc sống
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _filterCategory = _filterCategory == 'Học tập' ? 'Tất cả' : 'Học tập';
                            });
                          },
                          child: _buildCategoryCard(
                            icon: Icons.school_outlined,
                            title: 'Học tập',
                            subtitle: '$studyRemaining việc còn lại',
                            isSelected: _filterCategory == 'Học tập',
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _filterCategory = _filterCategory == 'Cuộc sống' ? 'Tất cả' : 'Cuộc sống';
                            });
                          },
                          child: _buildCategoryCard(
                            icon: Icons.home_outlined,
                            title: 'Cuộc sống',
                            subtitle: '$lifeRemaining việc còn lại',
                            isSelected: _filterCategory == 'Cuộc sống',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 4. Tiêu đề Danh sách: "Việc hôm nay" + "Xem tất cả"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _filterCategory == 'Tất cả' ? 'Việc hôm nay' : 'Việc: $_filterCategory',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _filterCategory = 'Tất cả';
                          });
                        },
                        child: Text(
                          _filterCategory == 'Tất cả' ? 'Xem tất cả' : 'Hiện tất cả',
                          style: const TextStyle(
                            color: Color(0xFF2F66F6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // 5. Danh sách các công việc
                  if (docs.isEmpty)
                    // Dữ liệu hiển thị mặc định khớp 100% hình ảnh đề bài
                    Column(
                      children: [
                        _buildStaticTaskItem(
                          'Tập thể dục 30 phút',
                          'Cuộc sống',
                          '06:30',
                          true,
                        ),
                        _buildStaticTaskItem(
                          'Nộp bài tập Lập trình di động',
                          'Học tập',
                          '09:00',
                          true,
                        ),
                        _buildStaticTaskItem(
                          'Ôn chương 3 - Cấu trúc dữ liệu',
                          'Học tập',
                          '14:00',
                          false,
                        ),
                        _buildStaticTaskItem(
                          'Đi chợ mua đồ cho tuần',
                          'Cuộc sống',
                          '17:30',
                          false,
                        ),
                      ],
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        final doc = filteredDocs[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final title = data['title'] ?? '';
                        final category = data['category'] ?? 'Học tập';
                        final time = data['time'] ?? '09:00';
                        final isDone = data['completed'] == true;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x04000000),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            onTap: () {
                              doc.reference.update({'completed': !isDone});
                            },
                            onLongPress: () {
                              // Cho phép xóa công việc khi nhấn giữ
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Xác nhận xóa'),
                                  content: Text('Bạn có chắc chắn muốn xóa "$title"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Hủy'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        doc.reference.delete();
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            leading: Icon(
                              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isDone ? const Color(0xFF2F66F6) : Colors.grey.shade400,
                              size: 24,
                            ),
                            title: Text(
                              title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDone ? Colors.grey.shade500 : const Color(0xFF1E293B),
                                decoration: isDone ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: category == 'Cuộc sống' ? const Color(0xFFFEF3C7) : const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: category == 'Cuộc sống' ? const Color(0xFFD97706) : const Color(0xFF2F66F6),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  time,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 70), // Khoảng trống tránh bị che bởi thanh FAB
                ],
              ),
            );
          },
        ),
      ),

      // 6. Bottom Navigation Bar với Docked FAB ở giữa
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 8,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home_rounded,
                  color: _currentNavIndex == 0 ? const Color(0xFF2F66F6) : Colors.grey.shade400,
                  size: 28,
                ),
                onPressed: () => setState(() => _currentNavIndex = 0),
              ),
              IconButton(
                icon: Icon(
                  Icons.format_list_bulleted_rounded,
                  color: _currentNavIndex == 1 ? const Color(0xFF2F66F6) : Colors.grey.shade400,
                  size: 26,
                ),
                onPressed: () {
                  setState(() {
                    _currentNavIndex = 1;
                    _filterCategory = 'Tất cả';
                  });
                },
              ),
              const SizedBox(width: 48), // Khoảng trống cho FAB
              IconButton(
                icon: Icon(
                  Icons.notifications_none_rounded,
                  color: _currentNavIndex == 2 ? const Color(0xFF2F66F6) : Colors.grey.shade400,
                  size: 26,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Không có thông báo mới.')),
                  );
                },
              ),
              // Nhấn vào icon Cài đặt -> Mở ProfileScreen
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.grey, size: 26),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ],
          ),
        ),
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

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF2F66F6) : const Color(0xFFF1F5F9),
          width: isSelected ? 1.5 : 1.0,
        ),
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

  Widget _buildStaticTaskItem(String title, String category, String time, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ListTile(
        leading: Icon(
          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isDone ? const Color(0xFF2F66F6) : Colors.grey.shade400,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDone ? Colors.grey.shade500 : const Color(0xFF1E293B),
            decoration: isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: category == 'Cuộc sống' ? const Color(0xFFFEF3C7) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: category == 'Cuộc sống' ? const Color(0xFFD97706) : const Color(0xFF2F66F6),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
        trailing: Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
      ),
    );
  }
}
