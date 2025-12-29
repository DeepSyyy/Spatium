/// Chat Message Model
/// Represents a single message in a chat session
class ChatMessageModel {
  final String sessionId;
  final String sender; // "user" or "ai"
  final String content;
  final String createdAt;

  const ChatMessageModel({
    required this.sessionId,
    required this.sender,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    try {
      return ChatMessageModel(
        sessionId: json['session_public_id']?.toString() ?? '',
        sender: json['sender']?.toString() ?? 'user',
        content: json['content']?.toString() ?? '',
        createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      );
    } catch (e) {
      print('❌ Error parsing ChatMessageModel: $e');
      print('❌ JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'session_public_id': sessionId,
      'sender': sender,
      'content': content,
      'created_at': createdAt,
    };
  }

  bool get isUser => sender == 'user';
  bool get isAI => sender == 'ai';
}
