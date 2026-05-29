import 'package:nalargizi/core/error/failures.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

/// UseCase: Google OAuth2 Sign In.
///
/// Source: claude.md §3A — POST /api/auth/google
/// Source: claude1.md §AUTH Responsibilities: Google Sign In
class GoogleLoginUseCase {
  const GoogleLoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<({AuthResultEntity? data, Failure? failure})> call(String idToken) {
    return _repository.googleLogin(idToken);
  }
}
