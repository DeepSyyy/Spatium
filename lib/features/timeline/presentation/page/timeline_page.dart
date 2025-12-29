import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/timeline/presentation/page/post_detail_page.dart';
import 'package:spatium/features/timeline/presentation/providers/timeline_providers.dart';
import 'package:spatium/features/timeline/presentation/widget/app_bar_timeline.dart';
import 'package:spatium/features/timeline/presentation/widget/card_timeline.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class TimelinePage extends ConsumerStatefulWidget {
  const TimelinePage({super.key});

  @override
  ConsumerState<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends ConsumerState<TimelinePage> {
  @override
  void initState() {
    super.initState();
    // Load posts when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timelineNotifierProvider.notifier).loadPosts();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(timelineNotifierProvider.notifier).refreshPosts();
  }

  void _onLike(String postId) {
    ref.read(timelineNotifierProvider.notifier).reactToPost(postId);
  }

  void _onComment(String postId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailPage(postId: postId)),
    );
  }

  void _onDelete(String postId) async {
    await ref.read(timelineNotifierProvider.notifier).deletePost(postId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Curhat berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final timelineState = ref.watch(timelineNotifierProvider);

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: TimelineAppbar(),
      body: SafeArea(
        child: timelineState.isLoading && timelineState.posts.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Memuat curhatan...'),
                  ],
                ),
              )
            : timelineState.hasError && timelineState.posts.isEmpty
            ? _buildErrorState(timelineState.error!)
            : timelineState.isEmpty
            ? _buildEmptyState()
            : RefreshIndicator(
                onRefresh: _onRefresh,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                    vertical: 8.0,
                  ),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: timelineState.posts.length,
                    itemBuilder: (context, index) {
                      final post = timelineState.posts[index];
                      return CardCurhat(
                        post: post,
                        onLike: () => _onLike(post.publicId),
                        onComment: () => _onComment(post.publicId),
                        onTap: () => _onComment(post.publicId),
                        onDelete: () => _onDelete(post.publicId),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppColor.secondary.withOpacity(0.5),
          ),
          const SizedBox(height: AppConstants.spacingL),
          Text(
            'Belum ada curhatan',
            style: SpatiumTypography.h2.copyWith(color: AppColor.secondary),
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            'Jadilah yang pertama berbagi cerita!',
            style: SpatiumTypography.bodyMedium.copyWith(
              color: AppColor.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColor.error),
            const SizedBox(height: AppConstants.spacingL),
            Text(
              'Tidak dapat memuat timeline',
              style: SpatiumTypography.h2.copyWith(color: AppColor.secondary),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              error,
              style: SpatiumTypography.bodyMedium.copyWith(
                color: AppColor.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingL),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(timelineNotifierProvider.notifier).loadPosts();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
