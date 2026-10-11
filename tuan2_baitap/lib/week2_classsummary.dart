import 'package:flutter/material.dart';

class ClassStudent {
  final String name;
  final double? score;

  ClassStudent({required this.name, this.score});
}

class ClassSummaryScreen extends StatelessWidget {
  const ClassSummaryScreen({super.key});

  String getRank(double? score) {
    if (score == null) return 'Chưa có điểm';
    if (score >= 8.0) return 'Giỏi';
    if (score >= 6.5) return 'Khá';
    if (score >= 5.0) return 'Trung bình';
    return 'Yếu';
  }

  Color getRankColor(double? score) {
    if (score == null) return Colors.grey;
    if (score >= 8.0) return Colors.green;
    if (score >= 6.5) return Colors.blue;
    if (score >= 5.0) return Colors.amber.shade700;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final List<ClassStudent> students = [
      ClassStudent(name: 'Nguyễn Văn An', score: 9.0),
      ClassStudent(name: 'Trần Thị Bình', score: 7.2),
      ClassStudent(name: 'Lê Minh Chi', score: null),
      ClassStudent(name: 'Phạm Quốc Dũng', score: 4.5),
      ClassStudent(name: 'Võ Thanh Em', score: 5.8),
    ];

    double sumScore = 0;
    int scoredCount = 0;
    int gioiCount = 0;
    int noScoreCount = 0;
    double maxScore = -1;

    for (var s in students) {
      if (s.score != null) {
        sumScore += s.score!;
        scoredCount++;
        if (s.score! >= 8.0) gioiCount++;
        if (s.score! > maxScore) maxScore = s.score!;
      } else {
        noScoreCount++;
      }
    }

    double avgScore = scoredCount > 0 ? sumScore / scoredCount : 0;

    List<Widget> listRows = [];
    for (var s in students) {
      listRows.add(
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(
                    getRank(s.score),
                    style: TextStyle(
                      fontSize: 12,
                      color: getRankColor(s.score),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                s.score != null ? '${s.score}' : '—',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text('Bảng điểm lớp'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text('Điểm trung bình lớp', style: TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 6),
                      Text(
                        avgScore.toStringAsFixed(2),
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const Divider(color: Colors.white24, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Giỏi', style: TextStyle(color: Colors.white70, fontSize: 11)),
                              const SizedBox(height: 4),
                              Text('$gioiCount', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Chưa có điểm', style: TextStyle(color: Colors.white70, fontSize: 11)),
                              const SizedBox(height: 4),
                              Text('$noScoreCount', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Cao nhất', style: TextStyle(color: Colors.white70, fontSize: 11)),
                              const SizedBox(height: 4),
                              Text('${maxScore > 0 ? maxScore : "—"}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'DANH SÁCH - ${students.length} SINH VIÊN',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: listRows,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}