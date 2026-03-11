import 'dart:convert';
import 'package:http/http.dart' as http;

/// Haber ve trend bilgisi servisi
class NewsService {
  // NewsAPI key - kendi key'inizi ekleyin
  static const String _newsApiKey = 'YOUR_NEWS_API_KEY';
  static const String _newsApiUrl = 'https://newsapi.org/v2';
  
  // Ünlü kişiler ve ilgi alanları
  static const Map<String, List<String>> _celebrityKeywords = {
    'Eda Mayan': ['magazin', 'gossip', 'televizyon', 'dizi', 'ünlü'],
    'Ela Soyman': ['müzik', 'şarkıcı', 'konser', 'albüm'],
    'Zeynep Solmas': ['film', 'sinema', 'oyuncu', 'dizi'],
    'Ela Sitem': ['spor', 'futbol', 'maç', 'sporcu'],
  };

  /// Ünlü kişiler hakkında güncel haberleri çek
  static Future<List<NewsArticle>> getCelebrityNews(String characterName) async {
    final keywords = _celebrityKeywords[characterName] ?? ['magazin', 'güncel'];
    
    try {
      final query = keywords.join(' OR ');
      final url = '$_newsApiUrl/everything?q=$query&language=tr&sortBy=publishedAt&apiKey=$_newsApiKey';
      
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = data['articles'] as List;
        
        return articles.take(5).map((article) => NewsArticle(
          title: article['title'] ?? '',
          description: article['description'] ?? '',
          source: article['source']?['name'] ?? '',
          url: article['url'] ?? '',
          publishedAt: article['publishedAt'] ?? '',
        )).toList();
      }
    } catch (e) {
      // Hata olursa boş liste dön
    }
    
    return [];
  }

  /// Türkiye'den güncel magazin haberleri
  static Future<List<NewsArticle>> getMagazineNews() async {
    try {
      final url = '$_newsApiUrl/top-headlines?country=tr&category=entertainment&apiKey=$_newsApiKey';
      
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = data['articles'] as List;
        
        return articles.take(10).map((article) => NewsArticle(
          title: article['title'] ?? '',
          description: article['description'] ?? '',
          source: article['source']?['name'] ?? '',
          url: article['url'] ?? '',
          publishedAt: article['publishedAt'] ?? '',
        )).toList();
      }
    } catch (e) {
      // Hata
    }
    
    return [];
  }

  /// Karakter için konuşma konusu önerileri
  static Future<List<String>> getConversationTopics(String characterName) async {
    final news = await getCelebrityNews(characterName);
    
    if (news.isEmpty) {
      // Fallback konular
      return _getDefaultTopics(characterName);
    }
    
    return news.map((n) => n.title).toList();
  }

  /// Karakter için güncel bilgi
  static Future<String> getCharacterContext(String characterName) async {
    final news = await getCelebrityNews(characterName);
    
    if (news.isEmpty) {
      return '';
    }
    
    final buffer = StringBuffer();
    buffer.writeln('Güncel konular:');
    
    for (var i = 0; i < news.length && i < 3; i++) {
      buffer.writeln('- ${news[i].title}');
    }
    
    return buffer.toString();
  }

  static List<String> _getDefaultTopics(String characterName) {
    switch (characterName) {
      case 'Eda Mayan':
        return [
          'Magazin dedikoduları',
          'Ünlülerin son paylaşımları',
          'TV programları',
          'Güncel olaylar',
        ];
      case 'Ela Soyman':
        return [
          'Yeni şarkılar',
          'Konser haberleri',
          'Müzik dünyası',
          'Sanatçı röportajları',
        ];
      default:
        return [
          'Güncel haberler',
          'Magazin',
          'Ünlüler',
        ];
    }
  }
}

/// Haber makalesi modeli
class NewsArticle {
  final String title;
  final String description;
  final String source;
  final String url;
  final String publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.source,
    required this.url,
    required this.publishedAt,
  });
}
