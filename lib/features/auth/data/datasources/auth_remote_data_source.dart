import 'package:spatium/core/constants/api_constants.dart';
import 'package:spatium/core/errors/exceptions.dart';
import 'package:spatium/core/network/api_client.dart';
import 'package:spatium/features/auth/data/models/auth_response_model.dart';
import 'package:spatium/features/auth/data/models/login_request.dart';
import 'package:spatium/features/auth/data/models/register_request.dart';

/// Auth Remote Data Source
/// Handles all authentication API calls
abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register(String alias);
  Future<AuthResponseModel> login(String recoveryCode);
  Future<AuthResponseModel> googleLogin({
    required String googleId,
    required String email,
    String? alias,
    String? photoUrl,
  });
  Future<Map<String, dynamic>> updateAlias(String newAlias);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  @override
  Future<AuthResponseModel> register(String alias) async {
    try {
      final request = RegisterRequest(alias: alias);
      final response = await apiClient.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Backend returns {data: {user, token}}
        final data = response.data['data'];
        return AuthResponseModel.fromJson(data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to register: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResponseModel> login(String recoveryCode) async {
    try {
      final request = LoginRequest(recoveryCode: recoveryCode);
      final response = await apiClient.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        // Backend returns {data: {user, token}}
        final data = response.data['data'];
        return AuthResponseModel.fromJson(data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to login: ${e.toString()}',
      );
    }
  }

  @override
  Future<AuthResponseModel> googleLogin({
    required String googleId,
    required String email,
    String? alias,
    String? photoUrl,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.googleLogin,
        data: {
          'google_id': googleId,
          'email': email,
          if (alias != null) 'alias': alias,
          if (photoUrl != null) 'photo_url': photoUrl,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Backend returns {data: {user, token}}
        final data = response.data['data'];
        return AuthResponseModel.fromJson(data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Google login failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to login with Google: ${e.toString()}',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> updateAlias(String newAlias) async {
    try {
      final response = await apiClient.put(
        ApiConstants.updateAlias,
        data: {'alias': newAlias},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return {
          'alias': data['alias'] ?? newAlias,
          'public_id': data['public_id'],
        };
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to update alias',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(
        message: 'Failed to update alias: ${e.toString()}',
      );
    }
  }
}
