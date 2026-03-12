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
  
  // 7 karakter
  final List<Character> _characters = [
    Character(id: '1', name: 'Eda Mayan', avatar: '👩‍🎤', personality: CharacterPersonality.funny, description: 'Direkt', isPremium: false),
    Character(id: '2', name: 'Ela Soyman', avatar: '💕', personality: CharacterPersonality.warm, description: 'İyimser', isPremium: false),
    Character(id: '3', name: 'Zeynep Solmas', avatar: '👩‍💼', personality: CharacterPersonality.realistic, description: 'Gerçekçi', isPremium: true),
    Character(id: '4', name: 'Derin Yılmaz', avatar: '🧠', personality: CharacterPersonality.psychologist, description: 'Psikolog', isPremium: true),
    Character(id: '5', name: 'Rüzgar Petek', avatar: '💨', personality: CharacterPersonality.romantic, description: 'Romantik', isPremium: true),
    Character(id: '6', name: 'Mert Arslan', avatar: '🏳️‍🌈', personality: CharacterPersonality.friend, description: 'Falcı', isPremium: true),
    Character(id: '7', name: 'Fatih Bilge', avatar: '👨‍💼', personality: CharacterPersonality.mentor, description: 'Mentor', isPremium: true),
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(GroupMessage(text: '👋 7 kişilik grup sohbeti başladı!', isSystem: true));
    _messages.add(GroupMessage(text: 'Eda: Selam herkese! 🙌', characterName: 'Eda Mayan', avatar: '👩‍🎤'));
    _messages.add(GroupMessage(text: 'Ela: Hoşgeldiniz! 💕', characterName: 'Ela Soyman', avatar: '💕'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A1A2E)), onPressed: () => Navigator.pop(context)),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grup Sohbeti', style: TextStyle(color: Color(0xFF1A1A2E), fontSize: 18, fontWeight: FontWeight.bold)),
            Text('7 kişi çevrimiçi', style: TextStyle(color: Color(0xFF22C55E), fontSize: 12)),
          ],
        ),
        actions: [IconButton(icon: const Icon(Icons.more_vert, color: Color(0xFF1A1A2E)), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Karakter avatar'ları
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _characters.length,
              itemBuilder: (context, index) {
                final char = _characters[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)]),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(child: Text(char.avatar!, style: const TextStyle(fontSize: 20))),
                      ),
                      const SizedBox(height: 4),
                      Text(char.name.split(' ').first, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
                    ],
                  ),
                );
              },
            ),
          ),

          // Mesajlar
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  if (msg.isSystem) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(color: const Color(0xFFF5F0FF), borderRadius: BorderRadius.circular(16)),
                        child: Text(msg.text, style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 12, fontWeight: FontWeight.w500)),
                      ),
                    );
                  }
                  return _buildMessage(msg);
                },
              ),
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))]),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: const Color(0xFFF5F0FF), borderRadius: BorderRadius.circular(24)),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(hintText: 'Gruba mesaj yaz...', border: InputBorder.none),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: _isLoading
                        ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
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
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)]), shape: BoxShape.circle),
            child: Center(child: Text(msg.avatar ?? '👤', style: const TextStyle(fontSize: 14))),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(msg.characterName ?? 'Kullanıcı', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1A1A2E))),
                    const SizedBox(width: 8),
                    Text('${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}', style: TextStyle(fontSize: 10, color: Colors.grey[400])),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFF5F0FF), borderRadius: BorderRadius.circular(12)),
                  child: Text(msg.text, style: const TextStyle(fontSize: 14)),
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
      _messages.add(GroupMessage(text: text, isUser: true, characterName: 'Sen', avatar: '👤', timestamp: DateTime.now()));
      _isLoading = true;
    });

    try {
      for (final character in _characters) {
        await Future.delayed(Duration(milliseconds: 300 + _characters.indexOf(character) * 200));
        
        final response = await AIService.sendMessage(message: text, character: character);
        
        setState(() {
          _messages.add(GroupMessage(text: response, characterName: character.name, avatar: character.avatar, timestamp: DateTime.now()));
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
  final DateTime timestamp;

  GroupMessage({required this.text, this.isUser = false, this.isSystem = false, this.characterName, this.avatar, DateTime? timestamp}) : timestamp = timestamp ?? DateTime.now();
}
