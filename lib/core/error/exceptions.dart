/// Exception classes thrown exclusively by Datasource layer.
///
/// Source: claude2.md §2 — Datasource hanya boleh melempar Exception.
/// Repository menangkap Exception ini dan memetakannya ke Failure.
class ServerException implements Exception {
  const ServerException([this.message = 'Terjadi kesalahan pada server.']);
  final String message;

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  const CacheException([this.message = 'Terjadi kesalahan saat membaca data lokal.']);
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message = 'Sesi tidak valid. Silakan login kembali.']);
  final String message;

  @override
  String toString() => 'UnauthorizedException: $message';
}
