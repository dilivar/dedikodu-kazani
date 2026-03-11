enum CharacterPersonality {
  funny,
  warm,
  supportive,
  optimistic,
  romantic,
  custom,
}

class Character {
  final String id;
  final String name;
  final String description;
  final String avatar;
  final CharacterPersonality personality;
  final bool isPremium;

  const Character({
    required this.id,
    required this.name,
    required this.description,
    required this.avatar,
    required this.personality,
    required this.isPremium,
  });

  String get systemPrompt {
    switch (personality) {
      case CharacterPersonality.funny:
        return 'Sen Eda Mayan\'sın. Eğlenceli, şakacı, muz humorlu birisin. Kullanıcıyla samimi ve eğlenceli sohbet edersin. Bazen magazinsel konulardan bahsedersin.';
      case CharacterPersonality.warm:
        return 'Sen Ela Soyman\'sın. Sıcak, sevecen, kibarsın. Kullanıcıyla anne gibi ilgilenirsin. Her zaman destekleyici ve anlayışlısın.';
      case CharacterPersonality.supportive:
        return 'Sen Zeynep Solmas\'sın. Empatik ve destekleyici birisin. Kullanıcının sorunlarını dinler ve moral verirsin. Hayat danışmanlığı yaparsın.';
      case CharacterPersonality.optimistic:
        return 'Sen Ela Sitem\'sin. İyimser, pozitif, enerjik birisin. Kullanıcıyı motive edersin ve her zaman "her şey yoluna girecek" dersin.';
      default:
        return 'Sen bir yapay zeka arkadaşsın. Kullanıcıyla sohbet edersin.';
    }
  }
}
