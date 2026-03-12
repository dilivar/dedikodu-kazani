class AppConstants {
  // App Info
  static const String appName = 'Dedikodu Kazanı';
  static const String appVersion = '1.0.0';
  static const String slogan = 'gerçekten daha gerçek arkadaşlık ✨';
  
  // Colors
  static const int primaryColor = 0xFF8B5CF6;
  static const int secondaryColor = 0xFF6B4EFF;
  static const int backgroundColor = 0xFFF5F0FF;
  static const int textColor = 0xFF1A1A2E;
  static const int grayColor = 0xFF6B7280;
  
  // Premium
  static const double premiumPrice = 49.99;
  static const String premiumCurrency = '₺';
  
  // Characters
  static const int totalCharacters = 8;
  static const int freeCharacters = 2;
  static const int premiumCharacters = 6;
  
  // Group Chat
  static const int maxGroupParticipants = 6;
  
  // Timeouts
  static const int apiTimeout = 30;
  static const int connectionTimeout = 15;
  
  // Storage Keys
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyIsPremium = 'is_premium';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyTtsEnabled = 'tts_enabled';
  
  // Messages
  static const String welcomeMessage = 'Merhaba! Ben senin AI arkadasımım 💬';
  static const String errorMessage = 'Bir hata oluştu. Tekrar dene.';
  static const String networkError = 'İnternet bağlantın kontrol et.';
}
