import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/chat_ai/data/repositories/chat_repository_impl.dart';
import 'package:spatium/features/chat_ai/presentation/providers/chat_state.dart';

/// Chat Notifier
/// Manages chat state and business logic using Riverpod
class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;

  ChatNotifier(this._repository) : super(const ChatState());

  /// Load all user sessions
  Future<void> loadSessions() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.getUserSessions();
    result.fold(
      (failure) {
        state = state.copyWith(
          error: failure.message,
          isLoading: false,
        );
      },
      (sessions) {
        state = state.copyWith(
          sessions: sessions,
          isLoading: false,
        );
      },
    );
  }

  /// Create new chat session
  Future<bool> createSession(String title) async {
    print('🟢 ChatNotifier: Creating session with title: $title');
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.createSession(title);
    
    return result.fold(
      (failure) {
        print('❌ ChatNotifier: Failed to create session: ${failure.message}');
        state = state.copyWith(
          error: failure.message,
          isLoading: false,
        );
        return false;
      },
      (session) {
        print('✅ ChatNotifier: Session created successfully: ${session.publicId}');
        final updatedSessions = [session, ...state.sessions];
        state = state.copyWith(
          sessions: updatedSessions,
          currentSession: session,
          messages: [],
          isLoading: false,
        );
        print('✅ ChatNotifier: State updated. Current session: ${state.currentSession?.title}');
        return true;
      },
    );
  }

  /// Select a session and load its messages
  Future<void> selectSession(String sessionId) async {
    final session = state.sessions.firstWhere(
      (s) => s.publicId == sessionId,
    );
    
    state = state.copyWith(
      currentSession: session,
      messages: [],
    );
    
    await loadMessages(sessionId);
  }

  /// Load messages for current session
  Future<void> loadMessages(String sessionId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.getSessionMessages(sessionId);
    result.fold(
      (failure) {
        state = state.copyWith(
          error: failure.message,
          isLoading: false,
        );
      },
      (messages) {
        state = state.copyWith(
          messages: messages,
          isLoading: false,
        );
      },
    );
  }

  /// Send a message to the AI
  Future<bool> sendMessage(String content) async {
    if (state.currentSession == null) return false;
    
    state = state.copyWith(isSendingMessage: true, clearError: true);

    final result = await _repository.sendMessage(
      state.currentSession!.publicId,
      content,
    );
    
    return result.fold(
      (failure) {
        state = state.copyWith(
          error: failure.message,
          isSendingMessage: false,
        );
        return false;
      },
      (message) async {
        // Wait a moment, then fetch AI response
        await Future.delayed(const Duration(milliseconds: 1000));
        
        // Reload messages to get AI response
        await loadMessages(state.currentSession!.publicId);
        
        state = state.copyWith(isSendingMessage: false);
        return true;
      },
    );
  }

  /// Delete a session
  Future<bool> deleteSession(String sessionId) async {
    final result = await _repository.deleteSession(sessionId);
    
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        final updatedSessions = state.sessions
            .where((s) => s.publicId != sessionId)
            .toList();
        
        final shouldClearSession = state.currentSession?.publicId == sessionId;
        
        state = state.copyWith(
          sessions: updatedSessions,
          clearCurrentSession: shouldClearSession,
          messages: shouldClearSession ? [] : state.messages,
        );
        return true;
      },
    );
  }

  /// Clear current session
  void clearCurrentSession() {
    state = state.copyWith(
      clearCurrentSession: true,
      messages: [],
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
