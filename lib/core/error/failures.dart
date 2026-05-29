/// Failure classes representing mapped errors for the UI layer.
///
/// Source: claude1.md §257-280 — ERROR HANDLING
/// Source: claude2.md §2 — Repository maps Exception → Failure
/// Never expose raw DioException to UI (claude1.md §279).
abstract class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => 'Failure: $message';
}

/// Failure from server-side errors (4xx, 5xx HTTP responses).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Terjadi kesalahan pada server.']);
}

/// Failure from network connectivity issues (timeout, no internet).
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Tidak dapat terhubung. Periksa koneksi internet.']);
}

/// Failure from local cache (Hive) read/write errors.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Gagal membaca data lokal.']);
}

/// Failure from invalid form input or business rule violations.
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Data tidak valid.']);
}

/// Failure when user session is expired or token is invalid.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Sesi tidak valid. Silakan login kembali.']);
}

/// Fallback for unexpected errors.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Terjadi kesalahan yang tidak diketahui.']);
}
