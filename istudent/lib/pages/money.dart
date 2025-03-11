import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // For graphs
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:istudent/pages/home.dart';
import 'package:istudent/pages/bottomnav.dart';

class FinanceApp extends StatefulWidget {
  @override
  _FinanceAppState createState() => _FinanceAppState();
}

class _FinanceAppState extends State<FinanceApp> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [HomeScreen(), AddTransactionScreen(), StatsScreen(), IncomeScreen(), InvestmentScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // Dark mode
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Income'),
            BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Invest'),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Finance Tracker', style: TextStyle(color: Colors.black)),
        backgroundColor: Color.fromARGB(255, 213, 128, 0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
          },
      ),
      ),
      body: Center(child: Text('Dashboard UI Here', style: TextStyle(fontSize: 18))),
    );
  }
}

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String _transactionType = 'Expense'; // Default type
  String _selectedPurpose = 'Food and Drink'; // Default purpose

  final List<String> _purposes = [
    'Food and Drink',
    'Shopping',
    'Transportation',
    'Entertainment',
    'Investment',
    'Housing',
    'Tuition Fee'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));

          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField(
              value: _transactionType,
              items: ['Income', 'Expense'].map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _transactionType = value as String;
                });
              },
              decoration: InputDecoration(labelText: 'Transaction Type'),
            ),
            TextField(decoration: InputDecoration(labelText: 'Amount')),
            DropdownButtonFormField(
              value: _selectedPurpose,
              items: _purposes.map((String purpose) {
                return DropdownMenuItem(value: purpose, child: Text(purpose));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPurpose = value as String;
                });
              },
              decoration: InputDecoration(labelText: 'Purpose'),
            ),
            ElevatedButton(onPressed: () {}, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));

          },
        ),
      ),
      body: Center(child: Text('Graph UI Here', style: TextStyle(fontSize: 18))),
    );
  }
}

class IncomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income & 50/30/20 Rule'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));

          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Enter your income')),
            ElevatedButton(onPressed: () {}, child: Text('Calculate Allocation')),
          ],
        ),
      ),
    );
  }
}

class InvestmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investment Suggestions'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));

          },
        ),
      ),
      body: Center(child: Text('Investment recommendations will be shown here.')),
    );
  }
}