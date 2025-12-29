import 'package:dio/dio.dart';
import 'package:spatium/core/constants/api_constants.dart';
import 'package:spatium/core/errors/exceptions.dart';
import 'package:spatium/core/network/api_client.dart';
import 'package:spatium/features/timeline/data/models/post_model.dart';

/// Timeline Remote Data Source
/// Handles all API calls related to timeline/posts functionality
abstract class TimelineRemoteDataSource {
  Future<List<PostModel>> getAllPosts();
  Future<PostModel> getPostDetail(String postId);
  Future<PostModel> createPost(String content, int moodTagId);
  Future<void> deletePost(String postId);
  Future<List<CommentModel>> getPostComments(String postId);
  Future<CommentModel> createComment(String postId, String content);
  Future<void> deleteComment(String commentId);
  Future<void> reactToPost(String postId, String emoji);
  Future<List<ReactionSummaryModel>> getReactionSummary(String postId);
}

class TimelineRemoteDataSourceImpl implements TimelineRemoteDataSource {
  final ApiClient apiClient;

  TimelineRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<PostModel>> getAllPosts() async {
    try {
      print('🔵 Getting all posts');
      final response = await apiClient.get(ApiConstants.posts);

      print('🔵 Response status: ${response.statusCode}');
      print('🔵 Response data: ${response.data}');

      if (response.statusCode == 200) {
        dynamic data;
        if (response.data is Map) {
          data = response.data['data'];
          if (data is Map && data['posts'] != null) {
            data = data['posts'];
          }
        } else {
          data = response.data;
        }

        if (data == null) {
          print('⚠️ No posts data');
          return [];
        }

        if (data is! List) {
          print('❌ Invalid data type: ${data.runtimeType}');
          return [];
        }

        return data
            .map((json) {
              try {
                return PostModel.fromJson(json as Map<String, dynamic>);
              } catch (e) {
                print('❌ Error parsing post: $e');
                return null;
              }
            })
            .whereType<PostModel>()
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get posts',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    } catch (e) {
      print('❌ Unexpected error in getAllPosts: $e');
      rethrow;
    }
  }

  @override
  Future<PostModel> getPostDetail(String postId) async {
    try {
      print('🔵 Getting post detail: $postId');
      print('🔵 Using apiClient: ${apiClient.hashCode}');
      final response = await apiClient.get(ApiConstants.postDetail(postId));

      print('🔵 Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        dynamic data;
        if (response.data is Map) {
          data = response.data['data'];
        } else {
          data = response.data;
        }

        if (data is! Map<String, dynamic>) {
          throw ServerException(message: 'Invalid response format');
        }

        return PostModel.fromJson(data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get post detail',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    }
  }

  @override
  Future<PostModel> createPost(String content, int moodTagId) async {
    try {
      print('🔵 Creating post with mood: $moodTagId');
      final response = await apiClient.post(
        ApiConstants.posts,
        data: {
          'content': content,
          'mood_internal_id': moodTagId,
        },
      );

      print('🔵 Response status: ${response.statusCode}');
      print('🔵 Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic data;
        if (response.data is Map) {
          data = response.data['data'];
          if (data is Map && data['post'] != null) {
            data = data['post'];
          }
        } else {
          data = response.data;
        }

        if (data is! Map<String, dynamic>) {
          throw ServerException(message: 'Invalid response format');
        }

        return PostModel.fromJson(data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to create post',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      final response = await apiClient.delete(ApiConstants.postDetail(postId));

      if (response.statusCode != 200) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to delete post',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    }
  }

  @override
  Future<List<CommentModel>> getPostComments(String postId) async {
    try {
      print('🔵 Getting comments for post: $postId');
      final response = await apiClient.get(ApiConstants.postComments(postId));

      if (response.statusCode == 200) {
        dynamic data;
        if (response.data is Map) {
          data = response.data['data'];
        } else {
          data = response.data;
        }

        if (data == null) return [];

        if (data is! List) {
          print('❌ Invalid data type: ${data.runtimeType}');
          return [];
        }

        return data
            .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get comments',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    }
  }

  @override
  Future<CommentModel> createComment(String postId, String content) async {
    try {
      print('🔵 Creating comment for post: $postId');
      final response = await apiClient.post(
        ApiConstants.comments,
        data: {
          'post_id': postId,
          'content': content,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic data;
        if (response.data is Map) {
          data = response.data['data'];
        } else {
          data = response.data;
        }

        if (data is! Map<String, dynamic>) {
          throw ServerException(message: 'Invalid response format');
        }

        return CommentModel.fromJson(data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to create comment',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    }
  }

  @override
  Future<void> deleteComment(String commentId) async {
    try {
      final response = await apiClient.delete(ApiConstants.deleteComment(commentId));

      if (response.statusCode != 200) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to delete comment',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    }
  }

  @override
  Future<void> reactToPost(String postId, String emoji) async {
    try {
      print('🔵 Reacting to post: $postId with emoji: $emoji');
      final response = await apiClient.post(
        ApiConstants.postReactions(postId),
        data: {'emoji': emoji},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to react to post',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    }
  }

  @override
  Future<List<ReactionSummaryModel>> getReactionSummary(String postId) async {
    try {
      final response = await apiClient.get(ApiConstants.postReactions(postId));

      if (response.statusCode == 200) {
        dynamic data;
        if (response.data is Map) {
          data = response.data['data'];
        } else {
          data = response.data;
        }

        if (data == null) return [];

        if (data is! List) return [];

        return data
            .map((json) => ReactionSummaryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get reactions',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Network error',
      );
    }
  }
}
