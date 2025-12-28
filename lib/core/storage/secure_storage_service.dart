import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spatium/core/constants/storage_constants.dart';

/// Secure Storage Service
/// Handles all secure storage operations using flutter_secure_storage
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  // ============================================
  // Auth Methods
  // ============================================

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(
      key: StorageConstants.accessToken,
      value: token,
    );
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: StorageConstants.accessToken);
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(
      key: StorageConstants.userId,
      value: userId,
    );
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: StorageConstants.userId);
  }

  /// Save user alias
  Future<void> saveUserAlias(String alias) async {
    await _storage.write(
      key: StorageConstants.userAlias,
      value: alias,
    );
  }

  /// Get user alias
  Future<String?> getUserAlias() async {
    return await _storage.read(key: StorageConstants.userAlias);
  }

  /// Save recovery code
  Future<void> saveRecoveryCode(String code) async {
    await _storage.write(
      key: StorageConstants.recoveryCode,
      value: code,
    );
  }

  /// Get recovery code
  Future<String?> getRecoveryCode() async {
    return await _storage.read(key: StorageConstants.recoveryCode);
  }

  /// Save user email
  Future<void> saveUserEmail(String email) async {
    await _storage.write(
      key: StorageConstants.userEmail,
      value: email,
    );
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    return await _storage.read(key: StorageConstants.userEmail);
  }

  /// Save user photo URL
  Future<void> saveUserPhotoUrl(String url) async {
    await _storage.write(
      key: StorageConstants.userPhotoUrl,
      value: url,
    );
  }

  /// Get user photo URL
  Future<String?> getUserPhotoUrl() async {
    return await _storage.read(key: StorageConstants.userPhotoUrl);
  }

  /// Save login status
  Future<void> saveLoginStatus(bool isLoggedIn) async {
    await _storage.write(
      key: StorageConstants.isLoggedIn,
      value: isLoggedIn.toString(),
    );
  }

  /// Get login status
  Future<bool> isLoggedIn() async {
    final value = await _storage.read(key: StorageConstants.isLoggedIn);
    return value == 'true';
  }

  /// Clear all auth data
  Future<void> clearAuth() async {
    await _storage.delete(key: StorageConstants.accessToken);
    await _storage.delete(key: StorageConstants.userId);
    await _storage.delete(key: StorageConstants.userAlias);
    await _storage.delete(key: StorageConstants.userEmail);
    await _storage.delete(key: StorageConstants.userPhotoUrl);
    await _storage.delete(key: StorageConstants.recoveryCode);
    await _storage.delete(key: StorageConstants.isLoggedIn);
  }

  // ============================================
  // General Storage Methods
  // ============================================

  /// Write any data to secure storage
  Future<void> write({
    required String key,
    required String value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  /// Read data from secure storage
  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

  /// Delete data from secure storage
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Check if key exists
  Future<bool> containsKey({required String key}) async {
    return await _storage.containsKey(key: key);
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Get all stored data (for debugging)
  Future<Map<String, String>> getAllData() async {
    return await _storage.readAll();
  }
}
