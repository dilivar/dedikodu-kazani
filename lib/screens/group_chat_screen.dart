import 'package:flutter/material.dart';
import 'package:dedikodu_kazani/models/character.dart';
import 'package:dedikodu_kazani/services/ai_service.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<GroupMessage> _messages = [];
  bool _isLoading = false;
  
  // Aktif karakterler
  final List<Character> _characters = [
    Character(
      id: '1',
      name: 'Eda Mayan',
      avatar: '👩‍🎤',
      personality: CharacterPersonality.funny,
      description: 'Sivri dilli',
      isPremium: false,
    ),
    Character(
      id: '2',
      name: 'Ela Soyman',
      avatar: '💕',
      personality: CharacterPersonality.warm,
      description: 'Sıcak',
      isPremium: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(GroupMessage(
      text: '🎉 Grup sohbeti başladı!',
      isSystem: true,
    ));
    _messages.add(GroupMessage(
      text: 'Eda: Heyy herkese! 🙌',
      characterName: 'Eda Mayan',
      avatar: '👩‍🎤',
    ));
    _messages.add(GroupMessage(
      text: 'Ela: Hoş geldiniz! 💕',
      characterName: 'Ela Soyman',
      avatar: '💕',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('👥 Grup Sohbeti'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Aktif karakterler
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _characters.length,
              itemBuilder: (context, index) {
                final char = _characters[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    backgroundColor: Colors.pink[100],
                    child: Text(char.avatar, style: const TextStyle(fontSize: 20)),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          
          // Mesajlar
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _GroupMessageBubble(message: _messages[index]);
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
                      hintText: 'Gruba mesaj yaz...',
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
      _messages.add(GroupMessage(
        text: 'Sen: $text',
        isUser: true,
      ));
      _isLoading = true;
    });

    try {
      // Tüm karakterlerden yanıt al
      for (final character in _characters) {
        await Future.delayed(const Duration(milliseconds: 500));
        
        final response = await AIService.sendMessage(
          message: text,
          character: character,
        );
        
        setState(() {
          _messages.add(GroupMessage(
            text: '${character.name}: $response',
            characterName: character.name,
            avatar: character.avatar,
          ));
        });
      }
    } catch (e) {
      // Hata
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

class GroupMessage {
  final String text;
  final bool isUser;
  final bool isSystem;
  final String? characterName;
  final String? avatar;

  GroupMessage({
    required this.text,
    this.isUser = false,
    this.isSystem = false,
    this.characterName,
    this.avatar,
  });
}

class _GroupMessageBubble extends StatelessWidget {
  final GroupMessage message;

  const _GroupMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isSystem) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message.text,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      );
    }

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
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
                child: Row(
                  children: [
                    Text(message.avatar!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      message.characterName ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
