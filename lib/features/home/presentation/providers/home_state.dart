import 'package:spatium/features/home/data/models/daily_mood_model.dart';

/// Home State
/// Represents the state of the home page with mood tracking and chat activity
class HomeState {
  final bool isLoading;
  final String? error;
  final DailyMoodModel? todayMood;
  final List<MoodStatModel> moodStats;
  final List<ChatActivityModel> chatActivities;
  final DateTime selectedMonth;
  final bool isSavingMood;

  HomeState({
    this.isLoading = false,
    this.error,
    this.todayMood,
    this.moodStats = const [],
    this.chatActivities = const [],
    DateTime? selectedMonth,
    this.isSavingMood = false,
  }) : selectedMonth = selectedMonth ?? DateTime.now();

  HomeState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    DailyMoodModel? todayMood,
    bool clearTodayMood = false,
    List<MoodStatModel>? moodStats,
    List<ChatActivityModel>? chatActivities,
    DateTime? selectedMonth,
    bool? isSavingMood,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      todayMood: clearTodayMood ? null : (todayMood ?? this.todayMood),
      moodStats: moodStats ?? this.moodStats,
      chatActivities: chatActivities ?? this.chatActivities,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      isSavingMood: isSavingMood ?? this.isSavingMood,
    );
  }

  bool get hasError => error != null && error!.isNotEmpty;
  bool get hasTodayMood => todayMood != null;

  /// Get mood for a specific date
  MoodStatModel? getMoodForDate(DateTime date) {
    final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    try {
      return moodStats.firstWhere((m) => m.date == dateString);
    } catch (e) {
      return null;
    }
  }

  /// Check if there was chat activity on a specific date
  bool hasChatActivityOnDate(DateTime date) {
    return chatActivities.any((chat) =>
        chat.date.year == date.year &&
        chat.date.month == date.month &&
        chat.date.day == date.day);
  }

  /// Get chat activities for a specific date
  List<ChatActivityModel> getChatActivitiesForDate(DateTime date) {
    return chatActivities.where((chat) =>
        chat.date.year == date.year &&
        chat.date.month == date.month &&
        chat.date.day == date.day).toList();
  }
}
