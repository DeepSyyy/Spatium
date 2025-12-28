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
        return AuthResponseModel.fromJson(response.data);
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
        return AuthResponseModel.fromJson(response.data);
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
}
