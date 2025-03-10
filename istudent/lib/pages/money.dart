import 'package:flutter/material.dart';

class MoneyPage extends StatelessWidget {
  const MoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Finance Management")),
      body: const Center(child: Text("Money Page")),
    );
  }
}
