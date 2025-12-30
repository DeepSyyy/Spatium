import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/home/presentation/providers/home_providers.dart';
import 'package:spatium/features/home/presentation/widgets/calendar_legend.dart';
import 'package:spatium/features/home/presentation/widgets/mood_calendar.dart';
import 'package:spatium/features/home/presentation/widgets/mood_picker_dialog.dart';
import 'package:spatium/features/home/presentation/widgets/my_posts_section.dart';
import 'package:spatium/features/home/presentation/widgets/today_mood_card.dart';
import 'package:spatium/features/timeline/presentation/providers/timeline_providers.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeNotifierProvider.notifier).loadHomeData();
      // Also load timeline posts to get user's posts
      ref.read(timelineNotifierProvider.notifier).loadPosts();
    });
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      ref.read(homeNotifierProvider.notifier).loadHomeData(),
      ref.read(timelineNotifierProvider.notifier).loadPosts(),
    ]);
  }

  Future<void> _deletePost(String postId) async {
    final success = await ref
        .read(timelineNotifierProvider.notifier)
        .deletePost(postId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Curhat berhasil dihapus' : 'Gagal menghapus curhat',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Future<void> _showMoodPicker() async {
    final homeState = ref.read(homeNotifierProvider);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => MoodPickerDialog(
        currentMoodId: homeState.todayMood?.moodTagId,
        currentNote: homeState.todayMood?.note,
      ),
    );

    if (result != null && mounted) {
      final moodId = result['moodId'] as int;
      final note = result['note'] as String;

      final success = await ref
          .read(homeNotifierProvider.notifier)
          .saveTodayMood(moodId, note);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Mood berhasil disimpan!' : 'Gagal menyimpan mood',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _onMonthChanged(DateTime month) {
    ref.read(homeNotifierProvider.notifier).changeMonth(month);
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);
    final timelineState = ref.watch(timelineNotifierProvider);

    // Filter for user's own posts
    final myPosts = timelineState.posts.where((p) => p.isOwner).toList();

    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      appBar: AppBar(
        title: Text('Home', style: SpatiumTypography.appBarTitle),
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.black,
        elevation: 0,
      ),
      body: homeState.isLoading && homeState.moodStats.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppConstants.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today's Mood Card
                    TodayMoodCard(
                      todayMood: homeState.todayMood,
                      isLoading: homeState.isSavingMood,
                      onAddMood: _showMoodPicker,
                    ),

                    const SizedBox(height: AppConstants.spacingXl),

                    // Section Title
                    Text('Mood & Aktivitas Chat', style: SpatiumTypography.h2),
                    const SizedBox(height: AppConstants.spacingS),
                    Text(
                      'Lihat riwayat mood dan kapan kamu chat dengan AI',
                      style: SpatiumTypography.bodyRegular.copyWith(
                        color: AppColor.secondary,
                      ),
                    ),

                    const SizedBox(height: AppConstants.spacingL),

                    // Calendar
                    MoodCalendar(
                      selectedMonth: homeState.selectedMonth,
                      moodStats: homeState.moodStats,
                      chatActivities: homeState.chatActivities,
                      onMonthChanged: _onMonthChanged,
                      onDateTap: (date) {
                        _showDateDetails(date, homeState);
                      },
                    ),

                    const SizedBox(height: AppConstants.spacingL),

                    // Legend
                    const CalendarLegend(),

                    const SizedBox(height: AppConstants.spacingXl),

                    // My Posts Section
                    MyPostsSection(
                      myPosts: myPosts,
                      isLoading: timelineState.isLoading,
                      onDeletePost: _deletePost,
                    ),

                    const SizedBox(height: AppConstants.spacingXl),
                  ],
                ),
              ),
            ),
    );
  }

  void _showDateDetails(DateTime date, homeState) {
    final mood = homeState.getMoodForDate(date);
    final chats = homeState.getChatActivitiesForDate(date);

    if (mood == null && chats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tidak ada data untuk tanggal ini'),
          backgroundColor: AppColor.secondary,
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildDateDetailsSheet(date, mood, chats),
    );
  }

  Widget _buildDateDetailsSheet(DateTime date, mood, List chats) {
    final dateStr = '${date.day}/${date.month}/${date.year}';

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacingL),
          Text('Detail - $dateStr', style: SpatiumTypography.h2),
          const SizedBox(height: AppConstants.spacingL),

          if (mood != null) ...[
            Text('Mood', style: SpatiumTypography.labelSemiBold),
            const SizedBox(height: AppConstants.spacingS),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              decoration: BoxDecoration(
                color: _getMoodColor(mood.moodTagId),
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
              child: Row(
                children: [
                  Text(
                    _getMoodEmoji(mood.moodTagId),
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: AppConstants.spacingM),
                  Text(mood.moodTagLabel, style: SpatiumTypography.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingL),
          ],

          if (chats.isNotEmpty) ...[
            Text('Chat dengan AI', style: SpatiumTypography.labelSemiBold),
            const SizedBox(height: AppConstants.spacingS),
            ...chats.map(
              (chat) => Container(
                margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
                padding: const EdgeInsets.all(AppConstants.spacingM),
                decoration: BoxDecoration(
                  color: AppColor.backgroundLight,
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: AppColor.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                    Expanded(
                      child: Text(
                        chat.title,
                        style: SpatiumTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: AppConstants.spacingL),
        ],
      ),
    );
  }

  Color _getMoodColor(int moodTagId) {
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
        return AppColor.backgroundLight;
    }
  }

  String _getMoodEmoji(int moodTagId) {
    switch (moodTagId) {
      case 1:
        return '😊';
      case 2:
        return '😢';
      case 3:
        return '😠';
      case 4:
        return '😐';
      default:
        return '❓';
    }
  }
}
