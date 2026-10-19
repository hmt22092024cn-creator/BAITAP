import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const CalculatorApp(),
  ),
);

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _num1Controller = TextEditingController(
    text: '4',
  );
  final TextEditingController _num2Controller = TextEditingController(
    text: '4',
  );

  String _selectedOp = '+';
  String _result = '8';

  void _calculate(String op) {
    setState(() {
      _selectedOp = op;
      double? n1 = double.tryParse(_num1Controller.text);
      double? n2 = double.tryParse(_num2Controller.text);

      if (n1 == null || n2 == null) {
        _result = 'Lỗi nhập số';
        return;
      }

      if (op == '+') {
        double val = n1 + n2;
        _result = val == val.toInt()
            ? val.toInt().toString()
            : val.toStringAsFixed(2);
      } else if (op == '-') {
        double val = n1 - n2;
        _result = val == val.toInt()
            ? val.toInt().toString()
            : val.toStringAsFixed(2);
      } else if (op == '*') {
        double val = n1 * n2;
        _result = val == val.toInt()
            ? val.toInt().toString()
            : val.toStringAsFixed(2);
      } else if (op == '/') {
        if (n2 == 0) {
          _result = 'Không thể chia cho 0';
        } else {
          double val = n1 / n2;
          _result = val == val.toInt()
              ? val.toInt().toString()
              : val.toStringAsFixed(2);
        }
      }
    });
  }

  Widget _buildOpButton(String op, Color color) {
    bool isSelected = _selectedOp == op;
    return GestureDetector(
      onTap: () => _calculate(op),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
        ),
        child: Center(
          child: Text(
            op,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Thực hành 03',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _num1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (val) => _calculate(_selectedOp),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOpButton('+', const Color(0xFFE55353)),
                _buildOpButton('-', const Color(0xFFE6A23C)),
                _buildOpButton('*', const Color(0xFF5352ED)),
                _buildOpButton('/', const Color(0xFF2F3542)),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _num2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (val) => _calculate(_selectedOp),
            ),
            const SizedBox(height: 24),
            Text(
              'Kết quả: $_result',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
