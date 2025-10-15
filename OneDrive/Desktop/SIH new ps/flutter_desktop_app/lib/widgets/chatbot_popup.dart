import 'package:flutter/material.dart';
import '../theme.dart';

// New data model for a chat message
class Message {
  final String text;
  final String sender; // 'user' or 'bot'
  Message({required this.text, required this.sender});
}

class ChatbotPopup extends StatefulWidget {
  const ChatbotPopup({super.key});

  @override
  State<ChatbotPopup> createState() => _ChatbotPopupState();
}

class _ChatbotPopupState extends State<ChatbotPopup> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    // Start with a welcome message from the bot
    _messages.add(Message(text: 'I am Vikky, your project analysis assistant. How can I help?', sender: 'bot'));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    setState(() {
      _messages.add(Message(text: text, sender: 'user'));
      _messages.add(Message(text: 'I am Vikky, your project analysis assistant. How can I help?', sender: 'bot'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        height: 500,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- THE FIX IS HERE: Added a header for the dialog ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vikky',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 1.0),
            const SizedBox(height: 8),
            // --- END OF FIX ---
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _MessageBubble(message: message);
                },
              ),
            ),
            const Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _handleSubmitted,
                      decoration: InputDecoration.collapsed(hintText: 'Send a message...', hintStyle: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A new helper widget to build the styled message bubbles
class _MessageBubble extends StatelessWidget {
  final Message message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUserMessage = message.sender == 'user';
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isUserMessage ? AppTheme.primaryLight : colorScheme.surface,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          isUserMessage ? message.text : 'Vikky: ${message.text}',
          style: TextStyle(
            color: isUserMessage ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}