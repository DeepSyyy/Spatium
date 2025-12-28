import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spatium/core/providers/core_providers.dart';
import 'package:spatium/features/chat_ai/data/datasources/chat_remote_data_source.dart';
import 'package:spatium/features/chat_ai/data/repositories/chat_repository_impl.dart';
import 'package:spatium/features/chat_ai/presentation/providers/chat_notifier.dart';
import 'package:spatium/features/chat_ai/presentation/providers/chat_state.dart';

// ============================================
// Data Sources
// ============================================

/// Chat Remote Data Source Provider
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatRemoteDataSourceImpl(apiClient);
});

// ============================================
// Repository
// ============================================

/// Chat Repository Provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final remoteDataSource = ref.watch(chatRemoteDataSourceProvider);
  return ChatRepositoryImpl(remoteDataSource);
});

// ============================================
// State Notifier
// ============================================

/// Chat Notifier Provider
final chatNotifierProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatNotifier(repository);
});
