import 'package:dio/dio.dart';
import 'package:spatium/core/constants/api_constants.dart';
import 'package:spatium/core/errors/exceptions.dart';
import 'package:spatium/core/network/api_client.dart';
import 'package:spatium/features/chat_ai/data/models/chat_message_model.dart';
import 'package:spatium/features/chat_ai/data/models/chat_session_model.dart';

/// Remote Data Source for Chat AI
/// Handles all API calls related to chat functionality
abstract class ChatRemoteDataSource {
  Future<List<ChatSessionModel>> getUserSessions();
  Future<ChatSessionModel> createSession(String title);
  Future<void> deleteSession(String sessionId);
  Future<List<ChatMessageModel>> getSessionMessages(String sessionId, {int limit = 20});
  Future<ChatMessageModel> sendMessage(String sessionId, String content);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ChatSessionModel>> getUserSessions() async {
    try {
      print('🔵 Getting user sessions');
      final response = await apiClient.get(ApiConstants.chatSession);
      
      print('🔵 Response status: ${response.statusCode}');
      print('🔵 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        dynamic data;
        if (response.data is Map) {
          data = response.data['data'];
        } else {
          data = response.data;
        }
        
        if (data == null) {
          print('⚠️ No sessions data');
          return [];
        }
        
        if (data is! List) {
          print('❌ Invalid data type: ${data.runtimeType}');
          return [];
        }
        
        return data
            .map((json) {
              try {
                return ChatSessionModel.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                print('❌ Error parsing session: $e');
                return null;
              }
            })
            .whereType<ChatSessionModel>()
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get sessions',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    } catch (e) {
      print('❌ Unexpected error in getUserSessions: $e');
      rethrow;
    }
  }

  @override
  Future<ChatSessionModel> createSession(String title) async {
    try {
      print('🔵 Creating session with title: $title');
      final response = await apiClient.post(
        ApiConstants.chatSession,
        data: {'title': title},
      );
      
      print('🔵 Response status: ${response.statusCode}');
      print('🔵 Response data: ${response.data}');
      print('🔵 Response data type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200) {
        // Handle response structure
        dynamic sessionData;
        if (response.data is Map) {
          sessionData = response.data['data'];
          print('🔵 Session data from map: $sessionData');
        } else {
          sessionData = response.data;
          print('🔵 Session data direct: $sessionData');
        }
        
        if (sessionData is! Map<String, dynamic>) {
          print('❌ Invalid session data type: ${sessionData.runtimeType}');
          throw ServerException(
            message: 'Invalid response format from server',
          );
        }
        
        final session = ChatSessionModel.fromJson(sessionData as Map<String, dynamic>);
        print('✅ Session created: ${session.publicId}');
        return session;
      } else {
        print('❌ Failed with status: ${response.statusCode}');
        throw ServerException(
          message: response.data['message'] ?? 'Failed to create session',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      print('❌ Response: ${e.response?.data}');
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    } catch (e) {
      print('❌ Unexpected error: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    try {
      final response = await apiClient.delete(
        ApiConstants.deleteChatSession(sessionId),
      );
      
      if (response.statusCode != 200) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to delete session',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    }
  }

  @override
  Future<List<ChatMessageModel>> getSessionMessages(
    String sessionId, {
    int limit = 20,
  }) async {
    try {
      print('🔵 Getting messages for session: $sessionId');
      final response = await apiClient.get(
        ApiConstants.sessionMessages(sessionId),
        queryParameters: {'limit': limit},
      );
      
      print('🔵 Response status: ${response.statusCode}');
      print('🔵 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        dynamic data;
        if (response.data is Map) {
          data = response.data['data'];
        } else {
          data = response.data;
        }
        
        if (data == null) {
          print('⚠️ No messages data');
          return [];
        }
        
        if (data is! List) {
          print('❌ Invalid data type: ${data.runtimeType}');
          return [];
        }
        
        return data
            .map((json) {
              try {
                return ChatMessageModel.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                print('❌ Error parsing message: $e');
                return null;
              }
            })
            .whereType<ChatMessageModel>()
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get messages',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    } catch (e) {
      print('❌ Unexpected error in getSessionMessages: $e');
      rethrow;
    }
  }

  @override
  Future<ChatMessageModel> sendMessage(String sessionId, String content) async {
    try {
      print('🔵 Sending message to session: $sessionId');
      final response = await apiClient.post(
        ApiConstants.sendMessage(sessionId),
        data: {
          'content': content,
          'sender': 'user',
        },
      );
      
      print('🔵 Response status: ${response.statusCode}');
      print('🔵 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        dynamic messageData;
        if (response.data is Map) {
          messageData = response.data['data'];
        } else {
          messageData = response.data;
        }
        
        if (messageData is! Map<String, dynamic>) {
          print('❌ Invalid message data type: ${messageData.runtimeType}');
          throw ServerException(
            message: 'Invalid response format from server',
          );
        }
        
        final message = ChatMessageModel.fromJson(messageData as Map<String, dynamic>);
        print('✅ Message sent: ${message.sessionId}');
        return message;
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to send message',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    } catch (e) {
      print('❌ Unexpected error in sendMessage: $e');
      rethrow;
    }
  }
}
