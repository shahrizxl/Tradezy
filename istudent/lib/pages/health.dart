import 'package:flutter/material.dart';
import 'package:istudent/pages/home.dart';
import 'package:istudent/pages/bottomnav.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Learn', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,

      ),
      backgroundColor: Colors.black,
      body: const Center(child: Text("Trade")),
    );
  }
}
