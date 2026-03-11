import 'package:flutter_tts/flutter_tts.dart';
import 'package:dedikodu_kazani/models/character.dart';

class TTSService {
  static final FlutterTts _tts = FlutterTts();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    await _tts.setLanguage('tr-TR');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    
    _isInitialized = true;
  }

  static Future<void> speak(String text, Character character) async {
    await initialize();
    
    // Karaktere göre ses ayarı
    switch (character.personality) {
      case CharacterPersonality.funny:
        await _tts.setSpeechRate(0.6);
        await _tts.setPitch(1.1);
        break;
      case CharacterPersonality.warm:
        await _tts.setSpeechRate(0.45);
        await _tts.setPitch(0.95);
        break;
      case CharacterPersonality.optimistic:
        await _tts.setSpeechRate(0.55);
        await _tts.setPitch(1.05);
        break;
      default:
        await _tts.setSpeechRate(0.5);
        await _tts.setPitch(1.0);
    }
    
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }

  static Future<void> setVoice(bool isMale) async {
    if (isMale) {
      await _tts.setVoice({'name': 'tr-TR', 'locale': 'tr-TR'});
    } else {
      await _tts.setVoice({'name': 'tr-TR', 'locale': 'tr-TR'});
    }
  }
}
