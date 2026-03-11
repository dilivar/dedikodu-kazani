import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _keyUserName = 'user_name';
  static const String _keyPremium = 'is_premium';
  static const String _keyUnlockedCharacters = 'unlocked_characters';

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  static Future<void> setPremium(bool isPremium) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPremium, isPremium);
  }

  static Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPremium) ?? false;
  }

  static Future<void> unlockCharacter(String characterId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> unlocked = prefs.getStringList(_keyUnlockedCharacters) ?? [];
    if (!unlocked.contains(characterId)) {
      unlocked.add(characterId);
      await prefs.setStringList(_keyUnlockedCharacters, unlocked);
    }
  }

  static Future<List<String>> getUnlockedCharacters() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyUnlockedCharacters) ?? ['1', '2']; // Default: Eda ve Ela
  }

  static Future<bool> isCharacterUnlocked(String characterId) async {
    final unlocked = await getUnlockedCharacters();
    return unlocked.contains(characterId);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
