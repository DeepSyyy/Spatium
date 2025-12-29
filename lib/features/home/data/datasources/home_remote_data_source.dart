import 'package:dio/dio.dart';
import 'package:spatium/core/constants/api_constants.dart';
import 'package:spatium/core/errors/exceptions.dart';
import 'package:spatium/core/network/api_client.dart';
import 'package:spatium/features/home/data/models/daily_mood_model.dart';

/// Home Remote Data Source
/// Handles API calls for home features (mood tracking, chat activity)
abstract class HomeRemoteDataSource {
  Future<DailyMoodModel?> getTodayMood();
  Future<List<MoodStatModel>> getMoodStatistics(int days);
  Future<DailyMoodModel> saveDailyMood(int moodTagId, String note);
  Future<List<ChatActivityModel>> getChatSessions();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl(this.apiClient);

  @override
  Future<DailyMoodModel?> getTodayMood() async {
    try {
      print('🔵 Getting today\'s mood');
      final response = await apiClient.get(ApiConstants.moodsToday);

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null) {
          return DailyMoodModel.fromJson(data);
        }
        return null;
      }
      return null;
    } on DioException catch (e) {
      // 400 means no mood found for today, which is valid
      if (e.response?.statusCode == 400) {
        return null;
      }
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    }
  }

  @override
  Future<List<MoodStatModel>> getMoodStatistics(int days) async {
    try {
      print('🔵 Getting mood statistics for $days days');
      final response = await apiClient.get(
        ApiConstants.moodsStatistics,
        queryParameters: {'days': days},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data is List) {
          return data.map((json) => MoodStatModel.fromJson(json)).toList();
        }
        return [];
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return [];
      }
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    }
  }

  @override
  Future<DailyMoodModel> saveDailyMood(int moodTagId, String note) async {
    try {
      print('🔵 Saving daily mood: $moodTagId');
      final response = await apiClient.post(
        ApiConstants.moods,
        data: {
          'mood_tag_internal_id': moodTagId,
          'note': note,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final moodData = response.data['data']?['mood'];
        if (moodData != null) {
          return DailyMoodModel.fromJson(moodData);
        }
        throw ServerException(message: 'Invalid response format');
      }
      throw ServerException(
        message: response.data['message'] ?? 'Failed to save mood',
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    }
  }

  @override
  Future<List<ChatActivityModel>> getChatSessions() async {
    try {
      print('🔵 Getting chat sessions for calendar');
      final response = await apiClient.get(ApiConstants.chatSession);

      if (response.statusCode == 200) {
        dynamic data = response.data['data'];
        
        if (data is Map && data['sessions'] != null) {
          data = data['sessions'];
        }
        
        if (data is List) {
          return data
              .map((json) => ChatActivityModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        return [];
      }
      return [];
    } on DioException catch (e) {
      print('❌ Error getting chat sessions: ${e.message}');
      return [];
    }
  }
}
