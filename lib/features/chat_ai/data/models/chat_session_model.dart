/// Chat Session Model
/// Represents a chat conversation session with the AI
class ChatSessionModel {
  final String publicId;
  final String title;
  final String moodTag;
  final String createdAt;
  final String updatedAt;

  const ChatSessionModel({
    required this.publicId,
    required this.title,
    required this.moodTag,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    try {
      return ChatSessionModel(
        publicId: json['public_id']?.toString() ?? '',
        title: json['title']?.toString() ?? 'Untitled',
        moodTag: json['mood_tag']?.toString() ?? '',
        createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
        updatedAt: json['updated_at']?.toString() ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      print('❌ Error parsing ChatSessionModel: $e');
      print('❌ JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'title': title,
      'mood_tag': moodTag,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
