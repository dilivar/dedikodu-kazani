import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dedikodu_kazani/models/character.dart';

class AIService {
  // OpenAI API - BURAYA KENDİ KEY'İNİZİ EKLEYİN
  static const String _apiKey = 'YOUR_OPENAI_API_KEY';
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  static Future<String> sendMessage({
    required String message,
    required Character character,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': character.systemPrompt,
            },
            {
              'role': 'user',
              'content': message,
            },
          ],
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        // API başarısız olursa fallback mesaj
        return _getFallbackResponse(message, character);
      }
    } catch (e) {
      // Hata durumunda fallback
      return _getFallbackResponse(message, character);
    }
  }

  static String _getFallbackResponse(String message, Character character) {
    // Basit fallback - gerçek API bağlanana kadar çalışır
    final responses = {
      CharacterPersonality.funny: [
        'Aaa ne diyorsun! 😄',
        'Vay be, ilginç! Devam et!',
        'Hahaa, çok güldüm! 🙌',
        'Olmaz öyle şey! 😂',
      ],
      CharacterPersonality.warm: [
        'Anlıyorum canım, buradayım 💕',
        'Seni çok iyi anlıyorum...',
        'Aww, üzülme. Geçer! 🌸',
        'Ne diyorsun ama, gel anlat! 💕',
      ],
      CharacterPersonality.supportive: [
        'Bu konuda sana yardımcı olmak istiyorum. 🌸',
        'Daha fazla anlatır mısın?',
        'Yanındayım. Ne hissediyorsun?',
        'Bu zor bir durum. Birlikte çözebiliriz. 💪',
      ],
      CharacterPersonality.optimistic: [
        'Biliyor musun, bu bile geçecek! ☀️',
        'Pozitif olalım! Her şey yoluna girecek!',
        'Hayat güzel, değil mi? 🌈',
        'Bir de şundan bak: ... 💫',
      ],
    };

    final random = DateTime.now().millisecondsSinceEpoch % 4;
    return responses[character.personality]?[random] ?? 
           'Hmm, anlıyorum. Devam et!';
  }
}
