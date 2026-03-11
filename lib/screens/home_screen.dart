import 'package:flutter/material.dart';
import 'package:dedikodu_kazani/models/character.dart';
import 'package:dedikodu_kazani/screens/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Character> _characters = [
    Character(
      id: '1',
      name: 'Eda Mayan',
      description: 'Sivri dilli, şakacı, ironik 🎭',
      avatar: '👩‍🎤',
      personality: CharacterPersonality.funny,
      isPremium: false,
    ),
    Character(
      id: '2',
      name: 'Ela Soyman',
      description: 'İyi niyetli, saf, sıcak kalpli 💕',
      avatar: '💕',
      personality: CharacterPersonality.warm,
      isPremium: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dedikodu Kazanı 🌯'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Hoşgeldin banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.pink[300]!],
              ),
            ),
            child: Column(
              children: [
                const Text(
                  '🌯',
                  style: TextStyle(fontSize: 50),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Dedikodu Kazanı',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'AI Arkadaşların burada!',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          // Karakterler
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Karakterler',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _characters.length,
              itemBuilder: (context, index) {
                final character = _characters[index];
                return _CharacterCard(
                  character: character,
                  onTap: () => _openChat(character),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(character: character),
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const _CharacterCard({
    required this.character,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.pink[100],
          child: Text(
            character.avatar,
            style: const TextStyle(fontSize: 30),
          ),
        ),
        title: Text(
          character.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          character.description,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.chat_bubble_outline, color: Colors.pinkAccent),
        onTap: onTap,
      ),
    );
  }
}
