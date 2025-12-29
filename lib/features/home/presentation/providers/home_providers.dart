import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/core/providers/core_providers.dart';
import 'package:spatium/features/home/data/datasources/home_remote_data_source.dart';
import 'package:spatium/features/home/data/repositories/home_repository.dart';
import 'package:spatium/features/home/presentation/providers/home_notifier.dart';
import 'package:spatium/features/home/presentation/providers/home_state.dart';

// ============================================
// Data Sources
// ============================================

/// Home Remote Data Source Provider
final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HomeRemoteDataSourceImpl(apiClient);
});

// ============================================
// Repository
// ============================================

/// Home Repository Provider
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final remoteDataSource = ref.watch(homeRemoteDataSourceProvider);
  return HomeRepositoryImpl(remoteDataSource);
});

// ============================================
// State Notifier
// ============================================

/// Home Notifier Provider
final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return HomeNotifier(repository);
});
