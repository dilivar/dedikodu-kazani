import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('👤 Profil', style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profil kartı
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF6B4EFF)]),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(child: Text('👤', style: TextStyle(fontSize: 50))),
                ),
                const SizedBox(height: 16),
                const Text('Kullanıcı', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('kullanici@email.com', style: TextStyle(color: Color(0xFF6B7280))),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('💎', style: TextStyle(fontSize: 20)),
                      SizedBox(width: 8),
                      Text('Premium Üye', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // İstatistikler
          Row(
            children: [
              Expanded(child: _buildStat('Sohbet', '24')),
              const SizedBox(width: 12),
              Expanded(child: _buildStat('Karakter', '2/8')),
              const SizedBox(width: 12),
              Expanded(child: _buildStat('Premium', 'Aktif')),
            ],
          ),
          const SizedBox(height: 20),

          // Menü
          _buildMenuItem(Icons.chat, 'Sohbet Geçmişi'),
          _buildMenuItem(Icons.favorite, 'Favori Karakterler'),
          _buildMenuItem(Icons.settings, 'Ayarlar'),
          _buildMenuItem(Icons.help, 'Yardım'),
          _buildMenuItem(Icons.info, 'Hakkında'),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF8B5CF6)),
        title: Text(text),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF6B7280)),
        onTap: () {},
      ),
    );
  }
}
