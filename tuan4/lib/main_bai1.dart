import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(
  DevicePreview(enabled: !kReleaseMode, builder: (context) => const Bai1App()),
);

class Bai1App extends StatelessWidget {
  const Bai1App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Bài 1 - UTH Todo V2',
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildStartScreen(),
          _buildOnboardingStep1(),
          _buildOnboardingStep2(),
          _buildOnboardingStep3(),
        ],
      ),
    );
  }

  // MÀN HÌNH START (NỀN XANH LỚN)
  Widget _buildStartScreen() {
    return Container(
      color: const Color(0xFF3B67E9),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
      child: Column(
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.playlist_add_check_rounded,
              size: 64,
              color: Color(0xFF3B67E9),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'UTH Todo',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Việc học, việc nhà - gọn gàng mỗi ngày',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.white70),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF3B67E9),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => _controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              child: const Text(
                'Bắt đầu',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ONBOARDING BƯỚC 1 (Mọi việc, gọn trong một chỗ)
  Widget _buildOnboardingStep1() {
    return _buildBaseOnboardingLayout(
      stepIndex: 0,
      title: 'Mọi việc, gọn trong một chỗ',
      subtitle: 'Ghi lại bài tập, việc nhà, lịch hẹn. Không còn quên việc nào.',
      buttonText: 'Tiếp tục',
      onButtonPressed: () => _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
      illustration: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTaskCard(isChecked: true),
          const SizedBox(height: 12),
          _buildTaskCard(isChecked: false),
          const SizedBox(height: 12),
          _buildTaskCard(isChecked: false),
        ],
      ),
    );
  }

  // ONBOARDING BƯỚC 2 (Chia theo Học tập và Cuộc sống)
  Widget _buildOnboardingStep2() {
    return _buildBaseOnboardingLayout(
      stepIndex: 1,
      title: 'Chia theo Học tập và\nCuộc sống',
      subtitle: 'Mỗi việc có nhóm riêng, nhìn là biết hôm nay cần lo gì.',
      buttonText: 'Tiếp tục',
      onButtonPressed: () => _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
      illustration: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCategoryCard(
            tagText: 'Học tập',
            tagBg: const Color(0xFFE8F0FE),
            tagColor: const Color(0xFF1967D2),
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            tagText: 'Cuộc sống',
            tagBg: const Color(0xFFFEF0E7),
            tagColor: const Color(0xFFD97706),
          ),
        ],
      ),
    );
  }

  // ONBOARDING BƯỚC 3 (Nhắc đúng lúc)
  Widget _buildOnboardingStep3() {
    return _buildBaseOnboardingLayout(
      stepIndex: 2,
      title: 'Nhắc đúng lúc',
      subtitle: 'Bật thông báo để UTH Todo nhắc bạn trước hạn chót.',
      buttonText: 'Bắt đầu ngay',
      onButtonPressed: () {},
      illustration: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A3B67E9),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: Color(0xFF3B67E9),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Text(
              'Ôn bài Toán lúc 19:00',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // BỐ CỤC CHUNG KHUNG ONBOARDING
  Widget _buildBaseOnboardingLayout({
    required int stepIndex,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onButtonPressed,
    required Widget illustration,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B67E9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.playlist_add_check_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'UTH Todo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B67E9),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Bỏ qua',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F6FD),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: illustration,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: List.generate(3, (index) {
                bool isActive = index == stepIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 6),
                  height: 6,
                  width: isActive ? 20 : 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF3B67E9)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B67E9),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onButtonPressed,
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // THẺ TASK DẠNG DANH SÁCH (CHO ONBOARDING 1A)
  Widget _buildTaskCard({required bool isChecked}) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isChecked
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: isChecked ? const Color(0xFF3B67E9) : Colors.grey.shade300,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: isChecked ? Colors.grey.shade300 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // THẺ CATEGORY NHÓM CÔNG VIỆC (CHO ONBOARDING 1B)
  Widget _buildCategoryCard({
    required String tagText,
    required Color tagBg,
    required Color tagColor,
  }) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: tagBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              tagText,
              style: TextStyle(
                color: tagColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}
