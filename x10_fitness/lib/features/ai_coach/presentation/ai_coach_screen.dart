import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_widgets.dart';

class _ChatMessage {
  _ChatMessage({required this.text, required this.isUser});
  final String text;
  final bool isUser;
}

/// Abstraction for the AI backend so it can be swapped (Anthropic, OpenAI,
/// Vertex/Gemini via Cloud Functions) without touching the UI layer.
/// Wire this up to a Cloud Function endpoint that proxies your chosen
/// LLM provider — never call third-party AI APIs with a key embedded
/// in the client app.
abstract class AiCoachService {
  Future<String> sendMessage(String message, List<String> history);
}

/// Temporary local fallback implementation. Replace with a real
/// [AiCoachService] that calls a Cloud Function before shipping to production.
class MockAiCoachService implements AiCoachService {
  @override
  Future<String> sendMessage(String message, List<String> history) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return 'This is a placeholder AI Coach response. Connect this screen to '
        'your Cloud Function-backed AI service to provide real fitness Q&A, '
        'exercise explanations, and workout plan generation. '
        'Reminder: I can only provide general educational guidance, not '
        'medical diagnosis.';
  }
}

class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key, this.service});

  final AiCoachService? service;

  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  late final AiCoachService _service = widget.service ?? MockAiCoachService();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'Hi! I\'m your AI Fitness Coach. Ask me about exercises, '
          'workout plans, or nutrition basics. I provide general '
          'educational guidance only — not medical advice.',
      isUser: false,
    ),
  ];
  bool _isSending = false;

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _isSending = true;
      _controller.clear();
    });
    _scrollToBottom();

    final history = _messages.map((m) => m.text).toList();
    final reply = await _service.sendMessage(text, history);

    setState(() {
      _messages.add(_ChatMessage(text: reply, isUser: false));
      _isSending = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Coach')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SafetyDisclaimerBanner(
                message: AppConstants.medicalDisclaimer,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isSending ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  }
                  final msg = _messages[index];
                  return Align(
                    alignment: msg.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: msg.isUser
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg.text,
                        style: TextStyle(
                          color: msg.isUser
                              ? Colors.white
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Ask about an exercise or workout plan...',
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _isSending ? null : _send,
                    icon: const Icon(Icons.send),
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
