import 'package:spatium/features/chat_ai/data/models/chat_message_model.dart';
import 'package:spatium/features/chat_ai/data/models/chat_session_model.dart';

/// Chat State
class ChatState {
  final List<ChatSessionModel> sessions;
  final ChatSessionModel? currentSession;
  final List<ChatMessageModel> messages;
  final bool isLoading;
  final bool isSendingMessage;
  final String? error;

  const ChatState({
    this.sessions = const [],
    this.currentSession,
    this.messages = const [],
    this.isLoading = false,
    this.isSendingMessage = false,
    this.error,
  });

  bool get hasActiveSession => currentSession != null;

  ChatState copyWith({
    List<ChatSessionModel>? sessions,
    ChatSessionModel? currentSession,
    bool clearCurrentSession = false,
    List<ChatMessageModel>? messages,
    bool? isLoading,
    bool? isSendingMessage,
    String? error,
    bool clearError = false,
  }) {
    return ChatState(
      sessions: sessions ?? this.sessions,
      currentSession: clearCurrentSession ? null : (currentSession ?? this.currentSession),
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      error: clearError ? null : error,
    );
  }
}
