/// Block Model
/// Represents a user block relationship

class BlockedUserModel {
  final String publicId;
  final String alias;
  final String blockedAt;

  const BlockedUserModel({
    required this.publicId,
    required this.alias,
    required this.blockedAt,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserModel(
      publicId: json['public_id']?.toString() ?? '',
      alias: json['alias']?.toString() ?? 'Unknown',
      blockedAt: json['blocked_at']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'alias': alias,
      'blocked_at': blockedAt,
    };
  }
}

/// Request model for blocking a user
class BlockUserRequest {
  final String userId;
  final String? reason;

  const BlockUserRequest({
    required this.userId,
    this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      if (reason != null && reason!.isNotEmpty) 'reason': reason,
    };
  }
}

/// Response model for block action
class BlockResponse {
  final String publicId;
  final String blockedAt;

  const BlockResponse({
    required this.publicId,
    required this.blockedAt,
  });

  factory BlockResponse.fromJson(Map<String, dynamic> json) {
    return BlockResponse(
      publicId: json['public_id']?.toString() ?? '',
      blockedAt: json['blocked_at']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }
}
