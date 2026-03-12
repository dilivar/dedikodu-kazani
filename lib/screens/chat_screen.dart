import 'package:flutter/material.dart';
import 'package:dedikodu_kazani/models/character.dart';
import 'package:dedikodu_kazani/services/ai_service.dart';

class ChatScreen extends StatefulWidget {
  final Character character;
  
  const ChatScreen({super.key, required this.character});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _messages = <Map<String, dynamic>>[];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Hoşgeldin mesajı
    _messages.add({
      'text': widget.character.introMessage,
      'isUser': false,
      'avatar': widget.character.avatar,
      'time': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(widget.character.avatar!, style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.character.name, style: const TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.bold)),
                const Row(
                  children: [
                    Text('●', style: TextStyle(color: Color(0xFF22C55E), fontSize: 10)),
                    SizedBox(width: 4),
                    Text('Çevrimiçi', style: TextStyle(color: Color(0xFF22C55E), fontSize: 12)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, color: Color(0xFF1A1A2E)), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFF5F0FF),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessage(msg);
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.add, color: Color(0xFF8B5CF6)), onPressed: () {}),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F0FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Mesaj yaz...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: _isLoading 
                        ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isUser = msg['isUser'] as bool;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(msg['avatar'] as String, style: const TextStyle(fontSize: 24)),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF8B5CF6) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isUser ? 20 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 20),
              ),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Text(
              msg['text'] as String,
              style: TextStyle(color: isUser ? Colors.white : const Color(0xFF1A1A2E)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    _controller.clear();
    setState(() {
      _messages.add({'text': text, 'isUser': true, 'time': DateTime.now()});
      _isLoading = true;
    });

    try {
      final response = await AIService.sendMessage(message: text, character: widget.character);
      setState(() {
        _messages.add({
          'text': response,
          'isUser': false,
          'avatar': widget.character.avatar,
          'time': DateTime.now(),
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'text': 'Bir hata oluştu 😔',
          'isUser': false,
          'avatar': widget.character.avatar,
          'time': DateTime.now(),
        });
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
