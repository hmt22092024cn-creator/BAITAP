import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const Bai2App(),
  ),
);

class Bai2App extends StatelessWidget {
  const Bai2App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Bài 2 - Quản lý thư viện',
      debugShowCheckedModeBanner: false,
      home: LibraryManagerScreen(),
    );
  }
}

class Book {
  String title;
  bool isBorrowed;
  Book({required this.title, this.isBorrowed = false});
}

class LibraryManagerScreen extends StatefulWidget {
  const LibraryManagerScreen({super.key});

  @override
  State<LibraryManagerScreen> createState() => _LibraryManagerScreenState();
}

class _LibraryManagerScreenState extends State<LibraryManagerScreen> {
  int _selectedIndex = 0;
  final TextEditingController _studentController = TextEditingController(text: "Nguyen Van A");

  final List<Book> _books = [
    Book(title: "Sách 01", isBorrowed: true),
    Book(title: "Sách 02", isBorrowed: true),
  ];

  void _addBook() {
    setState(() {
      _books.add(Book(title: "Sách 0${_books.length + 1}", isBorrowed: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hệ thống\nQuản lý Thư viện', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sinh viên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _studentController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5BFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã cập nhật sinh viên!')),
                    );
                  },
                  child: const Text('Thay đổi'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Danh sách sách', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: _books.map((book) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CheckboxListTile(
                      activeColor: Colors.red.shade700,
                      title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                      value: book.isBorrowed,
                      onChanged: (val) {
                        setState(() {
                          book.isBorrowed = val ?? false;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 160,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5BFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _addBook,
                  child: const Text('Thêm', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF2E5BFF),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Quản lý'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'DS Sách'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Sinh viên'),
        ],
      ),
    );
  }
}