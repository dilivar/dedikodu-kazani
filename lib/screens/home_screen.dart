import 'package:flutter/material.dart';
import 'package:dedikodu_kazani/theme/colors.dart';
import 'package:dedikodu_kazani/models/character.dart';
import 'package:dedikodu_kazani/screens/chat_screen.dart';
import 'package:dedikodu_kazani/screens/premium_screen.dart';
import 'package:dedikodu_kazani/screens/group_chat_screen.dart';
import 'package:dedikodu_kazani/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Arkadaş';
  
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
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const LogoWidget(size: 36),
            const SizedBox(width: 8),
            const Text('Dedikodu Kazanı'),
          ],
        ),
        centerTitle: true,
        backgroundColor: ThemeColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.crown),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PremiumScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ThemeColors.primary, ThemeColors.primaryDark],
              ),
            ),
            child: Column(
              children: [
                const Text('🌯', style: TextStyle(fontSize: 50)),
                const SizedBox(height: 8),
                Text(
                  'Hoşgeldin, $_userName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text('AI Arkadaşların burada!', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text('Karakterler', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ThemeColors.textPrimary)),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GroupChatScreen()),
          );
        },
        backgroundColor: ThemeColors.primaryDark,
        icon: const Icon(Icons.group),
        label: const Text('Grup Chat'),
      ),
    );
  }

  void _openChat(Character character) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(character: character)),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const _CharacterCard({required this.character, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: ThemeColors.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: ThemeColors.primary.withOpacity(0.2),
          child: Text(character.avatar, style: const TextStyle(fontSize: 30)),
        ),
        title: Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: ThemeColors.textPrimary)),
        subtitle: Text(character.description, style: TextStyle(color: ThemeColors.textSecondary)),
        trailing: const Icon(Icons.chat_bubble_outline, color: ThemeColors.primary),
        onTap: onTap,
      ),
    );
  }
}
