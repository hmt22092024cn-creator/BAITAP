import 'package:flutter/material.dart';
import 'wee2_calculator.dart';
import 'week2_studentlist.dart';
import 'week2_grading.dart';
import 'week2_classsummary.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bài tập Tuần 2',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      home: const Week2HomeScreen(),
    );
  }
}

class Week2HomeScreen extends StatelessWidget {
  const Week2HomeScreen({super.key});

  Widget _buildMenuButton(
      BuildContext context, String title, String subtitle, IconData icon, Widget targetScreen) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1E3A8A).withAlpha(25),
          child: Icon(icon, color: const Color(0xFF1E3A8A)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài tập Tuần 2'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildMenuButton(
                  context,
                  'Thực hành 03',
                  'Máy tính tính toán 2 số',
                  Icons.calculate,
                  const CalculatorScreen(),
                ),
                _buildMenuButton(
                  context,
                  'Bài 1 VN',
                  'Danh sách sinh viên & Vòng lặp for',
                  Icons.people,
                  const StudentListScreen(),
                ),
                _buildMenuButton(
                  context,
                  'Bài 2 VN',
                  'Xếp loại học lực (Nhập điểm động)',
                  Icons.grade,
                  const GradingScreen(),
                ),
                _buildMenuButton(
                  context,
                  'Bài 3 VN',
                  'Bảng điểm lớp tổng hợp',
                  Icons.analytics,
                  const ClassSummaryScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}