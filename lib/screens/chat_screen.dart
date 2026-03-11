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
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: _getIntroMessage(),
      isUser: false,
      avatar: widget.character.avatar,
    ));
  }

  String _getIntroMessage() {
    switch (widget.character.personality) {
      case CharacterPersonality.funny:
        return 'Heyy! 🙌 Ben ${widget.character.name}! Eğlenmeye hazır mısın?';
      case CharacterPersonality.warm:
        return 'Hoş geldin canım! 💕 Nasılsın bugün?';
      case CharacterPersonality.supportive:
        return 'Merhaba! 🌸 Senin için buradayım. Nasıl hissediyorsun?';
      case CharacterPersonality.optimistic:
        return 'Selam! ☀️ Bugün harika olacak! Bana ne anlatacaksın?';
      default:
        return 'Merhaba! Ben ${widget.character.name}.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD), // WhatsApp benzeri
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(widget.character.avatar),
            ),
            const SizedBox(width: 8),
            Text(widget.character.name),
          ],
        ),
        backgroundColor: const Color(0xFF128C7E), // WhatsApp green
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _MessageBubble(
                  message: _messages[index],
                  speakingText: _speakingText,
                  onSpeak: _speak,
                  onDelete: () => _deleteMessage(index),
                  onEdit: () => _editMessage(index),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  color: _isRecording ? Colors.red : const Color(0xFF128C7E),
                  onPressed: _toggleRecording,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Mesaj yaz...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF0F0F0),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 4),
                CircleAvatar(
                  backgroundColor: const Color(0xFF128C7E),
                  child: IconButton(
                    icon: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
    if (_isRecording) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎙️ Sesli mesaj kaydı yakında!')),
      );
    }
  }

  void _deleteMessage(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mesajı sil?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              setState(() => _messages.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editMessage(int index) {
    final controller = TextEditingController(text: _messages[index].text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mesajı düzenle'),
        content: TextField(controller: controller, maxLines: 3),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
          TextButton(
            onPressed: () {
              setState(() => _messages[index] = ChatMessage(
                text: controller.text,
                isUser: _messages[index].isUser,
                avatar: _messages[index].avatar,
              ));
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
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
      setState(() => _isLoading = false);
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
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _MessageBubble({
    required this.message,
    this.speakingText,
    required this.onSpeak,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isSpeaking = !message.isUser && speakingText == message.text;
    
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: message.isUser ? onDelete : null,
        onDoubleTap: message.isUser ? onEdit : null,
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: message.isUser 
                ? const Color(0xFFDCF8C6) // WhatsApp yeşil
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
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
              Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.black87 : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!message.isUser)
                    GestureDetector(
                      onTap: () => onSpeak(message.text),
                      child: Icon(
                        isSpeaking ? Icons.stop : Icons.volume_up,
                        size: 18,
                        color: isSpeaking ? Colors.red : const Color(0xFF128C7E),
                      ),
                    ),
                  if (!message.isUser) const SizedBox(width: 8),
                  Text(
                    '12:00', // Saat eklenecek
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
