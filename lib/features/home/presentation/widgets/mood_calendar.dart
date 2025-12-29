import 'package:flutter/material.dart';
import 'package:spatium/features/home/data/models/daily_mood_model.dart';
import 'package:spatium/styles/colors.dart';
import 'package:spatium/styles/constants.dart';
import 'package:spatium/styles/typography.dart';

/// Mood Calendar Widget
/// Displays a calendar with mood indicators and chat activity
class MoodCalendar extends StatelessWidget {
  final DateTime selectedMonth;
  final List<MoodStatModel> moodStats;
  final List<ChatActivityModel> chatActivities;
  final Function(DateTime) onMonthChanged;
  final Function(DateTime)? onDateTap;

  const MoodCalendar({
    super.key,
    required this.selectedMonth,
    required this.moodStats,
    required this.chatActivities,
    required this.onMonthChanged,
    this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: AppConstants.spacingM),
          _buildWeekDays(),
          const SizedBox(height: AppConstants.spacingS),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left, color: AppColor.secondary),
          onPressed: () {
            onMonthChanged(DateTime(selectedMonth.year, selectedMonth.month - 1));
          },
        ),
        Text(
          '${monthNames[selectedMonth.month - 1]} ${selectedMonth.year}',
          style: SpatiumTypography.h2,
        ),
        IconButton(
          icon: Icon(Icons.chevron_right, color: AppColor.secondary),
          onPressed: () {
            onMonthChanged(DateTime(selectedMonth.year, selectedMonth.month + 1));
          },
        ),
      ],
    );
  }

  Widget _buildWeekDays() {
    final weekDays = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) => SizedBox(
        width: 40,
        child: Text(
          day,
          textAlign: TextAlign.center,
          style: SpatiumTypography.small.copyWith(
            color: AppColor.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final lastDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7; // 0 = Sunday

    final today = DateTime.now();
    final isCurrentMonth = today.year == selectedMonth.year && today.month == selectedMonth.month;

    List<Widget> cells = [];

    // Empty cells for days before month starts
    for (int i = 0; i < startWeekday; i++) {
      final prevMonthDay = DateTime(selectedMonth.year, selectedMonth.month, 0).day - (startWeekday - i - 1);
      cells.add(_buildDayCell(prevMonthDay, isOtherMonth: true));
    }

    // Days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(selectedMonth.year, selectedMonth.month, day);
      final isToday = isCurrentMonth && day == today.day;
      
      // Get mood for this date
      final mood = _getMoodForDate(date);
      
      // Check for chat activity
      final hasChat = _hasChatActivityOnDate(date);

      cells.add(_buildDayCell(
        day,
        isToday: isToday,
        mood: mood,
        hasChat: hasChat,
        date: date,
      ));
    }

    // Fill remaining cells for next month
    final remainingCells = 7 - (cells.length % 7);
    if (remainingCells < 7) {
      for (int i = 1; i <= remainingCells; i++) {
        cells.add(_buildDayCell(i, isOtherMonth: true));
      }
    }

    // Build rows
    List<Widget> rows = [];
    for (int i = 0; i < cells.length; i += 7) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: cells.sublist(i, i + 7 > cells.length ? cells.length : i + 7),
      ));
      if (i + 7 < cells.length) {
        rows.add(const SizedBox(height: 4));
      }
    }

    return Column(children: rows);
  }

  Widget _buildDayCell(
    int day, {
    bool isToday = false,
    bool isOtherMonth = false,
    MoodStatModel? mood,
    bool hasChat = false,
    DateTime? date,
  }) {
    Color? backgroundColor;
    Color textColor = isOtherMonth ? AppColor.placeholder : AppColor.black;

    if (isToday) {
      backgroundColor = AppColor.primary;
      textColor = AppColor.white;
    } else if (mood != null && !isOtherMonth) {
      backgroundColor = _getMoodColor(mood.moodTagId);
      textColor = AppColor.black;
    }

    return GestureDetector(
      onTap: date != null && onDateTap != null ? () => onDateTap!(date) : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                day.toString(),
                style: SpatiumTypography.bodyMedium.copyWith(
                  color: textColor,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            // Chat activity indicator (small dot)
            if (hasChat && !isOtherMonth)
              Positioned(
                bottom: 2,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isToday ? AppColor.white : AppColor.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(int moodTagId) {
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
        return Colors.transparent;
    }
  }

  MoodStatModel? _getMoodForDate(DateTime date) {
    final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    try {
      return moodStats.firstWhere((m) => m.date == dateString);
    } catch (e) {
      return null;
    }
  }

  bool _hasChatActivityOnDate(DateTime date) {
    return chatActivities.any((chat) =>
        chat.date.year == date.year &&
        chat.date.month == date.month &&
        chat.date.day == date.day);
  }
}
