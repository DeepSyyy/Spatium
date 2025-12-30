import 'package:dio/dio.dart';
import 'package:spatium/core/constants/api_constants.dart';
import 'package:spatium/core/errors/exceptions.dart';
import 'package:spatium/core/network/api_client.dart';
import 'package:spatium/features/timeline/data/models/report_model.dart';
import 'package:spatium/features/timeline/data/models/block_model.dart';

/// Moderation Remote Data Source
/// Handles all API calls related to content moderation (reports and blocks)
abstract class ModerationRemoteDataSource {
  // Report methods
  Future<ReportModel> createReport(CreateReportRequest request);
  Future<List<ReportModel>> getMyReports();
  
  // Block methods
  Future<BlockResponse> blockUser(BlockUserRequest request);
  Future<void> unblockUser(String userId);
  Future<List<BlockedUserModel>> getBlockedUsers();
}

class ModerationRemoteDataSourceImpl implements ModerationRemoteDataSource {
  final ApiClient apiClient;

  ModerationRemoteDataSourceImpl(this.apiClient);

  // =====================================
  // 🚨 REPORT METHODS
  // =====================================

  @override
  Future<ReportModel> createReport(CreateReportRequest request) async {
    try {
      print('🔵 Creating report: ${request.toJson()}');
      final response = await apiClient.post(
        ApiConstants.reports,
        data: request.toJson(),
      );

      print('🔵 Response status: ${response.statusCode}');
      print('🔵 Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic data;
        if (response.data is Map) {
          data = response.data['data'];
        } else {
          data = response.data;
        }

        if (data is! Map<String, dynamic>) {
          throw ServerException(message: 'Invalid response format');
        }

        return ReportModel.fromJson(data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to create report',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      throw ServerException(
        message: e.response?.data['message'] ?? 'Gagal membuat laporan',
      );
    }
  }

  @override
  Future<List<ReportModel>> getMyReports() async {
    try {
      print('🔵 Getting my reports');
      final response = await apiClient.get(ApiConstants.myReports);

      print('🔵 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        dynamic data;
        if (response.data is Map) {
          data = response.data['data'];
        } else {
          data = response.data;
        }

        if (data == null) return [];

        if (data is! List) {
          print('❌ Invalid data type: ${data.runtimeType}');
          return [];
        }

        return data
            .map((json) => ReportModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get reports',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Gagal mengambil laporan',
      );
    }
  }

  // =====================================
  // 🚫 BLOCK METHODS
  // =====================================

  @override
  Future<BlockResponse> blockUser(BlockUserRequest request) async {
    try {
      print('🔵 Blocking user: ${request.userId}');
      final response = await apiClient.post(
        ApiConstants.blockUser,
        data: request.toJson(),
      );

      print('🔵 Response status: ${response.statusCode}');
      print('🔵 Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic data;
        if (response.data is Map) {
          data = response.data['data'];
        } else {
          data = response.data;
        }

        if (data is! Map<String, dynamic>) {
          throw ServerException(message: 'Invalid response format');
        }

        return BlockResponse.fromJson(data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to block user',
        );
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      throw ServerException(
        message: e.response?.data['message'] ?? 'Gagal memblokir pengguna',
      );
    }
  }

  @override
  Future<void> unblockUser(String userId) async {
    try {
      print('🔵 Unblocking user: $userId');
      final response = await apiClient.delete(ApiConstants.unblockUser(userId));

      if (response.statusCode != 200) {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to unblock user',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Gagal membuka blokir pengguna',
      );
    }
  }

  @override
  Future<List<BlockedUserModel>> getBlockedUsers() async {
    try {
      print('🔵 Getting blocked users');
      final response = await apiClient.get(ApiConstants.blockedUsers);

      print('🔵 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        dynamic data;
        if (response.data is Map) {
          data = response.data['data'];
        } else {
          data = response.data;
        }

        if (data == null) return [];

        if (data is! List) {
          print('❌ Invalid data type: ${data.runtimeType}');
          return [];
        }

        return data
            .map((json) => BlockedUserModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get blocked users',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Gagal mengambil daftar blokir',
      );
    }
  }
}
