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
  
  // 6 karakter listesi
  final List<Character> _characters = [
    Character(
      id: '1',
      name: 'Eda',
      description: 'Sanal Arkadaş 👩‍🍳',
      avatar: '👩‍🍳',
      personality: CharacterPersonality.funny,
      isPremium: false,
      introMessage: '👋 Merhaba! Ben Eda, senin sanal arkadaşın!',
      expertise: 'Her konuda sohbet',
    ),
    Character(
      id: '2',
      name: 'Ela',
      description: 'Sanal Arkadaş 💅',
      avatar: '💅',
      personality: CharacterPersonality.warm,
      isPremium: false,
      introMessage: '💅 Merhaba! Her konuda konuşabiliriz!',
      expertise: 'Her konuda sohbet',
    ),
    Character(
      id: '3',
      name: 'Mila',
      description: 'Sanal Arkadaş 🥗',
      avatar: 'Mi',
      personality: CharacterPersonality.realistic,
      isPremium: true,
      introMessage: 'Merhaba! Ben Mila!',
      expertise: 'Her konuda sohbet',
    ),
    Character(
      id: '4',
      name: 'Teo',
      description: 'Sanal Arkadaş 👶',
      avatar: 'T',
      personality: CharacterPersonality.psychologist,
      isPremium: true,
      introMessage: 'Merhaba! Ben Teo!',
      expertise: 'Her konuda sohbet',
    ),
    Character(
      id: '5',
      name: 'Batu',
      description: 'Sanal Arkadaş 💕',
      avatar: 'B',
      personality: CharacterPersonality.romantic,
      isPremium: true,
      introMessage: '💕 Merhaba! Konuşmak ister misin?',
      expertise: 'Her konuda sohbet',
    ),
    Character(
      id: '6',
      name: 'Mete',
      description: 'Sanal Arkadaş 📰',
      avatar: 'M',
      personality: CharacterPersonality.friend,
      isPremium: true,
      introMessage: '📰 Merhaba! Ne konuşmak istersin?',
      expertise: 'Her konuda sohbet',
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
            expandedHeight: 160,
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
                      const SizedBox(height: 20),
                      const LogoWidget(size: 50),
                      const SizedBox(height: 8),
                      Text(
                        'Dedikodu Kazanı 💬',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Sanal arkadaşların!',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Karakterler bölümü
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text('Arkadaşlar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
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
                    onTap: () => _onCharacterTap(context, character),
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
                            Text('Tüm arkadaşların burada!', style: TextStyle(color: Colors.white70, fontSize: 13)),
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

  void _onCharacterTap(BuildContext context, Character character) {
    if (character.isPremium) {
      // Premium karakter - fiyat göster
      _showPremiumPriceDialog(context, character);
    } else {
      // Ücretsiz - direkt sohbete git
      Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(character: character)));
    }
  }

  void _showPremiumPriceDialog(BuildContext context, Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(character.avatar!, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 12),
            Expanded(child: Text(character.name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.diamond, color: Colors.amber, size: 50),
            const SizedBox(height: 12),
            const Text('💎 Premium', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Fiyat: 9.99€/ay', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
            const SizedBox(height: 12),
            const Text('Ücretsiz denemek için Eda veya Ela\'yı seçin!', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
            ),
            child: const Text('Premium Al', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: character.isPremium
                        ? const Icon(Icons.lock, color: Colors.white, size: 28)
                        : Text(character.avatar!, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text(character.description, style: TextStyle(color: Colors.grey[500], fontSize: 11), textAlign: TextAlign.center, maxLines: 2),
              ],
            ),
            // Premium badge
            if (character.isPremium)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('💎', style: TextStyle(fontSize: 12)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
