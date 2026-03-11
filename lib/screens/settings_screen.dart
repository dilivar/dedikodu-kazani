import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiKeyController.text = 'YOUR_OPENAI_API_KEY';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ Ayarlar'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // API Key
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔑 OpenAI API Key',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'AI sohbet için OpenAI API key gerekli.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _apiKeyController,
                    decoration: InputDecoration(
                      hintText: 'sk-...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('API Key kaydedildi!')),
                      );
                    },
                    child: const Text('Kaydet'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Hakkında
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ℹ️ Hakkında',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text('Dedikodu Kazanı 🌯'),
                  const Text('Versiyon: 1.0.0'),
                  const Text('Made with ❤️ by Nisa'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // API Key alma
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📝 API Key Nasıl Alınır?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text('1. https://platform.openai.com adresine git'),
                  const Text('2. Hesap oluştur/giriş yap'),
                  const Text('3. API Keys bölümünden yeni key oluştur'),
                  const Text('4. Key\'i kopyala ve yukarıya yapıştır'),
                  const SizedBox(height: 8),
                  const Text(
                    'Not: OpenAI hesabınıza para yüklemeniz gerekebilir.',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
