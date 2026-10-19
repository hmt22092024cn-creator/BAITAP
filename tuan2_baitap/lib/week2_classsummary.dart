import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const ClassSummaryApp(),
  ),
);

class ClassSummaryApp extends StatelessWidget {
  const ClassSummaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const ClassSummaryScreen(),
    );
  }
}

class StudentScore {
  final String name;
  final double? score;

  StudentScore({required this.name, this.score});
}

class ClassSummaryScreen extends StatelessWidget {
  const ClassSummaryScreen({super.key});

  String getGradeLabel(double? score) {
    if (score == null) return 'Chưa có điểm';
    if (score >= 8.0) return 'Giỏi';
    if (score >= 6.5) return 'Khá';
    if (score >= 5.0) return 'Trung bình';
    return 'Yếu';
  }

  @override
  Widget build(BuildContext context) {
    final List<StudentScore> students = [
      StudentScore(name: 'Nguyễn Văn An', score: 9.0),
      StudentScore(name: 'Trần Thị Bình', score: 7.2),
      StudentScore(name: 'Lê Minh Trí', score: null),
      StudentScore(name: 'Phạm Quốc Dũng', score: 4.5),
      StudentScore(name: 'Võ Thanh Em', score: 5.8),
    ];

    double totalScore = 0;
    int validScoreCount = 0;
    int gioiCount = 0;
    int noScoreCount = 0;
    double maxScore = 0;

    for (var s in students) {
      if (s.score != null) {
        totalScore += s.score!;
        validScoreCount++;
        if (s.score! >= 8.0) gioiCount++;
        if (s.score! > maxScore) maxScore = s.score!;
      } else {
        noScoreCount++;
      }
    }

    double avgScore = validScoreCount > 0 ? totalScore / validScoreCount : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A5F),
        title: const Text(
          'Bảng điểm lớp',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A5F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Điểm trung bình lớp',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    avgScore.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Giỏi', '$gioiCount'),
                      _buildStatItem('Chưa có điểm', '$noScoreCount'),
                      _buildStatItem('Cao nhất', maxScore.toStringAsFixed(1)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'DANH SÁCH - ${students.length} SINH VIÊN',
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
                  itemCount: students.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final s = students[index];
                    final gradeLabel = getGradeLabel(s.score);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                gradeLabel,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            s.score != null
                                ? s.score!.toStringAsFixed(1)
                                : '--',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
