import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('⚙️ Ayarlar', style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profil
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Text('👤', style: TextStyle(fontSize: 30))),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kullanıcı', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('kullanici@email.com', style: TextStyle(color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Ayarlar
          _buildSettingItem(Icons.person, 'Profili Düzenle', ''),
          _buildSettingItem(Icons.notifications, 'Bildirimler', ''),
          _buildSettingItem(Icons.lock, 'Gizlilik', ''),
          _buildSettingItem(Icons.language, 'Dil', 'Türkçe'),
          _buildSettingItem(Icons.mic, 'Sesli Yanıt', 'Açık'),
          _buildSettingItem(Icons.auto_awesome, 'AI Model', 'Google Gemini'),

          const SizedBox(height: 20),

          // Premium banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Premium\'a Geç', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                      Text('Tüm özellikleri aç', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: const Text('💎', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Diğer
          _buildSettingItem(Icons.help, 'Yardım', ''),
          _buildSettingItem(Icons.info, 'Hakkında', ''),
          _buildSettingItem(Icons.logout, 'Çıkış', ''),

          const SizedBox(height: 40),
          const Center(child: Text('v1.0.0 • Dedikodu Kazanı', style: TextStyle(color: Color(0xFF6B7280)))),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8B5CF6)),
        title: Text(title),
        trailing: value.isNotEmpty 
            ? Text(value, style: const TextStyle(color: Color(0xFF6B7280)))
            : const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF6B7280)),
        onTap: () {},
      ),
    );
  }
}
