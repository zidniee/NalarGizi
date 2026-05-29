import 'package:nalargizi/core/error/failures.dart';
import '../repositories/auth_repository.dart';

/// UseCase: Send forgot password email.
///
/// Source: claude.md §3A — POST /api/auth/forgot-password
class ForgotPasswordUseCase {
  const ForgotPasswordUseCase(this._repository);
  final AuthRepository _repository;

  Future<({bool success, Failure? failure})> call(String email) {
    return _repository.forgotPassword(email);
  }
}
