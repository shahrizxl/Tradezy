import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:istudent/pages/home.dart';
import 'package:istudent/pages/ai.dart';
import 'package:istudent/pages/edu.dart';
import 'package:istudent/pages/health.dart';
import 'package:istudent/pages/money.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const Home(),
    FinanceApp(),
    const HealthPage(),
    const EduNavPage(),
    const Ai(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        color: Colors.blueAccent,
        animationDuration: const Duration(milliseconds: 500),
        items: const [
          Icon(Icons.home, size: 30),
          Icon(Icons.money, size: 30),
          Icon(Icons.school, size: 30),
          Icon(Icons.chat, size: 30),
          Icon(Icons.android, size: 30),

        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
