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
      description: 'Eğlenceli, şakacı, enerjik',
      avatar: '👩‍🎤',
      personality: 'funny',
      isPremium: false,
    ),
    Character(
      id: '2',
      name: 'Ela Soyman',
      description: 'Sıcak, sevecen, magazinsel',
      avatar: '💕',
      personality: 'warm',
      isPremium: false,
    ),
    Character(
      id: '3',
      name: 'Zeynep Solmas',
      description: 'Destekleyici, empatik',
      avatar: '🌸',
      personality: 'supportive',
      isPremium: true,
    ),
    Character(
      id: '4',
      name: 'Ela Sitem',
      description: 'İyimser, pozitif',
      avatar: '☀️',
      personality: 'optimistic',
      isPremium: true,
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
          // Karakterler Listesi
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
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
        title: Row(
          children: [
            Text(
              character.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (character.isPremium) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '💎 PREMIUM',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          character.description,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.chat_bubble_outline),
        onTap: onTap,
      ),
    );
  }
}
