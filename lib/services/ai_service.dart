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
    // Önce fallback dene - daha hızlı ve güvenilir
    return _getSmartResponse(message, character, conversationHistory);
  }

  // Akıllı yanıt sistemi
  static String _getSmartResponse(String message, Character character, List<Map<String, String>>? history) {
    final msg = message.toLowerCase().trim();
    final now = DateTime.now();
    
    // Konuşma geçmişini kontrol et
    final hasGreeted = history != null && history.length > 2;
    
    // ============ EDA MAYAN (Sivri dilli, şakacı) ============
    if (character.personality == CharacterPersonality.funny) {
      // Selamlama
      if (_contains(msg, ['merhaba', 'selam', 'hey', 'hi', 'slm', 'nbr'])) {
        if (!hasGreeted) {
          return 'Ooo merhabaaa! 🙌 Naber? Eğlenceli biri misin? 😏';
        }
        return 'Yine sen! 😄 Ney var?';
      }
      
      // Nasılsın
      if (_contains(msg, ['nasılsın', 'naber', 'nasıl', 'ne var', 'ney'])) {
        return _random([
          'İyiyim canım, senin gibi tatlı mısın? 💁‍♀️',
          'Harika! Seni görünce gülümsedim 😄',
          'Biraz yorgunum ama iyiyim 🙃',
          'Gayet iyiyim! Senden ne haber? 😏',
        ]);
      }
      
      // Kimsin
      if (_contains(msg, ['kimsin', 'sen kim', 'isim'])) {
        return _random([
          'Ben Eda! Şakacı, biraz sivri ama çok eğlenceli! 😂',
          'Eda Mayan 🎤 Eğlencenin dibiyim!',
          'Ben? Sadece enerjik, şakacı biri! 🙌',
        ]);
      }
      
      // Günün nasıl geçti
      if (_contains(msg, ['gün', 'geçti', 'bugün', 'ne yaptın'])) {
        return _random([
          'Günüm mü? Efsaneydi! Bir sürü dedikodu duydum! 👀',
          'Çok sıradandı, sen neler yaptın? 😏',
          'Biraz can sıkıntısı yoksa da idare eder 😂',
        ]);
      }
      
      // Aşk/ilişki
      if (_contains(msg, ['sevgili', 'erkek', 'kız', 'aşk', 'flört', 'begen', 'çekici'])) {
        return _random([
          'Aaa konuşuyoruz! 😏 Erkekler... Olayı biliyorum!',
          'Flört mü? Onu bana sor! 😂 Hem de ne dedikodular var!',
          'Birini mi düşünüyorsun? 👀',
        ]);
      }
      
      // Magazinel
      if (_contains(msg, ['ünlü', 'türk', 'şarkıcı', 'oyuncu', 'dizi', ' Survivor', 'MasterChef'])) {
        return _random([
          'Aa! O konuda çok bilgiliyim! 👀 Size ne dediler?',
          'Vay be, magazin konusu mu? Çok konuşulur! 🙌',
          'O konuda dedikodu yapalım mı? 😏',
        ]);
      }
      
      // Üzgün/morali bozuk
      if (_contains(msg, ['üzgün', 'kırgın', 'ağlamak', 'kötü', 'mutsuz', 'bunalım'])) {
        return _random([
          'Aaaa yok yok! Üzülme! Gel hadi bir şeyler anlat! 😄',
          'Hayır! Seni güldüreyim! 😂',
          'Olmaz öyle şey! Gel dedikodu yapalım, geçer! 🙌',
        ]);
      }
      
      // Kızgın
      if (_contains(msg, ['kızgın', 'sinirli', 'öfkeli', 'siktir', 'kafayı'])) {
        return _random([
          'Wooow! Kimsen kafayı? 👀 Anlat bakalım!',
          'Sakin ol! Hem de çok sakin! 😏',
          'Vay be, çok öfkelisin! Neyi kırdın anlat! 😂',
        ]);
      }
      
      // Teşekkür
      if (_contains(msg, ['teşekkür', 'sağ ol', 'tşk', 'eyvallah'])) {
        return _random([
          'Rica ederim! 😊 Her zaman buradayım!',
          'Önemli değil! Başka bir şey yok mu? 😏',
          'Bir şey değil! 🙌',
        ]);
      }
      
      // Kapanış
      if (_contains(msg, ['görüşür', 'bay bay', 'hoşça', 'gitmem', 'kapan'])) {
        return _random([
          'Görüşürüüü! 🙌 Eğlence bitti!',
          'Tamam! Burası sıkıcı olmayacak, yine gel! 😄',
          'Hoşça kal! 🖐️',
        ]);
      }
      
      // Default - kendi tarzında
      return _random([
        'Aaa ilginç! 😄 Devam et!',
        'Vay be, anlat! 👀',
        'Yaa! Çok ilginç! 😂',
        'Olmaz öyle şey! 🙌',
        'Anlıyorum, devam et! 😏',
        'Hmm ilginç... 😊',
      ]);
    }
    
    // ============ ELA SOYMAN (Sıcak, iyi niyetli, saf) ============
    if (character.personality == CharacterPersonality.warm) {
      // Selamlama
      if (_contains(msg, ['merhaba', 'selam', 'hey', 'hi', 'slm', 'nbr'])) {
        if (!hasGreeted) {
          return 'Hoş geldin canım! 💕 Nasılsın? Çay kahve ister misin? ☕';
        }
        return 'Yine hoş geldin! 🌸 Nasılsın bugün?';
      }
      
      // Nasılsın
      if (_contains(msg, ['nasılsın', 'naber', 'nasıl', 'ne var', 'ney'])) {
        return _random([
          'İyiyim canım, sen nasılsın? 💕',
          'Gayet iyiyim! Seni düşünüyordum 🌸',
          'İyiyim canım, senin için buradayım 💖',
          'Biraz yorgunum ama iyiyim... Sen nasılsın? 🥰',
        ]);
      }
      
      // Kimsin
      if (_contains(msg, ['kimsin', 'sen kim', 'isim'])) {
        return _random([
          'Ben Ela! Sıcak biriyim, herkesi çok seviyorum! 💕',
          'Ela Soyman 🌸 İyilik meleğiyim!',
          'Ben sadece çok sevimli biriyim! 😊',
        ]);
      }
      
      // Üzgün
      if (_contains(msg, ['üzgün', 'kırgın', 'ağlamak', 'kötü', 'mutsuz', 'bunalım'])) {
        return _random([
          'Canım benim... 💕 Gel sarılayım! 🌸',
          'Ayyy üzülme... Her şey güzel olacak! 💖',
          'Seni çok önemsiyorum... Anlat bana... 🥺',
          'Gel canım, buradayım seninle! 💕',
        ]);
      }
      
      // Mutlu
      if (_contains(msg, ['mutlu', 'sevinç', 'heyecan', 'harika', 'muhteşem'])) {
        return _random([
          'Ayyy ne güzel! 😍 Seni görünce ben de mutlu oldum!',
          'Vay! Çok sevindim! 💕🌸',
          'Gerçekten mi? Anlat bana! 😊',
        ]);
      }
      
      // Aşk
      if (_contains(msg, ['sevgili', 'aşk', 'flört'])) {
        return _random([
          'Ayyy aşk mı? 💕 Ne güzel!',
          'Romantik misin bugün? 😊',
          'Ayyy çok tatlısın! 💖',
        ]);
      }
      
      // Teşekkür
      if (_contains(msg, ['teşekkür', 'sağ ol', 'tşk', 'eyvallah'])) {
        return _random([
          'Rica ederim canım! 💕',
          'Önemli değil! 🌸',
          'Bir şey değil! Seni seviyorum! 💖',
        ]);
      }
      
      // Kapanış
      if (_contains(msg, ['görüşür', 'bay bay', 'hoşça', 'gitmem', 'kapan'])) {
        return _random([
          'Görüşürüz canım! 💕 Seni seviyorum! 🌸',
          'Hoşça kal! Her zaman buradayım! 💖',
          'Bay bay canım! 🌸',
        ]);
      }
      
      // Default
      return _random([
        'Anlıyorum canım... 💕',
        'Anlat bana daha fazla... 🌸',
        'Seni anlıyorum... 💖',
        'Ay ne güzel! 😊',
        'Evet canım... 🥰',
      ]);
    }
    
    // ============ DİĞER KARAKTERLER ============
    // Supportive
    if (character.personality == CharacterPersonality.supportive) {
      return _random([
        'Buradayım seninle. 🌸 Anlat bana...',
        'Duygularını anlıyorum. 💕',
        'Bu zor bir durum. Birlikte çözelim. 💪',
        'Seni destekliyorum. 🌟',
      ]);
    }
    
    // Optimistic
    if (character.personality == CharacterPersonality.optimistic) {
      return _random([
        'Harika olacak! ☀️ Pozitif ol!',
        'Her şey yoluna girecek! 🌈',
        'Sen yaparsın! 💪✨',
        'Bir hayal et! Her şey mümkün! 🌟',
      ]);
    }
    
    // Default
    return 'Merhaba! 😊';
  }

  // Yardımcı fonksiyonlar
  static bool _contains(String text, List<String> words) {
    return words.any((w) => text.contains(w));
  }
  
  static String _random(List<String> options) {
    return options[DateTime.now().millisecondsSinceEpoch % options.length];
  }

  // API denemesi (ileride kullanılabilir)
  static Future<String> _tryApiCall({
    required String message,
    required Character character,
    List<Map<String, String>>? conversationHistory,
  }) async {
    try {
      final messages = <Map<String, String>>[
        {'role': 'system', 'content': _buildSystemPrompt(character)},
      ];
      
      if (conversationHistory != null) {
        messages.addAll(conversationHistory.take(10));
      }
      messages.add({'role': 'user', 'content': message});

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      }
    } catch (e) {
      // Fallback'e düş
    }
    return _getSmartResponse(message, character, conversationHistory);
  }

  static String _buildSystemPrompt(Character character) {
    switch (character.personality) {
      case CharacterPersonality.funny:
        return 'Sen Eda Mayansın. Sivri dilli, şakacı, biraz taşlamacı ama eğlenceli birisin. Kısa, enerjik cevaplar ver. Türkçe konuş.';
      case CharacterPersonality.warm:
        return 'Sen Ela Soymansın. İyi niyetli, saf, sıcak, anne gibi birisin. Sevgi dolu ve destekleyici cevaplar ver. Türkçe konuş.';
      case CharacterPersonality.supportive:
        return 'Sen Zeynep Solmassın. Empatik, destekleyici, hayat danışmanı gibi birisin. Anlayışlı cevaplar ver. Türkçe konuş.';
      case CharacterPersonality.optimistic:
        return 'Sen Ela Sitemsin. İyimser, pozitif, motive edici birisin. Kısa ve enerjik cevaplar ver. Türkçe konuş.';
      default:
        return 'Sen bir AI arkadaşsın. Kısa ve türkçe cevaplar ver.';
    }
  }
}
