import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/core/providers/core_providers.dart';
import 'package:spatium/features/timeline/data/datasources/moderation_remote_data_source.dart';
import 'package:spatium/features/timeline/data/models/report_model.dart';
import 'package:spatium/features/timeline/data/models/block_model.dart';

/// Moderation Data Source Provider
final moderationDataSourceProvider = Provider<ModerationRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ModerationRemoteDataSourceImpl(apiClient);
});

/// State for blocked users list
class BlockedUsersState {
  final List<BlockedUserModel> blockedUsers;
  final bool isLoading;
  final String? error;

  const BlockedUsersState({
    this.blockedUsers = const [],
    this.isLoading = false,
    this.error,
  });

  BlockedUsersState copyWith({
    List<BlockedUserModel>? blockedUsers,
    bool? isLoading,
    String? error,
  }) {
    return BlockedUsersState(
      blockedUsers: blockedUsers ?? this.blockedUsers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// State for reports list
class ReportsState {
  final List<ReportModel> reports;
  final bool isLoading;
  final String? error;

  const ReportsState({
    this.reports = const [],
    this.isLoading = false,
    this.error,
  });

  ReportsState copyWith({
    List<ReportModel>? reports,
    bool? isLoading,
    String? error,
  }) {
    return ReportsState(
      reports: reports ?? this.reports,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Blocked Users Notifier
class BlockedUsersNotifier extends StateNotifier<BlockedUsersState> {
  final ModerationRemoteDataSource _dataSource;

  BlockedUsersNotifier(this._dataSource) : super(const BlockedUsersState());

  Future<void> loadBlockedUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final blockedUsers = await _dataSource.getBlockedUsers();
      state = state.copyWith(blockedUsers: blockedUsers, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> blockUser(String userId, {String? reason}) async {
    try {
      await _dataSource.blockUser(BlockUserRequest(
        userId: userId,
        reason: reason,
      ));
      await loadBlockedUsers();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> unblockUser(String userId) async {
    try {
      await _dataSource.unblockUser(userId);
      await loadBlockedUsers();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  bool isUserBlocked(String userId) {
    return state.blockedUsers.any((user) => user.publicId == userId);
  }
}

/// Reports Notifier
class ReportsNotifier extends StateNotifier<ReportsState> {
  final ModerationRemoteDataSource _dataSource;

  ReportsNotifier(this._dataSource) : super(const ReportsState());

  Future<void> loadMyReports() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final reports = await _dataSource.getMyReports();
      state = state.copyWith(reports: reports, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> createReport({
    required ReportType reportType,
    required String targetId,
    required ReportReason reason,
    String? description,
  }) async {
    try {
      await _dataSource.createReport(CreateReportRequest(
        reportType: reportType,
        targetId: targetId,
        reason: reason,
        description: description,
      ));
      await loadMyReports();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// Providers
final blockedUsersProvider = StateNotifierProvider<BlockedUsersNotifier, BlockedUsersState>((ref) {
  final dataSource = ref.watch(moderationDataSourceProvider);
  return BlockedUsersNotifier(dataSource);
});

final reportsProvider = StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  final dataSource = ref.watch(moderationDataSourceProvider);
  return ReportsNotifier(dataSource);
});
