import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dedikodu_kazani/models/character.dart';

class AIService {
  // Google AI Studio (Gemini) API Key
  static String _apiKey = 'AIzaSyD92NDDcQQFU4IQDOUqyKt_IyhF-Fs3k68';
  
  static const String _apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  static void setApiKey(String key) {
    _apiKey = key;
  }

  static Future<String> sendMessage({
    required String message,
    required Character character,
    List<Map<String, String>>? conversationHistory,
  }) async {
    // Önce smart response dene - daha hızlı
    return _getSmartResponse(message, character, conversationHistory);
  }

  // Gemini API çağrısı
  static Future<String> _callGemini(String prompt) async {
    try {
      final url = '$_apiUrl?key=$_apiKey';
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [{'text': prompt}]
          }],
          'generationConfig': {
            'temperature': 0.9,
            'maxOutputTokens': 500,
          }
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      }
    } catch (e) {
      // Fallback
    }
    return '';
  }

  // Akıllı yanıt sistemi
  static String _getSmartResponse(String message, Character character, List<Map<String, String>>? history) {
    final msg = message.toLowerCase().trim();
    
    // EDA - Aşçı + Sosyal
    if (character.personality == CharacterPersonality.funny) {
      if (_contains(msg, ['merhaba', 'selam', 'hey'])) {
        return 'Selam! 🙌 ${character.name} burada! Ne pişiriyoruz bugün?';
      }
      if (_contains(msg, ['yemek', 'tarif', 'pişir', 'aşçı'])) {
        return _random([
          'Bugün ne pişirelim? 👩‍🍳',
          'Karnın mı aç? Bir tarif vereyim mi? 🍳',
          'Mutfakta neler var? 🍕',
        ]);
      }
      if (_contains(msg, ['nasılsın', 'naber'])) {
        return _random([
          'İyiyim, sen neler yapıyorsun? 👩‍🍳',
          'Harika! Bugün ne pişirelim? 😄',
        ]);
      }
      return _random([
        'Aaa ilginç! 😄 Devam et!',
        'Vay be! 👀 Anlat bakalım!',
        'Yaa! Çok ilginç! 😂',
      ]);
    }
    
    // ELA - Stilist
    if (character.personality == CharacterPersonality.warm) {
      if (_contains(msg, ['merhaba', 'selam', 'hey'])) {
        return 'Hoşgeldin! 💅 Stil için buradayım!';
      }
      if (_contains(msg, ['stil', 'giyim', 'moda', 'makyaj'])) {
        return _random([
          '💅 Hangi tarzı denemek istersin?',
          'Bugün şık olalım! Kombin öneriyim!',
          'Moda konusunda her şeyi biliyorum! 💄',
        ]);
      }
      return _random([
        'Aww ne güzel! 💕',
        'Senin için buradayım! 🌸',
        'Çok tatlısın! 💅',
      ]);
    }
    
    // Default
    return _random([
      'Anlıyorum! 😊',
      'Devam et, dinliyorum! 🎯',
      'İlginç! 👀',
    ]);
  }

  static bool _contains(String text, List<String> words) {
    return words.any((w) => text.contains(w));
  }
  
  static String _random(List<String> options) {
    return options[DateTime.now().millisecondsSinceEpoch % options.length];
  }
}
