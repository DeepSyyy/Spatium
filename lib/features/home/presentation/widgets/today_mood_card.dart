import 'package:flutter/material.dart';
import 'package:spatium/features/home/data/models/daily_mood_model.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

/// Today Mood Card
/// Displays today's mood status and allows adding/updating mood
class TodayMoodCard extends StatelessWidget {
  final DailyMoodModel? todayMood;
  final bool isLoading;
  final VoidCallback onAddMood;

  const TodayMoodCard({
    super.key,
    this.todayMood,
    this.isLoading = false,
    required this.onAddMood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: todayMood != null
              ? [_getMoodGradientStart(todayMood!.moodTagId), _getMoodGradientEnd(todayMood!.moodTagId)]
              : [AppColor.primary.withOpacity(0.8), AppColor.primary],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: (todayMood != null 
                ? _getMoodGradientStart(todayMood!.moodTagId) 
                : AppColor.primary).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : todayMood != null
              ? _buildMoodDisplay()
              : _buildAddMoodPrompt(),
    );
  }

  Widget _buildMoodDisplay() {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColor.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              todayMood!.moodEmoji,
              style: const TextStyle(fontSize: 36),
            ),
          ),
        ),
        const SizedBox(width: AppConstants.spacingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mood Hari Ini',
                style: SpatiumTypography.small.copyWith(
                  color: AppColor.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                todayMood!.moodName,
                style: SpatiumTypography.h1.copyWith(
                  color: AppColor.white,
                ),
              ),
              if (todayMood!.note.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  todayMood!.note,
                  style: SpatiumTypography.bodyRegular.copyWith(
                    color: AppColor.white.withOpacity(0.9),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        IconButton(
          onPressed: onAddMood,
          icon: Icon(
            Icons.edit,
            color: AppColor.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildAddMoodPrompt() {
    return InkWell(
      onTap: onAddMood,
      borderRadius: BorderRadius.circular(AppConstants.radiusL),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColor.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.add,
                color: AppColor.white,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bagaimana perasaanmu hari ini?',
                  style: SpatiumTypography.h3.copyWith(
                    color: AppColor.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap untuk menambahkan mood harian',
                  style: SpatiumTypography.small.copyWith(
                    color: AppColor.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColor.white.withOpacity(0.8),
          ),
        ],
      ),
    );
  }

  Color _getMoodGradientStart(int moodTagId) {
    switch (moodTagId) {
      case 1: // Senang
        return const Color(0xFFFFB347);
      case 2: // Sedih
        return const Color(0xFF5B9BD5);
      case 3: // Marah
        return const Color(0xFFE74C3C);
      case 4: // Netral
        return const Color(0xFF95A5A6);
      default:
        return AppColor.primary;
    }
  }

  Color _getMoodGradientEnd(int moodTagId) {
    switch (moodTagId) {
      case 1: // Senang
        return const Color(0xFFFFCC70);
      case 2: // Sedih
        return const Color(0xFF7FB3D5);
      case 3: // Marah
        return const Color(0xFFE57373);
      case 4: // Netral
        return const Color(0xFFBDC3C7);
      default:
        return AppColor.primary.withOpacity(0.8);
    }
  }
}
