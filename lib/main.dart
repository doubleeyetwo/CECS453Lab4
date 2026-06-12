// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

// @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: MortgageCalculator());
//   }
// }

// class MortgageCalculator extends StatefulWidget {
//   @override
//   _MortgageCalculatorState createState() => _MortgageCalculatorState();
// }

// class _MortgageCalculatorState extends State<MortgageCalculator> {
//   // 1. Controllers for text fields
//   final TextEditingController _priceController = TextEditingController();
//   final TextEditingController _rateController = TextEditingController();
  
//   // 2. State variables for radio buttons
//   int _selectedyear = 10;
  
//   // 3. Calculation result
//   final _result = "0.00";

//   void _calculateMortgage() {
//     // Calculation logic here
//     setState(() {
//       // Update _result
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Mortgage Calculator")),
//       body: Column(
//         children: [
//           TextField(controller: _priceController, decoration: InputDecoration(labelText: 'Home Price')),
//           TextField(controller: _rateController, decoration: InputDecoration(labelText: 'Interest Rate %')),
          
//           RadioGroup<int>(
//             groupValue: _selectedyear,
//             onChanged: (val) => setState(() => _selectedyear = val!),
//             child: Row(
//               children: <Widget>[
//                 RadioListTile<int>(
//                   title:Text("10"),
//                   value: 10,
//                 ),
//                 RadioListTile<int>(
//                   title:Text("15"),
//                   value: 15,
//                 ),
//                 RadioListTile<int>(
//                   title:Text("30"),
//                   value: 30,
//                 )
//               ],
//             )

//           ),
          
//           ElevatedButton(onPressed: _calculateMortgage, child: Text("Calculate")),
//           Text("Monthly Payment: $_result"),
//         ],
//       ),
//     );
//   }
// }


import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MortgageCalculator());
  }
}

class MortgageCalculator extends StatefulWidget {
  @override
  _MortgageCalculatorState createState() => _MortgageCalculatorState();
}

class _MortgageCalculatorState extends State<MortgageCalculator> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  int _selectedyear = 10;
  String _result = "0.00";

  void _calculateMortgage() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final monthlyRate = rate / 100 / 12;
    final n = _selectedyear * 12;

    double payment = 0;
    if (monthlyRate > 0) {
      payment =
          price *
          monthlyRate *
          pow(1 + monthlyRate, n) /
          (pow(1 + monthlyRate, n) - 1);
    } else if (n > 0) {
      payment = price / n;
    }

    setState(() {
      _result = payment.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mortgage Calculator")),
      body: Column(
        children: [
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: 'Home Price'),
          ),
          TextField(
            controller: _rateController,
            decoration: InputDecoration(labelText: 'Interest Rate %'),
          ),
          RadioGroup<int>(
            groupValue: _selectedyear,
            onChanged: (val) => setState(() => _selectedyear = val!),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RadioListTile<int>(title: Text("10"), value: 10),
                ),
                Expanded(
                  child: RadioListTile<int>(title: Text("15"), value: 15),
                ),
                Expanded(
                  child: RadioListTile<int>(title: Text("30"), value: 30),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _calculateMortgage,
            child: Text("Calculate"),
          ),
          Text("Monthly Payment: $_result"),
        ],
      ),
    );
  }
}
