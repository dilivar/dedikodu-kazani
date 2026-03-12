import 'package:flutter/material.dart';
import 'package:dedikodu_kazani/theme/colors.dart';
import 'package:dedikodu_kazani/models/character.dart';
import 'package:dedikodu_kazani/screens/chat_screen.dart';
import 'package:dedikodu_kazani/screens/premium_screen.dart';
import 'package:dedikodu_kazani/screens/group_chat_screen.dart';
import 'package:dedikodu_kazani/screens/settings_screen.dart';
import 'package:dedikodu_kazani/widgets/logo_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Arkadaş';
  
  // 7 karakter listesi
  final List<Character> _characters = [
    Character(
      id: '1',
      name: 'Eda Mayan',
      description: 'Direkt + Eleştirel 🎭',
      avatar: '👩‍🎤',
      personality: CharacterPersonality.funny,
      isPremium: false,
    ),
    Character(
      id: '2',
      name: 'Ela Soyman',
      description: 'İyimser + Kibar 💕',
      avatar: '💕',
      personality: CharacterPersonality.warm,
      isPremium: false,
    ),
    Character(
      id: '3',
      name: 'Zeynep Solmas',
      description: 'Gerçekçi + Mantıklı 📊',
      avatar: '👩‍💼',
      personality: CharacterPersonality.realistic,
      isPremium: true,
    ),
    Character(
      id: '4',
      name: 'Derin Yılmaz',
      description: 'Psikolog + Empatik 🌸',
      avatar: '🧠',
      personality: CharacterPersonality.psychologist,
      isPremium: true,
    ),
    Character(
      id: '5',
      name: 'Rüzgar Petek',
      description: 'Romantik + Flörtöz 💘',
      avatar: '💨',
      personality: CharacterPersonality.romantic,
      isPremium: true,
    ),
    Character(
      id: '6',
      name: 'Mert Arslan',
      description: 'Arkadaş + Falcı 🔮',
      avatar: '🏳️‍🌈',
      personality: CharacterPersonality.friend,
      isPremium: true,
    ),
    Character(
      id: '7',
      name: 'Kaan Bilge',
      description: 'Mentor + Bilge 📚',
      avatar: '👨‍💼',
      personality: CharacterPersonality.mentor,
      isPremium: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: const Color(0xFF8B5CF6),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      const LogoWidget(size: 60),
                      const SizedBox(height: 8),
                      Text(
                        'Hoşgeldin, $_userName!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '7 AI Arkadaşın burada',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
              ),
              IconButton(
                icon: const Icon(Icons.crown, color: Colors.amber),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen())),
              ),
            ],
          ),

          // Karakterler bölümü
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text('Karakterler', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            ),
          ),

          // Karakter grid (2'li)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final character = _characters[index];
                  return _CharacterGridCard(
                    character: character,
                    onTap: () => _openChat(character),
                  );
                },
                childCount: _characters.length,
              ),
            ),
          ),

          // Grup chat butonu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GroupChatScreen())),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.group, color: Colors.white, size: 32),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Grup Sohbeti', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('7 karakterle aynı anda!', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _openChat(Character character) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(character: character)));
  }
}

class _CharacterGridCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const _CharacterGridCard({required this.character, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(child: Text(character.avatar!, style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(height: 12),
            Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(character.description, style: TextStyle(color: Colors.grey[500], fontSize: 11), textAlign: TextAlign.center, maxLines: 2),
            const SizedBox(height: 8),
            if (character.isPremium)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: const Text('💎 Premium', style: TextStyle(fontSize: 10, color: Colors.amber)),
              ),
          ],
        ),
      ),
    );
  }
}
