import 'package:flutter/material.dart';
import 'package:dedikodu_kazani/models/character.dart';
import 'package:dedikodu_kazani/services/ai_service.dart';
import 'package:dedikodu_kazani/services/tts_service.dart';

class ChatScreen extends StatefulWidget {
  final Character character;

  const ChatScreen({super.key, required this.character});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _speakingText;

  @override
  void initState() {
    super.initState();
    // Karakter tanıtımı
    _messages.add(ChatMessage(
      text: _getIntroMessage(),
      isUser: false,
      avatar: widget.character.avatar,
    ));
  }

  String _getIntroMessage() {
    switch (widget.character.personality) {
      case CharacterPersonality.funny:
        return 'Heyy! 🙌 Ben ${widget.character.name}! Eğlenmeye hazır mısın? Bugün neler var?';
      case CharacterPersonality.warm:
        return 'Hoş geldin canım! 💕 Nasılsın bugün? Sana bir kahve alayım (simgesel olarak ☕)';
      case CharacterPersonality.supportive:
        return 'Merhaba! 🌸 Senin için buradayım. Nasıl hissediyorsun bugün?';
      case CharacterPersonality.optimistic:
        return 'Selam! ☀️ Bugün harika olacak! Bana ne anlatacaksın?';
      default:
        return 'Merhaba! Ben ${widget.character.name}. Nasıl yardımcı olabilirim?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.pink[100],
              child: Text(widget.character.avatar),
            ),
            const SizedBox(width: 8),
            Text(widget.character.name),
          ],
        ),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Mesajlar
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _MessageBubble(
                  message: msg,
                  speakingText: _speakingText,
                  onSpeak: _speak,
                );
              },
            ),
          ),
          // Yazı alanı
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Mesaj yaz...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                  color: Colors.pinkAccent,
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    try {
      final response = await AIService.sendMessage(
        message: text,
        character: widget.character,
      );

      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          avatar: widget.character.avatar,
        ));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Üzgünüm, bir hata oluştu 😔',
          isUser: false,
          avatar: widget.character.avatar,
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _speak(String text) async {
    if (_speakingText == text) {
      await TTSService.stop();
      setState(() => _speakingText = null);
    } else {
      setState(() => _speakingText = text);
      await TTSService.speak(text, widget.character);
      setState(() => _speakingText = null);
    }
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String? avatar;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.avatar,
  });
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String? speakingText;
  final Function(String) onSpeak;

  const _MessageBubble({
    required this.message,
    this.speakingText,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    final isSpeaking = !message.isUser && speakingText == message.text;
    
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.pinkAccent : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser && message.avatar != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.avatar!,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                if (!message.isUser) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onSpeak(message.text),
                    child: Icon(
                      isSpeaking ? Icons.stop : Icons.volume_up,
                      size: 20,
                      color: isSpeaking ? Colors.red : Colors.pink,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
