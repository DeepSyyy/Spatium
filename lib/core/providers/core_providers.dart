import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spatium/core/network/api_client.dart';
import 'package:spatium/core/storage/secure_storage_service.dart';

// ============================================
// Core Providers
// ============================================

/// Secure Storage Provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
});

/// Secure Storage Service Provider
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return SecureStorageService(storage);
});

/// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final storageService = ref.watch(secureStorageServiceProvider);
  return ApiClient(storageService);
});
