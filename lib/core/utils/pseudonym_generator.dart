import 'dart:math';

/// Pseudonym Generator
/// Generates random, friendly pseudonyms for anonymous users
class PseudonymGenerator {
  static final Random _random = Random();

  /// Indonesian-friendly adjectives
  static const List<String> _adjectives = [
    // Emotions/States
    'Bahagia', 'Tenang', 'Ceria', 'Santai', 'Damai',
    'Berani', 'Bijak', 'Kuat', 'Lembut', 'Sabar',
    // Descriptive
    'Kecil', 'Mungil', 'Lucu', 'Imut', 'Manis',
    'Penasaran', 'Mengantuk', 'Bingung', 'Lapar', 'Asyik',
    'Kreatif', 'Unik', 'Ajaib', 'Hebat', 'Keren',
    // Weather/Nature
    'Cerah', 'Sejuk', 'Hangat', 'Segar', 'Teduh',
    // Colors (as descriptors)
    'Biru', 'Hijau', 'Ungu', 'Emas', 'Perak',
  ];

  /// Indonesian-friendly nouns (animals, objects, nature)
  static const List<String> _nouns = [
    // Cute Animals
    'Panda', 'Kucing', 'Kelinci', 'Koala', 'Hamster',
    'Pinguin', 'Beruang', 'Rubah', 'Rusa', 'Tupai',
    'Burung', 'Kupu', 'Lebah', 'Lumba', 'Anjing',
    'Kapibara', 'Otter', 'Landak', 'Rakun', 'Sloth',
    // Nature
    'Awan', 'Bintang', 'Bulan', 'Matahari', 'Pelangi',
    'Bunga', 'Pohon', 'Daun', 'Hujan', 'Salju',
    'Gunung', 'Laut', 'Sungai', 'Langit', 'Angin',
    // Objects
    'Buku', 'Pensil', 'Kopi', 'Teh', 'Kue',
    'Roti', 'Balon', 'Lilin', 'Jam', 'Lampu',
  ];

  /// Generate a random pseudonym
  /// Format: "Adjective Noun" (e.g., "Panda Mengantuk", "Kucing Bahagia")
  static String generate() {
    final adjective = _adjectives[_random.nextInt(_adjectives.length)];
    final noun = _nouns[_random.nextInt(_nouns.length)];
    return '$noun $adjective';
  }

  /// Generate multiple unique pseudonyms
  static List<String> generateMultiple(int count) {
    final Set<String> pseudonyms = {};
    while (pseudonyms.length < count) {
      pseudonyms.add(generate());
    }
    return pseudonyms.toList();
  }

  /// Generate a pseudonym with a number suffix for uniqueness
  static String generateWithNumber() {
    final base = generate();
    final number = _random.nextInt(999) + 1;
    return '$base $number';
  }

  /// Check if a name looks like a real name (simple heuristic)
  static bool looksLikeRealName(String name) {
    // Common patterns for real names
    final nameParts = name.trim().split(' ');
    
    // If it contains @, it's probably an email
    if (name.contains('@')) return true;
    
    // If it's a single word with capital letter, might be a name
    if (nameParts.length == 1 && 
        nameParts[0].isNotEmpty && 
        nameParts[0][0] == nameParts[0][0].toUpperCase()) {
      return true;
    }
    
    // If it has 2-3 words all capitalized (typical name format)
    if (nameParts.length >= 2 && nameParts.length <= 4) {
      final allCapitalized = nameParts.every((part) => 
        part.isNotEmpty && part[0] == part[0].toUpperCase());
      if (allCapitalized) return true;
    }
    
    return false;
  }

  /// Suggest a pseudonym based on input
  /// If input looks like a real name, generate a new one
  static String suggestAlias(String? input) {
    if (input == null || input.isEmpty) {
      return generate();
    }
    
    if (looksLikeRealName(input)) {
      return generate();
    }
    
    return input;
  }
}
