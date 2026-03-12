import 'package:intl/intl.dart';

class DateUtils {
  // Tarih formatla
  static String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'tr_TR').format(date);
  }

  // Saat formatla
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // Tarih ve saat
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy • HH:mm', 'tr_TR').format(date);
  }

  // Sohbet zamanı (dün, saat, vs)
  static String formatChatTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'Şimdi';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} dk';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} s';
    } else if (diff.inDays == 1) {
      return 'Dün';
    } else if (diff.inDays < 7) {
      return DateFormat('EEEE', 'tr_TR').format(date);
    } else {
      return DateFormat('dd/MM', 'tr_TR').format(date);
    }
  }

  // Yaş hesapla
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}

class StringUtils {
  // İlk harf büyük
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  // Kısalt
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Email doğrula
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Telefon doğrula
  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }
}

class NumberUtils {
  // Para formatla
  static String formatCurrency(double amount, {String symbol = '₺'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  // Numara formatla
  static String formatPhone(String phone) {
    if (phone.length == 10) {
      return '(${phone.substring(0, 3)}) ${phone.substring(3, 6)} ${phone.substring(6)}';
    }
    return phone;
  }
}
