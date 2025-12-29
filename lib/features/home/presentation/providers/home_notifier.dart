import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/features/home/data/repositories/home_repository.dart';
import 'package:spatium/features/home/presentation/providers/home_state.dart';

/// Home Notifier
/// Manages home page state and business logic
class HomeNotifier extends StateNotifier<HomeState> {
  final HomeRepository _repository;

  HomeNotifier(this._repository) : super(HomeState());

  /// Load all home data (mood stats, chat activities)
  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, clearError: true);

    // Load today's mood
    final todayResult = await _repository.getTodayMood();
    todayResult.fold(
      (failure) {
        // Ignore failure for today's mood - it's okay if not set
      },
      (mood) {
        state = state.copyWith(todayMood: mood);
      },
    );

    // Load mood statistics for the last 60 days (to cover 2 months in calendar)
    final statsResult = await _repository.getMoodStatistics(60);
    statsResult.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (stats) {
        state = state.copyWith(moodStats: stats);
      },
    );

    // Load chat sessions
    final chatResult = await _repository.getChatSessions();
    chatResult.fold(
      (failure) {
        // Ignore failure for chat activities
      },
      (activities) {
        state = state.copyWith(chatActivities: activities);
      },
    );

    state = state.copyWith(isLoading: false);
  }

  /// Save today's mood
  Future<bool> saveTodayMood(int moodTagId, String note) async {
    state = state.copyWith(isSavingMood: true, clearError: true);

    final result = await _repository.saveDailyMood(moodTagId, note);

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSavingMood: false,
          error: failure.message,
        );
        return false;
      },
      (mood) {
        state = state.copyWith(
          isSavingMood: false,
          todayMood: mood,
        );
        // Reload mood statistics to update calendar
        loadHomeData();
        return true;
      },
    );
  }

  /// Change selected month in calendar
  void changeMonth(DateTime month) {
    state = state.copyWith(selectedMonth: month);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Reset state (on logout/account switch)
  void resetState() {
    state = HomeState();
  }
}
