import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:spatium/features/timeline/data/models/post_model.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

/// My Posts Section Widget
/// Shows the user's own posts with delete option
class MyPostsSection extends StatelessWidget {
  final List<PostModel> myPosts;
  final bool isLoading;
  final Function(String postId) onDeletePost;
  final VoidCallback? onRefresh;

  const MyPostsSection({
    super.key,
    required this.myPosts,
    required this.isLoading,
    required this.onDeletePost,
    this.onRefresh,
  });

  String _formatTimeAgo(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) {
        return 'Baru saja';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes} menit lalu';
      } else if (diff.inHours < 24) {
        return '${diff.inHours} jam lalu';
      } else if (diff.inDays < 7) {
        return '${diff.inDays} hari lalu';
      } else {
        return DateFormat('dd MMM yyyy', 'id').format(date);
      }
    } catch (e) {
      return dateString;
    }
  }

  String _getMoodSvgPath(int moodTagId) {
    switch (moodTagId) {
      case 1:
        return 'assets/svg/happy.svg';
      case 2:
        return 'assets/svg/sad.svg';
      case 3:
        return 'assets/svg/angry.svg';
      case 4:
        return 'assets/svg/neutral.svg';
      default:
        return 'assets/svg/neutral.svg';
    }
  }

  String _getMoodName(int moodTagId) {
    switch (moodTagId) {
      case 1:
        return 'Senang';
      case 2:
        return 'Sedih';
      case 3:
        return 'Marah';
      case 4:
        return 'Netral';
      default:
        return 'Netral';
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

  Color _getMoodTextColor(int moodTagId) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Curhatanku', style: SpatiumTypography.h2),
            if (myPosts.isNotEmpty)
              Text(
                '${myPosts.length} curhat',
                style: SpatiumTypography.small.copyWith(
                  color: AppColor.secondary,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingS),
        Text(
          'Kelola curhatan yang sudah kamu kirim',
          style: SpatiumTypography.bodyRegular.copyWith(
            color: AppColor.secondary,
          ),
        ),
        const SizedBox(height: AppConstants.spacingL),
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.spacingXl),
              child: CircularProgressIndicator(),
            ),
          )
        else if (myPosts.isEmpty)
          _buildEmptyState()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: myPosts.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppConstants.spacingM),
            itemBuilder: (context, index) {
              final post = myPosts[index];
              return _MyPostCard(
                post: post,
                formatTimeAgo: _formatTimeAgo,
                getMoodSvgPath: _getMoodSvgPath,
                getMoodName: _getMoodName,
                getMoodBgColor: _getMoodBgColor,
                getMoodTextColor: _getMoodTextColor,
                onDelete: () => onDeletePost(post.publicId),
              );
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        color: AppColor.backgroundLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: AppColor.placeholder,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'Belum ada curhatan',
            style: SpatiumTypography.bodyMedium.copyWith(
              color: AppColor.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            'Curhatanmu akan muncul di sini',
            style: SpatiumTypography.small.copyWith(
              color: AppColor.placeholder,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MyPostCard extends StatelessWidget {
  final PostModel post;
  final String Function(String) formatTimeAgo;
  final String Function(int) getMoodSvgPath;
  final String Function(int) getMoodName;
  final Color Function(int) getMoodBgColor;
  final Color Function(int) getMoodTextColor;
  final VoidCallback onDelete;

  const _MyPostCard({
    required this.post,
    required this.formatTimeAgo,
    required this.getMoodSvgPath,
    required this.getMoodName,
    required this.getMoodBgColor,
    required this.getMoodTextColor,
    required this.onDelete,
  });

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hapus Curhat', style: SpatiumTypography.h2),
        content: Text(
          'Apakah kamu yakin ingin menghapus curhat ini? Tindakan ini tidak dapat dibatalkan.',
          style: SpatiumTypography.bodyRegular,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: SpatiumTypography.button.copyWith(
                color: AppColor.secondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: AppColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
            child: Text('Hapus', style: SpatiumTypography.button),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final truncatedContent = post.content.length > 100
        ? '${post.content.substring(0, 100)}...'
        : post.content;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with mood and delete button
          Row(
            children: [
              // Mood indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingS,
                  vertical: AppConstants.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: getMoodBgColor(post.moodTagId),
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      getMoodSvgPath(post.moodTagId),
                      width: 16,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      getMoodName(post.moodTagId),
                      style: SpatiumTypography.small.copyWith(
                        color: getMoodTextColor(post.moodTagId),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.spacingS),
              // Time
              Expanded(
                child: Text(
                  formatTimeAgo(post.createdAt),
                  style: SpatiumTypography.small.copyWith(
                    color: AppColor.placeholder,
                  ),
                ),
              ),
              // Delete button
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red.shade400,
                  size: 20,
                ),
                onPressed: () => _showDeleteConfirmation(context),
                tooltip: 'Hapus curhat',
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingS),
          // Content
          Text(
            truncatedContent,
            style: SpatiumTypography.bodyRegular,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppConstants.spacingS),
          // Stats row
          Row(
            children: [
              Icon(Icons.favorite, size: 14, color: AppColor.placeholder),
              const SizedBox(width: 4),
              Text(
                '${post.reactionCount}',
                style: SpatiumTypography.small.copyWith(
                  color: AppColor.placeholder,
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Icon(
                Icons.chat_bubble_outline,
                size: 14,
                color: AppColor.placeholder,
              ),
              const SizedBox(width: 4),
              Text(
                '${post.commentCount}',
                style: SpatiumTypography.small.copyWith(
                  color: AppColor.placeholder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
