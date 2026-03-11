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
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String? _speakingText;

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: _getIntroMessage(),
      isUser: false,
      avatar: widget.character.avatar,
      timestamp: DateTime.now(),
    ));
  }

  String _getIntroMessage() {
    switch (widget.character.personality) {
      case CharacterPersonality.funny:
        return 'Selam! 🙌 ${widget.character.name} burada!';
      case CharacterPersonality.warm:
        return 'Hoş geldin! 💕';
      default:
        return 'Merhaba! 👋';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: SafeArea(
        child: Column(
          children: [
            // Header - Özgün tasarım
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Geri butonu
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F0FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF6B4EFF)),
                  ),
                  const SizedBox(width: 12),
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(widget.character.avatar!, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // İsim ve durum
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.character.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF22C55E),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Çevrimiçi',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Menü butonları
                  IconButton(
                    icon: const Icon(Icons.call, color: Color(0xFF6B4EFF)),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Color(0xFF6B4EFF)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Mesajlar - Özgün balonlar
            Expanded(
              child: Container(
                color: const Color(0xFFF5F0FF),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _MessageBubble(
                      message: _messages[index],
                      speakingText: _speakingText,
                      onSpeak: _speak,
                      onLongPress: () => _showMessageOptions(index),
                    );
                  },
                ),
              ),
            ),

            // Input - Özgün tasarım
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Emoji butonu
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F0FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.emoji_emotions_outlined, color: Color(0xFF6B4EFF)),
                  ),
                  const SizedBox(width: 12),
                  // Input alanı
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F0FF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Mesaj yaz...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Gönder butonu
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.copy, color: Color(0xFF6B4EFF)),
              title: const Text('Kopyala'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: _messages[index].text));
                Navigator.pop(context);
              },
            ),
            if (_messages[index].isUser)
              ListTile(
                leading: const Icon(Icons.delete_outline, Colors.red),
                title: const Text('Sil', style: TextStyle(color: Colors.red)),
                onTap: () {
                  setState(() => _messages.removeAt(index));
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _scrollToBottom();

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
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Bir hata oluştu 😔',
          isUser: false,
          avatar: widget.character.avatar,
          timestamp: DateTime.now(),
        ));
      });
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.avatar,
    required this.timestamp,
  });
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String? speakingText;
  final Function(String) onSpeak;
  final VoidCallback onLongPress;

  const _MessageBubble({
    required this.message,
    this.speakingText,
    required this.onSpeak,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isSpeaking = !message.isUser && speakingText == message.text;
    
    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!message.isUser && message.avatar != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(message.avatar!, style: const TextStyle(fontSize: 28)),
              ),
            Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: message.isUser 
                        ? const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)],
                          ).colors.first
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(22),
                      topRight: const Radius.circular(22),
                      bottomLeft: Radius.circular(message.isUser ? 22 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : const Color(0xFF1A1A2E),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (!message.isUser)
                      GestureDetector(
                        onTap: () => onSpeak(message.text),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            isSpeaking ? Icons.stop_circle : Icons.volume_up,
                            size: 18,
                            color: isSpeaking ? Colors.red : const Color(0xFF6B4EFF),
                          ),
                        ),
                      ),
                    Text(
                      '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
