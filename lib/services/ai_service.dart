import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dedikodu_kazani/models/character.dart';

class AIService {
  static String _apiKey = '7u9cpg5aBmahiGrWn2gFbG2EGrD1Ly679gpCNVdDyxR5D63FiH3Qfdbva3ANhoc0z';
  
  static const String _apiUrl = 'https://api.stepfun.com/v1/chat/completions';
  static const String _model = 'step-1v-mini';

  static void setApiKey(String key) {
    _apiKey = key;
  }

  static Future<String> sendMessage({
    required String message,
    required Character character,
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      print('Sending message to Stepfun AI...');
      
      final messages = <Map<String, String>>[
        {
          'role': 'system',
          'content': _buildSystemPrompt(character),
        },
      ];

      if (conversationHistory != null) {
        messages.addAll(conversationHistory.take(10));
      }

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
        }),
      ).timeout(const Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'];
        }
        return 'Yanıt alınamadı';
      } else {
        final error = jsonDecode(response.body);
        return _getFallbackResponse(message, character, error.toString());
      }
    } catch (e) {
      print('Error: $e');
      return _getFallbackResponse(message, character, e.toString());
    }
  }

  static String _buildSystemPrompt(Character character) {
    switch (character.personality) {
      case CharacterPersonality.funny:
        return 'Sen Eda Mayansın. Sivri dilli, şakacı birisin. Kısa ve eğlenceli cevaplar ver. Türkçe konuş.';
      case CharacterPersonality.warm:
        return 'Sen Ela Soymansın. Sıcak, sevecen birisin. Kısa ve sıcak cevaplar ver. Türkçe konuş.';
      case CharacterPersonality.supportive:
        return 'Sen Zeynep Solmassın. Empatik ve destekleyici birisin. Kısa ve destekleyici cevaplar ver. Türkçe konuş.';
      case CharacterPersonality.optimistic:
        return 'Sen Ela Sitemsin. İyimser ve pozitif birisin. Kısa ve motive edici cevaplar ver. Türkçe konuş.';
      default:
        return 'Sen bir yapay zeka arkadaşsın. Kısa ve türkçe cevaplar ver.';
    }
  }

  static String _getFallbackResponse(String message, Character character, String error) {
    final lowercaseMsg = message.toLowerCase();

    // Selamlama
    if (lowercaseMsg.contains('merhaba') || lowercaseMsg.contains('selam') || lowercaseMsg.contains('hey')) {
      switch (character.personality) {
        case CharacterPersonality.funny:
          return 'Aaa merhaba! 😄 Nasılsın?';
        case CharacterPersonality.warm:
          return 'Hoş geldin canım! 💕 Nasılsın?';
        default:
          return 'Merhaba! 👋';
      }
    }

    // Nasılsın
    if (lowercaseMsg.contains('nasılsın') || lowercaseMsg.contains('naber')) {
      switch (character.personality) {
        case CharacterPersonality.funny:
          return 'İyiyim, sen? 🙌';
        case CharacterPersonality.warm:
          return 'İyiyim canım, sen nasılsın? 💕';
        case CharacterPersonality.optimistic:
          return 'Harika! ☀️';
        default:
          return 'İyiyim!';
      }
    }

    // Bilmiyorum yanıtı
    final responses = {
      CharacterPersonality.funny: [
        'Aaa ilginç! 😄 Devam et!',
        'Vay be! 🙌',
        'Yaa! 😂',
      ],
      CharacterPersonality.warm: [
        'Anlıyorum canım... 💕',
        'Ay ne güzel! 🌸',
        'Seni anlıyorum...',
      ],
      CharacterPersonality.optimistic: [
        'Harika! ☀️',
        'Pozitif olalım! 💪',
      ],
    };

    final random = DateTime.now().millisecondsSinceEpoch % 3;
    return responses[character.personality]?[random] ?? 'Anlıyorum!';
  }
}
