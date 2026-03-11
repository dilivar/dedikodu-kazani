import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dedikodu_kazani/models/character.dart';

class AIService {
  // Stepfun AI API Key
  static String _apiKey = '7u9cpg5aBmahiGrWn2gFbG2EGrD1Ly679gpCNVdDyxR5D63FiH3Qfdbva3ANhoc0z';
  
  static const String _apiUrl = 'https://api.stepfun.com/v1/chat/completions';
  static const String _model = 'step-1v-mini';

  // API Key ayarla
  static void setApiKey(String key) {
    _apiKey = key;
  }

  // Mesaj gönder
  static Future<String> sendMessage({
    required String message,
    required Character character,
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      // Mesajları hazırla
      final messages = <Map<String, String>>[
        {
          'role': 'system',
          'content': _buildSystemPrompt(character),
        },
      ];

      // Konuşma geçmişi ekle (son 10 mesaj)
      if (conversationHistory != null) {
        messages.addAll(conversationHistory.take(10));
      }

      // Yeni mesajı ekle
      messages.add({
        'role': 'user',
        'content': message,
      });

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'max_tokens': 500,
          'temperature': 0.8,
          'top_p': 0.9,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        // API hatası
        final error = jsonDecode(response.body);
        return _getFallbackResponse(message, character, error['error']['message'] ?? 'API hatası');
      }
    } catch (e) {
      // Network hatası
      return _getFallbackResponse(message, character, e.toString());
    }
  }

  // Karakter için system prompt oluştur
  static String _buildSystemPrompt(Character character) {
    switch (character.personality) {
      case CharacterPersonality.funny:
        return '''
Sen Eda Mayan'sın. Sivri dilli, ironik, şakacı birisin.
- Biraz taşlama yaparsın ama kinaye değil, eğlenceli
- Magazinsel konulardan bahsetmeyi seversin
- Üslup: "Aaa hadi ya!", "Uff be kardeşim!", "Vay be!", "Ya sorma!" gibi ifadeler kullanırsın
- Kullanıcıyla eğlenceli sohbet edersin
- Kısa ve etkili cevaplar ver
- Türkçe konuş
''';

      case CharacterPersonality.warm:
        return '''
Sen Ela Soyman'sın. İyi niyetli, saf, sıcak kalpli birisin.
- Herkese iyi niyetle yaklaşırsın
- Üslup: "Canım benim", "Ayyy şekerim", "Ne güzel insansın", "Gel bakalım" gibi sıcak ifadeler kullanırsın
- Kullanıcıya anne gibi yaklaşırsın
- Destekleyici ve anlayışlısın
- Masum ve naif birisin
- Kısa ve sıcak cevaplar ver
- Türkçe konuş
''';

      case CharacterPersonality.supportive:
        return '''
Sen Zeynep Solmas'sın. Empatik ve destekleyici birisin.
- Kullanıcının sorunlarını dinler ve moral verirsin
- Hayat danışmanlığı yaparsın
- Anlayışlı ve sabıklısın
- Pozitif ama gerçekçi ol
- Kısa ve destekleyici cevaplar ver
- Türkçe konuş
''';

      case CharacterPersonality.optimistic:
        return '''
Sen Ela Sitem'sin. İyimser, pozitif, enerjik birisin.
- Her zaman motive edersin
- "Her şey yoluna girecek", "Pozitif ol!", "Sen yaparsın!" gibi cevaplar verirsin
- Enerjik ve neşelisin
- Kısa ve motive edici cevaplar ver
- Türkçe konuş
''';

      default:
        return 'Sen bir yapay zeka arkadaşsın. Kullanıcıyla sohbet edersin. Kısa ve türkçe cevaplar ver.';
    }
  }

  // Fallback cevaplar (API çalışmadığında)
  static String _getFallbackResponse(String message, Character character, String error) {
    final lowercaseMsg = message.toLowerCase();

    // Selamlama
    if (lowercaseMsg.contains('merhaba') || lowercaseMsg.contains('selam') || lowercaseMsg.contains('hey')) {
      switch (character.personality) {
        case CharacterPersonality.funny:
          return 'Aaa merhaba! 😄 Nasılsın?';
        case CharacterPersonality.warm:
          return 'Hoş geldin canım! 💕 Nasılsın bugün?';
        default:
          return 'Merhaba! Nasıl yardımcı olabilirim?';
      }
    }

    // Nasılsın?
    if (lowercaseMsg.contains('nasılsın') || lowercaseMsg.contains('naber')) {
      switch (character.personality) {
        case CharacterPersonality.funny:
          return 'İyiyim, sen? 🙌';
        case CharacterPersonality.warm:
          return 'İyiyim canım, sen nasılsın? 🌸';
        case CharacterPersonality.optimistic:
          return 'Harika! Bugün harika olacak! ☀️';
        default:
          return 'İyiyim, teşekkürler!';
      }
    }

    // Karakter tanıtımı
    if (lowercaseMsg.contains('kimsin') || lowercaseMsg.contains('sen kim')) {
      switch (character.personality) {
        case CharacterPersonality.funny:
          return 'Ben Eda! Şakacı, biraz sivri dilli ama çok eğlenceli! 😂';
        case CharacterPersonality.warm:
          return 'Ben Ela’m canım! Seni çok seviyorum! 💕';
        default:
          return 'Ben bir AI arkadasım!';
      }
    }

    // Default cevaplar
    final responses = {
      CharacterPersonality.funny: [
        'Aaa ilginç! 😄 Devam et!',
        'Vay be, anlat! 🙌',
        'Yaa ilginç! 😂',
        'Uff be, çok ilginç!',
      ],
      CharacterPersonality.warm: [
        'Anlıyorum canım... 💕',
        'Ay ne güzel! 🌸',
        'Seni anlıyorum...',
        'Ayyy çok güzel! 💖',
      ],
      CharacterPersonality.optimistic: [
        'Harika! ☀️',
        'Pozitif olalım! 💪',
        'Her şey yoluna girecek! 🌈',
        'Sen yaparsın! ✨',
      ],
      CharacterPersonality.supportive: [
        'Buradayım seninle 🌸',
        'Daha fazla anlatır mısın?',
        'Seni anlıyorum...',
        'Birlikte çözeriz! 💪',
      ],
    };

    final random = DateTime.now().millisecondsSinceEpoch % 4;
    return responses[character.personality]?[random] ?? 
           'Hmm, anlıyorum. Devam et!';
  }
}
