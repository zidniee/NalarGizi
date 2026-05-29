import 'package:dio/dio.dart';
import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/network/api_endpoints.dart';
import 'package:nalargizi/core/network/api_response.dart';
import '../models/dashboard_overview_model.dart';

/// Remote data source for Dashboard feature.
///
/// Source: claude1.md §NETWORKING RULES — Only Datasources may access Dio.
/// Source: claude.md §3B — GET /api/dashboard/overview?child_id=<id>
class DashboardRemoteDataSource {
  const DashboardRemoteDataSource(this._dio);

  final Dio _dio;

  /// Fetch the full dashboard overview for a given child.
  Future<DashboardOverviewModel> getOverview({int childId = 1}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.dashboardOverview,
        queryParameters: {'child_id': childId},
      );
      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) =>
            DashboardOverviewModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }
      return apiResponse.data!;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Gagal mengambil data dashboard.');
    }
  }
}
