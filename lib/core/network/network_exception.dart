import 'package:dio/dio.dart';

class NetworkException implements Exception {
  const NetworkException(this.message);

  final String message;

  factory NetworkException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Koneksi timeout. Coba lagi.');
      case DioExceptionType.connectionError:
        return const NetworkException(
          'Tidak dapat terhubung ke server. Periksa internet.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return NetworkException(
          'Permintaan gagal dengan status code ${statusCode ?? '-'}',
        );
      case DioExceptionType.cancel:
        return const NetworkException('Permintaan dibatalkan.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const NetworkException('Terjadi kesalahan jaringan.');
    }
  }

  @override
  String toString() => message;
}
