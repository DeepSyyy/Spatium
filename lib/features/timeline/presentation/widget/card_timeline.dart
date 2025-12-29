import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spatium/features/timeline/data/models/post_model.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class CardCurhat extends StatefulWidget {
  final PostModel post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CardCurhat({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onTap,
    this.onDelete,
  });

  @override
  State<CardCurhat> createState() => _CardCurhatState();
}

class _CardCurhatState extends State<CardCurhat> {
  bool _isExpanded = false;
  bool _isAiExpanded = false;

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
      case 1: // Senang
        return AppColor.statusHappyText;
      case 2: // Sedih
        return AppColor.statusSadText;
      case 3: // Marah
        return AppColor.statusAngryText;
      case 4: // Netral
        return AppColor.statusNeutralText;
      default:
        return AppColor.statusNeutralText;
    }
  }

  Color _getMoodBgColor(int moodTagId) {
    switch (moodTagId) {
      case 1: // Senang
        return AppColor.statusHappyBg;
      case 2: // Sedih
        return AppColor.statusSadBg;
      case 3: // Marah
        return AppColor.statusAngryBg;
      case 4: // Netral
        return AppColor.statusNeutralBg;
      default:
        return AppColor.statusNeutralBg;
    }
  }

  void _showDeleteConfirmation() {
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
              widget.onDelete?.call();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final cardPadding = screenWidth * 0.04;
    final moodColor = _getMoodColor(widget.post.moodTagId);
    final moodBgColor = _getMoodBgColor(widget.post.moodTagId);

    // Check if content needs truncation
    final needsTruncation = widget.post.content.length > 150;
    final displayContent = _isExpanded || !needsTruncation
        ? widget.post.content
        : '${widget.post.content.substring(0, 150)}...';

    // Check if AI response needs truncation
    final hasAiResponse =
        widget.post.aiResponse != null && widget.post.aiResponse!.isNotEmpty;
    final needsAiTruncation =
        hasAiResponse && widget.post.aiResponse!.length > 150;
    final displayAiContent = hasAiResponse
        ? (_isAiExpanded || !needsAiTruncation
              ? widget.post.aiResponse!
              : '${widget.post.aiResponse!.substring(0, 150)}...')
        : '';

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withOpacity(AppConstants.opacityLow),
              blurRadius: AppConstants.blurRadiusS,
              offset: const Offset(0, AppConstants.elevationLow),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, Name, Time, Mood
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: AppConstants.spacingXl,
                  backgroundColor: AppColor.border,
                  child: Icon(Icons.person, color: AppColor.placeholder),
                ),
                const SizedBox(width: AppConstants.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Anonymous',
                              style: SpatiumTypography.h3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingS),
                          // Mood Tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingS,
                              vertical: AppConstants.spacingXs,
                            ),
                            decoration: BoxDecoration(
                              color: moodBgColor,
                              border: Border.all(
                                color: moodColor.withOpacity(
                                  AppConstants.opacityHigh,
                                ),
                                width: AppConstants.borderWidthThin,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusM,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: AppConstants.avatarS,
                                  backgroundColor: moodColor,
                                ),
                                const SizedBox(width: AppConstants.spacingXs),
                                Text(
                                  widget.post.moodName,
                                  style: SpatiumTypography.statusLabel.copyWith(
                                    color: moodColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // More menu (only for owner)
                          if (widget.post.isOwner && widget.onDelete != null)
                            PopupMenuButton<String>(
                              icon: Icon(
                                Icons.more_vert,
                                color: AppColor.secondary,
                                size: AppConstants.iconS,
                              ),
                              padding: EdgeInsets.zero,
                              onSelected: (value) {
                                if (value == 'delete') {
                                  _showDeleteConfirmation();
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: AppConstants.iconS,
                                      ),
                                      const SizedBox(
                                        width: AppConstants.spacingS,
                                      ),
                                      Text(
                                        'Hapus',
                                        style: SpatiumTypography.bodyRegular
                                            .copyWith(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatTimeAgo(widget.post.createdAt),
                        style: SpatiumTypography.small,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingM),

            // Post Content
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: displayContent,
                    style: SpatiumTypography.bodyRegular,
                  ),
                  if (needsTruncation)
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => setState(() => _isExpanded = !_isExpanded),
                        child: Text(
                          _isExpanded ? ' tutup' : ' lainnya',
                          style: SpatiumTypography.bodyRegular.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingM),

            // AI Response (if available)
            if (hasAiResponse) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: AppColor.aiResponseBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppConstants.avatarS),
                          decoration: BoxDecoration(
                            color: AppColor.aiResponseText.withOpacity(
                              AppConstants.opacityMedium,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.smart_toy_outlined,
                            color: AppColor.aiResponseText,
                            size: AppConstants.iconXs,
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
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: displayAiContent,
                            style: SpatiumTypography.aiResponseBody,
                          ),
                          if (needsAiTruncation)
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () => setState(
                                  () => _isAiExpanded = !_isAiExpanded,
                                ),
                                child: Text(
                                  _isAiExpanded ? ' tutup' : ' lainnya',
                                  style: SpatiumTypography.aiResponseBody
                                      .copyWith(
                                        color: AppColor.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingM),
            ],

            // Actions: Like and Comment
            Row(
              children: [
                // Like Button
                GestureDetector(
                  onTap: widget.onLike,
                  child: Row(
                    children: [
                      Icon(
                        widget.post.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: AppConstants.iconS,
                        color: widget.post.isLiked
                            ? Colors.red
                            : AppColor.placeholder,
                      ),
                      const SizedBox(width: AppConstants.spacingXs),
                      Text(
                        '${widget.post.reactionCount}',
                        style: SpatiumTypography.small,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstants.spacingL),
                // Comment Button
                GestureDetector(
                  onTap: widget.onComment,
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: AppConstants.iconS,
                        color: AppColor.placeholder,
                      ),
                      const SizedBox(width: AppConstants.spacingXs),
                      Text(
                        '${widget.post.commentCount}',
                        style: SpatiumTypography.small,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
