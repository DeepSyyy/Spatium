/// Report Model
/// Represents a user report against content or another user

enum ReportType {
  post,
  comment,
  user;

  String get value {
    switch (this) {
      case ReportType.post:
        return 'post';
      case ReportType.comment:
        return 'comment';
      case ReportType.user:
        return 'user';
    }
  }

  static ReportType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'post':
        return ReportType.post;
      case 'comment':
        return ReportType.comment;
      case 'user':
        return ReportType.user;
      default:
        return ReportType.post;
    }
  }
}

enum ReportReason {
  harassment,
  hateSpeech,
  spam,
  selfHarm,
  violence,
  inappropriate,
  other;

  String get value {
    switch (this) {
      case ReportReason.harassment:
        return 'harassment';
      case ReportReason.hateSpeech:
        return 'hate_speech';
      case ReportReason.spam:
        return 'spam';
      case ReportReason.selfHarm:
        return 'self_harm';
      case ReportReason.violence:
        return 'violence';
      case ReportReason.inappropriate:
        return 'inappropriate';
      case ReportReason.other:
        return 'other';
    }
  }

  String get label {
    switch (this) {
      case ReportReason.harassment:
        return 'Pelecehan';
      case ReportReason.hateSpeech:
        return 'Ujaran Kebencian';
      case ReportReason.spam:
        return 'Spam';
      case ReportReason.selfHarm:
        return 'Menyakiti Diri Sendiri';
      case ReportReason.violence:
        return 'Kekerasan';
      case ReportReason.inappropriate:
        return 'Konten Tidak Pantas';
      case ReportReason.other:
        return 'Lainnya';
    }
  }

  String get description {
    switch (this) {
      case ReportReason.harassment:
        return 'Perilaku yang menargetkan individu secara tidak pantas';
      case ReportReason.hateSpeech:
        return 'Konten yang mempromosikan kebencian terhadap kelompok tertentu';
      case ReportReason.spam:
        return 'Konten yang tidak relevan atau promosi berulang';
      case ReportReason.selfHarm:
        return 'Konten yang mempromosikan atau mendorong tindakan menyakiti diri sendiri';
      case ReportReason.violence:
        return 'Konten yang mengancam atau mempromosikan kekerasan';
      case ReportReason.inappropriate:
        return 'Konten yang tidak sesuai untuk komunitas ini';
      case ReportReason.other:
        return 'Alasan lain yang tidak tercantum di atas';
    }
  }

  static ReportReason fromString(String value) {
    switch (value.toLowerCase()) {
      case 'harassment':
        return ReportReason.harassment;
      case 'hate_speech':
        return ReportReason.hateSpeech;
      case 'spam':
        return ReportReason.spam;
      case 'self_harm':
        return ReportReason.selfHarm;
      case 'violence':
        return ReportReason.violence;
      case 'inappropriate':
        return ReportReason.inappropriate;
      case 'other':
        return ReportReason.other;
      default:
        return ReportReason.other;
    }
  }
}

enum ReportStatus {
  pending,
  reviewed,
  resolved,
  dismissed;

  String get value {
    switch (this) {
      case ReportStatus.pending:
        return 'pending';
      case ReportStatus.reviewed:
        return 'reviewed';
      case ReportStatus.resolved:
        return 'resolved';
      case ReportStatus.dismissed:
        return 'dismissed';
    }
  }

  static ReportStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return ReportStatus.pending;
      case 'reviewed':
        return ReportStatus.reviewed;
      case 'resolved':
        return ReportStatus.resolved;
      case 'dismissed':
        return ReportStatus.dismissed;
      default:
        return ReportStatus.pending;
    }
  }
}

class ReportModel {
  final String publicId;
  final ReportType reportType;
  final String targetId;
  final ReportReason reason;
  final String? description;
  final ReportStatus status;
  final String createdAt;

  const ReportModel({
    required this.publicId,
    required this.reportType,
    required this.targetId,
    required this.reason,
    this.description,
    required this.status,
    required this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      publicId: json['public_id']?.toString() ?? '',
      reportType: ReportType.fromString(json['report_type']?.toString() ?? 'post'),
      targetId: json['target_id']?.toString() ?? '',
      reason: ReportReason.fromString(json['reason']?.toString() ?? 'other'),
      description: json['description']?.toString(),
      status: ReportStatus.fromString(json['status']?.toString() ?? 'pending'),
      createdAt: json['created_at']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'report_type': reportType.value,
      'target_id': targetId,
      'reason': reason.value,
      'description': description,
      'status': status.value,
      'created_at': createdAt,
    };
  }
}

/// Request model for creating a report
class CreateReportRequest {
  final ReportType reportType;
  final String targetId;
  final ReportReason reason;
  final String? description;

  const CreateReportRequest({
    required this.reportType,
    required this.targetId,
    required this.reason,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'report_type': reportType.value,
      'target_id': targetId,
      'reason': reason.value,
      if (description != null && description!.isNotEmpty) 'description': description,
    };
  }
}
