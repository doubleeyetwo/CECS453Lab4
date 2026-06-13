import 'package:flutter/material.dart';
import 'dart:math';

class InputInfo { // Class to store results
  final double price;
  final double rate;
  final int year;
  final double result;
  final double monthly;

  const InputInfo(this.price, this.rate, this.year, this.result, this.monthly);
}

// Monthly payment helper function
double monthlyPayment(double amount, double rate, int years) {
  double mRate = (rate / 100) / 12;
  double temp = pow(1 / (1 + mRate), years * 12).toDouble();
  return amount * mRate / (1 - temp);
}

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

  void _calculateMortgage() {
    double price = double.tryParse(_priceController.text) ?? 0;
    double rate = double.tryParse(_rateController.text) ?? 0;

    double monthly = monthlyPayment(price, rate, _selectedyear);
    double total = monthly * (_selectedyear * 12);

    final InputInfo finalcalc = InputInfo(price, rate / 100, _selectedyear, total, monthly,);

    Navigator.push(context, MaterialPageRoute(builder: (context) => CalculationScreen(finalcalc)),); // Pass results to next screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mortgage Calculator", style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue,),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _rateController,
              decoration: InputDecoration(labelText: 'Interest Rate %'),
            ),
          ),
          RadioGroup<int>(
            groupValue: _selectedyear,
            onChanged: (val) => setState(() => _selectedyear = val!),
            child: Container(
              margin: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Text("Years:"),
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
            )
          ),
          ElevatedButton(
            onPressed: _calculateMortgage,
            child: Text("Done"),
          ),
        ],
      ),
    );
  }
}

class CalculationScreen extends StatelessWidget {
  final InputInfo results;

  const CalculationScreen(this.results, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculation Results", style: TextStyle(color: Colors.white), textAlign: TextAlign.center,), automaticallyImplyLeading: false, backgroundColor: Colors.blue),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: [
            Container(decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)), padding: EdgeInsets.all(10), 
            child: Column(
              children: <Widget>[
                Text("Amount: \$${results.price}", style: TextStyle(color: Colors.white, fontSize: 16),),
                Text("Years: ${results.year}", style: TextStyle(color: Colors.white, fontSize: 16)),
                Text("Interest Rate: ${(results.rate * 100).toStringAsFixed(2)}%", style: TextStyle(color: Colors.white,fontSize: 16),),
                Text("Monthly Payment: \$${results.monthly.isFinite ? results.monthly.toStringAsFixed(2) : 'N/A'}", style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              )
            ),
            Text("Total with Interest: \$${results.result.toStringAsFixed(2)}", style: TextStyle(fontSize: 22)),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to other screen to modify data
              }, 
              child: Text('Modify Data')
            )
          ],
        ),
      ),
    );
  }
}