/// Daily Mood Model
/// Represents a user's daily mood entry
class DailyMoodModel {
  final String publicId;
  final int moodTagId;
  final String note;
  final String date;
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyMoodModel({
    required this.publicId,
    required this.moodTagId,
    required this.note,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DailyMoodModel.fromJson(Map<String, dynamic> json) {
    return DailyMoodModel(
      publicId: json['public_id'] ?? '',
      moodTagId: json['mood_tag_internal_id'] ?? 0,
      note: json['note'] ?? '',
      date: json['date'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'public_id': publicId,
    'mood_tag_internal_id': moodTagId,
    'note': note,
    'date': date,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  String get moodName {
    switch (moodTagId) {
      case 1:
        return 'Senang';
      case 2:
        return 'Sedih';
      case 3:
        return 'Marah';
      case 4:
        return 'Netral';
      default:
        return 'Unknown';
    }
  }

  /// Get mood SVG asset path based on mood tag ID
  String get moodSvgPath {
    switch (moodTagId) {
      case 1:
        return 'assets/svg/happy.svg';
      case 2:
        return 'assets/svg/sad.svg';
      case 3:
        return 'assets/svg/angry.svg';
      case 4:
        return 'assets/svg/neutral.svg';
      default:
        return 'assets/svg/neutral.svg';
    }
  }
}

/// AI Reflection Model
class AIReflectionModel {
  final int moodTagId;
  final String reflection;
  final DateTime createdAt;

  AIReflectionModel({
    required this.moodTagId,
    required this.reflection,
    required this.createdAt,
  });

  factory AIReflectionModel.fromJson(Map<String, dynamic> json) {
    return AIReflectionModel(
      moodTagId: json['mood_tag_internal_id'] ?? 0,
      reflection: json['reflection'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }
}

/// Mood Statistics Model
class MoodStatModel {
  final String date;
  final int moodTagId;
  final String moodTagLabel;
  final int count;

  MoodStatModel({
    required this.date,
    required this.moodTagId,
    required this.moodTagLabel,
    required this.count,
  });

  factory MoodStatModel.fromJson(Map<String, dynamic> json) {
    return MoodStatModel(
      date: json['date'] ?? '',
      moodTagId: json['mood_tag_internal_id'] ?? 0,
      moodTagLabel: json['mood_tag_label'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

/// Chat Activity Model (for calendar tracking)
class ChatActivityModel {
  final String sessionId;
  final String title;
  final DateTime date;

  ChatActivityModel({
    required this.sessionId,
    required this.title,
    required this.date,
  });

  factory ChatActivityModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['created_at'] ?? json['updated_at'] ?? '');
    } catch (e) {
      parsedDate = DateTime.now();
    }
    return ChatActivityModel(
      sessionId: json['public_id'] ?? '',
      title: json['title'] ?? 'Untitled',
      date: parsedDate,
    );
  }
}
