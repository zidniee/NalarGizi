import 'package:dio/dio.dart';
import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/network/api_endpoints.dart';
import 'package:nalargizi/core/network/api_response.dart';
import '../models/notification_model.dart';

/// Remote data source for Notifications list.
///
/// Source: claude2.md §1 — Wrap response with ApiResponse
/// Source: claude2.md §2 — Datasource throws Exception
class NotificationRemoteDataSource {
  const NotificationRemoteDataSource(this._dio);

  final Dio _dio;

  /// Fetches system notifications.
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _dio.get(ApiEndpoints.profileNotifications);

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) => (data as List<dynamic>)
            .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
            .toList(),
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Gagal mengambil notifikasi.');
    }
  }
}
