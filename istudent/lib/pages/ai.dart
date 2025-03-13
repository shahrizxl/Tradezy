import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class Ai extends StatefulWidget {
  const Ai({super.key});

  @override
  State<Ai> createState() => _AiState();
}

class _AiState extends State<Ai> {
  final gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  final currentUser = ChatUser(id: "0", firstName: "User");
  final geminiUser = ChatUser(id: "1", firstName: "Istudent AI");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My AI' , style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,

        
      ),
      backgroundColor: Colors.black,
      body: DashChat(
        currentUser: currentUser,
        onSend: _handleSendMessage,
        messages: messages,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.blueAccent,
          containerColor: Colors.grey,
          textColor: Colors.black,
        ),
      ),
    );
  }

  void _handleSendMessage(ChatMessage message) async {
    setState(() {
      messages.insert(0, message);
    });

    try {
      final config = GenerationConfig(
        temperature: 0.7,
        topP: 1,
        topK: 1,
        maxOutputTokens: 2048,
      );

      final response = await gemini.text(message.text, generationConfig: config);
      
      if (response?.output != null) {
        setState(() {
          messages.insert(
            0,
            ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: response!.output.toString(),
            ),
          );
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        messages.insert(
          0,
          ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: "Sorry, I encountered an error. Please try again.",
          ),
        );
      });
    }
  }
}