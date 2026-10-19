import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const GradingApp(),
  ),
);

class GradingApp extends StatelessWidget {
  const GradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const GradingScreen(),
    );
  }
}

class GradingScreen extends StatefulWidget {
  const GradingScreen({super.key});

  @override
  State<GradingScreen> createState() => _GradingScreenState();
}

class _GradingScreenState extends State<GradingScreen> {
  // Controller cho ô nhập điểm (Mặc định là 8.5 theo đề)
  final TextEditingController _scoreController = TextEditingController(
    text: '8.5',
  );

  // Hàm xếp loại học lực theo đúng thang điểm đề bài
  Map<String, dynamic> evaluateGrade(double score) {
    if (score < 0 || score > 10) {
      return {
        'label': 'Không hợp lệ',
        'color': Colors.grey.shade600,
        'bg': Colors.grey.shade200,
      };
    } else if (score >= 8.0) {
      return {
        'label': 'Giỏi',
        'color': const Color(0xFF2E7D32),
        'bg': const Color(0xFFE8F5E9),
      };
    } else if (score >= 6.5) {
      return {
        'label': 'Khá',
        'color': const Color(0xFF1565C0),
        'bg': const Color(0xFFE3F2FD),
      };
    } else if (score >= 5.0) {
      return {
        'label': 'Trung bình',
        'color': const Color(0xFFE65100),
        'bg': const Color(0xFFFFF3E0),
      };
    } else {
      return {
        'label': 'Yếu',
        'color': const Color(0xFFC62828),
        'bg': const Color(0xFFFFEBEE),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    double currentScore = double.tryParse(_scoreController.text) ?? -1;
    final mainGrade = evaluateGrade(currentScore);
    final List<double> testScores = [9.0, 7.0, 5.5, 3.0, 11.0];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        title: const Text(
          'Xếp loại học lực',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KHU VỰC HIỂN THỊ VÀ NHẬP ĐIỂM
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Điểm trung bình',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),

                  // Ô nhập điểm trực tiếp
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _scoreController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {}); // Cập nhật giao diện khi đổi số
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Khung hiển thị kết quả xếp loại
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: mainGrade['bg'],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      mainGrade['label'],
                      style: TextStyle(
                        color: mainGrade['color'],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // PHẦN KIỂM TRA THÊM CỦA ĐỀ BÀI
            Text(
              'KIỂM TRA THÊM',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: testScores.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final score = testScores[index];
                    final grade = evaluateGrade(score);
                    final String scoreText = score == score.toInt()
                        ? score.toInt().toString()
                        : score.toString();
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Điểm $scoreText',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: grade['bg'],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              grade['label'],
                              style: TextStyle(
                                color: grade['color'],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
