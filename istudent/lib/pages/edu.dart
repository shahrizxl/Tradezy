import 'package:flutter/material.dart';
import 'package:istudent/pages/notes.dart'; // Make sure this path is correct
import 'package:istudent/pages/feed.dart'; // Add this import

class EduNavPage extends StatefulWidget {
  const EduNavPage({super.key});

  @override
  _EduNavPageState createState() => _EduNavPageState();
}

class _EduNavPageState extends State<EduNavPage> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [const Feed(), const NotesPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Traders info', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Traders chat'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
        ],
      ),
    );
  }
}