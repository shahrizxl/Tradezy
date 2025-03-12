import 'package:flutter/material.dart';
import 'package:istudent/pages/home.dart';
import 'package:istudent/pages/bottomnav.dart';

class EduPage extends StatelessWidget {
  const EduPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Education Management', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,

      ),
      backgroundColor: Colors.black,
      body: const Center(child: Text("Education Page")),
    );
  }
}
