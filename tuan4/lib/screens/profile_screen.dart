import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _getProviderBadge(dynamic user) {
    if (user == null || user.isAnonymous == true) {
      return 'Chế độ khách (Chưa liên kết)';
    }
    for (final info in user.providerData) {
      if (info.providerId == 'google.com') {
        return 'Đã liên kết tài khoản Google';
      }
      if (info.providerId == 'password') {
        return 'Đăng nhập bằng Email';
      }
    }
    return 'Tài khoản UTH Todo';
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;
    final userName = user?.displayName?.isNotEmpty == true
        ? user!.displayName!
        : (user?.email?.split('@').first ?? 'Minh Anh');
    final userEmail = user?.email ?? (user?.isAnonymous == true ? 'Khách dùng thử (Anonymous)' : 'minhanh@example.com');
    final isGoogleUser = user?.providerData.any((p) => p.providerId == 'google.com') ?? false;

    final userId = user?.uid ?? 'guest';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 100,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Color(0xFF2F66F6)),
          label: const Text(
            'Cài đặt',
            style: TextStyle(
              color: Color(0xFF2F66F6),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        title: const Text(
          'Hồ sơ',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Avatar & Thông tin tài khoản
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A2F66F6),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: user?.photoURL != null
                            ? ClipOval(
                                child: Image.network(
                                  user!.photoURL!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Text(
                                    userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2F66F6),
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                userName.isNotEmpty ? userName[0].toUpperCase() : 'M',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2F66F6),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    // Badge trạng thái liên kết
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isGoogleUser ? const Color(0xFFF0FDF4) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isGoogleUser ? const Color(0xFFBBF7D0) : const Color(0xFFBFDBFE),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isGoogleUser ? Icons.check_circle : Icons.verified_user_outlined,
                            size: 14,
                            color: isGoogleUser ? const Color(0xFF16A34A) : const Color(0xFF2F66F6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getProviderBadge(user),
                            style: TextStyle(
                              fontSize: 12,
                              color: isGoogleUser ? const Color(0xFF16A34A) : const Color(0xFF2F66F6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Thống kê 3 cột từ Firestore
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('todos')
                    .where('userId', isEqualTo: userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  final docs = snapshot.data?.docs ?? [];
                  int completedCount = 0;
                  int pendingCount = 0;

                  if (docs.isEmpty) {
                    // Dữ liệu mẫu khớp hình mockup nếu chưa có task trong Firestore
                    completedCount = 2;
                    pendingCount = 4;
                  } else {
                    for (final doc in docs) {
                      final data = doc.data() as Map<String, dynamic>?;
                      if (data?['completed'] == true) {
                        completedCount++;
                      } else {
                        pendingCount++;
                      }
                    }
                  }

                  final total = completedCount + pendingCount;
                  final percent = total > 0 ? ((completedCount / total) * 100).round() : 0;

                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x06000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('$completedCount', 'Việc đã xong'),
                        Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
                        _buildStatItem('$pendingCount', 'Đang chờ'),
                        Container(width: 1, height: 32, color: const Color(0xFFE2E8F0)),
                        _buildStatItem('$percent%', 'Hoàn thành'),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Biểu đồ tuần này (Chuẩn thiết kế theo slide)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x06000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tuần này',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          'Mục tiêu: 5 việc / ngày',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildBar(day: 'T2', heightPercent: 0.5),
                        _buildBar(day: 'T3', heightPercent: 0.85, isSelected: true),
                        _buildBar(day: 'T4', heightPercent: 0.35),
                        _buildBar(day: 'T5', heightPercent: 0.6),
                        _buildBar(day: 'T6', heightPercent: 0.25),
                        _buildBar(day: 'T7', heightPercent: 0.15),
                        _buildBar(day: 'CN', heightPercent: 0.05),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Nút Đăng xuất màu đỏ cam viền (như mockup)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFCA5A5)),
                    backgroundColor: const Color(0xFFFEF2F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () async {
                    await authService.signOut();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã đăng xuất thành công!'),
                          backgroundColor: Colors.blueGrey,
                        ),
                      );
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    }
                  },
                  icon: const Icon(Icons.logout, color: Color(0xFFDC2626), size: 20),
                  label: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildBar({
    required String day,
    required double heightPercent,
    bool isSelected = false,
  }) {
    final double barHeight = heightPercent * 70;
    return Column(
      children: [
        Container(
          height: 70,
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 14,
            height: barHeight < 6 ? 6 : barHeight,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2F66F6) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 11,
            color: isSelected ? const Color(0xFF2F66F6) : Colors.grey.shade500,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
