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
      text: '🎙️ Grup sohbeti başladı!',
      isSystem: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1DA1F2), // Twitter Spaces mavisi
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Dedikodu Kazanı Spaces',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Ana avatar (konuşmacı)
          Expanded(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ana karakter
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1DA1F2), Color(0xFF0D8EC7)],
                      ),
                    ),
                    child: const Center(
                      child: Text('👩‍🎤', style: TextStyle(fontSize: 50)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Eda Mayan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Konuşmacı',
                    style: Color(0xFF8BDAE9),
                  ),
                ],
              ),
            ),
          ),

          // Dinleyiciler (altta)
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _characters.length,
              itemBuilder: (context, index) {
                final char = _characters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text(char.avatar, style: const TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        char.name.split(' ').first,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Mesajlar (ses dalgaları tarzı)
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Seste olanlar
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.headphones, color: Color(0xFF1DA1F2)),
                        const SizedBox(width: 8),
                        const Text(
                          'Seste olanlar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1DA1F2).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('2', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  
                  // Konuşma
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        if (msg.isSystem) {
                          return Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(msg.text, style: const TextStyle(color: Colors.grey)),
                            ),
                          );
                        }
                        return _buildMessage(msg);
                      },
                    ),
                  ),

                  // Yazı alanı
                  Container(
                    padding: const EdgeInsets.all(12),
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
                            decoration: InputDecoration(
                              hintText: 'Gruba mesaj yaz...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: const Color(0xFF1DA1F2),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(GroupMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[200],
            child: Text(msg.avatar ?? '👤', style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg.characterName ?? 'Kullanıcı',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(msg.text, style: const TextStyle(fontSize: 14)),
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
        text: text,
        isUser: true,
        characterName: 'Sen',
        avatar: '👤',
      ));
      _isLoading = true;
    });

    try {
      for (final character in _characters) {
        await Future.delayed(const Duration(milliseconds: 300));
        
        final response = await AIService.sendMessage(
          message: text,
          character: character,
        );
        
        setState(() {
          _messages.add(GroupMessage(
            text: response,
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
