import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spatium/features/timeline/data/models/post_model.dart';
import 'package:spatium/features/timeline/presentation/providers/timeline_providers.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailPage({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timelineNotifierProvider.notifier).selectPost(widget.postId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTimeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) {
        return 'Baru saja';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes} Menit lalu';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} Jam lalu';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} Hari lalu';
      } else {
        return DateFormat('dd MMM yyyy', 'id').format(date);
      }
    } catch (e) {
      return dateString;
    }
  }

  Color _getMoodColor(int moodTagId) {
    switch (moodTagId) {
      case 1:
        return AppColor.statusHappyText;
      case 2:
        return AppColor.statusSadText;
      case 3:
        return AppColor.statusAngryText;
      case 4:
        return AppColor.statusNeutralText;
      default:
        return AppColor.statusNeutralText;
    }
  }

  Color _getMoodBgColor(int moodTagId) {
    switch (moodTagId) {
      case 1:
        return AppColor.statusHappyBg;
      case 2:
        return AppColor.statusSadBg;
      case 3:
        return AppColor.statusAngryBg;
      case 4:
        return AppColor.statusNeutralBg;
      default:
        return AppColor.statusNeutralBg;
    }
  }

  Future<void> _sendComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSending = true);

    final success = await ref
        .read(timelineNotifierProvider.notifier)
        .addComment(widget.postId, content);

    if (mounted) {
      setState(() => _isSending = false);

      if (success) {
        _commentController.clear();
        // Scroll to bottom to show new comment
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengirim komentar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timelineState = ref.watch(timelineNotifierProvider);
    final post = timelineState.selectedPost;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () {
            ref.read(timelineNotifierProvider.notifier).clearSelectedPost();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Detail Curhat',
          style: SpatiumTypography.appBarTitle,
        ),
        centerTitle: true,
      ),
      body: timelineState.isLoadingComments || post == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppConstants.spacingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Post Content
                        _buildPostContent(post),
                        const SizedBox(height: AppConstants.spacingL),
                        
                        // AI Response
                        if (post.aiResponse != null && post.aiResponse!.isNotEmpty) ...[
                          _buildAiResponse(post.aiResponse!),
                          const SizedBox(height: AppConstants.spacingL),
                        ],

                        // Actions
                        _buildActions(post),
                        
                        const Divider(height: 32),

                        // Comments Section
                        Text(
                          'Komentar',
                          style: SpatiumTypography.h2,
                        ),
                        const SizedBox(height: AppConstants.spacingM),
                        
                        if (post.comments.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(AppConstants.spacingL),
                            child: Center(
                              child: Text(
                                'Belum ada komentar',
                                style: SpatiumTypography.hint,
                              ),
                            ),
                          )
                        else
                          ...post.comments.map((comment) => _buildCommentItem(comment)),
                        
                        // "Tampilkan Lainnya" button (if has more comments)
                        if (post.comments.length >= 5)
                          Center(
                            child: TextButton(
                              onPressed: () {
                                // Load more comments
                              },
                              child: Text(
                                'Tampilkan Lainnya',
                                style: SpatiumTypography.button.copyWith(
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Comment Input
                _buildCommentInput(),
              ],
            ),
    );
  }

  Widget _buildPostContent(PostModel post) {
    final moodColor = _getMoodColor(post.moodTagId);
    final moodBgColor = _getMoodBgColor(post.moodTagId);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: AppColor.backgroundLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColor.border,
                child: Icon(Icons.person, color: AppColor.placeholder),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Anonymous',
                          style: SpatiumTypography.h3,
                        ),
                        const SizedBox(width: AppConstants.spacingS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: moodBgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: moodColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: moodColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                post.moodName,
                                style: SpatiumTypography.small.copyWith(
                                  color: moodColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _formatTimeAgo(post.createdAt),
                      style: SpatiumTypography.small.copyWith(
                        color: AppColor.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: AppColor.secondary),
                onPressed: () {
                  // Show options menu
                },
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingL),
          // Content
          Text(
            post.content,
            style: SpatiumTypography.bodyRegular,
          ),
        ],
      ),
    );
  }

  Widget _buildAiResponse(String aiResponse) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: AppColor.aiResponseBackground,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColor.aiResponseText.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.smart_toy_outlined,
                  color: AppColor.aiResponseText,
                  size: 16,
                ),
              ),
              const SizedBox(width: AppConstants.spacingS),
              Text(
                'Respon AI',
                style: SpatiumTypography.aiResponseTitle,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            aiResponse,
            style: SpatiumTypography.aiResponseBody,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(PostModel post) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            ref.read(timelineNotifierProvider.notifier).reactToPost(post.publicId);
          },
          child: Row(
            children: [
              Icon(
                post.isLiked ? Icons.favorite : Icons.favorite_border,
                size: 24,
                color: post.isLiked ? Colors.red : AppColor.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${post.reactionCount}',
                style: SpatiumTypography.bodyMedium.copyWith(
                  color: AppColor.secondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppConstants.spacingXl),
        Row(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 24,
              color: AppColor.secondary,
            ),
            const SizedBox(width: 4),
            Text(
              '${post.comments.length}',
              style: SpatiumTypography.bodyMedium.copyWith(
                color: AppColor.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColor.border,
            child: Icon(Icons.person, size: 20, color: AppColor.placeholder),
          ),
          const SizedBox(width: AppConstants.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Anonymous',
                      style: SpatiumTypography.labelSemiBold,
                    ),
                    const SizedBox(width: AppConstants.spacingS),
                    IconButton(
                      icon: Icon(Icons.more_vert, size: 16, color: AppColor.secondary),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  comment.content,
                  style: SpatiumTypography.bodyRegular,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimeAgo(comment.createdAt),
                  style: SpatiumTypography.small.copyWith(
                    color: AppColor.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.only(
        left: AppConstants.spacingL,
        right: AppConstants.spacingL,
        top: AppConstants.spacingM,
        bottom: MediaQuery.of(context).padding.bottom + AppConstants.spacingM,
      ),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingM),
              decoration: BoxDecoration(
                color: AppColor.backgroundLight,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Tulis komentar...',
                  hintStyle: SpatiumTypography.hint,
                  border: InputBorder.none,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendComment(),
                enabled: !_isSending,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingS),
          GestureDetector(
            onTap: _isSending ? null : _sendComment,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isSending ? AppColor.secondary : AppColor.primary,
                shape: BoxShape.circle,
              ),
              child: _isSending
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.send,
                      color: AppColor.white,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
