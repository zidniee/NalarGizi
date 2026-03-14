import 'package:dio/dio.dart';
import 'package:nalargizi/core/network/api_endpoints.dart';
import 'package:nalargizi/core/network/network_exception.dart';

import '../models/posyandu_model.dart';

class PosyanduRemoteDataSource {
  const PosyanduRemoteDataSource(this._dio);

  final Dio _dio;

  Future<PosyanduModel> fetchPosyanduData({
    bool allowMockFallback = true,
  }) async {
    try {
      final response = await _dio.get(ApiEndpoints.posyanduOverview);
      final payload = response.data;

      if (payload is! Map<String, dynamic>) {
        throw const FormatException('Format data posyandu tidak valid.');
      }

      return PosyanduModel.fromMap(payload);
    } on DioException catch (error) {
      if (allowMockFallback) {
        return PosyanduModel.fromMap(_mockResponse);
      }
      throw NetworkException.fromDioException(error);
    } on FormatException {
      if (allowMockFallback) {
        return PosyanduModel.fromMap(_mockResponse);
      }
      rethrow;
    }
  }
}

final Map<String, dynamic> _mockResponse = {
  'immunizations': [
    {'name': 'BCG', 'is_done': true},
    {'name': 'Polio 1', 'is_done': true},
    {'name': 'DPT 1', 'is_done': true},
    {'name': 'DPT 2', 'is_done': true},
    {'name': 'DPT 3', 'is_done': true},
    {'name': 'Campak', 'is_done': false},
    {'name': 'MR', 'is_done': false},
  ],
  'upcoming_schedules': [
    {
      'id': 'upcoming-1',
      'title': 'Posyandu & Vitamin A',
      'category': 'Vitamin',
      'location': 'Puskesmas Garuda',
      'scheduled_at': DateTime.now()
          .add(const Duration(days: 6))
          .toIso8601String(),
      'note': 'Bawa Buku KIA dan kartu imunisasi',
      'is_completed': false,
    },
    {
      'id': 'upcoming-2',
      'title': 'Imunisasi MR (Campak)',
      'category': 'Imunisasi',
      'location': 'Puskesmas Garuda',
      'scheduled_at': DateTime.now()
          .add(const Duration(days: 30))
          .toIso8601String(),
      'is_completed': false,
    },
  ],
  'completed_schedules': [
    {
      'id': 'history-1',
      'title': 'Imunisasi DPT 3',
      'category': 'Imunisasi',
      'location': 'Puskesmas Garuda',
      'scheduled_at': DateTime.now()
          .subtract(const Duration(days: 30))
          .toIso8601String(),
      'is_completed': true,
    },
    {
      'id': 'history-2',
      'title': 'Timbang Rutin',
      'category': 'Posyandu',
      'location': 'Posyandu Mawar',
      'scheduled_at': DateTime.now()
          .subtract(const Duration(days: 58))
          .toIso8601String(),
      'is_completed': true,
    },
    {
      'id': 'history-3',
      'title': 'Vitamin A Agustus',
      'category': 'Vitamin',
      'location': 'Posyandu Mawar',
      'scheduled_at': DateTime.now()
          .subtract(const Duration(days: 90))
          .toIso8601String(),
      'is_completed': true,
    },
  ],
};
