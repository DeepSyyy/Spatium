import 'package:spatium/features/timeline/data/models/post_model.dart';

/// Timeline State
/// Holds the state for the timeline feature
class TimelineState {
  final List<PostModel> posts;
  final PostModel? selectedPost;
  final bool isLoading;
  final bool isCreatingPost;
  final bool isLoadingComments;
  final String? error;

  const TimelineState({
    this.posts = const [],
    this.selectedPost,
    this.isLoading = false,
    this.isCreatingPost = false,
    this.isLoadingComments = false,
    this.error,
  });

  TimelineState copyWith({
    List<PostModel>? posts,
    PostModel? selectedPost,
    bool clearSelectedPost = false,
    bool? isLoading,
    bool? isCreatingPost,
    bool? isLoadingComments,
    String? error,
    bool clearError = false,
  }) {
    return TimelineState(
      posts: posts ?? this.posts,
      selectedPost: clearSelectedPost ? null : (selectedPost ?? this.selectedPost),
      isLoading: isLoading ?? this.isLoading,
      isCreatingPost: isCreatingPost ?? this.isCreatingPost,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      error: clearError ? null : error,
    );
  }

  bool get isEmpty => posts.isEmpty && !isLoading;
  bool get hasError => error != null;
}
