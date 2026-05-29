import 'package:dio/dio.dart';
import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/network/api_endpoints.dart';
import 'package:nalargizi/core/network/api_response.dart';
import 'package:nalargizi/features/growth/data/models/growth_model.dart';
import '../models/profile_model.dart';

/// Remote data source for parent and child profile.
///
/// Source: claude2.md §1 — Wrap response with ApiResponse
/// Source: claude2.md §2 — Datasource throws Exception
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._dio);

  final Dio _dio;

  /// Fetches profile information (parent & child).
  Future<ProfileModel> getProfileInfo() async {
    try {
      final response = await _dio.get(ApiEndpoints.profileInfo);
      
      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) => ProfileModel.fromJson(data as Map<String, dynamic>),
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Gagal mengambil data profil.');
    }
  }

  /// Fetches growth measurements history for child profile.
  Future<List<GrowthRecordModel>> getChildHistory() async {
    try {
      final response = await _dio.get(ApiEndpoints.profileHistory);

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List<dynamic>)
            .map((item) => GrowthRecordModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Gagal mengambil riwayat anak.');
    }
  }
}
