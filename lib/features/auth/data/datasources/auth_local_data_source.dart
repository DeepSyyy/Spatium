import 'package:spatium/core/storage/secure_storage_service.dart';
import 'package:spatium/features/auth/data/models/user_model.dart';
import 'package:spatium/features/auth/domain/entities/user_entity.dart';
import 'dart:convert';

/// Auth Local Data Source
/// Handles local storage of authentication data
abstract class AuthLocalDataSource {
  Future<void> cacheAuthData({
    required String token,
    required String userId,
    required String alias,
    required String recoveryCode,
    String? email,
    String? photoUrl,
  });

  Future<void> cacheUser(UserModel user);
  Future<UserEntity?> getCachedUser();
  Future<bool> isLoggedIn();
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService storageService;

  AuthLocalDataSourceImpl(this.storageService);

  @override
  Future<void> cacheAuthData({
    required String token,
    required String userId,
    required String alias,
    required String recoveryCode,
    String? email,
    String? photoUrl,
  }) async {
    await storageService.saveAccessToken(token);
    await storageService.saveUserId(userId);
    await storageService.saveUserAlias(alias);
    await storageService.saveRecoveryCode(recoveryCode);
    if (email != null) {
      await storageService.saveUserEmail(email);
    }
    if (photoUrl != null) {
      await storageService.saveUserPhotoUrl(photoUrl);
    }
    await storageService.saveLoginStatus(true);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await storageService.write(
      key: 'cached_user',
      value: userJson,
    );
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    final userJson = await storageService.read(key: 'cached_user');
    if (userJson != null) {
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      final userModel = UserModel.fromJson(userMap);
      return userModel.toEntity();
    }
    return null;
  }

  @override
  Future<bool> isLoggedIn() async {
    return await storageService.isLoggedIn();
  }

  @override
  Future<void> clearAuthData() async {
    await storageService.clearAuth();
    await storageService.delete(key: 'cached_user');
  }
}
