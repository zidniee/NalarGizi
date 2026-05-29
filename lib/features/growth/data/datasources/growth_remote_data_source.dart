import 'package:dio/dio.dart';
import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/network/api_endpoints.dart';
import 'package:nalargizi/core/network/api_response.dart';
import '../models/growth_model.dart';

/// Remote data source for Growth feature.
///
/// Source: claude1.md §NETWORKING RULES — Only Datasources may access Dio.
/// Source: claude.md §3C — GET /api/growth/records, POST /api/growth/records
class GrowthRemoteDataSource {
  const GrowthRemoteDataSource(this._dio);

  final Dio _dio;

  /// Fetch all growth records for a child.
  /// GET /api/growth/records?child_id=<id>
  Future<List<GrowthRecordModel>> getRecords({int childId = 1}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.growthRecords,
        queryParameters: {'child_id': childId},
      );
      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List<dynamic>)
            .map((e) =>
                GrowthRecordModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }
      return apiResponse.data!;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Gagal mengambil data pertumbuhan.');
    }
  }

  /// Add a new growth record.
  /// POST /api/growth/records
  Future<GrowthRecordModel> addRecord(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.growthRecords,
        data: data,
      );
      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (d) => GrowthRecordModel.fromJson(d as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }
      return apiResponse.data!;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Gagal menyimpan data pertumbuhan.');
    }
  }
}
