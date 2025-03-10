import 'package:flutter/material.dart';

class Ai extends StatefulWidget {
  const Ai({Key? key}) : super(key: key);

  @override
  State<Ai> createState() => _AiState();
}

class _AiState extends State<Ai> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("AI Page"),
      ),
    );
  }
}