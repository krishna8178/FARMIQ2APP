// lib/screens/chatbot_screen.dart
import 'package:flutter/material.dart';
import 'package:farmiq_app/utils/constants.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      _textController.clear();
      setState(() {
        _messages.insert(0, text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        // The icon theme will color the automatically added back button
        iconTheme: const IconThemeData(color: kPrimaryColor),

        // --- FIX ---
        // I have removed the manual `leading` widget.
        // The AppBar will now automatically add a back button if a previous screen exists.
        // This is the standard and most reliable way.

        title: const Text(
          'Farmy Assistant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _buildMessageItem(_messages[index]),
            ),
          ),
          const Divider(height: 1.0),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: const CircleAvatar(child: Text('U')),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('You', style: Theme.of(context).textTheme.titleMedium),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(message),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration(
                hintText: 'Ask Farmy a question...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.send, color: kPrimaryColor),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}