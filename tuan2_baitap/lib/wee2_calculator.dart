import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _num1Controller = TextEditingController(text: '4');
  final TextEditingController _num2Controller = TextEditingController(text: '4');

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

      switch (op) {
        case '+':
          double val = n1 + n2;
          _result = val == val.toInt() ? val.toInt().toString() : val.toStringAsFixed(2);
          break;
        case '-':
          double val = n1 - n2;
          _result = val == val.toInt() ? val.toInt().toString() : val.toStringAsFixed(2);
          break;
        case '*':
          double val = n1 * n2;
          _result = val == val.toInt() ? val.toInt().toString() : val.toStringAsFixed(2);
          break;
        case '/':
          if (n2 == 0) {
            _result = 'Không thể chia cho 0';
          } else {
            double val = n1 / n2;
            _result = val == val.toInt() ? val.toInt().toString() : val.toStringAsFixed(2);
          }
          break;
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
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thực hành 03'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _num1Controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (_) => _calculate(_selectedOp),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOpButton('+', Colors.red.shade400),
                    _buildOpButton('-', Colors.amber.shade600),
                    _buildOpButton('*', Colors.indigo.shade400),
                    _buildOpButton('/', Colors.black87),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _num2Controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (_) => _calculate(_selectedOp),
                ),
                const SizedBox(height: 24),
                Text(
                  'Kết quả: $_result',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}