import 'package:flutter/material.dart';

class Student {
  final String name;
  final String? email;
  final String? phone;

  Student({required this.name, this.email, this.phone});
}

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Student> students = [
      Student(name: 'Nguyễn Văn An', email: 'an@sv.edu.vn', phone: '0901 234 567'),
      Student(name: 'Trần Thị Bình', phone: '0912 888 999'),
      Student(name: 'Lê Minh Chi', email: 'chi@sv.edu.vn'),
      Student(name: 'Phạm Quốc Dũng'),
      Student(name: 'Võ Thanh Em', email: 'em@sv.edu.vn', phone: '0933 111 222'),
    ];

    int missingEmailCount = 0;
    for (var s in students) {
      if (s.email == null) {
        missingEmailCount++;
      }
    }

    List<Widget> studentCards = [];
    for (var s in students) {
      studentCards.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Email: ${s.email ?? "Chưa cập nhật"}',
                style: TextStyle(
                  fontSize: 13,
                  color: s.email == null ? Colors.red.shade400 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'SĐT: ${s.phone ?? "Chưa cập nhật"}',
                style: TextStyle(
                  fontSize: 13,
                  color: s.phone == null ? Colors.red.shade400 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text('Danh sách sinh viên'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: studentCards,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng: ${students.length} sinh viên',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Thiếu email: $missingEmailCount',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700),
                      ),
                    ],
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