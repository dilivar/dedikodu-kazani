import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {'name': 'Eda', 'avatar': '👩‍🍳', 'last': 'Bugün ne pişirelim?', 'time': '14:30', 'unread': 2},
      {'name': 'Ela', 'avatar': '💅', 'last': 'Bu elbise sana çok yakışacak!', 'time': '13:45', 'unread': 0},
      {'name': 'Zeynep', 'avatar': '🥗', 'last': 'Kahvaltıda ne yedin?', 'time': '12:20', 'unread': 1},
      {'name': 'Derin', 'avatar': '👶', 'last': 'Çocuğun nasıl hissediyor?', 'time': '11:00', 'unread': 0},
      {'name': 'Rüzgar', 'avatar': '💕', 'last': 'Seni düşünüyordum...', 'time': 'Dün', 'unread': 0},
      {'name': 'Mert', 'avatar': '📰', 'last': 'Bu gündem çok sıcak!', 'time': 'Dün', 'unread': 0},
      {'name': 'Fatih', 'avatar': '💰', 'last': 'Yatırım yaparken dikkat et', 'time': 'Dün', 'unread': 0},
      {'name': 'Seda', 'avatar': '🎮', 'last': 'Bu oyun çok eğlenceli!', 'time': 'Dün', 'unread': 0},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Sohbetler',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1A1A2E)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      chat['avatar']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            chat['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            chat['time']!,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat['last']!,
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat['unread'] != '0')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                chat['unread']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
