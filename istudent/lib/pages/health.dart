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
        title: const Text('Health Management'),
        backgroundColor: Color.fromARGB(255, 213, 128, 0),
                leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNav()));
          },
      ),
      ),
      backgroundColor: Colors.black,
      body: const Center(child: Text("Health Page")),
    );
  }
}
