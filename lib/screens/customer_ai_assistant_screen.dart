import 'package:flutter/material.dart';
import '../core/theme.dart';

class CustomerAIAssistantScreen extends StatefulWidget {
  const CustomerAIAssistantScreen({super.key});

  @override
  State<CustomerAIAssistantScreen> createState() => _CustomerAIAssistantScreenState();
}

class _CustomerAIAssistantScreenState extends State<CustomerAIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Hi! I\'m GharKaKhana AI. Tell me what you want to eat, and I\'ll help you find the perfect meal!',
      'time': 'Just now',
    },
  ];

  final List<String> _suggestedQuestions = [
    'Best veg meal under ₹100?',
    'Which mess is open now?',
    'Recommend something healthy.',
    'What did I order yesterday?',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'text': text,
        'time': 'Just now',
      });
      _messageController.clear();

      // Simulate AI response (TODO: Replace with real AI integration)
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add({
            'isUser': false,
            'text': 'I\'m looking for the best options for you. Based on your preferences, I\'d recommend trying the Veg Thali from Maa\'s Kitchen - it\'s highly rated and affordable!',
            'time': 'Just now',
          });
        });
      });
    });
  }

  void _askSuggestion(String question) {
    _messageController.text = question;
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.smart_toy, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            const Text('GharKaKhana AI'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final message = _messages[i];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Suggested Questions
          if (_messages.length <= 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _suggestedQuestions.map((question) {
                  return GestureDetector(
                    onTap: () => _askSuggestion(question),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        question,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask AI anything...',
                        hintStyle: TextStyle(color: AppColors.textMuted),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final text = message['text'] as String;
    final time = message['time'] as String;

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.smart_toy, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isUser ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isUser ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isUser ? Colors.white : AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        if (isUser) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(Icons.person, color: AppColors.textSecondary, size: 20),
          ),
        ],
      ],
    );
  }
}
