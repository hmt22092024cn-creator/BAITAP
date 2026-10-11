import 'package:flutter/material.dart';

class GradingScreen extends StatefulWidget {
  const GradingScreen({super.key});

  @override
  State<GradingScreen> createState() => _GradingScreenState();
}

class _GradingScreenState extends State<GradingScreen> {
  final TextEditingController _scoreController = TextEditingController(text: '8.5');

  String getRank(double? score) {
    if (score == null || score < 0 || score > 10) return 'Không hợp lệ';
    if (score >= 8.0) return 'Giỏi';
    if (score >= 6.5) return 'Khá';
    if (score >= 5.0) return 'Trung bình';
    return 'Yếu';
  }

  Color getRankColor(double? score) {
    if (score == null || score < 0 || score > 10) return Colors.grey;
    if (score >= 8.0) return Colors.green;
    if (score >= 6.5) return Colors.blue;
    if (score >= 5.0) return Colors.amber.shade700;
    return Colors.red;
  }

  Widget _buildPresetChip(double score) {
    return ActionChip(
      label: Text('$score'),
      onPressed: () {
        setState(() {
          _scoreController.text = score.toString();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double? currentScore = double.tryParse(_scoreController.text);
    String rank = getRank(currentScore);
    Color color = getRankColor(currentScore);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text('Xếp loại học lực'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'NHẬP ĐIỂM TRUNG BÌNH',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _scoreController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: 'Nhập từ 0 đến 10',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: color.withAlpha(35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            rank,
                            style: TextStyle(
                              color: color,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'THỬ NHANH CÁC MỨC ĐIỂM',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildPresetChip(9.5),
                    _buildPresetChip(7.5),
                    _buildPresetChip(6.0),
                    _buildPresetChip(4.0),
                    _buildPresetChip(11.0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}