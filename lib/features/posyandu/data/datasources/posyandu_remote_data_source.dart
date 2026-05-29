import 'package:dio/dio.dart';
import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/network/api_endpoints.dart';
import 'package:nalargizi/core/network/api_response.dart';
import 'package:nalargizi/features/posyandu/domain/entities/posyandu_schedule_item_entity.dart';

import '../models/posyandu_model.dart';
import '../models/posyandu_schedule_item_model.dart';

/// Remote data source for Posyandu feature.
///
/// Source: claude2.md §1 — Wrap response with ApiResponse
/// Source: claude2.md §2 — Datasource throws Exception
class PosyanduRemoteDataSource {
  const PosyanduRemoteDataSource(this._dio);

  final Dio _dio;

  /// Fetches the posyandu overview and immunization records.
  Future<PosyanduModel> fetchPosyanduData() async {
    try {
      final response = await _dio.get(ApiEndpoints.posyanduOverview);
      
      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) => PosyanduModel.fromMap(data as Map<String, dynamic>),
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (error) {
      throw ServerException(error.message ?? 'Gagal memuat data posyandu.');
    }
  }

  /// Marks a posyandu schedule as completed via PATCH.
  ///
  /// On success, the mock/server moves the schedule from upcoming → completed
  /// and the posyandu overview will reflect the updated state on next load.
  Future<void> markScheduleCompleted(String scheduleId) async {
    try {
      final response = await _dio.patch(
        ApiEndpoints.posyanduScheduleComplete(scheduleId),
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data,
      );

      if (!apiResponse.success) {
        throw ServerException(apiResponse.message);
      }
    } on DioException catch (error) {
      throw ServerException(error.message ?? 'Gagal menandai jadwal selesai.');
    }
  }

  /// Creates a new posyandu schedule via POST.
  ///
  /// Returns the saved [PosyanduScheduleItemModel] on success.
  Future<PosyanduScheduleItemModel> addSchedule(
    PosyanduScheduleItemEntity schedule,
  ) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.posyanduSchedule,
        data: {
          'id': schedule.id,
          'title': schedule.title,
          'category': schedule.category,
          'location': schedule.location,
          'scheduled_at': schedule.scheduledAt.toIso8601String(),
          'note': schedule.note,
          'is_completed': false,
        },
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) =>
            PosyanduScheduleItemModel.fromMap(data as Map<String, dynamic>),
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (error) {
      throw ServerException(
          error.message ?? 'Gagal menyimpan jadwal posyandu.');
    }
  }
}
