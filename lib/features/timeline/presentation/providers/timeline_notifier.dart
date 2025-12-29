import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/timeline/data/repositories/timeline_repository.dart';
import 'package:spatium/features/timeline/presentation/providers/timeline_state.dart';

/// Timeline Notifier
/// Manages timeline state and business logic
class TimelineNotifier extends StateNotifier<TimelineState> {
  final TimelineRepository _repository;

  TimelineNotifier(this._repository) : super(const TimelineState());

  /// Load all posts from the server
  Future<void> loadPosts() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.getAllPosts();
    result.fold(
      (failure) {
        state = state.copyWith(
          error: failure.message,
          isLoading: false,
        );
      },
      (posts) {
        // Sort by createdAt descending (newest first)
        final sortedPosts = List.of(posts);
        sortedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        
        state = state.copyWith(
          posts: sortedPosts,
          isLoading: false,
        );
      },
    );
  }

  /// Refresh posts (pull to refresh)
  Future<void> refreshPosts() async {
    await loadPosts();
  }

  /// Create a new post
  Future<bool> createPost(String content, int moodTagId) async {
    state = state.copyWith(isCreatingPost: true, clearError: true);

    final result = await _repository.createPost(content, moodTagId);
    
    return result.fold(
      (failure) {
        state = state.copyWith(
          error: failure.message,
          isCreatingPost: false,
        );
        return false;
      },
      (post) {
        // Add new post to the beginning of the list
        final updatedPosts = [post, ...state.posts];
        state = state.copyWith(
          posts: updatedPosts,
          isCreatingPost: false,
        );
        return true;
      },
    );
  }

  /// Delete a post
  Future<bool> deletePost(String postId) async {
    final result = await _repository.deletePost(postId);
    
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        final updatedPosts = state.posts
            .where((p) => p.publicId != postId)
            .toList();
        state = state.copyWith(posts: updatedPosts);
        return true;
      },
    );
  }

  /// Select a post to view details
  Future<void> selectPost(String postId) async {
    state = state.copyWith(isLoadingComments: true);
    
    final result = await _repository.getPostDetail(postId);
    result.fold(
      (failure) {
        state = state.copyWith(
          error: failure.message,
          isLoadingComments: false,
        );
      },
      (post) {
        state = state.copyWith(
          selectedPost: post,
          isLoadingComments: false,
        );
      },
    );
  }

  /// Clear selected post
  void clearSelectedPost() {
    state = state.copyWith(clearSelectedPost: true);
  }

  /// Add a comment to the selected post
  Future<bool> addComment(String postId, String content) async {
    final result = await _repository.createComment(postId, content);
    
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
        return false;
      },
      (comment) {
        // Update selected post with new comment
        if (state.selectedPost != null && state.selectedPost!.publicId == postId) {
          final updatedComments = [...state.selectedPost!.comments, comment];
          final updatedPost = state.selectedPost!.copyWith(
            comments: updatedComments,
            commentCount: state.selectedPost!.commentCount + 1,
          );
          state = state.copyWith(selectedPost: updatedPost);
        }
        
        // Update post in the list
        final updatedPosts = state.posts.map((p) {
          if (p.publicId == postId) {
            return p.copyWith(commentCount: p.commentCount + 1);
          }
          return p;
        }).toList();
        state = state.copyWith(posts: updatedPosts);
        
        return true;
      },
    );
  }

  /// React to a post (like)
  Future<bool> reactToPost(String postId, {String emoji = '❤️'}) async {
    // Optimistic update
    final updatedPosts = state.posts.map((p) {
      if (p.publicId == postId) {
        return p.copyWith(
          isLiked: !p.isLiked,
          reactionCount: p.isLiked ? p.reactionCount - 1 : p.reactionCount + 1,
        );
      }
      return p;
    }).toList();
    state = state.copyWith(posts: updatedPosts);

    final result = await _repository.reactToPost(postId, emoji);
    
    return result.fold(
      (failure) {
        // Revert optimistic update
        final revertedPosts = state.posts.map((p) {
          if (p.publicId == postId) {
            return p.copyWith(
              isLiked: !p.isLiked,
              reactionCount: p.isLiked ? p.reactionCount - 1 : p.reactionCount + 1,
            );
          }
          return p;
        }).toList();
        state = state.copyWith(posts: revertedPosts, error: failure.message);
        return false;
      },
      (_) => true,
    );
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Reset entire timeline state (used when user logs out or switches accounts)
  void resetState() {
    state = TimelineState();
  }
}
