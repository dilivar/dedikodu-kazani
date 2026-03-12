import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final FlutterTts _tts = FlutterTts();
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;
    
    await _tts.setLanguage('tr-TR');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    
    _isInitialized = true;
  }

  static Future<void> speak(String text) async {
    await init();
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }

  // Karaktere göre ses ayarı
  static Future<void> speakWithCharacter(String text, String personality) async {
    await init();
    
    switch (personality) {
      case 'funny': // Eda
        await _tts.setSpeechRate(0.6);
        await _tts.setPitch(1.1);
        break;
      case 'warm': // Ela
        await _tts.setSpeechRate(0.45);
        await _tts.setPitch(0.95);
        break;
      case 'romantic': // Rüzgar
        await _tts.setSpeechRate(0.4);
        await _tts.setPitch(0.9);
        break;
      default:
        await _tts.setSpeechRate(0.5);
        await _tts.setPitch(1.0);
    }
    
    await _tts.speak(text);
  }
}
