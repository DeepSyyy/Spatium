import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/core/providers/core_providers.dart';
import 'package:spatium/features/timeline/data/datasources/timeline_remote_data_source.dart';
import 'package:spatium/features/timeline/data/repositories/timeline_repository.dart';
import 'package:spatium/features/timeline/presentation/providers/timeline_notifier.dart';
import 'package:spatium/features/timeline/presentation/providers/timeline_state.dart';

// ============================================
// Data Sources
// ============================================

/// Timeline Remote Data Source Provider
final timelineRemoteDataSourceProvider = Provider<TimelineRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TimelineRemoteDataSourceImpl(apiClient);
});

// ============================================
// Repository
// ============================================

/// Timeline Repository Provider
final timelineRepositoryProvider = Provider<TimelineRepository>((ref) {
  final remoteDataSource = ref.watch(timelineRemoteDataSourceProvider);
  return TimelineRepositoryImpl(remoteDataSource);
});

// ============================================
// State Notifier
// ============================================

/// Timeline Notifier Provider
final timelineNotifierProvider = StateNotifierProvider<TimelineNotifier, TimelineState>((ref) {
  final repository = ref.watch(timelineRepositoryProvider);
  return TimelineNotifier(repository);
});
