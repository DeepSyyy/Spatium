/// Post Model
/// Represents a curhat post in the timeline
class PostModel {
  final String publicId;
  final String content;
  final String? aiResponse;
  final int moodTagId;
  final String createdAt;
  final List<CommentModel> comments;
  final int reactionCount;
  final int commentCount;
  final bool isLiked;

  const PostModel({
    required this.publicId,
    required this.content,
    this.aiResponse,
    required this.moodTagId,
    required this.createdAt,
    this.comments = const [],
    this.reactionCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      publicId: json['public_id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      aiResponse: json['ai_response']?.toString(),
      moodTagId: json['mood_tag_id'] is int ? json['mood_tag_id'] : int.tryParse(json['mood_tag_id']?.toString() ?? '1') ?? 1,
      createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((c) => CommentModel.fromJson(c as Map<String, dynamic>))
          .toList() ?? [],
      reactionCount: json['reaction_count'] is int ? json['reaction_count'] : int.tryParse(json['reaction_count']?.toString() ?? '0') ?? 0,
      commentCount: json['comment_count'] is int ? json['comment_count'] : int.tryParse(json['comment_count']?.toString() ?? '0') ?? 0,
      isLiked: json['is_liked'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'content': content,
      'ai_response': aiResponse,
      'mood_tag_id': moodTagId,
      'created_at': createdAt,
      'comments': comments.map((c) => c.toJson()).toList(),
      'reaction_count': reactionCount,
      'comment_count': commentCount,
      'is_liked': isLiked,
    };
  }

  PostModel copyWith({
    String? publicId,
    String? content,
    String? aiResponse,
    int? moodTagId,
    String? createdAt,
    List<CommentModel>? comments,
    int? reactionCount,
    int? commentCount,
    bool? isLiked,
  }) {
    return PostModel(
      publicId: publicId ?? this.publicId,
      content: content ?? this.content,
      aiResponse: aiResponse ?? this.aiResponse,
      moodTagId: moodTagId ?? this.moodTagId,
      createdAt: createdAt ?? this.createdAt,
      comments: comments ?? this.comments,
      reactionCount: reactionCount ?? this.reactionCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  /// Get mood name based on mood tag ID
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
        return 'Netral';
    }
  }
}

/// Comment Model
/// Represents a comment on a post
class CommentModel {
  final String publicId;
  final String postId;
  final String content;
  final String createdAt;

  const CommentModel({
    required this.publicId,
    required this.postId,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      publicId: json['public_id']?.toString() ?? '',
      postId: json['post_id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'post_id': postId,
      'content': content,
      'created_at': createdAt,
    };
  }
}

/// Reaction Summary Model
class ReactionSummaryModel {
  final String emoji;
  final int count;

  const ReactionSummaryModel({
    required this.emoji,
    required this.count,
  });

  factory ReactionSummaryModel.fromJson(Map<String, dynamic> json) {
    return ReactionSummaryModel(
      emoji: json['emoji']?.toString() ?? '❤️',
      count: json['count'] is int ? json['count'] : int.tryParse(json['count']?.toString() ?? '0') ?? 0,
    );
  }
}
