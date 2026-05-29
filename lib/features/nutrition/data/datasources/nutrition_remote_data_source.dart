import 'package:dio/dio.dart';
import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/network/api_endpoints.dart';
import 'package:nalargizi/core/network/api_response.dart';
import '../models/nutrition_model.dart';

/// Remote data source for Nutrition feature.
///
/// Source: claude2.md §1 — Wrap response with ApiResponse
/// Source: claude2.md §2 — Datasource throws Exception
class NutritionRemoteDataSource {
  const NutritionRemoteDataSource(this._dio);

  final Dio _dio;

  /// Fetches daily nutrition summary for a child on a specific date.
  Future<NutritionDailyModel> getDailySummary({
    required int childId,
    required String date,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.nutritionDaily,
        queryParameters: {
          'child_id': childId,
          'date': date,
        },
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) => NutritionDailyModel.fromJson(
          data as Map<String, dynamic>,
          childId: childId.toString(),
          date: date,
        ),
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Gagal mengambil data nutrisi harian.');
    }
  }

  /// Adds a new meal log for a child.
  /// POSTs to /api/nutrition/daily as required by MockInterceptor.
  Future<NutritionMealModel> addMealLog(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.nutritionDaily,
        data: data,
      );

      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) => NutritionMealModel.fromMap(data as Map<String, dynamic>),
      );

      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }

      return apiResponse.data!;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Gagal menyimpan catatan makanan.');
    }
  }
}
